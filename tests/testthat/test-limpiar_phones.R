input_example_1 <- tibble::tibble(
   id = 1:5,
   text_var = c(
     "Call me at 555-123-4567 or (555) 123-4568",
     "WhatsApp +44 20 1234 5678",
     "Contact: 07506308688",
     "Meeting at 09:00-17:00, call 4782-0699",
     "I earned £100,000,000 between 1995-2025")
)

output_example_1a <- tibble::tibble(
   id = 1:5,
   text_var = c(
     "Call me at phone_number or phone_number",
     "WhatsApp phone_number",
     "Contact: 07506308688",
     "Meeting at 09:00-17:00, call phone_number",
     "I earned £100,000,000 between 1995-2025"),
   phone_number_flag = c(
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE
   )
)

output_example_1b <- tibble::tibble(
   id = 1:5,
   text_var = c(
     "Call me at phone_number or phone_number",
     "WhatsApp phone_number",
     "Contact: phone_number",
     "Meeting at 09:00-17:00, call phone_number",
     "I earned £100,000,000 between 1995-2025"),
   phone_number_flag = c(
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    FALSE
   )
)

output_example_1c <- tibble::tibble(
   id = 1:5,
   text_var = c(
     "Call me at 555-123-4567 or (555) 123-4568",
     "WhatsApp +44 20 1234 5678",
     "Contact: 07506308688",
     "Meeting at 09:00-17:00, call 4782-0699",
     "I earned £100,000,000 between 1995-2025"),
   phone_number_flag = c(
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE
   )
)

output_example_1d <- tibble::tibble(
   id = 1:5,
   text_var = c(
     "Call me at 555-123-4567 or (555) 123-4568",
     "WhatsApp +44 20 1234 5678",
     "Contact: 07506308688",
     "Meeting at 09:00-17:00, call 4782-0699",
     "I earned £100,000,000 between 1995-2025"),
   phone_number_flag = c(
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    FALSE
   )
)

# Tests
test_that("Example test", {
  # test example behaviour
  output <- limpiar_phone_numbers(
    input_example_1,
    text_var = text_var,
    aggressive = FALSE,
    tag = "phone_number"
  );
  expect_equal(output, output_example_1a);
})

test_that("Agressive test", {
  # test aggressive works as expected
  output <- limpiar_phone_numbers(
    input_example_1,
    text_var = text_var,
    aggressive = TRUE,
    tag = "phone_number"
  );
  
  # Test that the result is the correct value
  expect_equal(output, output_example_1b);
})

test_that("No tag test", {
  # Test that no-tag behaviour is expected
  output <- limpiar_phone_numbers(
    input_example_1,
    text_var = text_var
  );
  expect_equal(output, output_example_1d);
})

test_that("Data input test", {
  # Test that data exists
  expect_error(limpiar_phone_numbers(
    "string",
    text_var = text_var,
    aggressive = FALSE,
    tag = "phone_number"
  ), regexp = "'df' must be a data.frame or tibble, but got type: character");
})

test_that("text_var input test", {
  # Test that text_var exists as a column
  expect_error(limpiar_phone_numbers(
    input_example_1,
    text_var = "not_a_column",
    aggressive = FALSE,
    tag = "phone_number"
  ), regexp = "object 'not_a_column' not found");
})

test_that("Agressive input test", {
  # Test that aggressive must be a bool
  expect_error(limpiar_phone_numbers(
    input_example_1,
    text_var = text_var,
    aggressive = "string",
    tag = "phone_number"
  ), regexp = "Parameter 'aggressive' must be logical");
})

test_that("text input as string test", {
  # test example behaviour
  output <- limpiar_phone_numbers(
    input_example_1,
    text_var = "text_var",
    aggressive = FALSE,
    tag = "phone_number"
  );
  expect_equal(output, output_example_1a);
})