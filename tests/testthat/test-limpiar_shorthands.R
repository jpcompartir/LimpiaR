test_that("Shorthands are altered", {

  test_df <- data.frame(mention_content =
                          c("tqm bebe, xq no me quieras?",
                            "eres un wn jajajaja!",
                            "pk no me amas de vdd?"))
  solution_df <- data.frame(mention_content =
                              c("te quiero mucho bebe, porque no me quieras?",
                                "eres un wuevon jajajaja!",
                                "porque no me amas de verdad?"))
  expect_equal(test_df %>% limpiar_shorthands(),
                                  solution_df)
})



