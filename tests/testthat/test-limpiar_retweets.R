test_that("retweets are filtered out of the data set", {
  a <- c("this is a drill")
  b <- c("this isn't a drill")
  c <- c("this might be a drill rt")
  d <- c("rt for fun")

  y <- tidyr::as_tibble(data.frame(mention_content = rbind(a, b)))


  z <- data.frame(mention_content = rbind(a, b, c, d))
  z <- tidyr::as_tibble(z)
  expect_equal(z %>%
                 limpiar_retweets, y)
})
