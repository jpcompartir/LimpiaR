# Completely Remove *Most* Emojis from Text

uses a simple Regular Expression (RegEx) to clear most emojis from the
text variable. Attempts to handle emojis which are joined together -
like family emojis, and 'edited emojis' like those with skin tones etc.
set

## Usage

``` r
limpiar_remove_emojis(data, text_var = mention_content)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

## Value

Data Frame with the text variable cleaned in place

## Examples

``` r
 emojis <- data.frame(
 text = c("Hello 👋 World",
  "Family: 👨‍👩‍👧‍👦",
  "Coding 👨🏽‍💻",
  "Flags 🏳️‍🌈 🇺🇸",
  "Weather ☀️ ⛈️ ❄️")
)

emojis
#>               text
#> 1   Hello 👋 World
#> 2 Family: 👨‍👩‍👧‍👦
#> 3    Coding 👨🏽‍💻
#> 4     Flags 🏳️‍🌈 🇺🇸
#> 5    Weather ☀️ ⛈️ ❄️

# using limpiar_remove_emojis() to remove them entirely:
limpiar_remove_emojis(emojis, text)
#>           text
#> 1 Hello  World
#> 2     Family: ‍‍‍
#> 3      Coding ‍
#> 4      Flags ‍ 
#> 5   Weather   
```
