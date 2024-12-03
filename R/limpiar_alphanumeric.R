#' Remove everything except letters, numbers, and spaces
#'
#' @description A simple regex for retaining only a-z, A-Z and 0-9 as well as white space characters, including new lines. This function *will* remove accented characters, and any non-English characters, punctuation, etc. so it is a heavy-duty approach to cleaning and should be used prudently.
#'
#' @inheritParams data_param
#' @inheritParams text_var
#'
#' @return Data frame with the text variable changed in place
#' @export
#'
#' @examples
#' 2+2
limpiar_alphanumeric <- function(data, text_var) {

  text_sym <- rlang::ensym(text_var)

  stopifnot(is.data.frame(df))

  # Pattern keeps alphanumeric and whitespace characters only
  alphanumeric_pattern <- "[^a-zA-Z0-9\\s]"  # \s matches any whitespace (spaces, tabs, newlines)
  compiled_pattern <- stringr::regex(alphanumeric_pattern)

  clean_df <- df %>%
    dplyr::mutate(
      !!text_sym := stringr::str_remove_all(
        string = !!text_sym,
        pattern = compiled_pattern
      )
    )

  return(clean_df)
}
