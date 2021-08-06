test_that("NA-heavy columns removed from data frame or tibble", {
  a <- cbind(c(NA, NA, NA, NA, NA))
  b <- cbind(c(NA, NA, 2, 3, NA))
  c <- cbind(c(1, 2, 3, 4, 5))

  df <- tibble::as_tibble(data.frame(a, b, c))
  df_two <- tibble::as_tibble(data.frame(b, c))
  df_three <- tibble::as_tibble(data.frame(c))

  expect_equal(limpiar_na_cols(df, 0.4), df_two)
  expect_equal(limpiar_na_cols(df, 0.5), df_three)
})
