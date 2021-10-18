#' limpiar_stopwords
#'
#'stop word list is editable via data("sentiment_stops") or data("topic_stops")
#'
#' @param text_var name of the text variable
#' @param stop_words "sentiment" or "topics" - sentiment retains negtion cues\n
#'
#' @return the text variable with specified stopw ords removed
#' @export
#'
#' @examples
#' \dontrun
#' df %>% mutate(text = limpiar_stopwords(text, "sentiment"))%>%
#' limpiar_spaces(text_var = text)
limpiar_stopwords <- function(text_var = text, stop_words){

  data("sentiment_stops")

  sentiment_stops <- sentiment_stops$sentiment_no_accents
  #Add a word boundary to every stop word to avoid q and q both being replaced with the replacement
  sentiment_stops <- stringr::str_replace_all(sentiment_stops, sentiment_stops, paste0("\\\\b", sentiment_stops, "\\\\b"))
  sentiment_hash <- hash::hash(keys = sentiment_stops, values = "")

  data("topic_stops")

  topic_stops <- topic_stops$topics_no_accents
  #see above @ sentiment_stops
  topic_stops <- stringr::str_replace_all(topic_stops, topic_stops, paste0("\\\\b", topic_stops, "\\\\b"))
  topic_hash <- hash::hash(keys = topic_stops, values = "")


  if(stop_words == "sentiment"){
    text_var <- stringr::str_replace_all(text_var,
                                          hash::values(sentiment_hash),
                                          hash::keys(sentiment_hash))

  }else{
   text_var <- text_var
  }
  if(stop_words == "topics"){
    text_var <- stringr::str_replace_all(text_var,
                                         hash::values(topic_hash),
                                         hash::keys(topic_hash))
  }else{text_var <- text_var}

  text_var
}
