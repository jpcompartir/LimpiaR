#' Clean slang from multiple Spanish dialects
#'
#' Replaces slang phrases from various Spanish dialects with everyday terms.
#' Function's primary use is to normalise text for Deep Learning sentiment algorithm.
#'
#' @param df Name of Data Frame or Tibble object
#' @param text_var Name of text variable/character vector
#'
#' @return Data Frame or Tibble object with text variable altered
#' @examples
#' \dontrun{
#' df %>%
#' limpiar_slang(text_var = text_var)}
#' @export


limpiar_slang <- function(df, text_var = mention_content){

  slang <- c("chaval", "me mola", "\\bmazo\\b", "\\bkeli\\b", "\\btuto\\b", "feten", "\\ba pachas",
             "chachi","\\bjeta\\b", "(es|eres|seas|sea|soy|esta|estas) un jeta", "sincio", "es\\w+ de lo(c|k)os",
             "(es|son|eres|sois) de lo(c|k)os", "la ostia", "la hostia", "cojonud(o|a)", "garito", "(da|das|dan) palo",
             "quillo|killo|\\billo", "riquino", "manda huevos", "morrina", "liarse", "se lio", "se ha liado",
             "que liada", "menuda liada", "tas flipao", "flipar", "de puta madre", "\\bchoni\\b", "\\bcani\\b", "talue|taluego",
             "menudo marron", "esta de muerte", "miarma", "menuda leche", "la leche", "me la suda", "me la pela", "pos ok|posok",
             "cotilla", "empollon", "que chulo", "\\bcuqui\\b", "\\bguay\\b", "tranqui\\b", "mis viejos", "que padre",
             "como una cabra", "\\bcutre\\b", "cabreo", "ti\\w+ la cana", "como un toro", "es la cana",
             "echar un cable", "toma\\w* el pelo", "es\\w+ de ped(a|o)", "llev\\w+ un mono encima", "es\\w+ pel(ad|a)o",
             "que tip(azo|in)", "pivon|pibonazo", "vendehumos\\w*", "chamaco", "(\\bwey|guey)", "chingon","de huevos", "la (neta|netflix)",
             "chido", "a huevo\\b", "mirrey", 'buena onda', "es\\w+ padre", "compa\\b", "\\bnaco\\b", "\\bnacos\\b",
             "que pedo", "una chela", "de poca madre", "que poca madre", "me vale madre", "vale madres", "que chimba",
             "\\bbobo\\b", "mala mia", "guacala|guacatela", "cheto", "chevere", "paila\\b", "piola", "crack", "boludo",
             "quilombo", "medio pelo", "jallalla", "\\bopa\\b", "cojudo", "\\byema\\b", "camote", "pintudo",
            "huaso", "jailon", "pucha", "yesca", "no manches"
             )

  corrections <- c("nino", "me gusta", "mucho", "casa", "instituto", "estupendo", "por partes iguales",
                   "ok", "cara", "ser una caradura", "deseo", "muy bueno", "loco", "lo mejor", "lo mejor",
                   "muy bueno", "bar", "da verguenza", "amigo", "adorable", "me he indignado", "nostalgia",
                   "confundirse", "se confundio", "se ha confundido", "que problema", "que problema", "estas loco",
                   "alucinar", "increible", "vulgar", "vulgar", "hasta luego", "que problema", "esta bueno", "mi amor",
                   "que golpe", "lo mejor", "no me importa", "no me importa", "ok", "chismoso", "estudioso",
                   "que bien", "adorable", "bien", "tranquilo", "mis padres", "que bien", "loco", "mediocre", "molestia",
                   "seducir", "fuerte", "lo mejor", "ayudar", "burlar", "estar borracho", "ir muy borracho", "arruinado",
                   "fenomenal", "atractivo", "mentiroso", "nino", "amigo", "fenomenal", "fenomenal", "la verdad",
                   "bueno", "muy bien", "persona de buen estatus economico", "agradable", "bien", "amigo", "vulgar", "vulgares",
                   "que pasa", "una cerveza", "muy buena", "que pena", "no me importa", "sin valor", "que bien",
                   "tonto", "perdon", "asco", "persona de buen estatus economico", "bien", "desasgtro", "inteligente",
                   "campeon", "retrasado", "desastre", "mediocre", "hola", "idiota", "tonto", "borracho", "enamorado", "genial",
                   "maleducado", "inutil", "maldita sea", "arruinado", "no molestes"
                   )

  slang_hash <- hash::hash(keys = slang, values = corrections)

  dplyr::mutate(df, {{ text_var }} := stringr::str_replace_all({{text_var}},
                                                                hash::values(slang_hash),
                                                                hash::keys(slang_hash)))
}


