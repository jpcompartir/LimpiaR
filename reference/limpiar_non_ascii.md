# Remove non-ASCII characters except those with latin accents

Function uses a simple RegEx to retain only basic ASCII characters plus
attempts to retain characters with latin accents. If you know that you
want to remove everything including accented characters then you should
use `limpiar_alphanumeric`.

## Usage

``` r
limpiar_non_ascii(data, text_var = mention_content)
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

limpiar_non_ascii(test_df, text)
#>                     text
#> 1        Simple text 123
#> 2  Hello! How are you?  
#> 3      café München niño
#> 4 #special@chars&(~)|[$]
#> 5                       
```
