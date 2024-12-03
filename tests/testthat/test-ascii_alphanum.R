test_that("limpiar_alphanumeric keeps only numbers, letters, spaces", {
  test_df <- data.frame(
    text = c(
      "Simple text 123",                          # Basic ASCII only
      "Hello! How are you? 😊 🌟",                # ASCII + punctuation + emojis
      "café München niño",                        # Latin-1 accented characters
      "#special@chars&(~)|[$]",                   # Special characters and symbols
      "混合汉字と日本語 → ⌘ £€¥"                    # CJK characters + symbols + arrows
    )
  )

  alpha_num <- test_df %>% limpiar_alphanumeric(text)
  expect_equal(sum(stringr::str_detect(test_df$text, "[^a-zA-Z0-9\\s]")), 4) # only row 1 matches our pattern
  expect_false(all(stringr::str_detect(alpha_num$text, "[^a-zA-Z0-9\\s]"))) # only alpha numeric left
})

test_that("limpiar_non_ascii keeps latin accents", {

  # get a test df from an LLM then write tests yourself.
  test_df <- data.frame(
    text = c(
      "Simple text 123",                          # Basic ASCII only
      "Hello! How are you? 😊 🌟",                # ASCII + punctuation + emojis
      "café München niño",                        # Latin-1 accented characters
      "#special@chars&(~)|[$]",                   # Special characters and symbols
      "混合汉字と日本語 → ⌘ £€¥"                    # CJK characters + symbols + arrows
    )
  )
  non_ascii <- limpiar_non_ascii(test_df, text)

  expect_true(non_ascii[1, 1] == test_df[1, 1]) # nothing removed
  expect_false(non_ascii[2, 1] == test_df[2, 1]) # emojis are removed
  expect_true(non_ascii[3, 1] == test_df[3, 1]) # accents not removed
  expect_true(non_ascii[4, 1] == test_df[4, 1]) # punctuation not removed
  expect_false(non_ascii[5, 1] == test_df[5, 1]) # non-english chars and specials are removed

})

test_that("limpiar_non_ascii and limpiar_alphanumeric are meaningfully different", {

  test_df <- data.frame(
    text = c(
      "Simple text 123",                          # Basic ASCII only
      "Hello! How are you? 😊 🌟",                # ASCII + punctuation + emojis
      "café München niño",                        # Latin-1 accented characters
      "#special@chars&(~)|[$]",                   # Special characters and symbols
      "混合汉字と日本語 → ⌘ £€¥"                    # CJK characters + symbols + arrows
    )
  )

  non_ascii <- limpiar_non_ascii(test_df, text)
  alphanum <- limpiar_alphanumeric(test_df, text)

  expect_equal(non_ascii[1,1], alphanum[1, 1]) # same when they should be

  # different when they should be:
  expect_true(stringr::str_detect(non_ascii[3, 1], "é"))
  expect_false(stringr::str_detect(alphanum[3, 1], "é"))

  # deals with punctuation predictably:
  expect_true(stringr::str_detect(non_ascii[2, 1], "!"))
  expect_false(stringr::str_detect(alphanum[2, 1], "!"))

})
