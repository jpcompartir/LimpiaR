test_that("limpiar_ex_subreddits extracts subreddits and produces correct error message if not", {

  data <- tidyr::tibble(
    permalink = c("www.reddit.com/r/wallstreetbets",
                  "www.reddit.com/r/random")
  )

  extracted <- data %>%
    limpiar_ex_subreddits()

  expect_setequal(names(extracted), c("permalink", "subreddit"))
  expect_equal(extracted$subreddit[[1]], "/r/wallstreetbets")
  error_data <- tidyr::tibble(permalink = 1)

  expect_error(limpiar_ex_subreddits(error_data, permalink), regexp = "permalink should be a character vector")
})
