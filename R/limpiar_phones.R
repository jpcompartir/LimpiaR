#' Clean phone numbers from text
#'
#' Function creates a flag column for posts containing phone numbers. 
#' Catches various phone number formats, i.e US, UK, European etc.
#' By default the function only replaces phone numbers in a recognised format.
#' Can also be set to be more aggressive and catch plain digit sequences (7-15 digits).
#' Can also be set to replace phone_numbers with a string.
#'
#' @param df Name of DataFrame or Tibble object
#' @param text_var Name of text variable/character vector
#' @param aggressive Bool: If TRUE, also catches plain digit sequences (7-15 digits)
#' @param tag String: Default = "None", if supplied replaces phone numbers with string
#'
#' @return The DataFrame or Tibble object with phone number flag column
#'
#' @details
#' Matches:
#' \itemize{
#'   \item International: +1 555-123-4567, +44 20 1234 5678
#'   \item US/Canada: (555) 123-4567, 555-123-4567
#'   \item UK: 07951 902 146, 01786 475545
#'   \item European: 77 54 33 33
#'   \item Latin American: 4782-0699
#'   \item Local: 555-1234
#' }
#' Also matches when aggressive = TRUE:
#' \itemize{
#'   \item Plain digits: 07546104638, 1234567890
#' }
#'
#' Avoids matching:
#' \itemize{
#'   \item 09:00-17:00
#'   \item 192.168.1.1
#'   \item $1,234,567
#'   \item 1,000,000,000
#'   \item 1995-2025
#' }
#'
#' @examples
#' # Example data
#' phone_examples <- tibble::tibble(
#'   id = 1:5,
#'   text_var = c(
#'     "Call me at 555-123-4567 or (555) 123-4568",
#'     "WhatsApp +44 20 1234 5678",
#'     "Contact: 07506308688",
#'     "Meeting at 09:00-17:00, call 4782-0699",
#'     "I earned £100,000,000 between 1995-2025"
#'   )
#' )
#'
#' # Default example
#' phone_examples %>% 
#'   limpiar_phone_numbers(text_var = text_var, aggressive = FALSE) %>% 
#'   dplyr::select(text_var)
#'
#' # More aggressive version, catching sequences of digits between 7-15 in length
#' phone_examples %>% 
#'   limpiar_phone_numbers(text_var = text_var, aggressive = TRUE) %>% 
#'   dplyr::select(text_var)
#' 
#' # Filter out rows containing phone numbers
#' phone_examples %>% 
#'   limpiar_phone_numbers(text_var = text_var, aggressive = FALSE) %>% 
#'   dplyr::filter(phone_number_flag == FALSE) %>% 
#'   dplyr::select(id, text_var)
#'
#' @export
#'
limpiar_phone_numbers <- function(df, 
                                   text_var = mention_content, 
                                   aggressive = TRUE,
                                   tag = "None") {
  
  # check data exists and is correct type
  if (!is.data.frame(df)) {
    stop("'df' must be a data.frame or tibble, but got type: ",
         class(df)[1])
  }

  # check aggressive is logical
  if (!is.logical(aggressive)) {
    stop("Parameter 'aggressive' must be logical (TRUE/FALSE), but got type: ",
         class(aggressive)[1])
  }

  # check tag exists and is a string
  if (!is.character(tag) || length(tag) != 1) {
    stop("Parameter 'tag' must be a single character string, but got type: ",
        class(tag)[1])
  }

  # handle both quoted and unquoted column names
  text_sym <- rlang::ensym(text_var)

  # check text var is correct type
  col_data <- dplyr::pull(df, !!text_sym)
  
  if (!is.character(col_data)) {
    stop("Parameter 'text_var' must be a character vector (string type), but got type: ",
         class(col_data)[1])
  }

  # phone number format patterns
  patterns <- c(
    # international with + prefix
    # matches +[1-3 digits][7-12 more digits with optional separators]
    "\\+\\d{1,3}(?:[\\s.-]?\\d){7,12}",
    
    # us/canada format with parentheses
    # matches (XXX) XXX-XXXX or (XXX) XXX XXXX
    "\\(\\d{3}\\)[\\s.-]?\\d{3}[\\s.-]?\\d{4}",
    
    # standard 10-digit with separators
    # matches XXX-XXX-XXXX or XXX XXX XXXX or XXX.XXX.XXXX
    "\\d{3}[\\s.-]\\d{3}[\\s.-]\\d{4}",
    
    # uk format (5-3-3)
    # matches 0XXXX XXX XXX
    "0\\d{4}\\s\\d{3}\\s\\d{3,6}",
    
    # uk format (5-6 with single space)
    # matches 0XXXX XXXXXX
    "0\\d{4}\\s\\d{6}",
    
    # european short format (8 digits with spaces)
    # matches XX XX XX XX (exactly 8 digits)
    "(?<!\\d)\\d{2}\\s\\d{2}\\s\\d{2}\\s\\d{2}(?!\\d)",
    
    # 8-digit format with hyphen (4-4 pattern)
    # matches XXXX-XXXX where first digit is 3-9 (avoids year ranges like 1995-2025)
    "(?<!\\d)[3-9]\\d{3}-\\d{4}(?!\\d)",
    
    # 7-digit local format with separator
    # matches XXX-XXXX or XXX XXXX
    "(?<!\\d)\\d{3}[\\s.-]\\d{4}(?!\\d)"
  )

  # currency symbols
  currency_symbols <- "\\u00a3\\u20ac\\u00a5"
  
  # add aggressive pattern if enabled
  if (aggressive) {
    aggressive_pattern <- paste0(
      "(?<![a-zA-Z.,$/", currency_symbols, "\\d])",
      "\\d{7,15}",
      "(?![a-zA-Z.,\\d])"
    )
    patterns <- c(patterns, aggressive_pattern)
  }
  
  # combine patterns with negative lookarounds
  full_pattern <- paste0(
    "(?<!\\d)",  # not preceded by digit
    "(?:", 
    paste(patterns, collapse = "|"),  # combining format patterns
    ")",
    "(?![:/=?&\\d-])"   # not followed by colon, digit, or dash
  )
  
  # output
  if (tag == "None") {
    # if tag not changed from default value, only create flag column
    df <- df %>%
      dplyr::mutate(
        phone_number_flag = stringr::str_detect(!!text_sym, full_pattern)
      )
  } else {
    # create flag column and replace phone numbers with tag
    df <- df %>%
      dplyr::mutate(
        phone_number_flag = stringr::str_detect(!!text_sym, full_pattern),
        !!text_sym := stringr::str_replace_all(!!text_sym, full_pattern, tag)
      )
  }
  
  return(df)
}