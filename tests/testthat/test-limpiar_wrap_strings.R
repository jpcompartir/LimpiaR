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
