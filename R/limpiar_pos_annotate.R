#' Annotate Texts for Parts of Speech Analysis
#'
#' @param data The data.frame or tibble object containing any texts that the user wishes to conduct parts of speech analysis on.
#' @param text_var Any texts or sentences the user wishes to perform the parts of speech annotations on.
#' @param pos_model A UDPipe model imported using `limpiar_pos_import_model`, and must be of class 'udpipe_model'.
#' @param in_parallel A logical argument allowing the user to leverage parallel processing to speed the function up. If set to TRUE,  the function will select the number of available cores minus one, processing more efficiently(faster), leaving one core to manage other computations.
#' @param parse_text Whether to perform dependency parsing on tokens. The default is set to "parser". The user may skip this step by supplying the argument with "none".
#' @param pos_tagging A logical argument stating whether to perform parts of speech tagging on tokens, such as differentiating between Nouns, Verbs Adjectives etc... The default is set to TRUE.
#' @param ... To enable the user to supply any additional arguments.
#' @return Returns a data frame object derived from CONLL-U formatting, where each row is an annotation of a word. To find out more on the formatting methods, read [here](https://universaldependencies.org/format.html).
#' @export
#'
#' @examples
#' output <- limpiar_pos_annotate(data = data, text_var = clean_text, saved_model = model_loaded, in_parallel = TRUE, parser = "none")
limpiar_pos_annotate <- function(data,
                                 text_var,
                                 pos_model,
                                 in_parallel = FALSE,
                                 parse_text = FALSE,
                                 pos_tagging = TRUE,
                                 ...) {

  # ensure data is of class data.frame, list or character and assign size by nrow number
  if (is.data.frame(data)) {
    size <- nrow(data)
    data <- data %>%
      dplyr::mutate(doc_id = dplyr::row_number())
  } else {
    stop("object supplied to 'data' argument should be of class data.frame")
  }

  # convert text_var to character using non-standard evaluation
  text_var <- rlang::ensym(text_var)
  text_var <- as.character(rlang::eval_tidy(text_var, data))

  # ensure the model is of udpipe_model format and stop if not
  if (!inherits(pos_model, "udpipe_model")) {
    stop("saved_model should be of class udpipe_model as returned by the function limpiar_pos_load_model.")
  }

  # creates a logical argument for dealing with parse_text argument
  stopifnot(is.logical(pos_tagging))
  if (pos_tagging == TRUE) {
    pos_tagging <- "tagger"
    message("parts of speech tagging...")
  } else {
    pos_tagging <- "none"
  }

  # creates a logical argument for dealing with parse_text argument
  stopifnot(is.logical(parse_text))
  if (parse_text == TRUE) {
    parse_text <- "parser"
    message("parsing tokens...")
  } else {
    parse_text <- "none"
  }

  # if statement for parallelization bits of code and chunksize that the udpipe function requires
  if (in_parallel == TRUE) {
    num_cores <- parallel::detectCores() -1
    parallel_chunksize <- ceiling(size / num_cores)
  } else {
    num_cores <- 1
    parallel_chunksize <- NULL
  }

  # call udpipe function and produce output before handling
  output <- udpipe::udpipe(x = text_var,
                           object = pos_model,
                           parallel.cores = num_cores,
                           parallel.chunksize = parallel_chunksize,
                           parser = parse_text,
                           tagger = pos_tagging)

  # handles the output, nests data and joins to original df
   output <- output %>%
     tidyr::nest(.by = doc_id) %>%
     dplyr::mutate(doc_id = as.integer(doc_id)) %>%
     dplyr::left_join(data, by = "doc_id") %>%
     dplyr::rename(nested_pos_data = data)

  return(output)
}
