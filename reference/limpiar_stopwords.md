# Clean stop words for visualisations

The two lists - sentiment & topics, are very similar, in that most words
are in both lists. However, sentiment analysis is sensitive to negation,
so negation cues e.g. "no", "nada" etc. are not removed by the sentiment
list. For most purposes, topics are the go-to lists, but care is always
advised when removing stop words.

## Usage

``` r
limpiar_stopwords(data, text_var = mention_content, stop_words)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

- stop_words:

  "sentiment" or "topics" - sentiment retains negation cues

## Value

the text variable with stop words from specified list removed

## Details

stop word list is editable via data("sentiment_stops") or
data("topic_stops").

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

limpiar_examples %>% limpiar_stopwords(stop_words = "topics") %>%
dplyr::select(mention_content) %>% limpiar_spaces()
#> # A tibble: 10 × 1
#>    mention_content                              
#>    <chr>                                        
#>  1 amigo sancho wn vdd jajaja                   
#>  2 RT amigo sancho wn vdd jajaja                
#>  3 @don_quijote digas, amigo honorable # #sancho
#>  4 metido dificil situación                     
#>  5 metido dificil situación                     
#>  6 Lo q. Mañana debemos luchar.                 
#>  7 grave quitarle vida                          
#>  8 ayyy nooo @robert_jordan 😢 😢 😢            
#>  9 unen grupo hagale clic https::larebelion.    
#> 10 gustaría quedarme ratito más                 
```
