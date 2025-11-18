# Reverses (inverts) limpiar_link_click

Undoes the effects of the limpiar_link_click function, giving you the
original url variable back.

## Usage

``` r
limpiar_link_click_reverse(df, url_var)
```

## Arguments

- df:

  Data Farame or Tibble Object

- url_var:

  URL Column

## Value

Data frame with the url_var in original form

## Examples

``` r
df <- LimpiaR::limpiar_examples[1, ]

df <- df %>% limpiar_link_click(mention_url)
df %>% limpiar_link_click_reverse(mention_url)
#> # A tibble: 1 × 5
#>   doc_id author_name mention_content           mention_url platform_interactions
#>    <int> <chr>       <chr>                     <chr>       <lgl>                
#> 1      1 don_quijote mi amigo sancho es un wn… www.twitte… NA                   
```
