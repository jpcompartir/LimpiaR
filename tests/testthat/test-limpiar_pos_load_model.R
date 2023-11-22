test_that("model_directory argument works as intended", {
  # load from where the saved model in data file is
  saved_model_dir <- "data/french-gsd-ud-2.5-191206.udpipe"

  loaded_model <- limpiar_pos_load_model(model_directory = saved_model_dir)

  expect_identical(saved_model_dir, loaded_model$file)
})
