test_that("input validation", {

  # define the correct model class here for later
  model_loaded <- "hello world"
  attr(model_loaded, "class") <- "udpipe_model"

  # expect error as data is not of data.frame class
  expect_error(limpiar_pos_annotate(data = 123), info = "is.data.frame(data) is not TRUE")

  # expect pos_model to be of class udpipe_model
  expect_error(limpiar_pos_annotate(data = data.frame(), pos_model = 123), regexp = "pos_model should be of class udpipe_model")

  # expect error when text_var is missing
  expect_error(limpiar_pos_annotate(data = data.frame(), pos_model = model_loaded), info = `argument "text_var" is missing`)

  # expect to be met with error when id_var not supplied
  expect_error(limpiar_pos_annotate(data = data.frame(text = "text"), text_var = text, pos_model = model_loaded), regexp = "id_var not supplied, unable to join annotations to original data")
})


test_that("output validation - id_var is unchanged between input and output and dependency parsing works", {

  # create some data and load a model
  data <- data.frame(text = paste0("texts",sample(1:5, 5, replace = FALSE))) %>% dplyr::mutate(universal_message_id = paste0("TWITTER", sample(1:5, 5, replace = FALSE)))
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = universal_message_id)

  # id_var is unchanged by function
  expect_identical(data$universal_message_id, unique(output$id_var))

  # all dep tags should be NA
  expect_true(all(is.na(output$dependency_tag)))

  # now create an output object with parsed tokens
  output_w_parsing <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = universal_message_id, parse_text = TRUE)

  # no dep tags should be NA
  expect_false(any(is.na(output_w_parsing$dependency_tag)))
})
