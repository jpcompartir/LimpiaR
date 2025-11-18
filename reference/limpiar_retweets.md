# Clean retweets from the text variable

Removes all posts with the 'rt' or 'RT' tag. Particularly effective when
used in conjunction with ParseR & SegmentR visualisations.

## Usage

``` r
limpiar_retweets(df, text_var = mention_content)
```

## Arguments

- df:

  Name of the Data Frame or Tibble Object

- text_var:

  Name of the text variable/character vector

## Examples

``` r
df <- data.frame(text_variable = cbind(c("rt <3", "RT <3", "original tweet")))
limpiar_retweets(df, text_variable)
#>    text_variable
#> 1 original tweet

limpiar_examples
#> # A tibble: 10 × 5
#>    doc_id author_name       mention_content    mention_url platform_interactions
#>     <int> <chr>             <chr>              <chr>       <lgl>                
#>  1      1 don_quijote       "mi amigo sancho … www.twitte… NA                   
#>  2      2 sancho_panza      "RT mi amigo sanc… www.twitte… NA                   
#>  3      3 edmond_dantes     "@don_quijote no … www.twitte… NA                   
#>  4      4 el_sordo          "nos han metido e… www.fakebo… NA                   
#>  5      5 commander_miranda "nos han metido e… www.fakebo… NA                   
#>  6      6 robert_jordan     "   Lo q no tenem… www.youtub… NA                   
#>  7      7 anselmo           "a mi es muy grav… www.twitte… NA                   
#>  8      8 maria             "ayyy nooo @rober… www.twitte… NA                   
#>  9      9 pablo             "todos se unen a … www.instag… NA                   
#> 10     10 pilar             "a mi me gustaría… www.instag… NA                   

limpiar_examples %>% limpiar_retweets()
#> # A tibble: 9 × 5
#>   doc_id author_name       mention_content     mention_url platform_interactions
#>    <int> <chr>             <chr>               <chr>       <lgl>                
#> 1      1 don_quijote       "mi amigo sancho e… www.twitte… NA                   
#> 2      3 edmond_dantes     "@don_quijote no d… www.twitte… NA                   
#> 3      4 el_sordo          "nos han metido en… www.fakebo… NA                   
#> 4      5 commander_miranda "nos han metido en… www.fakebo… NA                   
#> 5      6 robert_jordan     "   Lo q no tenemo… www.youtub… NA                   
#> 6      7 anselmo           "a mi es muy grave… www.twitte… NA                   
#> 7      8 maria             "ayyy nooo @robert… www.twitte… NA                   
#> 8      9 pablo             "todos se unen a n… www.instag… NA                   
#> 9     10 pilar             "a mi me gustaría … www.instag… NA                   
```
