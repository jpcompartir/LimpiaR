#' limpiar_duplicates
#'
#' Removes duplicate posts and 'deleted or protected mentions'
#'
#' @param data Data Frame or Tibble object
#' @param text_var Name of the text variable/character vector
#'
#' @return text variable/character with duplicates removed
#' @examples
#' \dontrun{
#' df <- data.frame(text_variable = cbind(c(
#' "Deleted or protected mention", "hello", "goodbye", "goodbye")))
#' limpiar_duplicates(df, text_variable)
#' }
#'
#' @export
limpiar_duplicates <- function(data, text_var = mention_content){
  dplyr::filter(data, !stringr::str_detect({{ text_var }}, "(D|d)eleted or") & !duplicated({{ text_var}}))
}
