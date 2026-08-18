test_that("finds planted near-duplicate and exact-duplicate pairs", {
  out <- limpiar_examples %>%
    limpiar_near_duplicates(mention_content, similarity = 0.5)

  expect_named(out, c("duplicates", "data", "deleted"))

  # Rows 1 and 2 are a tweet and its retweet, rows 4 and 5 are exact copies.
  # The retweet pair shares 7 of 8 distinct shingles, so Jaccard = 0.875.
  expect_equal(sort(out$duplicates$group), c(1L, 4L))
  expect_equal(sort(out$deleted$document), c(2L, 5L))
  expect_equal(
    out$deleted$similarity[order(out$deleted$document)],
    c(7 / 8, 1)
  )
  expect_equal(nrow(out$data), nrow(limpiar_examples) - 2)
})

test_that("first occurrence is kept and later occurrences are deleted", {
  out <- limpiar_examples %>%
    limpiar_near_duplicates(mention_content, similarity = 0.5)

  expect_true(all(out$deleted$group < out$deleted$document))
  expect_true(all(out$duplicates$group %in% out$data$document))
  expect_false(any(out$deleted$document %in% out$data$document))
})

test_that("results are identical for the same seed", {
  run_1 <- limpiar_near_duplicates(limpiar_examples, mention_content,
    similarity = 0.5, seed = 100
  )
  run_2 <- limpiar_near_duplicates(limpiar_examples, mention_content,
    similarity = 0.5, seed = 100
  )
  expect_identical(run_1, run_2)
})

test_that("the caller's random number state is not disturbed", {
  set.seed(1)
  before <- .Random.seed
  invisible(limpiar_near_duplicates(limpiar_examples, mention_content))
  expect_identical(before, .Random.seed)
})

test_that("a high threshold removes only exact duplicates", {
  out <- limpiar_examples %>%
    limpiar_near_duplicates(mention_content, similarity = 0.99)

  expect_equal(out$deleted$document, 5L)
  expect_equal(out$deleted$similarity, 1)
})

test_that("data with no near duplicates returns empty results", {
  df <- tibble::tibble(
    text = c(
      "the quick brown fox jumps over the lazy dog",
      "completely different words about gardening in spring sunshine",
      "financial markets closed higher after the announcement today"
    )
  )
  out <- limpiar_near_duplicates(df, text)

  expect_equal(nrow(out$duplicates), 0)
  expect_equal(nrow(out$deleted), 0)
  expect_equal(nrow(out$data), 3)
  expect_named(
    out$duplicates,
    c("group", "text", "n_duplicates", "mean_similarity", "min_similarity")
  )
  expect_named(out$deleted, c("text", "document", "group", "similarity"))
})

test_that("short, empty, and NA documents are always kept", {
  df <- tibble::tibble(
    text = c(
      "one two", "one two", "", NA_character_,
      "these five words repeat here exactly the same way",
      "these five words repeat here exactly the same way"
    )
  )
  out <- limpiar_near_duplicates(df, text, similarity = 0.5)

  # The two-word documents are identical but too short to shingle.
  expect_equal(out$deleted$document, 6L)
  expect_equal(sort(out$data$document), c(1L, 2L, 3L, 4L, 5L))
})

test_that("text_var accepts a string as well as a symbol", {
  by_symbol <- limpiar_near_duplicates(limpiar_examples, mention_content,
    similarity = 0.5
  )
  by_string <- limpiar_near_duplicates(limpiar_examples, "mention_content",
    similarity = 0.5
  )
  expect_identical(by_symbol, by_string)
})

test_that("extra columns are preserved in data and deleted", {
  out <- limpiar_examples %>%
    limpiar_near_duplicates(mention_content, similarity = 0.5)

  expected <- c(names(limpiar_examples), "document")
  expect_named(out$data, expected)
  expect_named(out$deleted, c(expected, "group", "similarity"))
  expect_equal(
    out$deleted$author_name,
    limpiar_examples$author_name[out$deleted$document]
  )
})

test_that("invalid inputs raise clear errors", {
  expect_error(
    limpiar_near_duplicates(limpiar_examples, mention_content, similarity = 0),
    "similarity"
  )
  expect_error(
    limpiar_near_duplicates(limpiar_examples, mention_content, similarity = 1.5),
    "similarity"
  )
  expect_error(
    limpiar_near_duplicates(limpiar_examples, mention_content, shingle_size = 0),
    "shingle_size"
  )
  expect_error(
    limpiar_near_duplicates(limpiar_examples, mention_content, n_hashes = 1),
    "n_hashes"
  )
  expect_error(
    limpiar_near_duplicates(limpiar_examples, mention_content, engine = "ann")
  )
  expect_error(
    limpiar_near_duplicates(
      dplyr::rename(limpiar_examples, group = mention_content), group
    ),
    "reserved"
  )
})

test_that("all planted pairs are recovered on a larger synthetic corpus", {
  set.seed(2024)
  vocabulary <- paste0("word", 1:500)
  base_docs <- purrr::map_chr(
    1:20,
    function(i) paste(sample(vocabulary, 15), collapse = " ")
  )
  # Each near duplicate changes the last word only. That alters one of the 13
  # three-word shingles, so each pair shares 12 of 14, Jaccard = 6/7.
  near_dupes <- sub(" \\S+$", " changed", base_docs)
  noise_docs <- purrr::map_chr(
    1:30,
    function(i) paste(sample(vocabulary, 15), collapse = " ")
  )

  df <- tibble::tibble(text = c(base_docs, near_dupes, noise_docs))
  out <- limpiar_near_duplicates(df, text, similarity = 0.6)

  expect_equal(sort(out$deleted$document), 21:40)
  expect_equal(sort(out$deleted$group), 1:20)
  expect_true(all(out$deleted$similarity >= 0.6))
})

test_that("chained near duplicates end up in one group", {
  df <- tibble::tibble(
    text = c(
      "alpha bravo charlie delta echo foxtrot golf hotel india juliet",
      "alpha bravo charlie delta echo foxtrot golf hotel india kilo",
      "alpha bravo charlie delta echo foxtrot golf hotel lima kilo"
    )
  )
  out <- limpiar_near_duplicates(df, text, similarity = 0.6)

  expect_equal(out$deleted$document, c(2L, 3L))
  expect_equal(out$deleted$group, c(1L, 1L))
  expect_equal(out$duplicates$n_duplicates, 2L)
})

test_that("band layout sits at or below the similarity threshold", {
  layout <- LimpiaR:::nd_choose_bands(100, 0.7)
  expect_equal(layout$bands * layout$rows, 100)
  expect_lte(layout$threshold, 0.7)

  strict <- LimpiaR:::nd_choose_bands(100, 0.99)
  expect_lte(strict$threshold, 0.99)
})

test_that("jaccard helper matches hand-computed values", {
  expect_equal(LimpiaR:::nd_jaccard(1:4, 3:6), 2 / 6)
  expect_equal(LimpiaR:::nd_jaccard(1:3, 1:3), 1)
  expect_equal(LimpiaR:::nd_jaccard(1:3, 4:6), 0)
})
