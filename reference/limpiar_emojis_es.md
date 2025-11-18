# Replace emojis with a Spanish textual description

Spanish version of limpiar_emojis function. Main usage is for
pre-processing the text variable as part of Deep Learning pipeline. The
most important argument is whether or not to add the emoji tag, which
will also print in snake case.

## Usage

``` r
limpiar_emojis_es(df, text_var = mention_content, with_emoji_tag = FALSE)
```

## Arguments

- df:

  Name of Data Frame or Tibble Object

- text_var:

  Name of text variable

- with_emoji_tag:

  Whether to replace with snakecase linked words or not

## Value

The Data Frame or Tibble object with most emojis cleaned from the text
variable

## Examples

``` r
limpiar_examples %>% limpiar_emojis_es() %>% dplyr::select(mention_content)
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
#>  8 ayyy nooo @robert_jordan cara llorosa cara llorosa cara llorosa    
#>  9 todos se unen a nuestro grupo hagale un clic https::larebelion.es  
#> 10 a mi me gustaría quedarme un ratito más                            
```
