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
    dplyr::filter(!token %in% c("\\bmicrosoft\\b","\\bapple\\b", "\\bsamsung\\b", "\\bwhatsapp\\b", "\\bintel\\b", "\\bamazon\\b", "\\bsony\\b", "\\binstagram\\b"))

  extras <- c("\\bsurface pro 8\\b", "\\bwin 11\\b", "\\bwin11\\b", "\\bsurface pro\\b")

  strings <- entities$token
  strings <- c(strings, extras)
  strings <- paste0(strings, collapse = "|")
  replacement <- "product"

  df %>%
    dplyr::mutate({{text_var}} := stringr::str_replace_all({{text_var}}, strings, replacement))
}


#' Remove known companies for pits & peaks
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
#'df %>% limpiar_pp_companies(message)
#' Example 2
#'limpiar_pp_companies(df, message)
#' }
limpiar_pp_companies <- function(df, text_var){
  companies <- c("\\bapple\\b", "\\bmicrosoft\\b", "\\bmsft\\b", "\\bnvidia\\b", "\\bsony\\b", "\\binstagram\\b",
                 "\\bwhatsapp\\b", "duckduckgo", "\\bddg\\b", "\\bduck duck go\\b", "\\bsamsung\\b", "\\blenovo\\b",
                 "\\bdell\\b", "\\bfacebook\\b", "\\byoutube\\b", "\\bxbox\\b", "\\bspotify\\b", "\\bmozilla firefox\\b",
                 "\\bmozilla\\b", "\\bfirefox\\b")
  companies <- paste0(companies, collapse = "|")
  replacement <- "company"

  df %>%
    dplyr::mutate({{text_var}} := stringr::str_replace_all({{text_var}}, companies, replacement))
}
