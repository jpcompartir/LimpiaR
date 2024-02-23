#Record global variables
utils::globalVariables(c("mention_content", "code_browser_emojis",
                         "description", "cldr_short_name", "mention_url","data", "descripcion", "nombre", "document", "n_ngram", "token", "permalink", "doc_id", "upos", "dep_rel"))


#' Tibble of examples for LimpiaR functions
#'
#'
#' @format A tibble with 10 rows and 5 columns
#' \describe{
#'   \item{doc_id}{Post ID}
#'   \item{author_name}{The author's public username}
#'   \item{mention_content}{Text variable}
#'   \item{mention_url}{Link to original post}
#'   \item{platform_interactions}{Number of interactions on parent platform}
#' }
#' @docType data
#' @name limpiar_examples
#' @usage data("limpiar_examples")
#' @keywords internal
"limpiar_examples"


#' sentiment_stops
#'
#' Stop words for sentiment analysis in Spanish (negation cues left in).
#'
#' @format A tibble with 2 columns & 682 rows
#' \describe{
#'   \item{Message}{Data frame with stop word vectors}
#' }
#' @docType data
#' @name sentiment_stops
#' @usage data("sentiment_stops")
#' @keywords internal
"sentiment_stops"


#' topic_stops
#'
#' Stop words for topic modelling in Spanish.
#'
#' @format A tibble with 2 columns & 704 rows
#' \describe{
#'   \item{Message}{Data frame with stop word vectors}
#' }
#' @docType data
#' @name topic_stops
#' @usage data("topic_stops")
#' @keywords internal
#'
"topic_stops"

#' spanish_emojis_df
#'
#' data frame with columns for emoji converting in Spanish
#'
#' @format 6 columns 1307 rows
#' \describe{
#'   \item{Message}{Data frame with emoji conversions in Spanish}
#' }
#' @docType data
#' @name code_browser_emojis
#' @usage data("spanish_emojis_df")
#' @keywords internal
"spanish_emojis_df"

#' code_browser_emojis
#'
#' data frame with columns for emoji converting
#'
#' @format 3 columns 1853 rows
#' \describe{
#'   \item{Message}{Data frame with emoji conversions}
#' }
#' @docType data
#' @name code_browser_emojis
#' @usage data("code_browser_emojis")
#' @keywords internal
#'
"code_browser_emojis"


#' entities
#'
#' data frame with entities for converting and removing
#'
#' @format 4 columns 193 rows
#' \describe{
#'   \item{token}{regex pattern for product}
#'   \item{replacement}{string to replace with}
#'   \item{n}{count of entity in original data}
#'   \item{word_count}{number of words entity's string comprises}
#' }
#' @docType data
#' @name entities
#' @usage data("entities")
#' @keywords internal
#'
"entities"

