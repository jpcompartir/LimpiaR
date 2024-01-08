test_that("language argument works as intended", {
 model <- limpiar_pos_import_model(language = "english")

 expect_true(stringr::str_detect(model$file, "english"))
})


test_that("input must be string", {

  modela <- limpiar_pos_import_model(language = "english")
  expect_no_error(modela)

  # catch the error message and then test if its to be expected
  modelb <- tryCatch(
    limpiar_pos_import_model(language = english),
    error = function(e) e
  )
  expect_identical(modelb$message, expected = "object 'english' not found")
})


test_that("model output is of appropriate class", {
  model <- limpiar_pos_import_model(language = "english")

  expect_true(inherits(model, "udpipe_model"))
})
