#' limpiar_shorthands
#'
#' Replaces common Spanish shorthands and abbreviations with their longer form equivalents. Follows a similar design to limpiar_accents - so can be called inside a dplyr::mutate() function call
#' @param text_var The text variable
#' @param spaces_as_underscores Whether multi-word corrections e.g. 'te quiero mucho' should have spaces or underscores. Default = FALSE
#'
#' @return The text variable with shorthands replaced
#' @export
#'
#' @examples
#' \dontrun{
#' df <- df %>% mutate(text_var = limpiar_shorthands(text_var))
#' text_var <- limpiar_shorthands(text_var)
#' }
limpiar_shorthands <- function(text_var, spaces_as_underscores = FALSE){

  shorthands <- c("\\bporq\\b","\\btqm\\b", "\\btq\\b", "\\bpq\\b", "\\bxq\\b", "\\bq\\b", "\\bk\\b", "\\bxk\\b",
                  "\\bpk\\b", "\\bxfa\\b", "\\bxa q\\b", "mxo", "bst", "\\btam\\b", "pti",
                  "\\bkn\\b", "ntnc", "\\btonces\\b", "\\bgnl\\b", "\\bkyat\\b",
                  "\\bfin d\\b", "\\bKO\\b", "\\b(TQI|tqi)\\b", "\\b(TKI|tki)\\b",
                  "\\b(NPN|npn)\\b", "\\bvrd\\b", "\\bvdd\\b", "\\bntp\\b", "\\b(GPI|gpi)\\b", "\\bslds\\b", "\\bctm\\b",
                  "\\bgrax\\b", "\\bwn\\b")

  shorthand_corrections <- c("\\bporque\\b", "te_quiero_mucho", "te_quiero", "porque", "porque", "que", "que",
                             "porque", "porque", "por_favor", "para_que", "mucho", "besitos",
                             "te_amo_mucho", "para_ti", "quien", "entonces", "entonces", "genial", "callate",
                             "fin_de_semana", "muerto", "tengo_que_irme", "tengo_que_irme",
                             "no_pasa_nada", "verdad", "verdad", "no_te_preocupes", "gracias_por_invitar",
                             "saludos", "chinga_tu_madre", "gracias", "wuevon")
  if(spaces_as_underscores){
    shorhand_corrections <- shorthand_corrections
  }else{
    shorthand_corrections <- stringr::str_replace_all(shorthand_corrections, "_", " ")
  }


  my_hash <- hash::hash(keys = shorthands,
                        values = shorthand_corrections)

  (text_var <- stringr::str_replace_all(text_var,
                                        hash::values(my_hash),
                                        hash::keys(my_hash)))
}
