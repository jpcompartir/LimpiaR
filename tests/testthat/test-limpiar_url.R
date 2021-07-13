test_that("multiplication works", {
  d <- c("find my website at: https://www.davidbrent.com")
  dd <- c("find my website at: ")
  e <- c("never visit this website: http://www.garethkeenan.org")
  ee <- c("never visit this website: ")
  f <- c("the old triangle, it goes jingle jangle")
  y <- tidyr::as_tibble(data.frame(mention_content = rbind(dd, ee, f)))
  df <- tidyr::as_tibble(data.frame(mention_content = rbind(d, e, f)))


  expect_equal(df %>% limpiar_url(), y)
})
