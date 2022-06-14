#' Replace emojis with a Spanish textual description
#'
#' Spanish version of limpiar_emojis function.
#' Main usage is for pre-processing the text variable as part of Deep Learning pipeline.
#' The most important argument is whether or not to add the emoji tag, which will also print in snake case.
#'
#'
#' @param df Name of Data Frame or Tibble Object
#' @param text_var Name of text variable
#' @param with_emoji_tag Whether to replace with snakecase linked words or not
#'
#' @return The Data Frame or Tibble object with most emojis cleaned from the text variable
#'
#' @examples
#'
#' limpiar_examples %>% limpiar_emojis_es() %>% dplyr::select(mention_content)
#' @export
limpiar_emojis_es <- function(df, text_var = mention_content, with_emoji_tag = FALSE){


  code_browser_emojis <- LimpiaR::spanish_emojis_df

  if(with_emoji_tag){
    keys <- code_browser_emojis %>%
      dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
      dplyr::pull(browser)

    values <- code_browser_emojis %>%
      dplyr::filter(!stringr::str_detect(cldr_short_name, "keycap: \\*"))%>%
      dplyr::pull(descripcion)
    values <- paste0(" ", values, " ")

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
      dplyr::mutate(nombre = paste0(nombre, " "))%>%
      dplyr::pull(nombre)

    values <- paste0(" ", values, " ")
    my_hash <- hash::hash(keys = keys, values = values)

    dplyr::mutate(df,
                  {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                             hash::values(my_hash),
                                                             hash::keys(my_hash)))%>%
      limpiar_spaces(text_var = {{text_var}})

  }
}

