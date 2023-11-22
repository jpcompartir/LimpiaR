#' Download UDPipe models to begin Parts of Speech Analysis
#'
#' @description
#' A function that retrieves and downloads pre-built models made by the UDPipe community, covering 65 different languages. For more information on what models are available, visit:[UDPipe Documentation](https://bnosac.github.io/udpipe/docs/doc1.html#pre-trained-models)
#'
#' @param language The chosen language that the user wishes to select. There are 65 options to choose from
#' @param model_directory A string pointing to a specific directory informing the function where to save the model
#' @param overwrite Whether to overwrite any pre-exisiting models saved in this location. `overwrite` is set to `TRUE` by default, meaning it will download the model and overwrite the file if the file already existed. If set to `FALSE`, the model will only be downloaded if it does not already exist on disk.
#'
#' @return Saves a model to the provided directory for the user to load into the session using `limpiar_pos_load_model`.
#' @export
#'
#' @examples
#' model <- limpiar_pos_download_model(language = "english", model_directory = "data/", overwrite = TRUE)
limpiar_pos_download_model <- function(language,
                                       model_directory,
                                       overwrite = TRUE) {
  stopifnot(is.character(language),
            is.character(model_directory),
            is.logical(overwrite))

  udpipe::udpipe_download_model(language = language,
                                model_dir = model_directory,
                                overwrite = overwrite)
}
