#' Annotate Texts for Parts of Speech Analysis
#'
#' @param data The data.frame or tibble object containing any texts that the user wishes to conduct parts of speech analysis on.
#' @param text_var Any texts or sentences the user wishes to perform the parts of speech annotations on.
#' @param id_var The document identifier, this can be something like universal_message_id or doc_number. The default is universal_message_id.
#' @param pos_model A UDPipe model imported using `limpiar_pos_import_model`, and must be of class 'udpipe_model'.
#' @param in_parallel A logical argument allowing the user to initiate parallel processing to speed the annotate function up. If set to TRUE,  the function will select the number of available cores minus one, processing more efficiently(faster), leaving one core to manage other computations. The default is FALSE.
#' @param dependency_parse Whether to perform dependency parsing on tokens. The default is set to FALSE. If the user wishes to perform parsing on tokens, they may do so by calling TRUE.
#' @param update_progress The user has the option to state how often they would like a progress report of the annotation process, posted in the console by stating whether they want a message every 100, 500 or 1000 documents. This is useful when annotating large sets of data and serves as a sanity check to ensure the session hasn't used up all available memory and the annotations have stopped running.
#' @param ... To enable the user to supply any additional arguments.
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

  # ensure data is of class data.frame and check if in_parallel and dependency_parse are logical
  stopifnot(is.data.frame(data),
            is.logical(in_parallel),
            is.logical(dependency_parse))

  # check if in_parallel and dependency_parse are logical
  # check that pos_model is of class udpipe_model
  if (!inherits(pos_model, "udpipe_model")) {
    stop("pos_model should be of class udpipe_model as returned by limpiar_pos_import_model()")
  }

  # define the size of the data based on n rows and mutate doc_id for joining
  size <- nrow(data)
  data <- data %>%
    dplyr::mutate(doc_id = dplyr::row_number())

  # some tidy evaluation on text var, convert to symbol before character
  text_var <- rlang::ensym(text_var)
  text_var <- as.character(dplyr::pull(data, !!text_var))

  # if statement handling when input of id_var is null
  if (!missing(id_var)) {
    id_var_pulled <- data %>% dplyr::pull({{id_var}})
    data <- data %>%
      dplyr::mutate(id_var = id_var_pulled)
  } else {
    stop("id_var not supplied, unable to join annotations to original data")
  }

  # if statements for POS tagging feature
  if (dependency_parse == TRUE) {
    dependency_parse <- "parser"
    message("Performing dependency parsing on tokens...")
  } else {
    dependency_parse <- "none"
  }

  # if statement for parallelization and chunksize bits of code that the udpipe function requires
  if (in_parallel) {
    num_cores <- parallel::detectCores() -1
    parallel_chunksize <- ceiling(size / num_cores)
  } else {
    num_cores <- 1
    parallel_chunksize <- ceiling(size / num_cores)
  }

  # ensure that progress is either set to one of the below options
  update_progress <- match.arg(as.character(update_progress), c(100, 500, 1000, 0))

  # call udpipe function and produce output before handling
  message("Parts of speech tagging in process...")
  output <- udpipe::udpipe(x = text_var,
                           object = pos_model,
                           parallel.cores = num_cores,
                           parallel.chunksize = parallel_chunksize,
                           parser = dependency_parse,
                           tagger = "tagger",
                           trace = as.numeric(update_progress),
                           ...)

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
    output_nested$id_var <- id_var_pulled
    output_nested <- output_nested %>% dplyr::select(-doc_id)
  } else {
    stop("Dimensions do not add up, data was lost in the annotation process")
  }

  output <- output_nested %>%
    dplyr::right_join(y = data, by = "id_var") %>%
    tidyr::unnest(cols = data)

  # handle output if dependancy parsing has been performed
  if (dependency_parse == "parser") {
    output <- output %>%
      dplyr::rename(pos_tag = upos,
                    dependency_tag = dep_rel) %>%
      dplyr::select(-c("start", "end", "term_id", "deps", "misc", "doc_id"))
  } else {
    output <- output %>%
      dplyr::rename(pos_tag = upos) %>%
      dplyr::select(-c("start", "end", "term_id", "deps", "misc", "doc_id", "dep_rel", "head_token_id", "feats"))
  }

  return(output)
}
