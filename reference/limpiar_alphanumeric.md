# Remove everything except letters, numbers, and spaces

A simple regex for retaining only a-z, A-Z and 0-9 as well as white
space characters, including new lines. This function *will* remove
accented characters, and any non-English characters, punctuation, etc.
so it is a heavy-duty approach to cleaning and should be used prudently.
If you know that you need to keep accents, try `limpiar_non_ascii`
first, before avoiding these functions altogether.

## Usage

``` r
limpiar_alphanumeric(data, text_var = mention_content)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

## Value

Data frame with the text variable changed in place

## Examples

``` r
test_df <- data.frame(
text = c(
  "Simple text 123",              # Basic ASCII only
  "Hello! How are you? 😊 🌟",    # ASCII + punctuation + emojis
  "café München niño",            # Latin-1 accented characters
  "#special@chars&(~)|[$]",       # Special characters and symbols
  "混合汉字と日本語 → ⌘ £€¥"      # CJK characters + symbols + arrows
)
)

limpiar_alphanumeric(test_df, text)
#>                  text
#> 1     Simple text 123
#> 2 Hello How are you  
#> 3      caf Mnchen nio
#> 4        specialchars
#> 5                    
```
