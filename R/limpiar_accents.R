
#' limpiar_accents
#'
#' Replaces accented characters with non-accented characters. Should be used within a dplyr::mutate() function call.
#'
#' @param x Name of text variable/character vector
#'
#' @return text variable/character vector with accents replaced
#' @export
#'


limpiar_accents <- function(x){
  x <- stringr::str_replace_all(x, '\u00E9', 'e')
  x <- stringr::str_replace_all(x, '\u00F3', 'o')
  x <- stringr::str_replace_all(x, '\u00E1', 'a')
  x <- stringr::str_replace_all(x, '\u00ED', 'i')
  x <- stringr::str_replace_all(x, '\u00FC', 'u')
  x <- stringr::str_replace_all(x, '\u00F9', 'u')
  x <- stringr::str_replace_all(x, '\u00F1', 'n')
  x <- stringr::str_replace_all(x, "\u00E8", "e")
  x <- stringr::str_replace_all(x, "\u00FA", "u")
  x
}


# usage things:
#  df %>%
#    dplyr::mutate(x = limpiar_accents(x))
#
# x <- limpiar_accents(x)


