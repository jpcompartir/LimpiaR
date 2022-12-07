#' Quickly extract subreddits from a link variable
#'
#' @param df Data Frame or Tibble Object
#' @param url_var The variable containing URLS e.g. `permalink`
#'
#' @return df with an additional column
#' @export
#'
#'@usage df %>% limpiar_ex_subreddits(url_var = permalink)
#'
limpiar_ex_subreddits <- function(df, url_var = permalink){

  url_type <- LandscapeR::column_type_checker(data = df, column = {{url_var}}, type = "character")
  if(url_type == "no") stop("url_var should be a character vector")

  df <- df %>%
    dplyr::mutate(subreddit = stringr::str_extract({{url_var}}, "/r/\\w+"))

  return(df)
}
