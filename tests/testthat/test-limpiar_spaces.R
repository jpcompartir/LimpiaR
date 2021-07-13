test_that("Excess spaces are removed from text variable", {
  a <- c("hello")
  b <- c("hello   lol")
  c <- c("hello there")
  d <- c("Deleted or protected mention")
  e <- c("hello lol")
  y <- tidyr::as_tibble(data.frame(mention_content = rbind(a, e, c, d)))
  z <- tidyr::as_tibble(data.frame(mention_content = rbind(a, b, c, d)))
  z %>%
    limpiar_spaces()

  expect_equal(z %>%
                 limpiar_spaces(), y)
})
