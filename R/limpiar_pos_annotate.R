#' Annotate Texts for Parts of Speech Analysis
#'
#' @param data The data.frame or tibble object containing any texts that the user wishes to conduct parts of speech analysis on.
#' @param text_var Any texts or sentences the user wishes to perform the parts of speech annotations on.
#' @param id_var The document identifier, this can be something like universal_message_id or doc_number. The default is universal_message_id.
#' @param pos_model A UDPipe model imported using `limpiar_pos_import_model`, and must be of class 'udpipe_model'.
#' @param in_parallel A logical argument allowing the user to leverage parallel processing to speed the function up. If set to TRUE,  the function will select the number of available cores minus one, processing more efficiently(faster), leaving one core to manage other computations.
#' @param parse_text Whether to perform dependency parsing on tokens. The default is set to FALSE. If the user wishs to perform parsing on tokens, they may do so by calling TRUE.
#' @param ... To enable the user to supply any additional arguments.
#' @return Returns a data frame with documents broken up into both a token and sentence level, in addition to the existing variables present in `data` supplied to the function. The returned object contains the parts of speech annotations in CONLL-U formatting, where each row is an annotation of a word. To find out more on the formatting methods, read [here](https://universaldependencies.org/format.html).
#' The additional arguments with tagged POS information are as follows:
#' - paragraph_id: The identifier indicating the paragraph the annotated token is derived from.
#' - sentence_id: Similar to paragraph_id but at a sentence level.
#' - sentence: The sentence the annotated token is derived from.
#' - token: The token(or word) being annotated for parts of speech.
#' - lemma: The lemmatized version of the annotated token.
#' - pos_tag: The universal parts of speech tag of the token. [Here](https://universaldependencies.org/format.html) for more information.
#' - head_token_id: Indicating what is the token id of the head of the token, indicating to which other token in the sentence it is related.
#' - dependency_tag: The information regarding dependency parsing of tokens, displaying the type of relation the token has with the head_token_id. [Here](https://universaldependencies.org/format.html) for more information.
#'
#' @export
#'
#' @examples
#' model <- limpiar_pos_import_model(language = "english")
#' annotations <- limpiar_pos_annotate(data = data,
#'                                    text_var = text,
#'                                    id_var = universal_message_id,
#'                                    pos_model = model,
#'                                    in_parallel = TRUE,
#'                                    parse_text = FALSE)
limpiar_pos_annotate <- function(data,
                                 text_var,
                                 id_var = universal_message_id,
                                 pos_model,
                                 in_parallel = FALSE,
                                 parse_text = FALSE,
                                 ...) {

  # ensure data is of class data.frame and assign size by nrow number
  if (is.data.frame(data)) {
    size <- nrow(data)
    data <- data %>%
      dplyr::mutate(doc_id = dplyr::row_number(),
                    universal_message_id = {{id_var}})
  } else {
    stop("Object supplied to 'data' argument should be of class data.frame")
  }
  # inform the user POS tagging is being performed
  message("Parts of speech tagging in process...")

  # extract id_var not knowing its name, overwrite id_var as a character string to a vector
  id_var <- data %>% dplyr::pull({{id_var}})

  # some tidy evaluation on id_var and text var. convert both to syumbol before as character
  text_var <- rlang::ensym(text_var)
  text_var <- as.character(rlang::eval_tidy(text_var, data))

  # if statements for POS tagging feature
  if (parse_text == TRUE) {
    parse_text <- "parser"
    message("Performing dependency parsing on tokens....")
  } else {
    parse_text <- "none"
  }

  # ensure the model is of udpipe_model format and stop if not
  if (!inherits(pos_model, "udpipe_model")) {
    stop("saved_model should be of class udpipe_model as returned by the function limpiar_pos_import_model.")
  }

  # if statement for parallelization and chunksize bits of code that the udpipe function requires
  if (in_parallel) {
    num_cores <- parallel::detectCores() -1
    parallel_chunksize <- ceiling(size / num_cores)
  } else {
    num_cores <- 1
    parallel_chunksize <- ceiling(size / num_cores)
  }

  # call udpipe function and produce output before handling
  output <- udpipe::udpipe(x = text_var,
                           object = pos_model,
                           parallel.cores = num_cores,
                           parallel.chunksize = parallel_chunksize,
                           parser = parse_text,
                           tagger = "tagger")

  # this rids of the annoying doc1, doc2... format in doc_id when calling FALSE for parallel processing
  if (!in_parallel) {
    output$doc_id <- output$doc_id %>%
      stringr::str_remove_all(pattern = "doc")
  }

  # nest the data based on doc_id/row_number
  output_nested <- output %>%
    tidyr::nest(.by = doc_id)

  # now join using message_id but only if rows match up to original df size
  if(nrow(output_nested) == size) {
    output_nested$universal_message_id <- id_var
    output_nested <- output_nested %>% dplyr::select(-doc_id)
  } else {
    stop("Dimensions do not add up, data was lost in the annotation process")
  }

  # join the nested df and make sure no rows are duplicated and are unique
  output <- output_nested %>%
    dplyr::right_join(y = data, by = "universal_message_id", relationship = "many-to-many") %>%
    dplyr::distinct()

  # unnest the data and select/rename suitable columns for ease
  output <- output %>%
    tidyr::unnest(cols = data) %>%
    dplyr::select(-c("start", "end", "term_id", "token_id", "xpos", "feats", "deps", "misc")) %>%
    dplyr::rename(pos_tag = upos,
                  dependency_tag = dep_rel)

  return(output)
}
