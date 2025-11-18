# Prepare a URL column to be clickable in Shiny/Data Table

Will allow you to click the hyperlink to load a URL, e.g. for selecting
an image.

## Usage

``` r
limpiar_link_click(df, url_var)
```

## Arguments

- df:

  Data Frame or Tibble Object

- url_var:

  URL Column

## Value

data frame with URL column edited to be clickable

## Details

Make sure that DataTable is rendered with the argument 'escape = FALSE'
or column will be all text.

The function now checks if your url_var was a clickable link, and if it
is then it won't add any new formatting.

## Examples

``` r
df <- LimpiaR::limpiar_examples[1, ]
df["mention_url"]
#> # A tibble: 1 × 1
#>   mention_url                   
#>   <chr>                         
#> 1 www.twitter.com/ejemplo/124864

df <- df %>% limpiar_link_click(mention_url)
df["mention_url"]
#> # A tibble: 1 × 1
#>   mention_url                                                              
#>   <chr>                                                                    
#> 1 <a href='www.twitter.com/ejemplo/124864' target='blank'>Click to View</a>
```
