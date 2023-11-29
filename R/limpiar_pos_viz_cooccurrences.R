#' Visualize Parts of Speech Co-occurrences within sentences
#'
#' @param annotated_df The output given from the limpiar_pos_annotate function as a data.frame object.
#' @param chosen_pos The chosen parts of speech the user wishes to visualise, tese can be either c("PROPN", "ADJ", "NOUN", "VERB").
#' @param n_occurrences How many different terms does the user wish to plot, the default is set to 40.
#'
#' @return A ggraph plot showing the connection between terms based on their occurrences within the same sentences.
#' @export
#'
#' @examples
#' limpiar_pos_viz_cooccurrences(annotated_df = output,
#' chosen_pos = c("PROPN", "ADJ"),
#' n_occurrences = 25)
limpiar_pos_viz_cooccurrences <- function(annotated_df,
                                          chosen_pos = c("PROPN", "ADJ", "NOUN", "VERB", "ADV"),
                                          n_occurrences = 40) {

  # calculate the co-occurrences in annotated dataset
  co_occurrences <- udpipe::cooccurrence(x = subset(annotated_df, upos %in% chosen_pos),
                                         term = "lemma",
                                         group = c("doc_id", "paragraph_id", "sentence_id"))

  # create the word network
  wordnetwork <- head(co_occurrences, n_occurrences)
  wordnetwork <- igraph::graph_from_data_frame(wordnetwork)

  # create the terms occurrences network
  network <- ggraph::ggraph(wordnetwork, layout = "fr") +
    ggraph::geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "pink") +
    ggraph::geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
    ggraph::theme_graph(base_family = "Arial Narrow") +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(title = "Co-occurrences within sentences")

  return(network)

}
