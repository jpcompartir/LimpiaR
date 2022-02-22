#' Replace emojis with a textual description
#'
#' Main usage is for pre-processing the text variable as part of Deep Learning pipeline.
#' The most important argument is whether or not to add the emoji tag, which will also print in snake case.
#'
#' @param df Name of Data Frame or Tibble Object
#' @param text_var Name of text variable
#' @param with_emoji_tag Whether to replace with snakecase linked words or not
#'
#' @return The Data Frame or Tibble object with most emojis cleaned from the text variable
#'
#' @examples
#' limpiar_examples %>% dplyr::select(mention_content)
#'
#' limpiar_examples %>% limpiar_emojis() %>% dplyr::select(mention_content)
#' @export
limpiar_emojis <- function(df, text_var = mention_content, with_emoji_tag = FALSE){


  data("code_browser_emojis", envir = environment())

  if(with_emoji_tag){
    keys <- code_browser_emojis %>%
      dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
      dplyr::pull(browser)

    values <- code_browser_emojis %>%
      dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
      dplyr::pull(description)
    values <- paste(" ", values)

    my_hash <- hash::hash(keys = keys, values = values)

    dplyr::mutate(df,
                  {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                             hash::values(my_hash),
                                                             hash::keys(my_hash)),
                  {{ text_var }} := stringr::str_replace_all({{ text_var }}, "emoji", "emoji "))%>%
      limpiar_spaces(text_var = {{text_var}})

    #This is for situations in which we don't want the snake case or the emoji tag (such as when making a bigram network, topics etc.)
    #But I would generally advise just not using limpiar_emojis in such cases.
  }else{
    keys <- code_browser_emojis %>%
      dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
      dplyr::pull(browser)

    values <- code_browser_emojis %>%
      dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
      dplyr::mutate(cldr_short_name = paste0(cldr_short_name, " "))%>%
      dplyr::pull(cldr_short_name)

    values <- paste(" ", values)
    my_hash <- hash::hash(keys = keys, values = values)

    dplyr::mutate(df,
                  {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                             hash::values(my_hash),
                                                            hash::keys(my_hash)))%>%
      limpiar_spaces(text_var = {{text_var}})


  }


}


