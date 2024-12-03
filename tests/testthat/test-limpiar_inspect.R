test_that("Inspect errors quickly if inputs aren't right", {

  expect_error(limpiar_inspect("hello", "h"),
               stringr::fixed("is.data.frame"))

  expect_error(limpiar_inspect("hello"),
               stringr::fixed("pattern"))

  test_data <- data.frame(text = "hello")
  expect_error(limpiar_inspect(test_data, text_var = text, "h"), stringr::fixed("mention_url"))

  })

test_that("Inspect handles regex patterns and is case-sensitive, plus open_view argument works",{

  test_df <- tibble(
    mention_content = c(
      "This is a test post about cats",
      "Looking for #dogs in the park",
      "No hashtags here",
      "Multiple cats and #dogs",
      "Post about #CATS (case test)",
      "Special characters #cats!?",
      "Empty content",
      "cats at the beginning",
      "At the end cats",
      "catch up"
    ),
    mention_url = c(
      "url1.com",
      "url2.com",
      "url3.com",
      "url4.com",
      "url5.com",
      "url6.com",
      "url7.com",
      "url8.com",
      "url9.com",
      "url10.com"
    )
  )

  # Check normal pattern works
  normal <- limpiar_inspect(test_df, "cat", open_view = FALSE)
  expect_equal(nrow(normal), 7)

  # Check that boundary regex are workin g for pattern
  boundary <- limpiar_inspect(test_df, "\\bcats\\b", open_view = FALSE)
  expect_equal(nrow(boundary), 6)

  # Check that case toggle is working
  case_sens <- limpiar_inspect(test_df, "cat", ignore_case = FALSE, open_view = FALSE)
  expect_equal(nrow(case_sens), 6)

  })


