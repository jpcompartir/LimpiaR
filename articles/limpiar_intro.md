# Introduction to LimpiaR

## LimpiaR Overview

LimpiaR is a package built to expedite pre-processing and cleaning of
text data, with some handy functions in Spanish and R. To get started,
we’ll load few helpful libraries.

## Walkthrough

``` r
library(magrittr)
library(dplyr)
library(stringr)
library(LimpiaR)
```

LimpiaR’s functions begin with limpiar\_. Once the library has been
loaded, typing limpiar\_ in an Rstudio script or Rmarkdown code block,
will produce a drop down menu of all LimpiaR functions, which should
help you to find the name of the function you’re looking for - you can
then use tab to autocomplete the function. Once inside the function,
RStudio should give you a popover which shows the argument the function
expects. You can also type ‘control + space’ when your cursor is inside
the function’s brackets to force extra help.

``` r
data
#> # A tibble: 10 × 2
#>    Mention.Content                                                   Mention.Url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                       www.twitte…
#>  2 "  han visto este articulo!? Que horror! https://guardian.com/em… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
#>  4 "jajajajaja eres un wn!"                                          www.facebo…
#>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q?"                                                 www.youtub…
#>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instag…
#>  8 "grax ntonces q?"                                                 www.youtub…
#>  9 "grax ntonces q?"                                                 www.youtub…
#> 10 "grax ntonces q?"                                                 www.youtub…
```

#### Column Names

We created a data frame of posts and URLs. After loading libraries and
data, the first part of any workflow should be to clean the column
names, this makes using tab completion, and accessing column names much
faster (which in the long run = big productivity gains). For this, we’ll
use the janitor package. You can uncomment the code to install janitor
if it is not already installed on your machine.

``` r
# ifelse(!"janitor" %in% installed.packages(),
#    install.packages("janitor"), library(janitor))

(data <- data %>% 
   janitor::clean_names())
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                       www.twitte…
#>  2 "  han visto este articulo!? Que horror! https://guardian.com/em… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
#>  4 "jajajajaja eres un wn!"                                          www.facebo…
#>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q?"                                                 www.youtub…
#>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instag…
#>  8 "grax ntonces q?"                                                 www.youtub…
#>  9 "grax ntonces q?"                                                 www.youtub…
#> 10 "grax ntonces q?"                                                 www.youtub…
```

### Lower Case Text Variable

For most workflows, the next step will be to make the text variable
lower case. We do this to make tokens like ‘AMAZING’ or ‘Amazing’ -\>
‘amazing’. You do not need a LimpiaR function for this, as the base R
function tolower() works just fine.

``` r
(data <- data %>%
  mutate(mention_content = tolower(mention_content)))
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                       www.twitte…
#>  2 "  han visto este articulo!? que horror! https://guardian.com/em… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
#>  4 "jajajajaja eres un wn!"                                          www.facebo…
#>  5 "rt dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q?"                                                 www.youtub…
#>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instag…
#>  8 "grax ntonces q?"                                                 www.youtub…
#>  9 "grax ntonces q?"                                                 www.youtub…
#> 10 "grax ntonces q?"                                                 www.youtub…
```

### Limpiar Functions

### limpiar_accents

Now we’re going to look at LimpiaR’s functions individually. The first
function is limpiar_accents, this will replace the accents most common
in Spanish words from the text variable, with their Latin-alphabet
equivalents e.g. ‘é -\> e’ . We will use the assignment operator to make
sure these changes are saved.

Tip: you can type ?limpiar_accents to access the documentation, and see
which arguments you need to fill in.

``` r
(data <- data %>%
  limpiar_accents(text_var = mention_content))
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa! coomo    estas @magdalena   ?!"                       www.twitte…
#>  2 "  han visto este articulo!? que horror! https://guardian.com/em… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
#>  4 "jajajajaja eres un wn!"                                          www.facebo…
#>  5 "rt dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q?"                                                 www.youtub…
#>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instag…
#>  8 "grax ntonces q?"                                                 www.youtub…
#>  9 "grax ntonces q?"                                                 www.youtub…
#> 10 "grax ntonces q?"                                                 www.youtub…
```

#### limpiar_duplicates

Now we’ll remove duplicate posts, notice that we don’t actually need to
type text_var = mention_content, because the default argument for
text_var is already mention_content.

``` r
(data <- data %>%
  limpiar_duplicates())
#> # A tibble: 7 × 2
#>   mention_content                                                    mention_url
#>   <chr>                                                              <chr>      
#> 1 "holaaaaaa! coomo    estas @magdalena   ?!"                        www.twitte…
#> 2 "  han visto este articulo!? que horror! https://guardian.com/emo… www.twitte…
#> 3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor"  www.facebo…
#> 4 "jajajajaja eres un wn!"                                           www.facebo…
#> 5 "rt dale un click a ver una mujer baila con su perro"              www.twitte…
#> 6 "grax ntonces q?"                                                  www.youtub…
#> 7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                     www.instag…
```

> Note: If the text column in our data frame were called ‘text’ we would
> have to specify text_var = text, or call:

``` r
data %>% rename(text = mention_content)
#> # A tibble: 7 × 2
#>   text                                                               mention_url
#>   <chr>                                                              <chr>      
#> 1 "holaaaaaa! coomo    estas @magdalena   ?!"                        www.twitte…
#> 2 "  han visto este articulo!? que horror! https://guardian.com/emo… www.twitte…
#> 3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor"  www.facebo…
#> 4 "jajajajaja eres un wn!"                                           www.facebo…
#> 5 "rt dale un click a ver una mujer baila con su perro"              www.twitte…
#> 6 "grax ntonces q?"                                                  www.youtub…
#> 7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                     www.instag…
```

#### limpiar_retweets

If you need to remove retweets, for example to create a bigram network,
limpiar has a function just for that.

``` r
(data <- data %>% 
   limpiar_retweets())
#> # A tibble: 6 × 2
#>   mention_content                                                    mention_url
#>   <chr>                                                              <chr>      
#> 1 "holaaaaaa! coomo    estas @magdalena   ?!"                        www.twitte…
#> 2 "  han visto este articulo!? que horror! https://guardian.com/emo… www.twitte…
#> 3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor"  www.facebo…
#> 4 "jajajajaja eres un wn!"                                           www.facebo…
#> 5 "grax ntonces q?"                                                  www.youtub…
#> 6 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                     www.instag…
```

#### limpiar_url

We generally don’t want URLs appearing in our charts or analyses, so we
can remove them with the limpiar_url function.

``` r
(data <- data %>%
   limpiar_url())
#> # A tibble: 6 × 2
#>   mention_content                                                   mention_url 
#>   <chr>                                                             <chr>       
#> 1 "holaaaaaa! coomo    estas @magdalena   ?!"                       www.twitter…
#> 2 "  han visto este articulo!? que horror!  no se puede!!"          www.twitter…
#> 3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.faceboo…
#> 4 "jajajajaja eres un wn!"                                          www.faceboo…
#> 5 "grax ntonces q?"                                                 www.youtube…
#> 6 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instagr…
```

#### limpiar_spaces

Next we’ll look at how to use LimpiaR to remove annoying white spaces,
like those at the beginning of a sentence, or between punctuation, or
multiple white spaces for no reason; as is common in the messy data we
often encounter.

``` r
(data <- data %>%
  limpiar_spaces())
#> # A tibble: 6 × 2
#>   mention_content                                               mention_url     
#>   <chr>                                                         <chr>           
#> 1 holaaaaaa! coomo estas @magdalena?!                           www.twitter.com…
#> 2 han visto este articulo!? que horror! no se puede!!           www.twitter.com…
#> 3 ayyyyyy a mi me gustaria ir a londres yaaa #llevame #porfavor www.facebook.co…
#> 4 jajajajaja eres un wn!                                        www.facebook.co…
#> 5 grax ntonces q?                                               www.youtube.com…
#> 6 yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣                   www.instagram.c…
```

#### limpiar_tags

We can also remove user handles (e.g. @magdalena) and hashtags with the
limpiar_tags function. Remember, you can type ?limpiar_tags to access
documentation.

Replace only hashtags:

``` r
data %>%
  limpiar_tags(user = FALSE, hashtag = TRUE)
#> # A tibble: 6 × 2
#>   mention_content                                            mention_url        
#>   <chr>                                                      <chr>              
#> 1 holaaaaaa! coomo estas @magdalena?!                        www.twitter.com/po…
#> 2 han visto este articulo!? que horror! no se puede!!        www.twitter.com/po…
#> 3 ayyyyyy a mi me gustaria ir a londres yaaa hashtag hashtag www.facebook.com/p…
#> 4 jajajajaja eres un wn!                                     www.facebook.com/p…
#> 5 grax ntonces q?                                            www.youtube.com/po…
#> 6 yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣                www.instagram.com/…
```

Replace only user tags:

``` r
data %>%
  limpiar_tags(user = TRUE, hashtag = FALSE)
#> # A tibble: 6 × 2
#>   mention_content                                               mention_url     
#>   <chr>                                                         <chr>           
#> 1 holaaaaaa! coomo estas @user?!                                www.twitter.com…
#> 2 han visto este articulo!? que horror! no se puede!!           www.twitter.com…
#> 3 ayyyyyy a mi me gustaria ir a londres yaaa #llevame #porfavor www.facebook.co…
#> 4 jajajajaja eres un wn!                                        www.facebook.co…
#> 5 grax ntonces q?                                               www.youtube.com…
#> 6 yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣                   www.instagram.c…
```

Replace both hashtags and user handles:

``` r
data %>%
  limpiar_tags()
#> # A tibble: 6 × 2
#>   mention_content                                            mention_url        
#>   <chr>                                                      <chr>              
#> 1 holaaaaaa! coomo estas @user?!                             www.twitter.com/po…
#> 2 han visto este articulo!? que horror! no se puede!!        www.twitter.com/po…
#> 3 ayyyyyy a mi me gustaria ir a londres yaaa hashtag hashtag www.facebook.com/p…
#> 4 jajajajaja eres un wn!                                     www.facebook.com/p…
#> 5 grax ntonces q?                                            www.youtube.com/po…
#> 6 yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣                www.instagram.com/…
```

#### Quick recap - we’ve looked at:

- cleaning column names with janitor::clean_names()
- making the text variable lower case with mutate() & tolower()
- cleaning accents with limpiar_accents()
- cleaning duplicate posts with limpiar_duplicates()
- cleaning retweets with limpiar_retweets()
- cleaning urls with limpiar_url()
- cleaning spaces with limpiar_spaces()
- cleaning user handles and hashtags with limpiar_tags()

#### limpiar_shorthands

One of the biggest problems with the messy data we encounter, are
shorthands. Generally, algorithms have been trained on clean, standard
language, so they do not encounter shorthands and abbreviations.
Shorthands also change all the time, making it impractical to
continuously train algorithms as new shorthands arise. This function
attempts to bridge that gap, by normalising the most common shorthands.

``` r
(data <- data %>%
   limpiar_shorthands())
#> # A tibble: 6 × 2
#>   mention_content                                               mention_url     
#>   <chr>                                                         <chr>           
#> 1 holaaaaaa! coomo estas @magdalena?!                           www.twitter.com…
#> 2 han visto este articulo!? que horror! no se puede!!           www.twitter.com…
#> 3 ayyyyyy a mi me gustaria ir a londres yaaa #llevame #porfavor www.facebook.co…
#> 4 jajajajaja eres un wuevon!                                    www.facebook.co…
#> 5 gracias entonces que?                                         www.youtube.com…
#> 6 yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣                   www.instagram.c…
```

#### limpiar_repeated_chars

We don’t want our algorithm to have to learn the difference between
‘ajajaj’ and ‘jaja’ or ‘ay’ and ‘ayyyy’ as practically speaking, there
is none. We also don’t want to introduce unnecessary tokens, so we
normalise the most common occurrences of repeated or additional
characters.

``` r
(data <- data %>%
   limpiar_repeat_chars())
#> # A tibble: 6 × 2
#>   mention_content                                        mention_url            
#>   <chr>                                                  <chr>                  
#> 1 hola! coomo estas @magdalena?!                         www.twitter.com/post1  
#> 2 han visto este articulo!? que horror! no se puede!!    www.twitter.com/post2  
#> 3 ay a mi me gustaria ir a londres ya #llevame #porfavor www.facebook.com/post1 
#> 4 jaja eres un wuevon!                                   www.facebook.com/post2 
#> 5 gracias entonces que?                                  www.youtube.com/post1  
#> 6 yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣            www.instagram.com/post1
```

Generally, the steps we’ve taken so far will be used in each and every
analysis/project to help clean the data. We will now look at some of the
more circumstantial functions, i.e. they will not be used in every
analysis.

#### Emojis

Emojis are a type of non-ASCII unicode character, which means that
removing all non-ASCII characters will remove emojis by force. It also
means that functions designed to target certain unicode characters by
patterns, may inadvertently remove other special characters - as well as
emojis, or instead of emojis!

##### limpiar_recode_emojis()

Why not juse a regular expression?

We scraped some lists of emojis which get the emojis directly for
replacement. This approach is more computationally expensive than
filtering out via RegEx, but it is often more precise as it targets the
emojis directly.

We don’t need to use limpiar_recode_emojis for every analysis, as many
ParseR & SegmentR functions ignore them implicitly. However, if we know
that we need to replace them with their text descriptios, we can can use
limpiar\_\_recode_emojis(). One problem with this, and the reason it is
for special cases only, is the emoji’s encodings are in English. We may,
at some point, translate them to Spanish, but it seems unlikely.

``` r
data %>%
  limpiar_recode_emojis(text_var = mention_content, with_emoji_tag = FALSE)
#> # A tibble: 6 × 2
#>   mention_content                                                    mention_url
#>   <chr>                                                              <chr>      
#> 1 hola! coomo estas @magdalena?!                                     www.twitte…
#> 2 han visto este articulo!? que horror! no se puede!!                www.twitte…
#> 3 ay a mi me gustaria ir a londres ya #llevame #porfavor             www.facebo…
#> 4 jaja eres un wuevon!                                               www.facebo…
#> 5 gracias entonces que?                                              www.youtub…
#> 6 yo soy el mejor face with tears of joy face with tears of joy fac… www.instag…
```

Or if we set `with_emoji_tag` to TRUE, our emojis are now pasted
together with ’\_’ and have an ’\_emoji’ label.

``` r
data %>%
  limpiar_recode_emojis(mention_content, with_emoji_tag = TRUE)
#> # A tibble: 6 × 2
#>   mention_content                                                    mention_url
#>   <chr>                                                              <chr>      
#> 1 hola! coomo estas @magdalena?!                                     www.twitte…
#> 2 han visto este articulo!? que horror! no se puede!!                www.twitte…
#> 3 ay a mi me gustaria ir a londres ya #llevame #porfavor             www.facebo…
#> 4 jaja eres un wuevon!                                               www.facebo…
#> 5 gracias entonces que?                                              www.youtub…
#> 6 yo soy el mejor face_with_tears_of_joy_emoji face_with_tears_of_j… www.instag…
```

> **Warning** the
> [`limpiar_recode_emojis()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_recode_emojis.md)
> function is quite slow and scales poorly with the size of inputs. So
> if using on a large dataset with many long documents expect functions
> to take a while to run.

##### limpiar_remove_emojis()

What about in situations where we don’t want to replace emojis with
their text inputs, **or** we don’t mind risking the loss of some other
non-ASCII characters, **or** we want something that runs fast?

Instead of `limpiar_recode_emojis` we can use `limpiar_remove_emojis`!
This function operates with a fairly simple RegEx pattern, meaning it
runs a lot more efficiently than its recode counterpart.

``` r
data %>%
  limpiar_remove_emojis(mention_content)
#> # A tibble: 6 × 2
#>   mention_content                                          mention_url          
#>   <chr>                                                    <chr>                
#> 1 "hola! coomo estas @magdalena?!"                         www.twitter.com/post1
#> 2 "han visto este articulo!? que horror! no se puede!!"    www.twitter.com/post2
#> 3 "ay a mi me gustaria ir a londres ya #llevame #porfavor" www.facebook.com/pos…
#> 4 "jaja eres un wuevon!"                                   www.facebook.com/pos…
#> 5 "gracias entonces que?"                                  www.youtube.com/post1
#> 6 "yo soy el mejor , no eres nada!! "                      www.instagram.com/po…
```

#### non-ASCII characters

ASCII (American Standard Code for Information Interchange) is a
character-encoding standard for representing numbers and text. There are
128 ASCII characters, including the letters from a-z in upper and
lowercase, numbers 0-9, common punctuation marks, and a few additional
characters with specific uses for computers. Everything else is
non-ASCII.

All 128 ASCII characters

| Dec | Hex | Char  | Description               |
|-----|:---:|:------|---------------------------|
| 000 | 00  | NUL   | Null                      |
| 001 | 01  | SOH   | Start of Heading          |
| 002 | 02  | STX   | Start of Text             |
| 003 | 03  | ETX   | End of Text               |
| 004 | 04  | EOT   | End of Transmission       |
| 005 | 05  | ENQ   | Enquiry                   |
| 006 | 06  | ACK   | Acknowledge               |
| 007 | 07  | BEL   | Bell                      |
| 008 | 08  | BS    | Backspace                 |
| 009 | 09  | HT    | Horizontal Tab            |
| 010 | 0A  | LF    | Line Feed                 |
| 011 | 0B  | VT    | Vertical Tab              |
| 012 | 0C  | FF    | Form Feed                 |
| 013 | 0D  | CR    | Carriage Return           |
| 014 | 0E  | SO    | Shift Out                 |
| 015 | 0F  | SI    | Shift In                  |
| 016 | 10  | DLE   | Data Link Escape          |
| 017 | 11  | DC1   | Device Control 1 (XON)    |
| 018 | 12  | DC2   | Device Control 2          |
| 019 | 13  | DC3   | Device Control 3 (XOFF)   |
| 020 | 14  | DC4   | Device Control 4          |
| 021 | 15  | NAK   | Negative Acknowledge      |
| 022 | 16  | SYN   | Synchronous Idle          |
| 023 | 17  | ETB   | End of Transmission Block |
| 024 | 18  | CAN   | Cancel                    |
| 025 | 19  | EM    | End of Medium             |
| 026 | 1A  | SUB   | Substitute                |
| 027 | 1B  | ESC   | Escape                    |
| 028 | 1C  | FS    | File Separator            |
| 029 | 1D  | GS    | Group Separator           |
| 030 | 1E  | RS    | Record Separator          |
| 031 | 1F  | US    | Unit Separator            |
| 032 | 20  | SPACE | Space                     |
| 033 | 21  | !     | Exclamation Mark          |
| 034 | 22  | ”     | Double Quote              |
| 035 | 23  | \#    | Number Sign               |
| 036 | 24  | \$    | Dollar Sign               |
| 037 | 25  | %     | Percent                   |
| 038 | 26  | &     | Ampersand                 |
| 039 | 27  | ’     | Single Quote              |
| 040 | 28  | (     | Left Parenthesis          |
| 041 | 29  | )     | Right Parenthesis         |
| 042 | 2A  | \*    | Asterisk                  |
| 043 | 2B  | \+    | Plus                      |
| 044 | 2C  | ,     | Comma                     |
| 045 | 2D  | \-    | Hyphen                    |
| 046 | 2E  | .     | Period                    |
| 047 | 2F  | /     | Forward Slash             |
| 048 | 30  | 0     | Zero                      |
| 049 | 31  | 1     | One                       |
| 050 | 32  | 2     | Two                       |
| 051 | 33  | 3     | Three                     |
| 052 | 34  | 4     | Four                      |
| 053 | 35  | 5     | Five                      |
| 054 | 36  | 6     | Six                       |
| 055 | 37  | 7     | Seven                     |
| 056 | 38  | 8     | Eight                     |
| 057 | 39  | 9     | Nine                      |
| 058 | 3A  | :     | Colon                     |
| 059 | 3B  | ;     | Semicolon                 |
| 060 | 3C  | \<    | Less Than                 |
| 061 | 3D  | =     | Equals                    |
| 062 | 3E  | \>    | Greater Than              |
| 063 | 3F  | ?     | Question Mark             |
| 064 | 40  | @     | At Sign                   |
| 065 | 41  | A     | Uppercase A               |
| 066 | 42  | B     | Uppercase B               |
| 067 | 43  | C     | Uppercase C               |
| 068 | 44  | D     | Uppercase D               |
| 069 | 45  | E     | Uppercase E               |
| 070 | 46  | F     | Uppercase F               |
| 071 | 47  | G     | Uppercase G               |
| 072 | 48  | H     | Uppercase H               |
| 073 | 49  | I     | Uppercase I               |
| 074 | 4A  | J     | Uppercase J               |
| 075 | 4B  | K     | Uppercase K               |
| 076 | 4C  | L     | Uppercase L               |
| 077 | 4D  | M     | Uppercase M               |
| 078 | 4E  | N     | Uppercase N               |
| 079 | 4F  | O     | Uppercase O               |
| 080 | 50  | P     | Uppercase P               |
| 081 | 51  | Q     | Uppercase Q               |
| 082 | 52  | R     | Uppercase R               |
| 083 | 53  | S     | Uppercase S               |
| 084 | 54  | T     | Uppercase T               |
| 085 | 55  | U     | Uppercase U               |
| 086 | 56  | V     | Uppercase V               |
| 087 | 57  | W     | Uppercase W               |
| 088 | 58  | X     | Uppercase X               |
| 089 | 59  | Y     | Uppercase Y               |
| 090 | 5A  | Z     | Uppercase Z               |
| 091 | 5B  | \[    | Left Bracket              |
| 092 | 5C  | \\    | Backslash                 |
| 093 | 5D  | \]    | Right Bracket             |
| 094 | 5E  | ^     | Caret                     |
| 095 | 5F  | \_    | Underscore                |
| 096 | 60  | \`    | Backtick                  |
| 097 | 61  | a     | Lowercase a               |
| 098 | 62  | b     | Lowercase b               |
| 099 | 63  | c     | Lowercase c               |
| 100 | 64  | d     | Lowercase d               |
| 101 | 65  | e     | Lowercase e               |
| 102 | 66  | f     | Lowercase f               |
| 103 | 67  | g     | Lowercase g               |
| 104 | 68  | h     | Lowercase h               |
| 105 | 69  | i     | Lowercase i               |
| 106 | 6A  | j     | Lowercase j               |
| 107 | 6B  | k     | Lowercase k               |
| 108 | 6C  | l     | Lowercase l               |
| 109 | 6D  | m     | Lowercase m               |
| 110 | 6E  | n     | Lowercase n               |
| 111 | 6F  | o     | Lowercase o               |
| 112 | 70  | p     | Lowercase p               |
| 113 | 71  | q     | Lowercase q               |
| 114 | 72  | r     | Lowercase r               |
| 115 | 73  | s     | Lowercase s               |
| 116 | 74  | t     | Lowercase t               |
| 117 | 75  | u     | Lowercase u               |
| 118 | 76  | v     | Lowercase v               |
| 119 | 77  | w     | Lowercase w               |
| 120 | 78  | x     | Lowercase x               |
| 121 | 79  | y     | Lowercase y               |
| 122 | 7A  | z     | Lowercase z               |
| 123 | 7B  | {     | Left Brace                |
| 124 | 7C  | \|    | Vertical Bar              |
| 125 | 7D  | }     | Right Brace               |
| 126 | 7E  | ~     | Tilde                     |
| 127 | 7F  | DEL   | Delete                    |

For our purposes we have extended the ASCII characters to include Latin
accents (é, í, etc.), let’s get our original data frame back to
demonstrate. We should remove things like emojis, but keep our
punctuation and accented characters:

    #> # A tibble: 10 × 2
    #>    mention_content                                                   mention_url
    #>    <chr>                                                             <chr>      
    #>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                       www.twitte…
    #>  2 "  han visto este articulo!? Que horror! https://guardian.com/em… www.twitte…
    #>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
    #>  4 "jajajajaja eres un wn!"                                          www.facebo…
    #>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
    #>  6 "grax ntonces q?"                                                 www.youtub…
    #>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instag…
    #>  8 "grax ntonces q?"                                                 www.youtub…
    #>  9 "grax ntonces q?"                                                 www.youtub…
    #> 10 "grax ntonces q?"                                                 www.youtub…

``` r
data %>%
  limpiar_non_ascii(mention_content)
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                       www.twitte…
#>  2 "  han visto este articulo!? Que horror! https://guardian.com/em… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
#>  4 "jajajajaja eres un wn!"                                          www.facebo…
#>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q?"                                                 www.youtub…
#>  7 "yo soy el mejor , no eres nada!!  "                              www.instag…
#>  8 "grax ntonces q?"                                                 www.youtub…
#>  9 "grax ntonces q?"                                                 www.youtub…
#> 10 "grax ntonces q?"                                                 www.youtub…
```

#### limpiar_alphanumeric

Similar to non-ASCII characters, we can retain only the alphanumeric
characters (a-zA-Z0-9 + spaces). This is a heavy-duty option which
*will* remove all accented characters.

``` r
data %>%
  limpiar_alphanumeric(mention_content)
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa cmo    ests magdalena   "                              www.twitte…
#>  2 "  han visto este articulo Que horror httpsguardiancomemojisbann… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa llevame porfavor"   www.facebo…
#>  4 "jajajajaja eres un wn"                                           www.facebo…
#>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q"                                                  www.youtub…
#>  7 "yo soy el mejor  no eres nada  "                                 www.instag…
#>  8 "grax ntonces q"                                                  www.youtub…
#>  9 "grax ntonces q"                                                  www.youtub…
#> 10 "grax ntonces q"                                                  www.youtub…
```

If we want to use `limpiar_alphanumeric` **and retain** our accented
characters, then we should recode the accents first with
`limpiar_accents`:

``` r
data %>%
  limpiar_accents(mention_content) %>%
  limpiar_alphanumeric(mention_content)
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa coomo    estas magdalena   "                           www.twitte…
#>  2 "  han visto este articulo Que horror httpsguardiancomemojisbann… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa llevame porfavor"   www.facebo…
#>  4 "jajajajaja eres un wn"                                           www.facebo…
#>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q"                                                  www.youtub…
#>  7 "yo soy el mejor  no eres nada  "                                 www.instag…
#>  8 "grax ntonces q"                                                  www.youtub…
#>  9 "grax ntonces q"                                                  www.youtub…
#> 10 "grax ntonces q"                                                  www.youtub…
```

> You’ll need to make an informed choice between `limpiar_alphanumeric`,
> `limpiar_non_ascii` and other functions like `limpiar_accents` and
> `limpiar_*_emojis`

#### limpiar_stopwords

Stop words are common words that do not provide us with much information
as to an utterance’s meaning. For example, in the sentence: ‘the man is
in prison for theft’, if we knew only one word from this sentence, and
that word was ‘is’, ‘in’, ‘the’, or ‘for’ then we wouldn’t have much
idea what the sentence is about. However, ‘prison’ or ‘theft’, would
give us a lot more information.

For many analyses, we remove stop words to help us see the ‘highest
information’ words, to get a high-level understanding of large bodies of
texts (such as in topic modelling and bigram networks.) For virtually
all scenarios, you will want to use the limpiar_stopwords() with the
argument stop_words = “topics” like so:

``` r
data %>%
  limpiar_stopwords(stop_words = "topics") %>%
  limpiar_spaces() #to clear the spaces of words that were removed
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 holaaaaaa! cóómo estás @magdalena?!                               www.twitte…
#>  2 visto articulo!? Que horror! https://guardian.com/emojisbanned N… www.twitte…
#>  3 ayyyyyy gustaria londres yaaa #llevame #porfavor                  www.facebo…
#>  4 jajajajaja wn!                                                    www.facebo…
#>  5 RT dale click mujer baila perro                                   www.twitte…
#>  6 grax ntonces q?                                                   www.youtub…
#>  7 😂😂😂,!! 🤣🤣                                                    www.instag…
#>  8 grax ntonces q?                                                   www.youtub…
#>  9 grax ntonces q?                                                   www.youtub…
#> 10 grax ntonces q?                                                   www.youtub…
```

However, sometimes we want to keep words that would usually be treated
as stopwords for a specific purpose. For example, when we’re analysing
sentiment ‘negatives’ can invert the sentiment of a text - ‘no me gusta’
vs ‘me gusta’. If we remove all instances of ‘no’ from our data, we will
do a worse job at analysing sentiment. For Spanish we have a slightly
shorter list of stopwords for sentiment than topics, where we have
removed a few choice terms.

``` r
data %>%
  limpiar_stopwords(stop_words = "sentiment") %>%
  limpiar_spaces() 
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 holaaaaaa! cóómo estás @magdalena?!                               www.twitte…
#>  2 visto articulo!? Que horror! https://guardian.com/emojisbanned N… www.twitte…
#>  3 ayyyyyy gustaria londres yaaa #llevame #porfavor                  www.facebo…
#>  4 jajajajaja wn!                                                    www.facebo…
#>  5 RT dale click mujer baila perro                                   www.twitte…
#>  6 grax ntonces q?                                                   www.youtub…
#>  7 mejor 😂😂😂, no nada!! 🤣🤣                                      www.instag…
#>  8 grax ntonces q?                                                   www.youtub…
#>  9 grax ntonces q?                                                   www.youtub…
#> 10 grax ntonces q?                                                   www.youtub…
```

Warning - sentences can look quite strange without stopwords, and a lot
of social posts are virtually meaningless altogether!

> It’s also worth pointing out, that a lot of information can be lost
> when removing stop words. Many phrases in English and Spanish have
> very different meanings when a stop word is removed, and some
> stopwords lists contain negatives, which can drastically change the
> meaning of a sentence! So use with care.

### Utility Functions

We are nearly at the end of this introduction to LimpiaR, but before we
finish, let’s look at two utility functions which may be useful. We’ve
conjoured up a new data frame called df, which we will use to show the
last two functions and how to chain everything together.

``` r
df
#> # A tibble: 10 × 3
#>    mention_content                                            mention_url na_col
#>    <chr>                                                      <chr>       <chr> 
#>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                www.twitte… NA    
#>  2 "  han visto este articulo!? Que horror! https://guardian… www.twitte… NA    
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #p… www.facebo… NA    
#>  4 "jajajajaja eres un wn!"                                   www.facebo… NA    
#>  5 "RT dale un click a ver una mujer baila con su perro"      www.twitte… NA    
#>  6 "grax ntonces q?"                                          www.youtub… NA    
#>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "             www.instag… NA    
#>  8 "grax ntonces q?"                                          www.youtub… NA    
#>  9 "grax ntonces q?"                                          www.youtub… tadaa 
#> 10 "grax ntonces q?"                                          www.youtub… NA
```

#### limpiar_inpsect

So, imagine that we see a strange pattern, and we want to check what’s
going on with that specific pattern. We can use limpiar_inspect to view
all posts which contain that pattern in an interactive frame!

``` r
limpiar_inspect(df, 
                pattern = "ntonces", 
                text_var = mention_content,
                url_var = mention_url,
                title = "ntonces")
```

| mention_content | mention_url           |
|:----------------|:----------------------|
| grax ntonces q? | www.youtube.com/post1 |
| grax ntonces q? | www.youtube.com/post2 |
| grax ntonces q? | www.youtube.com/post3 |
| grax ntonces q? | www.youtube.com/post4 |

Whilst it’s pretty obvious that all of the ‘grax ntonces q?’ posts are
exactly the same, in the real world we’re going to have 10,000 times as
many posts, and searching for suspicious patterns may take up a lot of
our time.

#### limpiar_na_cols

This final function is useful when we want to remove ‘mostly NA’ columns
of a data frame. We may want to do this to save memory, for example if
we have 400,000 posts and 80 columns. In this case we’ll get rid of all
columns for which 25% or more of their values are NA.

``` r
limpiar_na_cols(df,threshold =  0.25)
#> # A tibble: 10 × 2
#>    mention_content                                                   mention_url
#>    <chr>                                                             <chr>      
#>  1 "holaaaaaa! cóómo    estás @magdalena   ?!"                       www.twitte…
#>  2 "  han visto este articulo!? Que horror! https://guardian.com/em… www.twitte…
#>  3 "ayyyyyy a mi me   gustaria ir a londres yaaa #llevame #porfavor" www.facebo…
#>  4 "jajajajaja eres un wn!"                                          www.facebo…
#>  5 "RT dale un click a ver una mujer baila con su perro"             www.twitte…
#>  6 "grax ntonces q?"                                                 www.youtub…
#>  7 "yo soy el mejor 😂😂😂, no eres nada!! 🤣🤣 "                    www.instag…
#>  8 "grax ntonces q?"                                                 www.youtub…
#>  9 "grax ntonces q?"                                                 www.youtub…
#> 10 "grax ntonces q?"                                                 www.youtub…
```

### Putting It All Together

To speed things up, we **could** call the functions together in one big
long pipe.

``` r
df %>%
  limpiar_na_cols(threshold = 0.25)%>%
  limpiar_accents()%>%
  limpiar_retweets()%>%
  limpiar_shorthands()%>%
  limpiar_repeat_chars()%>%
  limpiar_url()%>%
  limpiar_remove_emojis()%>%
  limpiar_shorthands()%>%
  limpiar_spaces()%>%
  limpiar_duplicates()
#> # A tibble: 6 × 2
#>   mention_content                                        mention_url            
#>   <chr>                                                  <chr>                  
#> 1 hola! coomo estas @magdalena?!                         www.twitter.com/post1  
#> 2 han visto este articulo!? Que horror! NO SE PUEDE!!    www.twitter.com/post2  
#> 3 ay a mi me gustaria ir a londres ya #llevame #porfavor www.facebook.com/post1 
#> 4 jaja eres un wuevon!                                   www.facebook.com/post2 
#> 5 gracias entonces que?                                  www.youtube.com/post1  
#> 6 yo soy el mejor, no eres nada!!                        www.instagram.com/post1
```

However, we generally want to check what the effects of our
transformations are on our data, so doing a lot of operations like this
without any intermediate checks is risky.
