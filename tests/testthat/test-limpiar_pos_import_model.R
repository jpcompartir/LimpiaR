test_that("input validation and output of appropriate class", {

  # expects error when supplying language argument without string
  expect_error(limpiar_pos_import_model(language = english), regexp = "object 'english' not found")

  model_loaded <- limpiar_pos_import_model(language = "english")
  # expect no error when input is appropriate
  expect_no_error(model_loaded)

  # expect output to be of udpipe_model class
  expect_true(inherits(model_loaded, "udpipe_model"))
})
