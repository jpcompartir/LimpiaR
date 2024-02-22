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

  # Set up the route to the model cache directory - we want to cache models where possible
  model_cache_dir <- file.path(normalizePath(system.file(package = "LimpiaR")), "model_cache")

  # Check the directory exists as it should've been created in .onLoad - if it's not, we'll just use a tempdir() - should circumvent potential problems in Virtual Machines like github actions etc.?
  if(dir.exists(model_cache_dir)){
    model_dir = model_cache_dir
  } else {
    message("Cannot identify model_cache directory in Library, saving model to tempdir()")
    model_dir = tempdir()
  }

  # stop if not statement, for language input being of string class
  stopifnot(rlang::is_string(language))

  # save model to a temporary directory and don't overwrite unless models not already in the temp directory
  model <- udpipe::udpipe_download_model(language = language,
                                         model_dir = model_dir,
                                         overwrite = FALSE)

  # load model from the directory
  model_loaded <- udpipe::udpipe_load_model(file = model$file)

  return(model_loaded)
}
