#' Remove posts containing spam-like n-grams
#'
#' #' Function identifies posts which contain suspicious-looking n-gram patterns.
#' Posts can then be removed, the pattern inspected, and the posts that were removed too.
#' You can re-assign your current data frame to the 'clean' data frame through the third element of the list.
#'
#' @param data Data frame or tibble object
#' @param text_var  Name of the text variable
#' @param n_gram Number of words in the n-gram i.e. n = 2 = bigram
#' @param min_freq Minimum number of times n-gram should be seen to be removed
#'
#' @return A list of 3 data frames 1. suspicious-looking n-grams, 2. data with them removed, 3. rows of data frame that were removed
#' @export
#'
limpiar_spam_grams <- function(data, text_var, n_gram, min_freq){

  data <- data %>%
    dplyr::mutate(document = dplyr::row_number())

  ngrams <- data %>%
    dplyr::select(document, {{text_var}}) %>%
    tidytext::unnest_tokens(ngrams, {{text_var}}, token = "ngrams",
                            n = n_gram, format = "text") %>%
    dplyr::add_count(ngrams, name = "n_ngram") %>%
    dplyr::filter(!is.na(ngrams)) %>%
    dplyr::filter(n_ngram >= min_freq)

  docs <- ngrams %>% dplyr::pull(document) %>% unique()

  ngrams <- ngrams %>%
    dplyr::select(ngrams) %>%
    dplyr::count(ngrams, sort = TRUE)

  keep <- data %>%
    dplyr::filter(!document %in% docs)

  remove <- data %>%
    dplyr::filter(document %in% docs)

  list("spam_grams" = ngrams, "data" = keep, "deleted" = remove)
}
