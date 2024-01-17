#' Quickly extract subreddits from a link variable
#'
#' @param df Data Frame or Tibble Object
#' @param url_var The variable containing URLS e.g. `permalink`
#'
#' @return df with an additional column
#' @export
#'
#'@usage
#'limpiar_ex_subreddits(df, url_var = permalink)
#'
limpiar_ex_subreddits <- function(df, url_var = permalink){

  url_sym <- rlang::ensym(url_var)
 if(!is.character(df[[url_sym]])) {
   stop(paste0( rlang::as_string(url_sym), " should be a character vector"))
 }

  df <- df %>%
    dplyr::mutate(subreddit = stringr::str_extract(!!url_sym, "/r/\\w+"))

  return(df)
}
