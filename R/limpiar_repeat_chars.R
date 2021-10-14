#' limpiar_repeat_chars
#'
#' Removes all multiple vowels (holaaaa) and normalises common laughing patterns \n(jajaja, jejeje, ajajaaaaja)
#'
#' @param df Name of the Data Frame or Tibble object
#' @param text_var Name of the text variable/character vector. Default is mention_content
#'
#' @return Data Frame or Tibble object with most repeat vowels & laughing pattterns normalised
#' @export
#'
#' @examples
#' \dontrun
#' df %>% limpiar_repeat_chars(text_var = text)
#'
limpiar_repeat_chars <- function(df, text_var = .data$mention_content){
  #Checks there is a j + (e or i or a)
  laughing_regex <- "(?=.+j)((?=.+a)|(?=.+e)|(?=.+i))[(j|a|i|e)+(j|a|i|e)+]{4,}$"

  #Replaces messy laughing strings with "jaja"
  laughing_replacement <- "jaja"

  #Creates a capture group for any vowel seen 2 or more times
  repeat_vowels_regex <-  "([a|e|i|o|u])\\1{2,}"

  #replaces two or more of the same vowel with one of that same vowel
  repeat_vowels_replacement <- "\\1"

  dplyr::mutate(df,
         {{ text_var }} := stringr::str_replace_all({{ text_var }}, laughing_regex, laughing_replacement),
         {{text_var }} := stringr::str_replace_all({{ text_var }}, repeat_vowels_regex, repeat_vowels_replacement))
}
