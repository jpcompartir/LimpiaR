#' Clean slang from multiple dialects
#'
#' Replaces slang phrases from various Spanish dialects with everyday terms.
#' Function's primary use is to normalise text for Deep Learning sentiment algorithm.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#'
#' @return Data Frame or Tibble object with text variable altered
#' @examples
#' \dontrun{
#' df %>%
#' limpiar_slang(text_var = text_var)}
#' @export


limpiar_slang <- function(df, text_var = mention_content){

  slang <- c()
  corrections <- c()

  slang_hash <- hash::hash(keys = slang, values = corrections)

  dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{text_var}},
                                                                hash::values(slang_hash),
                                                                hash::keys(slang_hash)))

}
