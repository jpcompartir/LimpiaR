test_that("Stop words are removed from the text variable", {

  data <- data.frame(sentences = c("Me llamo Kike, vivo en la ciudad de Madrid",
                                   "buenos dias Kike, un gusto conocerle!",
                                   "this sentence should not be edited"))
  data %>%
    limpiar_spaces(text_var = sentences)
  solution_df <- data.frame(sentences = c("Me llamo Kike, vivo ciudad Madrid",
                                          "buenos Kike, gusto conocerle!",
                                          "this sentence should not be edited"))

  expect_equal(data %>%
                 dplyr::mutate(sentences = limpiar_stopwords(text_var = sentences, stop_words = "sentiment"))%>%
                 limpiar_spaces(text_var = sentences),
               solution_df)
})
