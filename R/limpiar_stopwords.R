#' Clean stop words for visualisations
#'
#'The two lists - sentiment & topics, are very similar, in that most words are in both lists.
#'However, sentiment analysis is sensitive to negation, so negation cues e.g.
#'"no", "nada" etc. are not removed by the sentiment list. For most purposes, topics
#'are the go-to lists, but care is always advised when removing stop words.
#'
#'stop word list is editable via data("sentiment_stops") or data("topic_stops").
#'
#' @inheritParams data_param
#' @inheritParams text_var
#' @param stop_words "sentiment" or "topics" - sentiment retains negation cues
#'
#' @return the text variable with stop words from specified list removed
#'
#' @examples
#' limpiar_examples %>% dplyr::select(mention_content)
#'
#' limpiar_examples %>% limpiar_stopwords(stop_words = "topics") %>%
#' dplyr::select(mention_content) %>% limpiar_spaces()
#'
#' @export
limpiar_stopwords <- function(data, text_var = mention_content, stop_words){

  data("sentiment_stops", envir = environment())

  sentiment_stops <- sentiment_stops$sentiment_no_accents
  #Add a word boundary to every stop word to avoid q and q both being replaced with the replacement
  sentiment_stops <- stringr::str_replace_all(sentiment_stops, sentiment_stops, paste0("\\\\b", sentiment_stops, "\\\\b"))
  sentiment_hash <- hash::hash(keys = sentiment_stops, values = "")

  data("topic_stops", envir = environment())

  topic_stops <- topic_stops$topics_no_accents
  #see above @ sentiment_stops
  topic_stops <- stringr::str_replace_all(topic_stops, topic_stops, paste0("\\\\b", topic_stops, "\\\\b"))
  topic_hash <- hash::hash(keys = topic_stops, values = "")


  if(stop_words == "sentiment"){
    data <- dplyr::mutate(data, {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                                 hash::values(sentiment_hash),
                                                                 hash::keys(sentiment_hash)))
  }else{}

  if(stop_words == "topics"){
    data <- dplyr::mutate(data, {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                                 hash::values(topic_hash),
                                                                 hash::keys(topic_hash)))
  }else{}

  return(data)
}










