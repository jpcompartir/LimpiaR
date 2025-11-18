# Wrap strings for visual ease

Useful for pre-processing a dataset in which you need to read many
documents, or scan over a lot of documents, e.g. when rendering an
interactive scatter plot and using plotly's hover, or when using
`DT::datatable(escape = FALSE)`.

## Usage

``` r
limpiar_wrap(
  data,
  text_var = mention_content,
  n = 15,
  newline_char = "<br><br>"
)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

- n:

  number of words

- newline_char:

  the specific delimiter to wrap the texts with

## Value

Data Frame with text variable edited in place

## Examples

``` r
limpiar_examples %>% limpiar_wrap(mention_content, n = 5, newline_char = "<br>")
#> # A tibble: 10 × 5
#>    doc_id author_name       mention_content    mention_url platform_interactions
#>     <int> <chr>             <chr>              <chr>       <lgl>                
#>  1      1 don_quijote       "mi amigo sancho … www.twitte… NA                   
#>  2      2 sancho_panza      "RT mi amigo sanc… www.twitte… NA                   
#>  3      3 edmond_dantes     "@don_quijote no … www.twitte… NA                   
#>  4      4 el_sordo          "nos han metido e… www.fakebo… NA                   
#>  5      5 commander_miranda "nos han metido e… www.fakebo… NA                   
#>  6      6 robert_jordan     " Lo q no tenemos… www.youtub… NA                   
#>  7      7 anselmo           "a mi es muy grav… www.twitte… NA                   
#>  8      8 maria             "ayyy nooo @rober… www.twitte… NA                   
#>  9      9 pablo             "todos se unen a … www.instag… NA                   
#> 10     10 pilar             "a mi me gustaría… www.instag… NA                   
```
