#' limpiar_spaces
#'
#' Remove excess spaces from the text variable
#'
#' @param df Name of the Data Frame or Tibble object
#' @param text_var Name of the text variable/character vector
#' @importFrom magrittr %>%
#' @return text variable/character vector with excess spaces removed
#' @export
#'
#' @examples
#' df <- data.frame(text_variable = "clean   the   spaces please")
#' limpiar_spaces(df, text_var = text_variable)
limpiar_spaces <- function(df, text_var = .data$mention_content){
  .col = rlang::enquo(text_var)
  df %>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := stringr::str_replace_all(!!rlang::enquo(text_var), "\\s+", " "))
}

