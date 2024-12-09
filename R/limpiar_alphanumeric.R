#' Remove everything except letters, numbers, and spaces
#'
#' @description A simple regex for retaining only a-z, A-Z and 0-9 as well as white space characters, including new lines. This function *will* remove accented characters, and any non-English characters, punctuation, etc. so it is a heavy-duty approach to cleaning and should be used prudently. If you know that you need to keep accents, try `limpiar_non_ascii` first, before avoiding these functions altogether.
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
#' limpiar_alphanumeric(test_df, text)
#'
#' @export
limpiar_alphanumeric <- function(data, text_var = mention_content) {

  text_sym <- rlang::ensym(text_var)

  stopifnot(is.data.frame(data))

  # Pattern keeps alphanumeric and whitespace characters only
  alphanumeric_pattern <- "[^a-zA-Z0-9\\s]"  # \s matches any whitespace (spaces, tabs, newlines)
  compiled_pattern <- stringr::regex(alphanumeric_pattern)

  clean_df <- data %>%
    dplyr::mutate(
      !!text_sym := stringr::str_remove_all(
        string = !!text_sym,
        pattern = compiled_pattern
      )
    )

  return(clean_df)
}
