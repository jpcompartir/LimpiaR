#' Load Previously Downloaded UDPipe Models
#'
#' @param model_directory A string pointing to a specific directory where a UDPipe classified model is saved
#'
#' @return Loads the model into memory, ready for the annotation steps in the parts of speech workflow
#' @export
#'
#' @examples
#' model_loaded <- limpiar_pos_load_model(model_directory = "data/english-ewt-ud-2.5-191206.udpipe")
limpiar_pos_load_model <- function(model_directory) {

  stopifnot(is.character(model_directory))

  udpipe::udpipe_load_model(file = model_directory)
}
