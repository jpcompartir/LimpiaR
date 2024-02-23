#' @title Annotate Texts for Parts of Speech Analysis using udpipe models.
#'
#' @description Take a data frame with a text and id variable and extract its parts of speech using {udpipe models} which we import for a specific language with `limpiar_pos_import_model`. This function will annotate the data frame according to the language of the imported model.
#'
#' @details The leg work is done by {udpipe}. We have implemented it into LimpiaR because:
#'
#' 1) Taking data as its first argument allows it to integrate with Tidyerse workflows (it makes the function pipe-able)
#'
#' 2) We want the mental model to be as consistent as possible, i.e. when using LimpiaR in the pre-processing pipeline the user mainly calls LimpiaR, and doesn't have to remember another package.
#'
#' There are many potential workflows so we won't try to enumerate them here. However,  as clear use-cases emerge we will create new limpiar_pos_ functions on a case-by-case basis. An example workflow would be to convert all adjectives and nouns to lemma and then visualise the results.
#'
#' @param data The data.frame or tibble object containing any texts that the user wishes to conduct parts of speech analysis on.
#' @param text_var Any texts or sentences the user wishes to perform the parts of speech annotations on.
#' @param id_var Unique identifier for each document. No default supplied. recommended to use 'universal_message_id' if using a social listening export.
#' @param pos_model A UDPipe model imported using `limpiar_pos_import_model` - must be of class 'udpipe_model'.
#' @param in_parallel A logical argument allowing the user to initiate parallel processing to speed the annotate function up. If set to TRUE,  the function will select the number of available cores minus one, processing more efficiently(faster), leaving one core to manage other computations. The default is FALSE.
#' @param dependency_parse Whether to perform dependency parsing on tokens. The default is set to FALSE because parsing dependencies takes considerable time and they are not always needed.
#' @param update_progress The user has the option to state how often they would like a progress report of the annotation process, posted in the console by stating whether they want a message every 100, 500 or 1000 documents. This is useful when annotating large sets of data and serves as a sanity check to ensure the session hasn't used up all available memory and the annotations have stopped running.
#' @param ... To enable the user to supply any additional arguments to udpipe::udpipe.
#' @return Returns a data frame with documents broken up into both a token and sentence level, in addition to the existing variables present in `data` supplied to the function. The returned object contains the parts of speech annotations in CONLL-U formatting, where each row is an annotation of a word. To find out more on the formatting methods, read [here](https://universaldependencies.org/format.html).
#' The additional arguments with tagged POS information are as follows:
#' - paragraph_id: The identifier indicating the paragraph the annotated token is derived from.
#' - sentence_id: Similar to paragraph_id but at a sentence level.
#' - sentence: The sentence the annotated token is derived from.
#' - token_id: Token index, integer starting at 1 for each new sentence. May be a range for multiword tokens or a decimal number for empty nodes.
#' - token: The token(or word) being annotated for parts of speech.
#' - lemma: The lemmatized version of the annotated token.
#' - pos_tag: The universal parts of speech tag of the token. [Here](https://universaldependencies.org/format.html) for more information.
#' - xpos: The treebank-specific parts of speech tag of the token.
#' - feats: The morphological features of the token, used for dependency parsing visualisations,.
#' - head_token_id: Indicating what is the token id of the head of the token, indicating to which other token in the sentence it is related.
#' - dependency_tag: The information regarding dependency parsing of tokens, displaying the type of relation the token has with the head_token_id. [Here](https://universaldependencies.org/format.html) for more information.
#'
#' @export
#'
#' @examples
#' data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]),
#' document = 1:100)
#' model <- LimpiaR::limpiar_pos_import_model(language = "english")
#' annotations <- limpiar_pos_annotate(data = data,
#'                                    text_var = text,
#'                                    id_var = document,
#'                                    pos_model = model,
#'                                    in_parallel = FALSE,
#'                                    dependency_parse = TRUE,
#'                                    progress = "100")
limpiar_pos_annotate <- function(data,
                                 text_var,
                                 id_var,
                                 pos_model,
                                 ...,
                                 in_parallel = FALSE,
                                 dependency_parse = FALSE,
                                 update_progress = 100) {


  # Early stopping and input validation ----
  stopifnot(is.data.frame(data),
            nrow(data) > 0,
            is.logical(in_parallel),
            is.logical(dependency_parse),
            is.numeric(update_progress),
            update_progress >= 0,
            inherits(pos_model, "udpipe_model"))

  # Tidy evaluate user-supplied variables ----
  text_sym <- rlang::ensym(text_var)
  text_var <- data[[text_sym]]

  id_sym <- rlang::ensym(id_var)
  data[[id_sym]]

  # Function main body ----

  # define the size of the data based on n rows and mutate doc_id for joining
  size <- nrow(data)

  # if statements for POS tagging feature
  if (dependency_parse == TRUE) {
    dependency_parse <- "parser"
  } else {
    dependency_parse <- "none"
  }

  # if statement for parallelization and chunksize bits of code that the udpipe function requires
  if (in_parallel) {
    num_cores <- parallel::detectCores() -1
    parallel_chunksize <- floor(size / num_cores)
  } else {
    num_cores <- 1
    parallel_chunksize <- floor(size / num_cores)
  }

  # call udpipe function and produce output before handling
  output <- udpipe::udpipe(x = text_var,
                           object = pos_model,
                           parallel.cores = num_cores,
                           parallel.chunksize = parallel_chunksize,
                           parser = dependency_parse,
                           tagger = "tagger",
                           trace = update_progress,
                           ...)

  # this rids of the annoying doc1, doc2... format in doc_id when calling FALSE for parallel processing. TODO: Is this necessary?
  if (!in_parallel) {
    output$doc_id <- output$doc_id %>%
      stringr::str_remove_all(pattern = "doc")
  }

  # nest the data based on doc_id/row_number
  output <- output %>%
    tidyr::nest(.by = doc_id)

  # Add original id to output
  output[[id_sym]] <- data[[id_sym]]

  output <- output %>%
    tidyr::unnest(cols = data)

  # Rename cols and de-select un-needed columns
  output <- output %>%
    dplyr::rename(pos_tag = upos) %>%
    dplyr::select(-c("start", "end", "term_id", "deps", "misc"))

  # If the dependency's have been parsed, rename the col and remove deps.
  if(dependency_parse == "parser") {
    output <- dplyr::rename(output, dependency_tag = dep_rel)
  } else {
    output <- dplyr::select(output, -c("dep_rel", "head_token_id", "feats"))
  }

  return(output)
}
