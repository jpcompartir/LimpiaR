#' Call multiple LimpiaR functions together
#'
#' Used on a data frame to remove duplicates, empty rows, and retweets.
#' Transform the text variable to lower case and remove user handles and hashtags.
#' Clean accents, urls, shorthands, repeated characters, and if specified punctuation.
#'
#' You should only use this function when you are sure you want to execute each of the steps.
#'
#'
#' @param df Data Frame or Tibble Object
#' @param text_var The text variable/character vector
#' @param remove_retweets Whether or not to remove retweets, default is to remove
#' @param remove_punctuation Whether or not to remove punctuation, default is not to remove
#' @return The original Data Frame with the text variable cleaned
#' @export
#'
#' @examples
#'limpiar_df(limpiar_examples, text_var = mention_content, remove_punctuation = TRUE)
#'

limpiar_df <- function(df, text_var = mention_content, remove_retweets = TRUE, remove_punctuation = FALSE){
  df <- df %>%
    janitor::remove_empty(which = "rows")%>%
    #tidy evaluation takes column input, quotes + unquotes
    dplyr::mutate({{ text_var }} := tolower({{ text_var }}))%>%
    limpiar_accents({{ text_var }})%>%
    limpiar_url({{ text_var }})%>%
    limpiar_tags({{ text_var }})


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
