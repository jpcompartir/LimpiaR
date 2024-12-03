test_that("limpiar_recode_emojis recodes not removes", {

})

test_that("limpiar_remove_emojis input validation works", {
  df <- data.frame(text = c("Hello 👋", "World 🌍"))

  expect_error(limpiar_remove_emojis("not_a_df", "text"))
  expect_error(limpiar_remove_emojis(df, 123))


  expect_error(limpiar_remove_emojis(df, "missing_col"))
})

test_that("limpiar_remove_emojis preserves special characters", {
  input_df <- tibble::tribble(
    ~text,
    "café π μ",                    # Accents and Greek
    "München ist schön",           # German umlauts
    "русский язык",                # Russian
    "漢字とひらがな",                # Chinese and Japanese
    "Hello! @ # $ % ^",            # Punctuation
    "H₂O + CO₂",                   # Subscripts
    "→ ← + ÷ × ≠"                  # Math symbols
  )

  output_df <- limpiar_remove_emojis(input_df, text)

  # check we didn't remove stuff we didn't want to
  expect_equal(output_df$text[1], "café π μ")
  expect_equal(output_df$text[2], "München ist schön")
  expect_equal(output_df$text[3], "русский язык")
  expect_equal(output_df$text[4], "漢字とひらがな")
})

test_that("limpiar_remove_emojis removes all emoji types", {
  input_df <- tibble::tribble(
    ~text,
    "Hello 👋 World",
    "Family: 👨‍👩‍👧‍👦",
    "Coding 👨🏽‍💻",
    "Flags 🏳️‍🌈 🇺🇸",
    "Weather ☀️ ⛈️ ❄️"
  )

  # First verify emojis are present
  expect_match(input_df$text[1], "\U{1F44B}")  # Wave emoji
  expect_match(input_df$text[2], "👨‍👩‍👧‍👦")    # Family
  expect_match(input_df$text[3], "👨🏽‍💻")      # Professional with skin tone
  expect_match(input_df$text[4], "🏳️‍🌈")      # Pride flag
  expect_match(input_df$text[5], "[☀️⛈️❄️]")   # Weather symbols

  # Remove emojis
  output_df <- limpiar_remove_emojis(input_df, text)

  # Verify emojis are gone
  expect_false(any(grepl("\U{1F44B}", output_df$text[1])))
  expect_false(any(grepl("👨‍👩‍👧‍👦", output_df$text[2])))
  expect_false(any(grepl("👨🏽‍💻", output_df$text[3])))
  expect_false(any(grepl("🏳️‍🌈", output_df$text[4])))
  expect_false(any(grepl("[☀️⛈️❄️]", output_df$text[5])))

})
