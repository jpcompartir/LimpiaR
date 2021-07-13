#' limpiar_na_cols
#'
#' A function to remove columns with a specified proportion of NA/missing values.
#'
#' @param data The Data Frame or Tibble Object
#' @param y A decimal between 0 and 1: The minimum proportion of NA values a column should contain to not be deleted.
#'
#' @return data frame or tibble
#' @export
#'
#' @examples
#' print("hello world")


limpiar_na_cols <- function(data, y){
  data <- data[colSums(is.na(data)) <= nrow(data) * y]
  data
}

#
# #Usage things
#  # limpiar_na_cols(data = df, y = 0.75)
#  #
#  # limpiar_na_cols(data = df ,y = 0.5)
