# Recode emojis with a textual description

Main usage is for pre-processing the text variable as part of Deep
Learning pipeline. The most important argument is whether or not to add
the emoji tag, which will also print in snake case.

## Usage

``` r
limpiar_recode_emojis(data, text_var = mention_content, with_emoji_tag = FALSE)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

- with_emoji_tag:

  Whether to replace with snakecase linked words or not

## Value

The Data Frame or Tibble object with most emojis cleaned from the text
variable

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

# Without tagging and combining:
limpiar_recode_emojis(emojis, text)
#>                                                     text
#> 1                                Hello waving hand World
#> 2                          Family: man ‍ woman ‍ girl ‍ boy
#> 3                                   Coding man 🏽‍ laptop
#> 4          Flags white flag ️‍ rainbow flag: United States
#> 5 Weather sun ️ cloud with lightning and rain ️ snowflake ️

# With tagging and combining:
limpiar_recode_emojis(emojis, text, TRUE)
#>                                                                       text
#> 1                                            Hello waving_hand_emoji World
#> 2                    Family: man_emoji ‍ woman_emoji ‍ girl_emoji ‍ boy_emoji
#> 3                                         Coding man_emoji 🏽‍ laptop_emoji
#> 4          Flags white_flag_emoji ️‍ rainbow_emoji flag:_United_States_emoji
#> 5 Weather sun_emoji ️ cloud_with_lightning_and_rain_emoji ️ snowflake_emoji ️

# using limpiar_remove_emojis() to remove them entirely:
limpiar_remove_emojis(emojis, text)
#>           text
#> 1 Hello  World
#> 2     Family: ‍‍‍
#> 3      Coding ‍
#> 4      Flags ‍ 
#> 5   Weather   
```
