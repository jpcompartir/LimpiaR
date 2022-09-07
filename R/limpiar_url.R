#' Clean URLs from the text variable
#'
#' Removes the most common forms of URLs from the text variable
#'
#' @param df Data Frame or Tibble Object
#' @param text_var Name of the text variable/character vector
#'
#' @return Data Frame or Tibble object with URLs removed from the text variable
#' @examples
#' limpiar_examples %>% dplyr::select(mention_content)
#'
#' limpiar_examples %>% limpiar_url() %>% dplyr::select(mention_content)
#'
#' @export

limpiar_url <- function(df, text_var = mention_content){

  df %>%
    dplyr::mutate({{ text_var }} := stringr::str_remove_all({{ text_var }}, "htt(p|ps)\\S+"))%>%
    dplyr::mutate({{ text_var }} := stringr::str_remove_all({{ text_var }}, "[w]{3}\\.\\S+")) %>%
    dplyr::mutate({{text_var}} := stringr::str_remove_all({{text_var}}, "\\S+\\.[a-z]+\\S+"))
}
