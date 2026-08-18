make_corpus <- function(n_docs, seed = 99) {
  set.seed(seed)
  vocab <- paste0("w", 1:5000)
  zipf <- 1 / seq_along(vocab)

  n_base <- floor(n_docs * 0.55)
  n_near <- floor(n_docs * 0.25)
  n_mass <- floor(n_docs * 0.05)
  n_noise <- n_docs - n_base - n_near - n_mass

  base_docs <- purrr::map_chr(seq_len(n_base), function(i) {
    len <- sample(6:60, 1)
    paste(sample(vocab, len, replace = TRUE, prob = zipf), collapse = " ")
  })
  near <- purrr::map_chr(sample(base_docs, n_near, replace = TRUE), function(d) {
    words <- strsplit(d, " ")[[1]]
    k <- max(1, floor(length(words) * 0.1))
    words[sample(length(words), k)] <- sample(vocab, k)
    paste(words, collapse = " ")
  })
  mass <- rep(base_docs[1], n_mass)
  noise <- purrr::map_chr(seq_len(n_noise), function(i) {
    paste(sample(vocab, sample(6:40, 1)), collapse = " ")
  })
  tibble::tibble(text = sample(c(base_docs, near, mass, noise)))
}
