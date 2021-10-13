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

limpiar_url <- function(df, text_var = .data$mention_content){
  .col = rlang::enquo(text_var)
  df %>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := stringr::str_replace_all(!!rlang::enquo(text_var), "htt(p|ps)[[:alnum:][:punct:]]*", ""))%>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := stringr::str_replace_all(!!rlang::enquo(text_var), "[w]{3}\\.\\S+", ""))
}

