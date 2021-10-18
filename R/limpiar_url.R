#' limpiar_url
#'
#' Removes the most common forms of URLs from a text variable of a data frame/tibble
#' @param df Data Frame or Tibble Object
#' @param text_var Name of the text variable/character vector
#'
#' @return text variable/character vector with URLs removed
#' @export
#'
#' @examples
#' \dontrun
#' df %>% limpiar_url()

limpiar_url <- function(df, text_var = mention_content){

  df %>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "htt(p|ps)[[:alnum:][:punct:]]*", ""))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[w]{3}\\.\\S+", ""))
}
