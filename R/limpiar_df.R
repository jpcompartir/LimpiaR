#' limpiar_df
#'
#' used on a data frame to clean the column names, remove duplicates, empty rows and retweets,
#' turn the text variable to all lower case (advisable to do any part of speech tagging before using).
#' Function also cleans accents, common urls and trims excess white spaces.
#'
#' @param df Data Frame or Tibble Object
#' @param text_var The text variable/character vector
#' @importFrom magrittr %>%
#' @return The original Data Frame with the text variable cleaned
#' @export
#'
#' @examples
#' print("hello world")

limpiar_df <- function(df, text_var){
  .col = rlang::enquo(text_var)

  df %>%
    janitor::clean_names()%>%
    janitor::remove_empty(which = "rows")%>%
    limpiar_duplicates(!!rlang::enquo(text_var))%>%
    #tidy evaluation takes column input, quotes + unquotes
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := tolower(!!rlang::enquo(text_var)))%>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiar_accents(!!rlang::enquo(text_var)))%>%
    limpiar_retweets(!!rlang::enquo(text_var))%>%
    limpiar_url(!!rlang::enquo(text_var))%>%
    limpiar_spaces(!!rlang::enquo(text_var))
}


