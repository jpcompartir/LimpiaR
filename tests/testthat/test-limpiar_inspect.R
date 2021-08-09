test_that("inspection works", {
  a <- c("http.url.com")
  b <- a
  c <- b
  d <- c
  e <- c("my mention content")
  f <- c("do not view me")
  g <- e
  h <- e
  i <- c(rbind(e, f, g, h))
  j <- data.frame(mention_content = i, mention_url = rbind(a, b, c, d))
  k <- c(rbind(e, g, h))
  l <- tibble::view(data.frame(mention_content = k, mention_url = rbind(a,c,d)))

  expect_equal(limpiar_inspect(j, pattern = "men"), l)
})
