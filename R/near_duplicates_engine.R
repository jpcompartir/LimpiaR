# Internal helpers for limpiar_near_duplicates(). None of these are exported.
#
# The LSH engine follows the standard minhash + banding recipe:
#   1. nd_shingles()          turn each document into a set of word n-grams
#   2. nd_minhash()           compress each shingle set into a short signature
#   3. nd_candidate_pairs()   band the signatures to find likely pairs
#   4. nd_verify_pairs()      confirm candidates with exact Jaccard similarity
#   5. nd_union_find()        connect verified pairs into groups


#' Compute (a * x + b) mod p exactly with doubles
#'
#' R doubles hold integers exactly only up to 2^53, and a * x can exceed that
#' when a and x are both close to p (~2^31). Splitting a into 13-bit and
#' high-bit parts keeps every intermediate product below 2^53.
#'
#' @noRd
nd_hash_ints <- function(x, a, b, p = 2147483647) {
  a_hi <- a %/% 8192
  a_lo <- a %% 8192
  (((a_hi * x) %% p) * 8192 + a_lo * x + b) %% p
}


#' Draw the random hash coefficients for a given seed
#'
#' Restores the caller's RNG state on exit so that running the function does
#' not disturb random numbers generated elsewhere in the user's session.
#'
#' @noRd
nd_hash_coefficients <- function(n_hashes, seed, p = 2147483647) {
  has_seed <- exists(".Random.seed", envir = globalenv(), inherits = FALSE)
  if (has_seed) {
    old_seed <- get(".Random.seed", envir = globalenv(), inherits = FALSE)
    on.exit(assign(".Random.seed", old_seed, envir = globalenv()), add = TRUE)
  } else {
    on.exit(rm(".Random.seed", envir = globalenv()), add = TRUE)
  }

  set.seed(seed)
  list(
    a = as.double(sample.int(p - 1L, n_hashes, replace = TRUE)),
    b = as.double(sample.int(p, n_hashes, replace = TRUE)) - 1,
    band_a = as.double(sample.int(p - 1L, 1L))
  )
}


#' Choose the LSH band layout for a similarity threshold
#'
#' Splitting n_hashes into b bands of r rows makes pairs with Jaccard
#' similarity s collide with probability 1 - (1 - s^r)^b. That curve rises
#' steeply around (1/b)^(1/r), so we pick the divisor of n_hashes whose curve
#' sits closest below `similarity`: false negatives are unrecoverable, while
#' false positives are removed later by exact verification.
#'
#' @noRd
nd_choose_bands <- function(n_hashes, similarity) {
  divisors <- which(n_hashes %% seq_len(n_hashes) == 0L)
  thresholds <- (divisors / n_hashes)^(1 / divisors)
  below <- thresholds <= similarity
  rows <- if (any(below)) max(divisors[below]) else 1L

  list(
    rows = rows,
    bands = n_hashes %/% rows,
    threshold = (rows / n_hashes)^(1 / rows)
  )
}


#' Shingle documents into distinct word n-grams
#'
#' Returns a tibble of (document, shingle_id) sorted by document, where
#' shingle_id is a dense integer id. Documents with fewer words than
#' shingle_size produce no rows: they cannot take part in comparisons.
#' The shingle strings themselves are dropped as soon as ids are assigned,
#' which releases most of the peak memory before the minhash stage.
#'
#' @noRd
nd_shingles <- function(data, text_name, shingle_size) {
  shingles <- data %>%
    dplyr::select("document", text = dplyr::all_of(text_name)) %>%
    tidytext::unnest_tokens(
      "shingle", "text",
      token = "ngrams", n = shingle_size
    ) %>%
    dplyr::filter(!is.na(.data$shingle)) %>%
    dplyr::distinct(.data$document, .data$shingle) %>%
    dplyr::arrange(.data$document)

  shingles$shingle_id <- match(shingles$shingle, unique(shingles$shingle))
  shingles$shingle <- NULL
  shingles
}


#' Compute minhash signatures for every document
#'
#' doc_index must be sorted and cover 1..n_docs. For each hash function the
#' grouped minimum is taken with a loop over within-document positions rather
#' than over documents, so each iteration is one vectorised pmin over all
#' documents that have at least that many shingles. These loops are the hot
#' path of the whole function and stay as base loops on purpose: a mapped
#' per-document version does n_docs * n_hashes function calls instead.
#'
#' @noRd
nd_minhash <- function(doc_index, shingle_id, n_docs, n_shingles,
                       coefs, n_hashes, p = 2147483647) {
  counts <- tabulate(doc_index, nbins = n_docs)
  position <- sequence(counts)
  slice_triplet <- split(seq_along(doc_index), position)
  slice_doc <- split(doc_index, position)

  universe <- as.double(seq_len(n_shingles))
  sig <- matrix(0, nrow = n_docs, ncol = n_hashes)

  for (k in seq_len(n_hashes)) {
    hashed <- nd_hash_ints(universe, coefs$a[[k]], coefs$b[[k]], p)
    values <- hashed[shingle_id]
    sig_k <- rep.int(Inf, n_docs)
    for (j in seq_along(slice_triplet)) {
      docs_j <- slice_doc[[j]]
      sig_k[docs_j] <- pmin(sig_k[docs_j], values[slice_triplet[[j]]])
    }
    sig[, k] <- sig_k
  }

  sig
}


#' Find candidate pairs by banding the signature matrix
#'
#' Documents whose signatures agree on every row of at least one band become
#' candidates. Buckets larger than bucket_cap are compared to their first
#' document only (a "star") instead of all-pairs: such buckets are almost
#' always mass-duplicate content, and the star keeps the pair count linear in
#' the bucket size while union-find still connects the whole group.
#'
#' @noRd
nd_candidate_pairs <- function(sig, rows, bands, band_a,
                               p = 2147483647, bucket_cap = 100L) {
  n_docs <- nrow(sig)
  pairs_a <- vector("list", bands)
  pairs_b <- vector("list", bands)

  for (band in seq_len(bands)) {
    band_cols <- ((band - 1L) * rows + 1L):(band * rows)
    key <- rep.int(0, n_docs)
    for (col in band_cols) {
      key <- nd_hash_ints(key, band_a, sig[, col], p)
    }

    shared <- duplicated(key) | duplicated(key, fromLast = TRUE)
    if (!any(shared)) next

    in_bucket <- which(shared)
    buckets <- split(in_bucket, key[in_bucket])

    band_pairs <- purrr::map(buckets, function(members) {
      if (length(members) <= bucket_cap) {
        pair_matrix <- utils::combn(members, 2L)
        list(pair_matrix[1L, ], pair_matrix[2L, ])
      } else {
        list(rep.int(members[[1L]], length(members) - 1L), members[-1L])
      }
    })
    pairs_a[[band]] <- unlist(purrr::map(band_pairs, 1L), use.names = FALSE)
    pairs_b[[band]] <- unlist(purrr::map(band_pairs, 2L), use.names = FALSE)
  }

  a <- unlist(pairs_a, use.names = FALSE)
  b <- unlist(pairs_b, use.names = FALSE)
  if (is.null(a)) {
    return(list(a = integer(0), b = integer(0)))
  }

  # double arithmetic: a * n_docs overflows 32-bit integers past ~46k docs
  first_seen <- !duplicated(as.double(a) * n_docs + b)
  list(a = a[first_seen], b = b[first_seen])
}


#' Exact Jaccard similarity of two shingle-id sets
#'
#' @noRd
nd_jaccard <- function(x, y) {
  common <- sum(match(x, y, nomatch = 0L) > 0L)
  common / (length(x) + length(y) - common)
}


#' Keep only candidate pairs at or above the similarity threshold
#'
#' The small epsilon stops floating point representation of ratios like 7/10
#' from narrowly failing a threshold of 0.7.
#'
#' @noRd
nd_verify_pairs <- function(a, b, sets, similarity) {
  jaccard <- purrr::map2_dbl(
    a, b,
    function(doc_a, doc_b) nd_jaccard(sets[[doc_a]], sets[[doc_b]])
  )
  keep <- jaccard >= similarity - 1e-9
  list(a = a[keep], b = b[keep], similarity = jaccard[keep])
}


#' Connect verified pairs into groups with union-find
#'
#' Roots are always the smallest index in their tree, so each group's
#' representative is its first document in row order. The loop is sequential
#' by nature: each union depends on the state left by the previous one, so it
#' cannot be replaced with a map.
#'
#' @noRd
nd_union_find <- function(a, b, n) {
  parent <- seq_len(n)
  find_root <- function(i) {
    while (parent[[i]] != i) {
      parent[[i]] <<- parent[[parent[[i]]]]
      i <- parent[[i]]
    }
    i
  }
  for (e in seq_along(a)) {
    root_a <- find_root(a[[e]])
    root_b <- find_root(b[[e]])
    if (root_a < root_b) {
      parent[[root_b]] <- root_a
    } else if (root_b < root_a) {
      parent[[root_a]] <- root_b
    }
  }
  purrr::map_int(seq_len(n), find_root)
}


#' The LSH engine: shingle sets in, verified duplicate pairs out
#'
#' This is the contract any future engine must meet: given per-document
#' shingle-id sets and a Jaccard threshold, return list(a, b, similarity)
#' where a and b index into sets and every pair sits at or above the
#' threshold.
#'
#' @noRd
nd_engine_lsh <- function(doc_index, shingle_id, sets, n_docs, n_shingles,
                          similarity, n_hashes, seed) {
  layout <- nd_choose_bands(n_hashes, similarity)
  coefs <- nd_hash_coefficients(n_hashes, seed)

  sig <- nd_minhash(doc_index, shingle_id, n_docs, n_shingles, coefs, n_hashes)
  candidates <- nd_candidate_pairs(sig, layout$rows, layout$bands, coefs$band_a)
  verified <- nd_verify_pairs(candidates$a, candidates$b, sets, similarity)

  c(verified, layout["bands"], layout["rows"])
}
