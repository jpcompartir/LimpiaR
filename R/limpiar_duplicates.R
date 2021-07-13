#' limpiar_duplicates
#'
#' Removes duplicate posts and deleted or protected mentions
#'
#' @param data Data Frame or Tibble object
#' @param x Name of the text variable/character vector
#'
#' @return text variable/character with duplicates removed
#' @export
#'
#' @examples
#' print("hello world")
limpiar_duplicates <- function(data, x = .data$mention_content){
  data %>%
    dplyr::filter(!stringr::str_detect(!!rlang::enquo(x), "Deleted or"))%>%
    dplyr::filter(!duplicated(!!rlang::enquo(x)))
}
