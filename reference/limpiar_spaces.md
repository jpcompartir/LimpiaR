# Clean redundant spaces

Remove excess spaces from the text variable.

## Usage

``` r
limpiar_spaces(df, text_var = mention_content)
```

## Arguments

- df:

  Name of the Data Frame or Tibble object

- text_var:

  Name of the text variable/character vector

## Value

text variable/character vector with excess spaces removed

## Examples

``` r
df <- data.frame(text_variable = "clean   the   spaces please")
limpiar_spaces(df, text_var = text_variable)
#>             text_variable
#> 1 clean the spaces please

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

limpiar_examples %>% limpiar_spaces() %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                    
#>    <chr>                                                              
#>  1 mi amigo sancho es un wn de vdd jajaja                             
#>  2 RT mi amigo sancho es un wn de vdd jajaja                          
#>  3 @don_quijote no digas eso, tu amigo es muy honorable #vamos #sancho
#>  4 nos han metido en una muy dificil situación                        
#>  5 nos han metido en una muy dificil situación                        
#>  6 Lo q no tenemos es tiempo. Mañana debemos luchar.                  
#>  7 a mi es muy grave quitarle la vida al otro                         
#>  8 ayyy nooo @robert_jordan 😢 😢 😢                                  
#>  9 todos se unen a nuestro grupo hagale un clic https::larebelion.es  
#> 10 a mi me gustaría quedarme un ratito más                            
```
