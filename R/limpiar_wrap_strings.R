#' Wrap strings for visual ease
#'
#' @description Useful for pre-processing a dataset in which you need to read many documents, or scan over a lot of documents, e.g. when rendering an interactive scatter plot and using plotly's hover, or when using `DT::datatable(escape = FALSE)`.
#'
#' @inheritParams data_param
#' @inheritParams text_var
#' @param n number of words
#' @param newline_char the specific delimiter to wrap the texts with
#'
#' @return Data Frame with text variable edited in place
#' @export
#'
#' @examples
limpiar_wrap <- function(data, text_var = mention_content, n = 15, newline_char = "<br><br>") {

  stopifnot(
    is.data.frame(data),
    is.character(newline_char),
    is.numeric(n)
  )

  text_sym <- rlang::ensym(text_var)
  # optimised approach to reduce memory and computation time


  results <- data %>%
    dplyr::mutate(
      !!text_sym := {
        # Pre-compile pattern for efficiency
        split_pattern <- stringr::regex("\\s+")

        # Process in chunks to reduce memory usage
        words_list <- stringr::str_split(!!text_sym, split_pattern)

        vapply(words_list, function(words) {
          len <- length(words)
          if(len <= n) return(paste(words, collapse = " ")) # If words is less than n then don't add anything.

          # Get number of rows in advace, and calculate remainder
          complete_rows <- floor(len/n)
          remaining <- len %% n

          if(remaining > 0) {
            # Process main rows in chunks
            rows_as_text <- character(complete_rows + 1)
            for(i in seq_len(complete_rows)) {
              idx <- ((i-1) * n + 1):(i * n)
              rows_as_text[i] <- paste(words[idx], collapse = " ")
            }
            # Handle last row separately
            rows_as_text[complete_rows + 1] <- paste(
              words[(complete_rows * n + 1):len],
              collapse = " "
            )
          } else {
            # Process complete rows only
            rows_as_text <- character(complete_rows)
            for(i in seq_len(complete_rows)) {
              idx <- ((i-1) * n + 1):(i * n) # Iteratively extract ids (1:n, n+1: 2n, 2n+1:3n  etc.)
              # paste the words in the row together, with spaces as delimiters. If we were to newline_char here we'd have a newline every word
              rows_as_text[i] <- paste(words[idx], collapse = " ")
            }
          }

          # paste all the rows together (re-assemble text) with a newline_char between each row.
          paste(rows_as_text, collapse = newline_char)
        }, character(1)) # Tell vapply we expect a character of length 1 in return
      }
    )

  return(results)
}
