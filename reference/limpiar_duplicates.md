# Clean the text variable of duplicate posts

Removes duplicate posts, and posts which are deleted or protected by
APIs

## Usage

``` r
limpiar_duplicates(data, text_var = mention_content)
```

## Arguments

- data:

  Data Frame or Tibble object

- text_var:

  Name of the text variable/character vector

## Value

The Data Frame or Tibble object with duplicate posts removed from the
text variable

## Examples

``` r
df <- data.frame(text_variable = cbind(c(
"Deleted or protected mention", "hello", "goodbye", "goodbye")))
limpiar_duplicates(df, text_variable)
#>   text_variable
#> 1         hello
#> 2       goodbye

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


limpiar_examples %>% limpiar_duplicates()
#> # A tibble: 9 × 5
#>   doc_id author_name   mention_content         mention_url platform_interactions
#>    <int> <chr>         <chr>                   <chr>       <lgl>                
#> 1      1 don_quijote   "mi amigo sancho es un… www.twitte… NA                   
#> 2      2 sancho_panza  "RT mi amigo sancho es… www.twitte… NA                   
#> 3      3 edmond_dantes "@don_quijote no digas… www.twitte… NA                   
#> 4      4 el_sordo      "nos han metido en una… www.fakebo… NA                   
#> 5      6 robert_jordan "   Lo q no tenemos es… www.youtub… NA                   
#> 6      7 anselmo       "a mi es muy grave qui… www.twitte… NA                   
#> 7      8 maria         "ayyy nooo @robert_jor… www.twitte… NA                   
#> 8      9 pablo         "todos se unen a nuest… www.instag… NA                   
#> 9     10 pilar         "a mi me gustaría qued… www.instag… NA                   
```
