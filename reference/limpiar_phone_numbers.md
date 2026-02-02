# Clean phone numbers from text

Function creates a flag column for posts containing phone numbers.
Catches various phone number formats, i.e US, UK, European etc. By
default the function only replaces phone numbers in a recognised format.
Can also be set to be more aggressive and catch plain digit sequences
(7-15 digits). Can also be set to replace phone_numbers with a string.

## Usage

``` r
limpiar_phone_numbers(
  df,
  text_var = mention_content,
  aggressive = TRUE,
  tag = "None"
)
```

## Arguments

- df:

  Name of DataFrame or Tibble object

- text_var:

  Name of text variable/character vector

- aggressive:

  Bool: If TRUE, also catches plain digit sequences (7-15 digits)

- tag:

  String: Default = "None", if supplied replaces phone numbers with
  string

## Value

The DataFrame or Tibble object with phone number flag column

## Details

Matches:

- International: +1 555-123-4567, +44 20 1234 5678

- US/Canada: (555) 123-4567, 555-123-4567

- UK: 07951 902 146, 01786 475545

- European: 77 54 33 33

- Latin American: 4782-0699

- Local: 555-1234

Also matches when aggressive = TRUE:

- Plain digits: 07546104638, 1234567890

Avoids matching:

- 09:00-17:00

- 192.168.1.1

- \$1,234,567

- 1,000,000,000

- 1995-2025

## Examples

``` r
# Example data
phone_examples <- tibble::tibble(
  id = 1:5,
  text_var = c(
    "Call me at 555-123-4567 or (555) 123-4568",
    "WhatsApp +44 20 1234 5678",
    "Contact: 07506308688",
    "Meeting at 09:00-17:00, call 4782-0699",
    "I earned £100,000,000 between 1995-2025"
  )
)

# Default example
phone_examples %>% 
  limpiar_phone_numbers(text_var = text_var, aggressive = FALSE) %>% 
  dplyr::select(text_var)
#> # A tibble: 5 × 1
#>   text_var                                 
#>   <chr>                                    
#> 1 Call me at 555-123-4567 or (555) 123-4568
#> 2 WhatsApp +44 20 1234 5678                
#> 3 Contact: 07506308688                     
#> 4 Meeting at 09:00-17:00, call 4782-0699   
#> 5 I earned £100,000,000 between 1995-2025  

# More aggressive version, catching sequences of digits between 7-15 in length
phone_examples %>% 
  limpiar_phone_numbers(text_var = text_var, aggressive = TRUE) %>% 
  dplyr::select(text_var)
#> # A tibble: 5 × 1
#>   text_var                                 
#>   <chr>                                    
#> 1 Call me at 555-123-4567 or (555) 123-4568
#> 2 WhatsApp +44 20 1234 5678                
#> 3 Contact: 07506308688                     
#> 4 Meeting at 09:00-17:00, call 4782-0699   
#> 5 I earned £100,000,000 between 1995-2025  

# Filter out rows containing phone numbers
phone_examples %>% 
  limpiar_phone_numbers(text_var = text_var, aggressive = FALSE) %>% 
  dplyr::filter(phone_number_flag == FALSE) %>% 
  dplyr::select(id, text_var)
#> # A tibble: 2 × 2
#>      id text_var                               
#>   <int> <chr>                                  
#> 1     3 Contact: 07506308688                   
#> 2     5 I earned £100,000,000 between 1995-2025
```
