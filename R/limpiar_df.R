#' limpiar_df
#'
#' @param df Data Frame or Tibble Object
#' @param text_var The text variable/character vector
#'
#' @return The original data frame with the text variable cleaned
#' @export
#'
#' @examples
#' print("hello world")
#' @importFrom magrittr %>%


limpiar_df <- function(df, text_var){
  .col = rlang::enquo(text_var)
  df %>%
    limpiar_duplicates()%>%
    #tidy evaluation takes column input, quotes + unquotes
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := tolower(!!rlang::enquo(text_var)))%>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiar_accents(!!rlang::enquo(text_var)))%>%
    limpiar_retweets()%>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiar_url(!!rlang::enquo(text_var)))%>%
    limpiar_spaces()
}



# limpiar_df <- function(df, text_var = mention_content){
#   .col = rlang::enquo(text_var)
#   df %>%
#     limpiaR::limpiar_duplicates()%>%
#     #tidy evaluation takes column input, quotes + unquotes
#     dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := tolower(!!rlang::enquo(text_var)))%>%
#     dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiaR::limpiar_accents(!!rlang::enquo(text_var)))%>%
#     limpiaR::limpiar_retweets()%>%
#     dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiaR::limpiar_url(!!rlang::enquo(text_var)))%>%
#     limpiaR::limpiar_spaces()
# }
