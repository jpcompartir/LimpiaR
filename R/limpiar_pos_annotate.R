#' Annotate Texts for Parts of Speech Analysis
#'
#' @param data The data.frame or tibble object containing any texts that the user wishes to conduct parts of speech analysis on.
#' @param text_var Any texts or sentences the user wishes to perform the parts of speech annotations on.
#' @param saved_model A UDPipe model loaded into memory using `limpiar_pos_load_model`, and must be of class 'udpipe_model'.
#' @param in_parallel A logical argument allowing the user to leverage parallel processing to speed the function up. If set to TRUE,  the function will select the number of available cores minus 1 and process more efficiently(faster).
#' @param parse_text Whether to perform dependency parsing on tokens. The default is set to "parser". The user may skip this step by supplying the argument with "none".
#' @param ... To enable the user to supply any additonal arguments.
#' @return Returns a data frame object derived from CONLL-U formatting, where each row is an annotation of a word. To find out more on the formatting methods, read [here](https://universaldependencies.org/format.html).
#' @export
#'
#' @examples
#' output <- limpiar_pos_annotate(data = data, text_var = clean_text, saved_model = model_loaded, in_parallel = TRUE, parser = "none")
limpiar_pos_annotate <- function(data,
                                 text_var,
                                 saved_model,
                                 in_parallel = FALSE,
                                 parse_text = FALSE,
                                 ...) {

  # ensure data is of class data.frame, list or character and assign size by nrow number
  if (is.data.frame(data)) {
    size <- nrow(data)
  } else if (is.list(data) || is.character(data)) {
    size <- length(data)
  } else {
    stop("data should either be a data.frame, a list, or a character vector")
  }

  # convert text_var to character using non-standard evaluation
  text_var <- rlang::ensym(text_var)
  text_var <- as.character(rlang::eval_tidy(text_var, data))

  # ensure the model is of udpipe_model format and stop if not
  if (!inherits(saved_model, "udpipe_model")) {
    stop("saved_model should be of class udpipe_model as returned by the function limpiar_pos_load_model.")
  }

  # creates a logical argument for dealing with parse_text argument
  stopifnot(is.logical(parse_text))
  if (parse_text == TRUE) {
    parse_text <- "parser"
    message("performing dependency parsing on tokens")
  } else {
    parse_text <- "none"
  }

  # if statement for parallelization bits of code and chunksize that the udpipe function requires
  if (in_parallel == TRUE) {
    parallel.cores <- future::availableCores() - 1
    parallel.chunksize <- ceiling(size / parallel.cores)
  } else {
    parallel.cores <- 1L
    parallel.chunksize <- NULL
  }

  # fix the typo in the function call
  output <- udpipe::udpipe(x = text_var, object = saved_model, parallel.cores = parallel.cores, parallel.chunksize = parallel.chunksize, parser = parse_text)

  return(output)
}
