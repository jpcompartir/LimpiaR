#' limpiar_na_cols
#'
#' A function to remove NA-heavy columns. Retains columns
#'
#'
#' @param df The Data Frame or Tibble object
#' @param threshold Threshold of non-NA entries a column must exceed to be retained.
#'
#' @return Data Frame or Tibble with NA-heavy columns purged
#' @export
#'
#' @examples
#' a <- cbind(c(NA, NA, NA, NA, NA))
#' b <- cbind(c(NA, NA, 2, NA, 3))
#' c <- cbind(c(1, 2, 3, 4, 5))
#' df <- tibble::as_tibble(data.frame(a, b, c))
#' df <- limpiar_na_cols(df, 0.4)
#'
limpiar_na_cols <- function(df, threshold){
  df[colSums(!is.na(df)) /nrow(df)  >= threshold]
}
