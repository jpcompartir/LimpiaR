#' limpiar_accents
#'
#' Replaces accented characters with non-accented characters.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#'
#' @return text variable/character vector with accents replaced
#' @examples
#' \dontrun{df %>% limpiar_accents(text_var = message)}
#'
#'
#' @export

limpiar_accents <- function(df, text_var = mention_content){

  keys <- c('\u00E9', '\u00F3','\u00E1', '\u00ED', '\u00FC', '\u00F9',
            '\u00F1', '\u00E8', '\u00FA')
  values <- c('e', 'o', 'a', 'i', 'u', 'u', 'n', 'e', 'u')

  my_hash <- hash::hash(keys = keys, values = values)

  dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                               hash::values(my_hash),
                                                               hash::keys(my_hash)))

}




