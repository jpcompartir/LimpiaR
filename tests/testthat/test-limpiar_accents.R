test_that("Test that accents are removed", {
  dirty_vec <- c('róllover','ùltimatüm', 'ársénal','fíring hose', 'fún',
                 'reèd ', 'ñino')
  cleaned_vec <- c("rollover","ultimatum","arsenal",
               "firing hose","fun","reed ","nino")
  df <- tibble::as_tibble(data.frame(mention_content = unlist(dirty_vec)))
  df_two <- tibble::as_tibble(data.frame(mention_content = unlist(cleaned_vec)))

  expect_equal(df %>%
                 limpiar_accents(),df_two)
})
