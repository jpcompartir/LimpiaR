#' Prepare a URL column to be clickable in Shiny/Data Table
#'
#' Will allow you to click the hyperlink to load a URL, e.g. for selecting an image.
#' Make sure that DataTable is rendered with the argument 'escape = FALSE' or column will be all text.=
#'
#' @param df Data Farame or Tibble Object
#' @param url_var URL Column
#'
#' @return data frame with URL column edited to be clickable
#' @export
#'
#' @examples
#' \dontrun{
#' Example 1:
#' df %>% limpiar_link_click(permalink)
#'
#' Example 2:
#' limpiar_link_click(data, mention_url)
#' }
limpiar_link_click <- function(df, url_var){
  url_sym <- rlang::ensym(url_var)

  df %>%
    dplyr::mutate({{url_var}}:= paste0("<a href='", !!url_sym, "' target='blank'>", "Click to View", "</a>"))
}
