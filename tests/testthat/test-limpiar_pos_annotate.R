test_that("function will only run when data is of data.frame class", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100) %>% dplyr::mutate(universal_message_id = paste0("TWITTER", sample(1:100, 100, replace = FALSE)))
  model_loaded <- limpiar_pos_import_model("english")

  outputa <- limpiar_pos_annotate(data = data, text_var = text, id_var = universal_message_id, pos_model = model_loaded, parse_text = FALSE)
  expect_no_error(outputa)

  data_matrix <- as.matrix(data) # convert data to matrix class
  # catch the error message when data is not correct class
  outputb <- tryCatch(
    limpiar_pos_annotate(data = data_matrix, text_var = text, id_var = universal_message_id, pos_model = model_loaded, parse_text = FALSE),
    error = function(e) e
  )
  expect_identical(outputb$message, "is.data.frame(data) is not TRUE")

  # catch the error message when id_var not supplied
  outputc <- tryCatch(
    limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, parse_text = FALSE),
    error = function(e) e
  )
  expect_identical(outputc$message, "id_var not supplied, unable to join annotations to original data")
})


test_that("dependency parsing feature is working", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, parse_text = FALSE)
  expect_true(all(is.na(output$dependency_tag)))

  output_w_parsing <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, parse_text = TRUE)
  expect_false(any(is.na(output_w_parsing$dependency_tag)))
})


test_that("output is in expected format", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100)
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = document, parse_text = FALSE)

  expect_true(inherits(output, "data.frame"))
})


test_that("id_var is unchanged between input and output", {
  data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]), document = 1:100) %>% dplyr::mutate(universal_message_id = paste0("TWITTER", sample(1:100, 100, replace = FALSE)))
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = universal_message_id, parse_text = FALSE)

  input_id_var <- data$universal_message_id
  output_id_var <- unique(output$id_var)

  expect_identical(input_id_var, output_id_var)
})
