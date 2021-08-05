#' limpiar_df
#'
#' @param df Data Frame or Tibble Object
#' @param text_var The text variable/character vector
#' @importFrom magrittr %>%
#' @return The original data frame with the text variable cleaned
#' @export
#'
#' @examples
#' print("hello world")



limpiar_df <- function(df, text_var = .data$mention_content){
  .col = rlang::enquo(text_var)
  df %>%
    janitor::clean_names()%>%
    janitor::remove_empty(which = "rows")%>%
    limpiar_duplicates(text_var)%>%
    #tidy evaluation takes column input, quotes + unquotes
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := tolower(!!rlang::enquo(text_var)))%>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiar_accents(!!rlang::enquo(text_var)))%>%
    limpiar_retweets(text_var)%>%
    dplyr::mutate(!!paste0("", rlang::quo_name(.col)) := limpiar_url(!!rlang::enquo(text_var)))%>%
    limpiar_spaces(text_var)
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

# df <- data.frame(text_variable = cbind(c("HEY YÁLL", "RT boom boy", "boom boy",
#                                          "boom boy", "keep this one, right?",
#                                          "https::remove_me.com")))
# df
# limpiar_df(df, text_variable)
