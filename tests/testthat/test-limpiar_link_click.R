test_that("limpiar_link_click correctly creates a clickable link ", {
  df <- LimpiaR::limpiar_examples
  df <- df[1:10, ]

  # Doesn't have the link clickable already
  expect_true(all(!stringr::str_detect(df$mention_url, "^<a href=")))

  # Creates a clickable link
  df <- df %>%
    limpiar_link_click(mention_url)

  expect_true(all(stringr::str_detect(df$mention_url, "^<a href=")))

  # Doesn't create a clickable link if it already exists
  expect_message(df %>%
                   limpiar_link_click(mention_url),
                 "url_var already detected as a clickable link, returning input data frame"
  )

})

test_that("limpiar_link_click_reverse correctly removes a clickable link ", {
  df <- LimpiaR::limpiar_examples
  df <- df[1:10, ]

  # Doesn't have the link clickable already
  expect_true(all(!stringr::str_detect(df$mention_url, "^<a href=")))

  # Creates a clickable link
  link_click <- df %>%
    limpiar_link_click(mention_url)

  expect_true(all(stringr::str_detect(link_click$mention_url, "^<a href=")))

  # Removes a clickable link (inverts)
  link_remove <- link_click %>%
    limpiar_link_click_reverse(mention_url)

  expect_true(all(!stringr::str_detect(link_remove$mention_url, "^<a href=")))

  #Confirm it properly inverts
  expect_true(all(link_remove$mention_url == df$mention_url))

  # Doesn't remove a clickable link if it doesn't exist
  expect_message(df %>%
                   limpiar_link_click_reverse(mention_url),
                 "url_var not detected as a clickable link, returning input data frame"
  )

})
