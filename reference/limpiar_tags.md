# Clean user handles and hashtags

Function replaces user handles and hashtags with neutral tags. You can
choose whether to replace both hashtags & users or either one.

## Usage

``` r
limpiar_tags(df, text_var = mention_content, user = TRUE, hashtag = TRUE)
```

## Arguments

- df:

  Name of Data Frame or Tibble object

- text_var:

  Name of text variable/character vector

- user:

  Whether to replace user handles or not TRUE = replace

- hashtag:

  Whether to replace hashtags or not TRUE = replace

## Value

The Data Frame or Tibble object with user handles and/or hashtags
removed from the text variable

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

#Both user and hashtags
limpiar_examples %>% limpiar_tags() %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                    
#>    <chr>                                                              
#>  1 "mi amigo sancho es un wn de vdd jajaja"                           
#>  2 "RT mi amigo sancho es un wn de vdd jajaja"                        
#>  3 "@user no digas eso, tu amigo es muy honorable hashtag hashtag"    
#>  4 "nos han metido en una muy dificil situación"                      
#>  5 "nos han metido en una muy dificil situación"                      
#>  6 "   Lo q no tenemos es tiempo.   Mañana    debemos luchar.   "     
#>  7 "a mi es muy grave quitarle la vida al otro"                       
#>  8 "ayyy nooo @user 😢 😢 😢 "                                        
#>  9 "todos se unen a nuestro grupo hagale un clic https::larebelion.es"
#> 10 "a mi me gustaría quedarme un ratito más"                          

#Just user tags
limpiar_examples %>% limpiar_tags(hashtag = FALSE) %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                    
#>    <chr>                                                              
#>  1 "mi amigo sancho es un wn de vdd jajaja"                           
#>  2 "RT mi amigo sancho es un wn de vdd jajaja"                        
#>  3 "@user no digas eso, tu amigo es muy honorable #vamos #sancho"     
#>  4 "nos han metido en una muy dificil situación"                      
#>  5 "nos han metido en una muy dificil situación"                      
#>  6 "   Lo q no tenemos es tiempo.   Mañana    debemos luchar.   "     
#>  7 "a mi es muy grave quitarle la vida al otro"                       
#>  8 "ayyy nooo @user 😢 😢 😢 "                                        
#>  9 "todos se unen a nuestro grupo hagale un clic https::larebelion.es"
#> 10 "a mi me gustaría quedarme un ratito más"                          

#Just hashtags
limpiar_examples %>% limpiar_tags(user = FALSE) %>% dplyr::select(mention_content)
#> # A tibble: 10 × 1
#>    mention_content                                                       
#>    <chr>                                                                 
#>  1 "mi amigo sancho es un wn de vdd jajaja"                              
#>  2 "RT mi amigo sancho es un wn de vdd jajaja"                           
#>  3 "@don_quijote no digas eso, tu amigo es muy honorable hashtag hashtag"
#>  4 "nos han metido en una muy dificil situación"                         
#>  5 "nos han metido en una muy dificil situación"                         
#>  6 "   Lo q no tenemos es tiempo.   Mañana    debemos luchar.   "        
#>  7 "a mi es muy grave quitarle la vida al otro"                          
#>  8 "ayyy nooo @robert_jordan 😢 😢 😢 "                                  
#>  9 "todos se unen a nuestro grupo hagale un clic https::larebelion.es"   
#> 10 "a mi me gustaría quedarme un ratito más"                             
```
