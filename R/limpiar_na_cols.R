#' Clean NA-heavy columns from a Data Frame or Tibble
#'
#' Remove columns whose proportion of NAs is higher than determined threshold.
#' Setting threshold of 0.25 asks R to remove all columns with 25% or more NA values.
#' Can be useful when dealing with large data frames, where many columns are redundant.
#'
#' @param df The Data Frame or Tibble object
#' @param threshold Threshold of non-NA entries a column must exceed to be retained.
#'
#' @return Data Frame or Tibble with NA-heavy columns purged
#' @export
#'
#' @examples
#' limpiar_examples
#'
#' limpiar_examples %>% limpiar_na_cols(0.1)
#'
limpiar_na_cols <- function(df, threshold){
  df[colSums(!is.na(df)) /nrow(df)  >= threshold]
}
