test_that("Duplicate characters rare removed", {

  duplicate_df <- data.frame(text =
                               c("holaaaaa", "aaaaiiii nooooo!",
                                 "jaaaaaaaaa!!!","aaa huuuevooooo",
                                 "no me digaaaas!"))
  solution_df <- data.frame(text =
                              c("hola", "ai no!",
                                "ja!!!", "a huevo",
                                "no me digas!"))


  expect_equal(duplicate_df %>% limpiar_repeat_chars(text_var = text), solution_df)
})



test_that("Laughing patterns are normalised", {
  laughing_df <- data.frame(message =
                              c("jajajajaja", "aaajjajjaja",
                                "jjjajjajjaja", "lol omg jajjaaja",
                                "jejejeje lol!", "wow iiijijiji",
                                "just the same please"))
  solution_df <- data.frame(message =
                              c("jaja", "jaja",
                                "jaja", "lol omg jaja",
                                "jaja lol!", "wow jaja",
                                "just the same please"))
  expect_equal(laughing_df %>% limpiar_repeat_chars(text_var = message), solution_df)
})
