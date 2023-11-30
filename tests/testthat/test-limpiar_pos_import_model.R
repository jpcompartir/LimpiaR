test_that("language argument works as intended", {
 model <- limpiar_pos_import_model(language = "spanish")

 expect_true(stringr::str_detect(model$file, "spanish"))
})


test_that("model is of approptiate class", {
  model <- limpiar_pos_import_model(language = "english")

  expect_true(inherits(model, "udpipe_model"))
})
