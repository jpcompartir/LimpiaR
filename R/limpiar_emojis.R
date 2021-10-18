#' limpiar_emojis
#'
#' functions to replace most emojis with a snakecase descrition + '_emoji'
#'
#'
#' @param df Name of Data Frame or Tibble Object
#' @param text_var Name of text variable
#'
#' @return Data Frame with most emojis cleaned
#' @export
#'
#' @examples
#' \dontrun
#' df %>% limpiar_emojis(text_var)
#'
#'
limpiar_emojis <- function(df, text_var = mention_content){

  data("code_browser_emojis")

  keys <- code_browser_emojis %>%
    dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
    dplyr::pull(browser)

  values <- code_browser_emojis %>%
    dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
    dplyr::pull(description)

  my_hash <- hash::hash(keys = keys, values = values)

  dplyr::mutate(df,
         {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                              hash::values(my_hash),
                                              hash::keys(my_hash)),
         {{ text_var }} := stringr::str_replace_all({{ text_var }}, "emoji", "emoji "))
}

