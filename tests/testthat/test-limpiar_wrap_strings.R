test_that("limpiar_wrap_strings stops fast if inputs aren't right", {

  data <- c()
  expect_error(limpiar_wrap(data), stringr::fixed("is.data.frame"))

  data <- data.frame()
  expect_error(limpiar_wrap(data), stringr::fixed("mention_content"))

  data <- data.frame(
    x = ""
  )
  expect_error(limpiar_wrap(data, x, n = "x"), stringr::fixed("is.numeric"))
  expect_error(limpiar_wrap(data, x, n = 10, newline_char = 1), stringr::fixed("is.character"))
})


test_that("limpiar_wrap_strings output is correct and the parameters work", {

  test_output <- limpiar_examples %>%
    limpiar_wrap(mention_content, n = 5)

  expect_equal(stringr::str_count(test_output[1, "mention_content"], "<br>"), 2)

  test_breaker <- limpiar_examples %>%
    limpiar_wrap(mention_content, n = 5, newline_char = "<testing>")

  expect_equal(stringr::str_count(test_breaker[1, "mention_content"], "<br>"), 0)
  expect_equal(stringr::str_count(test_breaker[1, "mention_content"], "<testing>"), 1)

})
