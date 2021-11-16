data = data.frame(text_var = c(
  "@the_rock you're the #best ever email me on rockfan@hotmail.com p.s. I love @randy_orton too!"))

no_hashtags <- data.frame(text_var = c(
  "@the_rock you're the hashtag ever email me on rockfan@hotmail.com p.s. I love @randy_orton too!"
))

no_user_handles <- data.frame(text_var = c(
  "@user you're the #best ever email me on rockfan@hotmail.com p.s. I love @user too!"
))

no_user_or_hashtags <- data.frame(text_var = c(
  "@user you're the hashtag ever email me on rockfan@hotmail.com p.s. I love @user too!"
))

test_that("Function cleans only hashtags", {

  expect_equal(limpiar_tags(data, text_var = text_var, user = FALSE), no_hashtags)
})


test_that("Function cleans only users", {
  expect_equal(limpiar_tags(data, text_var = text_var, hashtag = FALSE), no_user_handles)
})

test_that("Function cleans both hashtags & users", {
  expect_equal(limpiar_tags(data, text_var = text_var), no_user_or_hashtags)
})
