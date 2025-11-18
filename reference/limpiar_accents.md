# Clean accented characters

Useful for reducing overall number of tokens. Warning: removing accents
results in loss of information, so should be done with care.

## Usage

``` r
limpiar_accents(df, text_var = mention_content)
```

## Arguments

- df:

  Name of Data Frame or Tibble object

- text_var:

  Name of text variable/character vector

## Value

Data Frame or Tibble object with accents in the text variable replaced

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
limpiar_examples %>% limpiar_accents() %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                      
#>    <chr>                                                                
#>  1 "mi amigo sancho es un wn de vdd jajaja"                             
#>  2 "RT mi amigo sancho es un wn de vdd jajaja"                          
#>  3 "@don_quijote no digas eso, tu amigo es muy honorable #vamos #sancho"
#>  4 "nos han metido en una muy dificil situacion"                        
#>  5 "nos han metido en una muy dificil situacion"                        
#>  6 "   Lo q no tenemos es tiempo.   Manyana    debemos luchar.   "      
#>  7 "a mi es muy grave quitarle la vida al otro"                         
#>  8 "ayyy nooo @robert_jordan 😢 😢 😢 "                                 
#>  9 "todos se unen a nuestro grupo hagale un clic https::larebelion.es"  
#> 10 "a mi me gustaria quedarme un ratito mas"                            

```
