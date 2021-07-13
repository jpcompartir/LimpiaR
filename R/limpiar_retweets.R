#' limpiar_retweets
#'
#' Removes all posts with the 'rt' tag
#'
#' @param df Name of the Data Frame or Tibble Object
#' @param x Name of the text variable/character vector
#'
#' @export
#'
#' @examples
#' print("hello world")

limpiar_retweets <- function(df, x = .data$mention_content){
  df %>%
    dplyr::filter(!stringr::str_detect(!!rlang::enquo(x), "\\brt\\b"))
}



