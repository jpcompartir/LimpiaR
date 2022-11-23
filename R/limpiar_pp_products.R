#' Replace entities for the Peaks&Pit classifier
#'
#' @param df Data Frame or Tibble object
#' @param text_var Name of your text variable
#'
#' @return Data Frame or Tibble object with text variable edited inline
#' @export
#'
#' @examples
#' \dontrun{
#' Example 1
#'df %>% limpiar_pp_products(message)
#' Example 2
#'limpiar_pp_products(df, message)
#' }
#'
limpiar_pp_products <- function(df, text_var){
  entities <- LimpiaR::entities

  entities <- entities %>%
    dplyr::filter(!token %in% c("\\bmicrosoft\\b","\\b|apple\\b", "\\bsamsung\\b", "\\bwhatsapp\\b", "\\bintel\\b", "\\bamazon\\b",
                                "\\bsony\\b", "\\binstagram\\b"))

  strings <- entities$token
  strings <- paste0(strings, collapse = "|")
  replacement <- "product"

  df %>%
    dplyr::mutate({{text_var}} := stringr::str_replace_all({{text_var}}, strings, replacement))
}
