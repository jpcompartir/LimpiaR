test_that("duplicate posts and deleted or protected mentions are removed", {
  a <- c("hello")
  b <- a
  c <- c("hello there")
  d <- c("Deleted or protected mention")
  z <- tidyr::as_tibble(data.frame(mention_content = rbind(a, b, c,d)))
  w <- tidyr::as_tibble(data.frame(mention_content = rbind(a, c)))

  expect_equal(z %>%
                 limpiar_duplicates(), w)
})

