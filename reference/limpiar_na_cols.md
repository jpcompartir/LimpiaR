# Clean NA-heavy columns from a Data Frame or Tibble

Remove columns whose proportion of NAs is higher than determined
threshold. Setting threshold of 0.25 asks R to remove all columns with
25% or more NA values. Can be useful when dealing with large data
frames, where many columns are redundant.

## Usage

``` r
limpiar_na_cols(df, threshold)
```

## Arguments

- df:

  The Data Frame or Tibble object

- threshold:

  Threshold of non-NA entries a column must exceed to be retained.

## Value

Data Frame or Tibble with NA-heavy columns purged

## Examples

``` r
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

limpiar_examples %>% limpiar_na_cols(0.1)
#> # A tibble: 10 × 4
#>    doc_id author_name       mention_content                          mention_url
#>     <int> <chr>             <chr>                                    <chr>      
#>  1      1 don_quijote       "mi amigo sancho es un wn de vdd jajaja" www.twitte…
#>  2      2 sancho_panza      "RT mi amigo sancho es un wn de vdd jaj… www.twitte…
#>  3      3 edmond_dantes     "@don_quijote no digas eso, tu amigo es… www.twitte…
#>  4      4 el_sordo          "nos han metido en una muy dificil situ… www.fakebo…
#>  5      5 commander_miranda "nos han metido en una muy dificil situ… www.fakebo…
#>  6      6 robert_jordan     "   Lo q no tenemos es tiempo.   Mañana… www.youtub…
#>  7      7 anselmo           "a mi es muy grave quitarle la vida al … www.twitte…
#>  8      8 maria             "ayyy nooo @robert_jordan 😢 😢 😢 "     www.twitte…
#>  9      9 pablo             "todos se unen a nuestro grupo hagale u… www.instag…
#> 10     10 pilar             "a mi me gustaría quedarme un ratito má… www.instag…
```
