test_that("saved_model expects udpipe_model class", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  expect_true(inherits(model_loaded, "udpipe_model"))
})


test_that("defualt arguments are working and in_parallel speeds up processing time", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  start_time <- Sys.time() # time function processing time
  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document)
  finish_time <- Sys.time()
  diff <- finish_time - start_time

  start_time <- Sys.time() # now time with in_parallel = TRUE
  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, in_parallel = TRUE, parse_text = FALSE)
  finish_time <- Sys.time()
  diff_parallel <- finish_time - start_time

  # expect processing time to be faster with in_parallel argument TRUE
  expect_true(diff_parallel < diff)

  # dependency parsing is FALSE by default. dep_rel column should be empty
  expect_true(all(is.na(output$dependency_tag)))
})


test_that("dependency parsing feature is working", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, in_parallel = TRUE, parse_text = FALSE)
  expect_true(all(is.na(output$dependency_tag)))

  output_w_parsing <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, in_parallel = TRUE, parse_text = TRUE)
  expect_false(any(is.na(output_w_parsing$dependency_tag)))
})


test_that("output is in expected format", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, in_parallel = TRUE, parse_text = FALSE)

  expect_true(inherits(output, "data.frame"))
})

