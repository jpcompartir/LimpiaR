test_that("saved_model expects udpipe_model class", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")
  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, in_parallel = TRUE, parse_text = FALSE)

  expect_true(inherits(model_loaded, "udpipe_model"))
  expect_false(is.data.frame(model_loaded))
  # models from download model function are of data.frame class
})


test_that("in_parallel speeds up processing time", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")
  start_time <- Sys.time() # time function processing time
  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, in_parallel = FALSE, parse_text = FALSE)
  finish_time <- Sys.time()
  diff <- finish_time - start_time

  start_time <- Sys.time() # now time with in_parallel = TRUE
  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, in_parallel = TRUE, parse_text = FALSE)
  finish_time <- Sys.time()
  diff_parallel <- finish_time - start_time

  expect_true(diff_parallel < diff)
})


test_that("dependency parsing works as intended", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, in_parallel = TRUE, parse_text = FALSE)
  expect_true(all(is.na(output$nested_pos_data[[1]]$dep_rel)))

  output_w_parsing <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, in_parallel = TRUE, parse_text = TRUE)
  expect_false(any(is.na(output_w_parsing$nested_pos_data[[1]]$dep_rel)))
})


test_that("output is in expected format", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, in_parallel = TRUE, parse_text = FALSE)

  expect_true(inherits(output, "data.frame"))
})

