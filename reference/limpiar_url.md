# Clean URLs from the text variable

Removes the most common forms of URLs from the text variable

## Usage

``` r
limpiar_url(df, text_var = mention_content)
```

## Arguments

- df:

  Data Frame or Tibble Object

- text_var:

  Name of the text variable/character vector

## Value

Data Frame or Tibble object with URLs removed from the text variable

## Examples

``` r
limpiar_examples %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                      
#>    <chr>                                                                
#>  1 "mi amigo sancho es un wn de vdd jajaja"                             
#>  2 "RT mi amigo sancho es un wn de vdd jajaja"                          
#>  3 "@don_quijote no digas eso, tu amigo es muy honorable #vamos #sancho"
#>  4 "nos han metido en una muy dificil situación"                        
#>  5 "nos han metido en una muy dificil situación"                        
#>  6 "   Lo q no tenemos es tiempo.   Mañana    debemos luchar.   "       
#>  7 "a mi es muy grave quitarle la vida al otro"                         
#>  8 "ayyy nooo @robert_jordan 😢 😢 😢 "                                 
#>  9 "todos se unen a nuestro grupo hagale un clic https::larebelion.es"  
#> 10 "a mi me gustaría quedarme un ratito más"                            

limpiar_examples %>% limpiar_url() %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                      
#>    <chr>                                                                
#>  1 "mi amigo sancho es un wn de vdd jajaja"                             
#>  2 "RT mi amigo sancho es un wn de vdd jajaja"                          
#>  3 "@don_quijote no digas eso, tu amigo es muy honorable #vamos #sancho"
#>  4 "nos han metido en una muy dificil situación"                        
#>  5 "nos han metido en una muy dificil situación"                        
#>  6 "   Lo q no tenemos es tiempo.   Mañana    debemos luchar.   "       
#>  7 "a mi es muy grave quitarle la vida al otro"                         
#>  8 "ayyy nooo @robert_jordan 😢 😢 😢 "                                 
#>  9 "todos se unen a nuestro grupo hagale un clic "                      
#> 10 "a mi me gustaría quedarme un ratito más"                            
```
