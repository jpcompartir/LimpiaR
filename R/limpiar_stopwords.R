#' Clean stopwords for visualisations
#'
#'The two lists - sentiment & topics, are very similar, in that most words are in both lists.
#'However, sentiment analysis is sensitive to negation, so negation cues e.g.
#'"no", "nada" etc. are not removed by the sentiment list. For most purposes, topics
#'are the go-to lists, but care is always advised when removing stop words.
#'
#'stop word list is editable via data("sentiment_stops") or data("topic_stops").
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var name of the text variable
#' @param stop_words "sentiment" or "topics" - sentiment retains negation cues
#'
#' @return the text variable with specified stopw ords removed
#'
#' @examples
#' \dontrun{df %>% limpiar_stopwords(stop_words = "sentiment") %>%
#' limpiar_spaces(text_var = text)}
#' @export
limpiar_stopwords <- function(df, text_var = mention_content, stop_words){

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
    df <- dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                                 hash::values(sentiment_hash),
                                                                 hash::keys(sentiment_hash)))
  }else{}

  if(stop_words == "topics"){
    df <- dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                                 hash::values(topic_hash),
                                                                 hash::keys(topic_hash)))
  }else{}

  df
}










