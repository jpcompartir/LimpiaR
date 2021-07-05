library(stringr)

#' Title
#'
#' @param x A character vector
#'
#' @return
#' @export
#'
#' @examples
#'
limpiar_accents <- function(x){
  x <- str_replace_all(x, 'é', 'e')
  x <- str_replace_all(x, 'ó', 'o')
  x <- str_replace_all(x, 'á', 'a')
  x <- str_replace_all(x, 'í', 'i')
  x <- str_replace_all(x, 'ü', 'u')
  x <- str_replace_all(x, 'ù', 'u')
  x <- str_replace_all(x, 'ñ', 'n')
  x <- str_replace_all(x, "è", "e")
  x <- str_replace_all(x, "ú", "u")
}

