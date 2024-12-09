#' Inspect every post and URL which contains a pattern
#'
#' @description Produces a viewable data frame with posts matching a regular expression and    Useful for investigating suspected spam posts, or other patterns of interest. Set the name of the title to avoid new frames overwriting old ones.
#'
#' @details add boundary tags e.g. `\\b` to either side of your pattern if you wish to only match words rather than parts of words. For example, `pattern="cats"` will match '#cats', but also 'catch up'. If we add a word boundary: `pattern = \\bcats\\b` we won't match either '#cats' or 'catch up'.
#'
#'
#'
#' @inheritParams data_param
#' @param pattern Pattern you wish to inspect e.g. "link bio"
#' @inheritParams text_var
#' @param url_var Name of the data frame's URL-column
#' @param title Name of the viewable pane
#' @param open_view For testing purposes, default is set to TRUE
#' @param ignore_case Whether the pattern should ignore the upper case/lower case distinction
#' @importFrom rlang enquo
#' @importFrom rlang :=
#' @examples
#' df <- data.frame(
#' text_variable = rbind("check me out", "don't look at me"),
#' text_url = rbind("www.twitter.com", "www.facebook.com"))
#' limpiar_inspect(df, "check", text_var = text_variable, url_var = text_url)
#' @export
#'
limpiar_inspect <- function(data,
                            pattern,
                            text_var = mention_content,
                            url_var = mention_url,
                            title = "inspect",
                            open_view = TRUE,
                            ignore_case = TRUE) {

  stopifnot(is.character(pattern),
            is.data.frame(data),
            is.character(title),
            is.logical(open_view))

  title_var = enquo(title)

  regex_pattern <- stringr::regex(pattern, ignore_case = ignore_case)

  view_data <- data %>%
    dplyr::filter(stringr::str_detect({{ text_var }}, regex_pattern))%>%
    dplyr::select({{ text_var }}, {{ url_var }})

  if (open_view){
    tibble::view(view_data, title = title_var)
  }

  invisible(view_data)

}
