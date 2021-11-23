#' Clean user handles and hashtags
#'
#' Function replaces user handles and hashtags with neutral tags.
#' You can choose whether to replace both hashtags & users or either one.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#' @param user Whether to replace user handles or not TRUE = replace
#' @param hashtag Whether to replace hashtags or not TRUE = replace
#'
#' @return The Data Frame or Tibble object with user handles and/or hashtags removed from the text variable
#' @examples
#' limpiar_examples
#'
#' #Both user and hashtags
#' limpiar_examples %>% limpiar_tags() %>% dplyr::select(mention_content)
#'
#' #Just user tags
#' limpiar_examples %>% limpiar_tags(hashtag = FALSE) %>% dplyr::select(mention_content)
#'
#' #Just hashtags
#' limpiar_examples %>% limpiar_tags(user = FALSE) %>% dplyr::select(mention_content)
#'
#' @export
#'
limpiar_tags <- function(df, text_var = mention_content, user = TRUE, hashtag = TRUE){


  #These functions use the \\B boundary tags instead of \\b to avoid accidentalyl normalising email addresses

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
