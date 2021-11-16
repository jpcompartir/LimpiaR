#' Call multiple LimpiaR functions together
#'
#' used on a data frame to remove duplicates, empty rows, and retweets,
#' turn the text variable to all lower case (advisable to do any part of speech tagging before using).
#' Function also cleans accents, common urls, punctuation if specified and trims excess white spaces.
#' Use remove_retweets = FALSE to keep retweets in the text variable.
#'
#' @param df Data Frame or Tibble Object
#' @param text_var The text variable/character vector
#' @param remove_retweets Whether or not to remove retweets, default is to remove
#' @param remove_punctuation Whether or not to remove punctuation (and then clean whitespace)
#' @importFrom magrittr %>%
#' @return The original Data Frame with the text variable cleaned
#' @export
#'
#' @examples
#' \dontrun{limpiar_df(df, text_var = mention_content)}
#'

limpiar_df <- function(df, text_var = mention_content, remove_retweets = TRUE, remove_punctuation = FALSE){
  df <- df %>%
    janitor::remove_empty(which = "rows")%>%
    #tidy evaluation takes column input, quotes + unquotes
    dplyr::mutate({{ text_var }} := tolower({{ text_var }}))%>%
    limpiar_accents({{ text_var }})%>%
    limpiar_url({{ text_var }})


  #Option to not remove retweets
  if(remove_retweets){
    df <- df %>%
      dplyr::filter(!stringr::str_detect({{ text_var }}, "\\brt\\b"))
    df
  }else{
    df
  }

  #Option to remove punctuation
  if (remove_punctuation){
    df <-df %>%
      dplyr::mutate({{ text_var }} := tm::removePunctuation({{ text_var }}))
  }else{
    df
  }

  #Now remove excess white spaces, duplicates, and normalise shorthands.
  df %>%
    limpiar_shorthands({{ text_var }})%>%
    limpiar_spaces({{ text_var }})%>%
    limpiar_duplicates({{ text_var }})%>%
    limpiar_repeat_chars({{ text_var }})
}
