#' Remove non-ASCII characters except those with latin accents
#'
#' @inheritParams data_param
#' @inheritParams text_var
#'
#' @return Data frame with the text variable changed in place
#' @export
#'
#' @examples
#' 2+2
limpiar_non_ascii <- function(df, text_var) {

  text_sym <- rlang::ensym(text_var)

  stopifnot(is.data.frame(df))

  # Pattern matches all non-ASCII except latin accents
  non_ascii_pattern <- paste0(
    "[^\\x20-\\x7E",                               # Keep basic ASCII
    "\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u00FF", # Keep Latin-1 Supplement
    "\\u0100-\\u017F]"                             # Keep Latin Extended-A
  )
  compiled_pattern <- stringr::regex(non_ascii_pattern)

  clean_df <- df %>%
    dplyr::mutate(
      !!text_sym := stringr::str_remove_all(
        string = !!text_sym,
        pattern = compiled_pattern
      )
    )

  return(clean_df)
}




