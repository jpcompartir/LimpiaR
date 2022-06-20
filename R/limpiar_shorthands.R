#' Clean shorthands and abbreviations
#'
#' Replaces common Spanish shorthands and abbreviations with their longer form equivalents.
#' Choose whether to link the replacements with snake case or not, with spaces_as_underscores.
#' Useful primarily for normalising text ahead of sentiment classification.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#' @param spaces_as_underscores Whether multi-word corrections e.g. 'te quiero mucho' should have spaces or underscores. Default = FALSE

#'
#' @return The text variable with shorthands replaced
#' @export
#'
#' @examples
#' limpiar_examples %>% dplyr::select(mention_content)
#'
#' limpiar_examples %>% limpiar_shorthands() %>% dplyr::select(mention_content)
#'
limpiar_shorthands <- function(df, text_var = mention_content, spaces_as_underscores = FALSE){

  shorthands <- c("\\bporq\\b","\\btqm\\b", "\\btq\\b", "\\bpq\\b", "\\bxq\\b", "\\bq\\b", "\\bk\\b", "\\bxk\\b",
                  "\\bpk\\b", "\\bxfa\\b", "\\bxa q\\b", "\\bmxo\\b", "\\bbst\\b", "\\btam\\b", "\\bpti\\b",
                  "\\bkn\\b", "\\bntnc", "\\btonces\\b", "\\bgnl\\b", "\\bkyat\\b",
                  "\\bfin d\\b", "\\bKO\\b", "\\b(TQI|tqi)\\b", "\\b(TKI|tki)\\b",
                  "\\b(NPN|npn)\\b", "\\bvrd\\b", "\\bvdd\\b", "\\bntp\\b", "\\b(GPI|gpi)\\b", "\\bslds\\b", "\\bctm\\b",
                  "\\bgrax\\b", "\\bwn\\b", "\\basdc\\b", "\\b100pre\\b", "\\b(k|q) aces\\b", "\\bsbs\\b",
                  "\\bvns\\b", "\\baora\\b", "\\bbn\\b", "\\bnx\\b","\\bcdo\\b", "\\bdim\\b",
                  "\\bdcr\\b", "\\bkntm\\b", "\\bnph\\b", "\\bre100\\b", "\\btvo\\b", "\\bweno\\b", "\\bbb\\b", "\\bntonces","\\Bporfavor",
                  "\\beske\\b", "\\btb\\b", "\\bijo\\b", "\\bm\\b", "\\bbno\\bn", "\\btol\\b", "\\bntr\\b", "\\bx\\b", "\\bdsd\\b", "\\bbno\\b",
                  "\\bde vd\\b", "\\bkedarse\\b", "\\bkedar\\b", "\\bkeda\\b", "\\bdps\\b", "\\btmb\\b", "\\bmnn\\b", "dmierda", "\\besq\\b", "\\bvd\\b",
                  "\\buds\\b",  "\\btkm\\b", "\\bchtm\\b")

  shorthand_corrections <- c("porque", "te_quiero_mucho", "te_quiero", "porque", "porque", "que", "que",
                             "porque", "porque", "por_favor", "para_que", "mucho", "besitos",
                             "te_amo_mucho", "para_ti", "quien", "entonces", "entonces", "genial", "callate",
                             "fin_de_semana", "muerto", "tengo_que_irme", "tengo_que_irme",
                             "no_pasa_nada", "verdad", "verdad", "no_te_preocupes", "gracias_por_invitar",
                             "saludos", "chinga_tu_madre", "gracias", "wuevon", "a_salir_de_casa", "siempre",
                             "que haces", "sabes", "vienes", "ahora", "bien", "buenas noches", "cuando", "dime",
                             "decir", "cuentame", "no_puedo_hablar", "recien", "te_veo", "bueno", "bebe", "entonces",
                             "porfavor", "es que", "tambien", "hijo", "me", "bueno", "todo el", "nosotros", "por", "desde", "bueno",
                             "de verdad", "quedarse", "quedar", "queda", "despues", "tambien", "manyana", "demierda", "es que", "verdad",
                             "ustedes", "te quiero mucho", "chinga tu madre")
  if(spaces_as_underscores){
    shorhand_corrections <- shorthand_corrections
  }else{
    shorthand_corrections <- stringr::str_replace_all(shorthand_corrections, "_", " ")
  }


  my_hash <- hash::hash(keys = shorthands,
                        values = shorthand_corrections)

  dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{ text_var }},
                                        hash::values(my_hash),
                                        hash::keys(my_hash)))
}

