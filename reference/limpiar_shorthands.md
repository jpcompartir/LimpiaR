# Clean shorthands and abbreviations

Replaces common Spanish shorthands and abbreviations with their longer
form equivalents. Choose whether to link the replacements with snake
case or not, with spaces_as_underscores. Useful primarily for
normalising text ahead of sentiment classification.

## Usage

``` r
limpiar_shorthands(
  df,
  text_var = mention_content,
  spaces_as_underscores = FALSE
)
```

## Arguments

- df:

  Name of Data Frame or Tibble object

- text_var:

  Name of text variable/character vector

- spaces_as_underscores:

  Whether multi-word corrections e.g. 'te quiero mucho' should have
  spaces or underscores. Default = FALSE

## Value

The text variable with shorthands replaced

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

limpiar_examples %>% limpiar_shorthands() %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                      
#>    <chr>                                                                
#>  1 "mi amigo sancho es un wuevon de verdad jajaja"                      
#>  2 "RT mi amigo sancho es un wuevon de verdad jajaja"                   
#>  3 "@don_quijote no digas eso, tu amigo es muy honorable #vamos #sancho"
#>  4 "nos han metido en una muy dificil situación"                        
#>  5 "nos han metido en una muy dificil situación"                        
#>  6 "   Lo que no tenemos es tiempo.   Mañana    debemos luchar.   "     
#>  7 "a mi es muy grave quitarle la vida al otro"                         
#>  8 "ayyy nooo @robert_jordan 😢 😢 😢 "                                 
#>  9 "todos se unen a nuestro grupo hagale un clic https::larebelion.es"  
#> 10 "a mi me gustaría quedarme un ratito más"                            
```
