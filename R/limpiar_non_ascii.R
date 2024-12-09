#' Remove non-ASCII characters except those with latin accents
#'
#' @description Function uses a simple RegEx to retain only basic ASCII characters plus attempts to retain characters with latin accents. If you know that you want to remove everything including accented characters then you should use `limpiar_alphanumeric`.
#'
#' @inheritParams data_param
#' @inheritParams text_var
#'
#' @return Data frame with the text variable changed in place
#'
#' @examples
#' test_df <- data.frame(
#' text = c(
#'   "Simple text 123",              # Basic ASCII only
#'   "Hello! How are you? 😊 🌟",    # ASCII + punctuation + emojis
#'   "café München niño",            # Latin-1 accented characters
#'   "#special@chars&(~)|[$]",       # Special characters and symbols
#'   "混合汉字と日本語 → ⌘ £€¥"      # CJK characters + symbols + arrows
#' )
#' )
#'
#' limpiar_non_ascii(test_df, text)
#'
#' @export
limpiar_non_ascii <- function(data, text_var = mention_content) {

  text_sym <- rlang::ensym(text_var)

  stopifnot(is.data.frame(data))

  # Pattern matches all non-ASCII except latin accents
  non_ascii_pattern <- paste0(
    "[^\\x20-\\x7E",                               # Keep basic ASCII
    "\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u00FF", # Keep Latin-1 Supplement
    "\\u0100-\\u017F]"                             # Keep Latin Extended-A
  )
  compiled_pattern <- stringr::regex(non_ascii_pattern)

  clean_df <- data %>%
    dplyr::mutate(
      !!text_sym := stringr::str_remove_all(
        string = !!text_sym,
        pattern = compiled_pattern
      )
    )

  return(clean_df)
}




