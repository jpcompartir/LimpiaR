#' Clean the text variable of duplicate posts
#'
#' Removes duplicate posts, and posts which are deleted or protected by APIs
#' @param data Data Frame or Tibble object
#' @param text_var Name of the text variable/character vector
#'
#' @return The Data Frame or Tibble object with duplicate posts removed from the text variable
#' @examples
#' df <- data.frame(text_variable = cbind(c(
#' "Deleted or protected mention", "hello", "goodbye", "goodbye")))
#' limpiar_duplicates(df, text_variable)
#'
#' limpiar_examples
#'
#'
#' limpiar_examples %>% limpiar_duplicates()
#'
#' @export
limpiar_duplicates <- function(data, text_var = mention_content){
  dplyr::filter(data, !stringr::str_detect({{ text_var }}, "(D|d)eleted or") & !duplicated({{ text_var}}))
}
