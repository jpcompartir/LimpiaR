#' Clean accented characters
#'
#' Useful for reducing overall number of tokens.
#' Warning: removing accents results in loss of information, so should be done with care.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#' @importFrom magrittr %>%
#' @return Data Frame or Tibble object with accents in the text variable replaced
#' @examples
#' limpiar_examples %>% dplyr::select(mention_content)
#' limpiar_examples %>% limpiar_accents() %>% dplyr::select(mention_content)
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




