#' Remove near-duplicate posts
#'
#' @description
#' Finds groups of posts whose text is nearly identical, keeps the first post
#' of each group, and removes the rest. Two posts count as near duplicates
#' when the Jaccard similarity of their shingle sets is at least `similarity`,
#' where a shingle is a run of `shingle_size` consecutive words. Text is
#' lowercased and stripped of punctuation before shingling, but the returned
#' data keeps your original text.
#'
#' The default engine uses minhash signatures with locality sensitive hashing
#' (LSH), so it scales to hundreds of thousands of documents without comparing
#' every pair. The method is probabilistic. Every removal is confirmed with an
#' exact similarity calculation, so precision does not depend on chance, but a
#' small share of true near-duplicate pairs close to the threshold can be
#' missed. Results are reproducible for a fixed `seed`, and raising `n_hashes`
#' reduces the number of missed pairs at a linear cost in compute time. See
#' `vignette("near_duplicates")` for guidance on choosing parameters.
#'
#' Documents with fewer than `shingle_size` words produce no shingles, so they
#' are always kept. The function adds a `document` column holding the original
#' row number, overwriting any existing column with that name.
#'
#' @inheritParams data_param
#' @inheritParams text_var
#' @param similarity Jaccard similarity threshold between 0 and 1. Pairs of
#'   documents at or above the threshold are treated as near duplicates.
#' @param shingle_size Number of consecutive words in each shingle.
#' @param n_hashes Number of minhash functions in each document's signature.
#'   More hashes find more of the true near-duplicate pairs and take longer to
#'   run.
#' @param engine Method used to find near-duplicate pairs. Currently only
#'   `"lsh"` is available.
#' @param seed Integer seed for the random hash functions. The same data,
#'   parameters, and seed always return the same result.
#'
#' @return A list of three tibbles:
#'   * `duplicates`: one row per near-duplicate group, with the kept document's
#'     row number (`group`), its text, the number of removed documents
#'     (`n_duplicates`), and the mean and minimum similarity of the removed
#'     documents to the kept one.
#'   * `data`: the input data with near duplicates removed.
#'   * `deleted`: the removed rows, each tagged with its `group` and its
#'     `similarity` to the document that was kept.
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' near_dupes <- limpiar_examples %>%
#'   limpiar_near_duplicates(mention_content, similarity = 0.5)
#'
#' near_dupes$duplicates
#' near_dupes$data
#' near_dupes$deleted
limpiar_near_duplicates <- function(data,
                                    text_var = mention_content,
                                    similarity = 0.7,
                                    shingle_size = 3,
                                    n_hashes = 100,
                                    engine = c("lsh"),
                                    seed = 42) {
  stopifnot(is.data.frame(data))
  engine <- match.arg(engine)
  if (!is.numeric(similarity) || length(similarity) != 1 ||
    similarity <= 0 || similarity > 1) {
    stop("`similarity` must be a single number greater than 0 and at most 1")
  }
  if (!is.numeric(shingle_size) || length(shingle_size) != 1 || shingle_size < 1) {
    stop("`shingle_size` must be a single whole number of at least 1")
  }
  if (!is.numeric(n_hashes) || length(n_hashes) != 1 || n_hashes < 2) {
    stop("`n_hashes` must be a single whole number of at least 2")
  }

  text_name <- names(dplyr::select(data, {{ text_var }}))
  if (length(text_name) != 1) {
    stop("`text_var` must select exactly one column")
  }
  if (text_name %in% c("document", "group", "similarity")) {
    stop(
      "rename your text column: `", text_name,
      "` is reserved for the function's output"
    )
  }

  data <- dplyr::mutate(data, document = dplyr::row_number())

  shingles <- nd_shingles(data, text_name, shingle_size)
  documents <- unique(shingles$document)
  doc_index <- match(shingles$document, documents)
  sets <- split(shingles$shingle_id, doc_index)

  pairs <- switch(engine,
    lsh = nd_engine_lsh(
      doc_index = doc_index,
      shingle_id = shingles$shingle_id,
      sets = sets,
      n_docs = length(documents),
      n_shingles = max(shingles$shingle_id, 0L),
      similarity = similarity,
      n_hashes = n_hashes,
      seed = seed
    )
  )

  roots <- nd_union_find(pairs$a, pairs$b, length(documents))
  removed <- which(roots != seq_along(roots))

  if (length(removed) == 0) {
    duplicates <- tibble::tibble(
      group = integer(0),
      n_duplicates = integer(0),
      mean_similarity = double(0),
      min_similarity = double(0)
    )
    duplicates[[text_name]] <- character(0)
    duplicates <- dplyr::relocate(
      duplicates, dplyr::all_of(text_name),
      .after = "group"
    )
    deleted <- data[0, ]
    deleted$group <- integer(0)
    deleted$similarity <- double(0)
    return(list(duplicates = duplicates, data = data, deleted = deleted))
  }

  removed_similarity <- purrr::map2_dbl(
    removed, roots[removed],
    function(doc, root) nd_jaccard(sets[[doc]], sets[[root]])
  )

  removal_order <- order(documents[roots[removed]], documents[removed])
  removal <- tibble::tibble(
    document = documents[removed],
    group = documents[roots[removed]],
    similarity = removed_similarity
  )[removal_order, ]

  duplicates <- removal %>%
    dplyr::summarise(
      n_duplicates = dplyr::n(),
      mean_similarity = mean(.data$similarity),
      min_similarity = min(.data$similarity),
      .by = "group"
    ) %>%
    dplyr::arrange(dplyr::desc(.data$n_duplicates), .data$group)
  duplicates[[text_name]] <- data[[text_name]][duplicates$group]
  duplicates <- dplyr::relocate(
    duplicates, dplyr::all_of(text_name),
    .after = "group"
  )

  deleted <- data[removal$document, ]
  deleted$group <- removal$group
  deleted$similarity <- removal$similarity

  kept <- data[-removal$document, ]

  list(duplicates = duplicates, data = kept, deleted = deleted)
}
