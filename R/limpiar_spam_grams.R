#' Remove posts with suspicious n-grams
#'
#' Function identifies posts which contain suspicious-looking n-gram patterns.
#' Posts can then be removed, the pattern inspected, and the posts that were removed too.
#' You can re-assign your current data frame to the 'clean' data frame through the third element of the list.
#'
#' @param data Data frame or tibble object
#' @param text_var Name of the text variable
#' @param n_gram  Number of words in the n-gram i.e. n = 2 = bigram
#' @param top_n  Number of n-grams to keep
#' @param min_freq Minimum number of
#' @param in_parallel Whether to run the function with parallel processing
#'
#' @return A list with the suspicious-looking ngrams, removed posts, data & regex pattern
#' @export
#'
limpiar_spam_grams <- function(data, text_var, n_gram = 8, top_n = 1000, min_freq = 5, in_parallel = TRUE){

  #Tidy evaluate supplied text variable (symbol as column in data)
  text_sym <- rlang::ensym(text_var)

  grams <- data  %>%
    dplyr::mutate(document = dplyr::row_number()) %>%
    dplyr::select(document, {{text_var}}) %>%
    tidytext::unnest_tokens(ngrams, !!text_sym, token = "ngrams", format = "text", n = n_gram) %>%
    dplyr::add_count(ngrams, name = "n_ngram")

  grams <- grams %>%
    dplyr::add_count(document, ngrams, name = "n_doc_gram") %>%
    dplyr::add_count(document, name = "n_doc")

  grams <- grams %>%
    dplyr::filter(n_ngram > min_freq)

  grams <- grams %>%
    dplyr::filter(!is.na(ngrams)) %>%
    dplyr::group_split(document) %>%
    purrr::map(~ .x %>%
                 dplyr::mutate(x = nrow(.x),
                               n_samples = ifelse(x > 5, 5, x)) %>%
                 dplyr:: sample_n(size = max(n_samples))) %>%
    purrr::reduce(rbind)

  message("Unnesting ngrams finished")

  regex <- paste0(grams$ngrams, collapse = "|")

  if(!in_parallel){

    message("Removing spam regex from data")
    removed <- data %>% dplyr::filter(stringr::str_detect({{text_var}}, regex))%>%
      dplyr::select({{text_var}})

    data <- data %>% dplyr::filter(!stringr::str_detect({{text_var}}, regex))

    return(list(grams, removed, data, regex))

  } else{

    options(future.rng.onMisuse = "ignore")
    future::plan(future::multisession(workers = future::availableCores() -1))

    data <- data %>%
      dplyr::mutate(.row_id = dplyr::row_number(),
                    cuts = cut(.row_id, future::availableCores() - 1))

    #Parallelise the string removals as this is the costly part
    message("Removing spam regex from data")
    removed <- data %>%
      dplyr::group_split(cuts) %>%
      furrr::future_map_dfr(~ .x %>%
                              dplyr::filter(stringr::str_detect(!!text_sym, regex)) %>%
                              dplyr::select(!!text_sym, .row_id))

    future::plan(future::sequential())
    message("Ending parallel session")

    data <- data %>% dplyr::filter(!.row_id %in% removed$.row_id) %>%
      dplyr::select(-c(.row_id, cuts))

    removed <- dplyr::select(removed, -.row_id)


    return(list(grams,removed,data,regex))
  }


}
