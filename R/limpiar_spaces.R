#' limpiar_spaces
#'
#' Remove excess spaces from the text variable
#'
#' @param df Name of the Data Frame or Tibble object
#' @param text_var Name of the text variable/character vector
#' @return text variable/character vector with excess spaces removed
#' @export
#'
#' @examples
#' df <- data.frame(text_variable = "clean   the   spaces please")
#' limpiar_spaces(df, text_var = text_variable)
limpiar_spaces <- function(df, text_var = .data$mention_content){

  df %>%
    dplyr::mutate({{ text_var }} := stringr::str_trim({{ text_var }}))%>%
    dplyr::mutate({{ text_var }} := stringr::str_squish({{ text_var }}))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[:space:]+\\.", "."))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[:space:]+\\,", ","))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[:space:]+:", ":"))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[:space:]+;", ","))%>%
    dplyr::mutate({{ text_var }} := stringr::str_replace_all({{ text_var }}, "[:space:]+\\!", "!"))
}
