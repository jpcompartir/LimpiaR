
#' limpiar_accents
#'
#' Replaces accented characters with non-accented characters. Should be used within a dplyr::mutate() function call.
#'
#' @param text_var Name of text variable/character vector
#'
#' @return text variable/character vector with accents replaced
#' @examples
#' df <- data.frame(text_variable = "thé óld mán")
#' dplyr::mutate(df, limpiar_accents(text_variable))
#' @export



limpiar_accents <- function(text_var){
  text_var <- stringr::str_replace_all(text_var, '\u00E9', 'e')
  text_var <- stringr::str_replace_all(text_var, '\u00F3', 'o')
  text_var <- stringr::str_replace_all(text_var, '\u00E1', 'a')
  text_var <- stringr::str_replace_all(text_var, '\u00ED', 'i')
  text_var <- stringr::str_replace_all(text_var, '\u00FC', 'u')
  text_var <- stringr::str_replace_all(text_var, '\u00F9', 'u')
  text_var <- stringr::str_replace_all(text_var, '\u00F1', 'n')
  text_var <- stringr::str_replace_all(text_var, "\u00E8", "e")
  text_var <- stringr::str_replace_all(text_var, "\u00FA", "u")
  text_var
}





