#' @title Prepare a URL column to be clickable in Shiny/Data Table
#'
#' @description Will allow you to click the hyperlink to load a URL, e.g. for selecting an image.
#' @details Make sure that DataTable is rendered with the argument 'escape = FALSE' or column will be all text.
#'
#' The function now checks if your url_var was a clickable link, and if it is then it won't add any new formatting.
#'
#' @param df Data Frame or Tibble Object
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

  already_formatted <- df %>%
    dplyr::slice_sample(n = 5) %>%
    dplyr::filter(stringr::str_detect(!!url_sym, "^<a href")) %>%
    nrow()

  if(already_formatted > 0) {
    message("url_var already detected as a clickable link, returning input data frame.")
    return(df)
  }

  data <- df %>%
    dplyr::mutate({{url_var}}:= paste0("<a href='", !!url_sym, "' target='blank'>", "Click to View", "</a>"))

  return(data)
}


#' @title Reverses (inverts) limpiar_link_click
#'
#' @description Undoes the effects of the limpiar_link_click function, giving you the original url variable back.
#'
#'
#' @param df Data Farame or Tibble Object
#' @param url_var URL Column
#'
#' @return Data frame with the url_var in original form
#' @export
#'
#' @examples
#' df <- LimpiaR::limpiar_examples[1, ]
#'
#' df <- df %>% limpiar_link_click(mention_url)
#' df$mention_url
#' df %>% limpiar_link_click_reverse(mention_url)
#'
limpiar_link_click_reverse <- function(df, url_var) {
  url_sym <- rlang::ensym(url_var)

  already_formatted <- df %>%
    dplyr::slice_sample(n = 5) %>%
    dplyr::filter(stringr::str_detect(!!url_sym, "^<a href")) %>%
    nrow()

  if(already_formatted == 0) {
    message("url_var not detected as a clickable link, returning input data frame.")
    return(df)
  }

  data <- df %>%
    dplyr::mutate({{url_var}}:= stringr::str_replace_all(!!url_sym, "<a href='", "")) %>%
    dplyr::mutate({{url_var}}:= stringr::str_replace_all(!!url_sym, "' target=.*", ""))

  return(data)
}
