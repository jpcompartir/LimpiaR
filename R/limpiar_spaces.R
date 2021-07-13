#' limpiar_spaces
#'
#' Remove excess spaces from the text variable
#'
#' @param df Name of the Data Frame or Tibble object
#' @param x Name of the text variable/character vector
#'
#' @return text variable/character vector with excess spaces removed
#' @export
#'
#' @examples
#' print("hello world")
limpiar_spaces <- function(df, x = .data$mention_content){
  .col = rlang::enquo(x)
  df %>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := stringr::str_replace_all(!!rlang::enquo(x), "\\s+", " "))
}
