#' Inspect every post and URL which contains a pattern
#'
#' Produces a viewable data frame with posts matching a regular expression and their url.
#' Useful for investigating suspected spam posts, or other patterns of interest.
#' Set the name of the title to avoid new frames overwriting old ones.
#'
#'
#' @param data Data frame or tibble object
#' @param pattern Pattern you wish to inspect e.g. "link bio"
#' @param text_var Name of the text variable/character vector
#' @param url_var Name of the data frame's URL-column
#' @param title Name of the viewable pane
#'
#' @importFrom rlang enquo
#' @importFrom rlang :=
#' @examples
#' df <- data.frame(
#' text_variable = rbind("check me out", "don't look at me"),
#' text_url = rbind("www.twitter.com", "www.facebook.com"))
#' limpiar_inspect(df, "check", text_var = text_variable, post_url = text_url)
#' @export
#'


limpiar_inspect <- function(data,
                            pattern,
                            text_var = mention_content,
                            url_var = mention_url,
                            title = "inspect") {
  title_var = enquo(title)

  data %>%
    dplyr::filter(stringr::str_detect({{ text_var }}, pattern))%>%
    dplyr::select({{ text_var }}, {{ url_url }}) %>%
    tibble::view(title = title_var)
}
