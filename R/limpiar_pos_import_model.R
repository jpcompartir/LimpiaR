#' Import UDPipe models to begin Parts of Speech Analysis
#'
#' @description
#' A function that retrieves and downloads pre-built models made by the UDPipe community, covering 65 different languages. For more information on what models are available, visit:[UDPipe Documentation](https://bnosac.github.io/udpipe/docs/doc1.html#pre-trained-models)
#'
#'
#' @param language The chosen language that the user wishes to select. There are 65 options to choose from
#'
#' @return Loads the model into memory, ready for the annotation steps in the parts of speech workflow.
#' @export
#'
#' @examples
#' pos_model <- limpiar_pos_import_model(language = "english")
limpiar_pos_import_model <- function(language) {

  # stop if not statement, for language input being of string class
  stopifnot(rlang::is_string(language))

  # save model to a temporary directory and don't overwrite unless models not already in the temp directory
  model <- udpipe::udpipe_download_model(language = language,
                                         model_dir = tempdir(),
                                         overwrite = FALSE)

  # load model from the temp directory
  model_loaded <- udpipe::udpipe_load_model(file = model$file)

  return(model_loaded)
}

