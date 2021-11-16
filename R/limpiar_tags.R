#' limpiar_tags
#'
#' Function replaces user handles and hashtags and replaces them with neutral tags.
#' You can choose whether to replace both hashtags & users or either one.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#' @param user Whether to replace user handles or not TRUE = replace
#' @param hashtag Whether to replace hashtags or not TRUE = replace
#'
#' @return the df object with the text_var cleaned of user / # tags
#' @example
#' \dontrun{
#' data <- data %>% limpiar_tags(text_var = text_var, user = TRUE, hashtag = FALSE)
#' }
#'
#' @export
#'
limpiar_tags <- function(df, text_var = mention_content, user = TRUE, hashtag = TRUE){

  #Return just user tags relaced if user = TRUE and hashtag = FALSE
  if(user & !hashtag){
    (df <- dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},"\\B@\\w+", "@user")))
  }

  #Return just hashtags replaced if user = FALSE and hashtag = TRUE
  if(hashtag & !user){
    (df <- dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},"\\B#\\S+", "hashtag")))
  }

  #First remove user tags, then return the data frame after removing hashtags
  if(hashtag & user){
    df <- dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},"\\B@\\w+", "@user"))
    (df <- dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},"\\B#\\S+", "hashtag")))
  }else{df}

}
