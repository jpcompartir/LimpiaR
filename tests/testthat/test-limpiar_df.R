test_that("data frame gets cleaned", {
  a <-cbind(c("Hello, wélcóme to LimpiaR",
              "HELLO, WÉLCÓME TO LIMPIAR",
              "RT Welcome to LimpiaR!",
              "Hello, wélcóme to LimpiaR",
              "URL HERE https::limpiar.com ",
              "Hello,    welcome to LIMPIAR!"))

  b <- cbind(c("www.twitter.com",
               "www.facebook.com",
               "www.youtube.es",
               "www.twitter.com",
               "guardian.net",
               "www.randomlink.com"))

  df <- data.frame(mention_content = a,
                   Text_url= b)

  c <- cbind(c("hello, welcome to limpiar",
               "url here",
               "hello, welcome to limpiar!"))
  d <- cbind(c("www.twitter.com",
               "guardian.net",
               "www.randomlink.com"))
  answer_df <- data.frame(mention_content = c,
                          Text_url = d)

  expect_equal(limpiar_df(df, mention_content), answer_df)
})
