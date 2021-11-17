#' Clean URLs from the text variable
#'
#' Removes the most common forms of URLs from the text variable
#'
#' @param df Data Frame or Tibble Object
#' @param text_var Name of the text variable/character vector
#'
#' @return text variable/character vector with URLs removed
#'
#' @examples
#' \dontrun{df %>% limpiar_url()}
#' @export

limpiar_url <- function(df, text_var = mention_content){

  df %>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "htt(p|ps)\\S+", ""))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[w]{3}\\.\\S+", ""))
}
