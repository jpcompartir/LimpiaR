#' Recode emojis with a textual description
#'
#' @description Main usage is for pre-processing the text variable as part of Deep Learning pipeline. The most important argument is whether or not to add the emoji tag, which will also print in snake case.
#'
#' @inheritParams data_param
#' @inheritParams text_var
#' @param with_emoji_tag Whether to replace with snakecase linked words or not
#'
#' @return The Data Frame or Tibble object with most emojis cleaned from the text variable
#'
#' @examples
#'  emojis <- data.frame(
#'  text = c("Hello 👋 World",
#'   "Family: 👨‍👩‍👧‍👦",
#'   "Coding 👨🏽‍💻",
#'   "Flags 🏳️‍🌈 🇺🇸",
#'   "Weather ☀️ ⛈️ ❄️")
#' )
#'
#' emojis
#'
#' # Without tagging and combining:
#' limpiar_recode_emojis(emojis, text)
#'
#' # With tagging and combining:
#' limpiar_recode_emojis(emojis, text, TRUE)
#'
#' # using limpiar_remove_emojis() to remove them entirely:
#' limpiar_remove_emojis(emojis, text)
#'
#' @export
limpiar_recode_emojis <- function(data, text_var = mention_content, with_emoji_tag = FALSE){
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

    dplyr::mutate(data,
                  {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                             hash::values(my_hash),
                                                             hash::keys(my_hash)),
                  {{ text_var }} := stringr::str_replace_all({{ text_var }}, "emoji", "emoji "))%>%
      limpiar_spaces(text_var = {{text_var}})

    #This is for situations in which we don't want the snake case or the emoji tag (such as when making a bigram network, topics etc.)
    #But I would generally advise just not using limpiar_recode_emojiss in such cases.
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

    dplyr::mutate(data,
                  {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                                             hash::values(my_hash),
                                                            hash::keys(my_hash)))%>%
      limpiar_spaces(text_var = {{text_var}})
  }
}


#' Completely Remove *Most* Emojis from Text
#'
#' @description uses a simple Regular Expression (RegEx) to clear most emojis from the text variable. Attempts to handle emojis which are joined together - like family emojis, and 'edited emojis' like those with skin tones etc. set
#'
#'
#' @inheritParams data_param
#' @inheritParams text_var
#'
#' @return Data Frame with the text variable cleaned in place
#' @examples
#'
#'  emojis <- data.frame(
#'  text = c("Hello 👋 World",
#'   "Family: 👨‍👩‍👧‍👦",
#'   "Coding 👨🏽‍💻",
#'   "Flags 🏳️‍🌈 🇺🇸",
#'   "Weather ☀️ ⛈️ ❄️")
#' )
#'
#' emojis
#'
#' # using limpiar_remove_emojis() to remove them entirely:
#' limpiar_remove_emojis(emojis, text)
#' @export
limpiar_remove_emojis <- function(data, text_var) {

  text_sym <- rlang::ensym(text_var)

  stopifnot(is.data.frame(data))

  emojis_pattern <- paste0(
    # the estimates/explanations are imprecise - complex emojis and new emojis get matched when they shouldn't, but the result in aggregate is good (i.e. we're removing emojis and not other stuff)
    "[\U{1F000}-\U{1FFFF}]",                       # Main emoji blocks
    "|[\U{2190}-\U{27BF}]",                        # Arrows, symbols
    "|[\U{2B00}-\U{2BFF}]",                        # Misc symbols
    "|[\U{1F1E6}-\U{1F1FF}]",                      # Regional indicators
    "|[\U{1F300}-\U{1F5FF}]",                      # Additional emoji
    "|[\U{1F600}-\U{1F64F}]",                      # Emoticons
    "|[\U{1F680}-\U{1F6FF}]",                      # Transport
    "|[\U{1F900}-\U{1F9FF}]",                      # Supplemental
    "|[\U{1FA00}-\U{1FA6F}]",                      # Extended-A
    "|[\U{1FA70}-\U{1FAFF}]",                      # Extended-B
    "|[\U{FE00}-\U{FE0F}]"                         # Variation selectors
  )
  compiled_pattern <- stringr::regex(emojis_pattern)

  clean_df <- data %>%
    dplyr::mutate(
      !!text_sym := stringr::str_remove_all(
        string = !!text_sym,
        pattern = compiled_pattern)
    )

  return(clean_df)
}



