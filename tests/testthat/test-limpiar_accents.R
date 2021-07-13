test_that("Accents are removed", {
  dirty_vec <- c('róllover','ùltimatüm', 'ársénal','fíring hose', 'fún',
                 'reèd ', 'ñino')
  cleaned_vec <- c("rollover","ultimatum","arsenal",
               "firing hose","fun","reed ","nino")

  expect_equal(sort(cleaned), sort(limpiar_accents(test_vecs)))
})

test_that("works within a pipe", {
  dirty_vec <- c('róllover','ùltimatüm', 'ársénal','fíring hose', 'fún',
                 'reèd ', 'ñino')
  cleaned_vec <- c("rollover","ultimatum","arsenal",
               "firing hose","fun","reed ","nino")
  df <- tibble::as_tibble(data.frame(mention_content = unlist(dirty_vec)))
  df_two <- tibble::as_tibble(data.frame(mention_content = unlist(cleaned_vec)))

  expect_equal(df %>%
                 dplyr::mutate(mention_content = limpiar_accents(mention_content)),df_two)
})

