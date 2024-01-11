test_that("input validation", {

  # define the correct model class here for later
  model_loaded <- "hello world"
  attr(model_loaded, "class") <- "udpipe_model"

  # expect error as data is not of data.frame class
  expect_error(limpiar_pos_annotate(data = 123), regexp = "is.data.frame")

  # expects dependency_parse input to be logical(TRUE or FALSE)
  expect_error(limpiar_pos_annotate(data = data.frame(), dependency_parse = "yeah"), regexp = "is.logical")

  # expects in_parallel input to be logical(TRUE or FALSE)
  expect_error(limpiar_pos_annotate(data = data.frame(), dependency_parse = FALSE, in_parallel = "go on then"), regexp = "is.logical")

  # expect pos_model to be of class udpipe_model
  expect_error(limpiar_pos_annotate(data = data.frame(), pos_model = 123), regexp = "pos_model should be of class udpipe_model")

  # expect error when text_var is missing
  expect_error(limpiar_pos_annotate(data = data.frame(), pos_model = model_loaded), regexp = "is missing, with no default")

  # expect to be met with error when id_var not supplied
  expect_error(limpiar_pos_annotate(data = data.frame(text = "text"), text_var = text, pos_model = model_loaded), regexp = "id_var not supplied, unable to join annotations to original data")
})


test_that("output validation - id_var is unchanged between input and output and dependency parsing works", {

  # create some data and load a model
  data <- data.frame(text = paste0("texts",1:5),
                     universal_message_id = paste0("TWITTER", 1:5))
  model_loaded <- limpiar_pos_import_model("english")

  output <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = universal_message_id)

  # all dependency parsing bits should NOT be present
  expect_contains(object = names(output), expected = c("paragraph_id", "sentence_id", "sentence", "token_id", "token", "lemma", "pos_tag", "xpos", "id_var", "text", "universal_message_id"))

  # id_var is unchanged by function
  expect_identical(data$universal_message_id, unique(output$id_var))

  # now create an output object with parsed tokens
  output_w_dep_parsing <- limpiar_pos_annotate(data = data, text_var = text, pos_model = model_loaded, id_var = universal_message_id, dependency_parse = TRUE)

  # all dependency parsing bits should be present
  expect_contains(object = names(output_w_dep_parsing), expected = c("paragraph_id", "sentence_id", "sentence", "token_id", "token", "lemma", "pos_tag", "xpos", "feats", "head_token_id", "dependency_tag", "id_var", "text", "universal_message_id"))

  # no dep tags should be NA
  expect_false(any(is.na(output_w_dep_parsing$dependency_tag)))
})
