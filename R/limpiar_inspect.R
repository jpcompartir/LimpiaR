
#' limpiar_inspect
#'
#' Produces a viewable data frame with posts matching a regular expression and their url. Useful for investigating suspected spam posts.
#'
#'
#' @param data Data frame or tibble object
#' @param pattern Pattern you wish to inspect e.g. "link bio"
#' @param text_var Name of the text variable/character vector
#' @param post_url Name of the data frame's URL-column
#'
#' @importFrom rlang enquo
#' @importFrom rlang quo_name
#' @importFrom rlang :=
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' print("hello world")

limpiar_inspect <- function(data,
                            pattern,
                            text_var = .data$mention_content,
                            post_url =  .data$mention_url) {
  data %>%
    dplyr::filter(stringr::str_detect(!!rlang::enquo(text_var), pattern))%>%
    dplyr::select(!!rlang::enquo(text_var), !!rlang::enquo(post_url)) %>%
    tibble::view()
}



