test_that("download model functions work as intended", {
  model <- limpiar_pos_download_model(language = "french", model_directory = "data/", overwrite = FALSE)

  # test the language argument works
  expect_identical("french-gsd", model$language)

  # check model downloaded with no problems
  expect_false(model$download_failed)
  expect_match(model$download_message, regexp = "OK")
})
