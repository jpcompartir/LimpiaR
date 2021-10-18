#' limpiar_retweets
#'
#' Removes all posts with the 'rt' tag
#'
#' @param df Name of the Data Frame or Tibble Object
#' @param text_var Name of the text variable/character vector
#'
#' @export
#'
#' @examples
#' df <- data.frame(text_variable = cbind(c("rt <3", "RT <3", "original tweet")))
#' limpiar_retweets(df, text_variable)

limpiar_retweets <- function(df, text_var = mention_content){
  dplyr::filter(df, !stringr::str_detect({{ text_var}}, "\\b(rt|RT)\\b"))
}

