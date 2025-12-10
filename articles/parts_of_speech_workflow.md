# LimpiaR - Parts of Speech Workflow

We want to take a document (or later a set of documents) like:

> Who was the first person on the moon?

And extract for each token (where in this case token = word) in the
document its part of speech and its lemma. So that for each document we
have a table like:

| token | lemma | pos_tag |
|:------|:------|:--------|
| Who   | who   | PRON    |
| was   | be    | AUX     |
| the   | the   | DET     |
| first | first | ADJ     |
| man   | man   | NOUN    |
| on    | on    | ADP     |
| the   | the   | DET     |
| moon  | moon  | NOUN    |
| ?     | ?     | PUNCT   |

In this vignette we’ll be looking at how to use LimpiaR via {udpipe} to
achieve this. For a primer on parts of speech see [Parts of Speech
Wikipedia](https://en.wikipedia.org/wiki/Part_of_speech).

For all UPOS Tags use the following table as a reference:

| Part of Speech            | UPOS Tag | Definition                                                                                                                                                                                               |
|:--------------------------|:---------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Adjective                 | ADJ      | Usually describes or modifies a noun. It provides information about an object’s size, color, shape, etc. Example: “big”, “blue”.                                                                         |
| Adposition                | ADP      | Class of words that includes prepositions and postpositions, used to express spatial or temporal relations or mark various semantic roles. Example: “in”, “on”, “before”, “after”.                       |
| Adverb                    | ADV      | Modifies a verb, an adjective, another adverb, or even an entire sentence. It provides information about manner, time, place, frequency, degree, etc. Example: “quickly”, “very”.                        |
| Auxiliary                 | AUX      | Special verb used to add functional or grammatical meaning to the clause in which it appears. It accompanies the main verb and forms different aspects, voices, or moods. Example: “is”, “have”, “will”. |
| Coordinating Conjunction  | CCONJ    | Joins words, phrases, or clauses of similar grammatical status and syntactic importance. Example: “and”, “but”, “or”.                                                                                    |
| Determiner                | DET      | Introduces a noun and provides context in terms of definiteness, where it belongs in a sequence, quantity, or ownership. Example: “a”, “the”, “this”, “those”.                                           |
| Interjection              | INTJ     | An abrupt remark, made apart from the main sentence structure, often used to express strong emotion or surprise. Example: “Oh!”, “Wow!”, “Ugh!”.                                                         |
| Noun                      | NOUN     | Represents a person, place, thing, or idea. Nouns can be subjects, objects, or complement in a sentence. Example: “dog”, “city”, “happiness”.                                                            |
| Numeral                   | NUM      | A word, symbol, or group of words representing a number. Example: “one”, “first”, “100”.                                                                                                                 |
| Particle                  | PART     | A function word that does not fit into the other categories but is used to express grammatical relationships with other words or to specify the attitude of the speaker. Example: “up” in “stand up”.    |
| Pronoun                   | PRON     | Replaces a noun, often used to avoid repetition. Pronouns can do most things that nouns can do. Example: “he”, “they”, “who”.                                                                            |
| Proper Noun               | PROPN    | Names a specific person, place, thing, or idea and is typically capitalized. Example: “Elizabeth”, “London”, “Microsoft”.                                                                                |
| Punctuation               | PUNCT    | Symbols that organize writing into clauses, phrases, and sentences, clarify meaning, and indicate pauses. Example: “.”, “,”, “!”.                                                                        |
| Subordinating Conjunction | SCONJ    | Introduces a subordinate clause and indicates the relationship between the subordinate clause and the rest of the sentence. Example: “because”, “although”, “when”.                                      |
| Symbol                    | SYM      | A mark or character used as a conventional representation of an object, function, or process. Example: “\$”, “%”, “&”.                                                                                   |
| Verb                      | VERB     | Expresses an action, occurrence, or state of being. Verbs are central to a clause. Example: “run”, “be”, “have”.                                                                                         |
| Other                     | X        | A category used for words or tokens that do not fit into the above categories. This is less common and often used in tagging to mark anomalies or unclassifiable items.                                  |

Source: universaldependencies.org/u/pos

## Workflow

The main motivation for processing and extracting parts of speech is to
home in on the particular aspects of language which are most informative
for answering a given research question. For example, if you want to
know what people think about something, you might focus on adjectives
and nouns because adjectives describe things, and nouns are things. If
you want to know how people are using something, you might focus more on
verbs/phrasal verbs as they are ‘doing words’.

### Loading packages

``` r
library(LimpiaR)
library(tibble)
library(dplyr)
library(stringr)
```

### Getting started

LimpiaR’s PoS workflow leans on pre-existing functionality of the
{udpipe} package to allow users to import a pre-trained model for parts
of speech analysis whilst enabling advanced users to perform ‘dependency
parsing’.

What is dependency parsing?

“a technique which provides to each word in a sentence the link to
another word in the sentence, which is called its syntactical head. This
link between each 2 words furthermore has a certain type of relationship
giving you further details about it”

see
[here](https://www.r-bloggers.com/2019/07/dependency-parsing-with-udpipe/)
for more info.

### Importing a udpipe model

First, we import the model we want to use. UDPipe pre-trained models are
built upon Universal Dependencies treebanks and are made available for
more than 65 languages based on 101 treebanks. For demonstrative
purposes we’ll use `language = "english"`.

``` r
model <- limpiar_pos_import_model(language = "english")
```

### Example data

Now that we have our model imported into our session, let’s get some
data to tag, tokenise, lemmatise, and extract parts of speech. We need a
data frame with both a text variable and an ID column which uniquely
identifies each text.

``` r
(
data <-tibble(text = tolower(stringr::sentences[1:100]),
                      universal_message_id = paste0("TWITTER", 1:100))
)
```

    ## # A tibble: 100 × 2
    ##    text                                        universal_message_id
    ##    <chr>                                       <chr>               
    ##  1 the birch canoe slid on the smooth planks.  TWITTER1            
    ##  2 glue the sheet to the dark blue background. TWITTER2            
    ##  3 it's easy to tell the depth of a well.      TWITTER3            
    ##  4 these days a chicken leg is a rare dish.    TWITTER4            
    ##  5 rice is often served in round bowls.        TWITTER5            
    ##  6 the juice of lemons makes fine punch.       TWITTER6            
    ##  7 the box was thrown beside the parked truck. TWITTER7            
    ##  8 the hogs were fed chopped corn and garbage. TWITTER8            
    ##  9 four hours of steady work faced us.         TWITTER9            
    ## 10 a large size in stockings is hard to sell.  TWITTER10           
    ## # ℹ 90 more rows

So now we have some data and we also have our desired model loaded into
session, the function we need next is
[`limpiar_pos_annotate()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pos_annotate.md).

Before we begin, it’s important to note that our output will be
sensitive to cleaning steps. For example, it is possible that with the
removal of punctuation, PoS Tagging may under-perform. This could also
be said for the POS tagging process as nouns(NOUN) and
proper-nouns(PROPN) will be harder to differentiate if punctuation is
removed as well as all text being lowercase.

So be careful when pre-processing your text variable if you’re intending
to follow the PoS workflow.

### Extracting parts of speech

The`limpiar_pos_annotate` function converts the text of each document
into its tokens, lemmas, POS tags, and dependency relationships\*. The
input data frame should have one document per row, the return data frame
will have one row per token. This means the return data frame will have
many more rows than the input data frame!

dependency_parse default value

\*the `dependency_parse` argument is set to `FALSE` by default as this
step can be costly in time and compute if performed on large data sets.
Most users will get by just fine without parsing dependencies, but if
you are sure you need them set this argument to `TRUE`.

`limpiar_pos_annotate` can be sped up by using `in_parallel = TRUE`,
this argument makes the function process multiple rows of the data frame
in parallel.

Running the function in parallel prevents the progress from being
updated.

By default the function will print its progress every 100 rows, this way
you know that it’s still working and roughly how long it should take to
finish running. If you don’t want the progress updates to print in your
console set `update_progress = 0`.

``` r
# annotate texts and perform dependency parsing
annotations <- limpiar_pos_annotate(data = data, text_var = text, id_var = universal_message_id, pos_model = model, dependency_parse = TRUE, in_parallel = FALSE, update_progress = 25)
```

    ## 2025-12-10 12:30:44.503284 Annotating text fragment 1/100
    ## 2025-12-10 12:30:44.667172 Annotating text fragment 26/100
    ## 2025-12-10 12:30:44.807189 Annotating text fragment 51/100
    ## 2025-12-10 12:30:44.96691 Annotating text fragment 76/100

Now that we have our texts tokenized, dependencies parsed, and POS
annotations are complete, let’s take a look at the output. After
annotating we have 882 rows, which is an 8.82x increase!

``` r
annotations %>%
  select(-c(sentence, feats, xpos, doc_id)) %>%
  relocate(universal_message_id)
```

    ## # A tibble: 882 × 9
    ##    universal_message_id paragraph_id sentence_id token_id token  lemma  pos_tag
    ##    <chr>                       <int>       <int> <chr>    <chr>  <chr>  <chr>  
    ##  1 TWITTER1                        1           1 1        the    the    DET    
    ##  2 TWITTER1                        1           1 2        birch  birch  NOUN   
    ##  3 TWITTER1                        1           1 3        canoe  canoe  NOUN   
    ##  4 TWITTER1                        1           1 4        slid   slid   NOUN   
    ##  5 TWITTER1                        1           1 5        on     on     ADP    
    ##  6 TWITTER1                        1           1 6        the    the    DET    
    ##  7 TWITTER1                        1           1 7        smooth smooth ADJ    
    ##  8 TWITTER1                        1           1 8        planks plank  NOUN   
    ##  9 TWITTER1                        1           1 9        .      .      PUNCT  
    ## 10 TWITTER2                        1           1 1        glue   glue   VERB   
    ## # ℹ 872 more rows
    ## # ℹ 2 more variables: head_token_id <chr>, dependency_tag <chr>

Output has some additional columns, we will pay closest attention to
paragraph_id, sentence_id, token, lemma, pos_tag, dependency_tag.

What are these new columns?

`paragraph_id` and `sentence_id` tell us which of the document’s
paragraphs, and which sentence the token is in. Because our data set
contains only single sentences, all of these values are 1.

`token` is the word the rest of the columns refer to.

`lemma` is the [lemmatised](https://en.wikipedia.org/wiki/Lemmatization)
version of the token, an example of lemmatisation is ‘served’ being
converted to ‘serve’.

`pos_tag` displays PoS labels such as; Noun(NOUN), Proper Noun(PROPN),
Pronoun(PRON), Verb(VERB), Adjective(ADJ) etc. For more on the exact
tags and what they mean see [PoS
Tags](https://universaldependencies.org/u/pos/index.html) or the UPOS
tags table at the top of this document.

`dependency_tag` displays the dependency relation for each token.
Dependency relations are significantly more complicated than parts of
speech. see [Dependency
Relations](https://universaldependencies.org/u/dep/) for more details.

`head_token_id`, `dependency_tag` and `feats` will only be present if we
select `dependency_parse = TRUE`, they tell us the id of the token
(inside the document, paragraph, sentence) which the token of that row
has the dependency relation to, the dependency relation and additional
features of the relationship

Finally, the column you inserted as `id_var =`. This variable will help
you to join the results back to your original data frame.

### Manipulating the output

Now that we have adequate context, let’s look at what we can do with our
output.

We can combine commonly-used {dplyr} functions for data wrangling and
summarisation to filter for certain parts of speech and count their
occurrences.

Given the size of our data set there are limited inferences we can make
from the counts, but if we just want to know which adjectives are seen
most frequently:

``` r
# Count adjectives
annotations %>% 
  filter(pos_tag %in% c("ADJ")) %>%
  count(token, pos_tag, sort = TRUE)
```

    ## # A tibble: 65 × 3
    ##    token pos_tag     n
    ##    <chr> <chr>   <int>
    ##  1 blue  ADJ         3
    ##  2 clear ADJ         3
    ##  3 third ADJ         3
    ##  4 large ADJ         2
    ##  5 more  ADJ         2
    ##  6 sharp ADJ         2
    ##  7 small ADJ         2
    ##  8 wide  ADJ         2
    ##  9 young ADJ         2
    ## 10 bent  ADJ         1
    ## # ℹ 55 more rows

Alternatively we could do the same thing for nouns, but this time count
the lemma (in case of plurals).

``` r
#Count the lemma of each noun
annotations %>% 
  filter(pos_tag %in% c("NOUN")) %>% # this time selecting nouns
  count(lemma, sort = TRUE)
```

    ## # A tibble: 214 × 2
    ##    lemma     n
    ##    <chr> <int>
    ##  1 fence     3
    ##  2 week      3
    ##  3 air       2
    ##  4 boy       2
    ##  5 cat       2
    ##  6 coat      2
    ##  7 day       2
    ##  8 fish      2
    ##  9 girl      2
    ## 10 grass     2
    ## # ℹ 204 more rows

#### Adjective - Noun collocations

Are there any adjective -\> noun pairs seen more than once? This task
gets slightly more involved as we need to look at the value of each
token and the value in the next row, so first we need
[`dplyr::filter`](https://dplyr.tidyverse.org/reference/filter.html) and
[`dplyr::lag`](https://dplyr.tidyverse.org/reference/lead-lag.html) +
[`dplyr::lead`](https://dplyr.tidyverse.org/reference/lead-lag.html),
and to group by the doc_id, paragraph_id and sentence_id.

``` r
adj_to_noun <- annotations %>% 
  filter(
    pos_tag == "ADJ" & lead(pos_tag) == "NOUN" | pos_tag == "NOUN" & lag(pos_tag) == "ADJ", .by = c(doc_id, paragraph_id, sentence_id))
```

Then we’ll need to perform some more {dplyr} magic to count the ADJ-NOUN
collocations. The data is now set up so that row 1+2, 3+4, 4+5 and so on
and so forth are ADJ-NOUN collocations, we can use this information to
extract the pairs with a combination of floor division, exploiting how
cumsum meshes with logicals in R, and a ‘grouped, summarise paste with a
flourish of collapse’ trick.

``` r
adj_to_noun %>%
  mutate(collocation_id = row_number() %% 2, .before = 1) %>% 
  mutate(collocation_id = cumsum(collocation_id == 1)) %>%
  summarise(collocation = paste0(token, collapse = " "), .by = collocation_id) %>%
  count(collocation, sort = TRUE)
```

    ## # A tibble: 56 × 2
    ##    collocation         n
    ##    <chr>           <int>
    ##  1 third week          2
    ##  2 bent hook           1
    ##  3 big task            1
    ##  4 blue air            1
    ##  5 blue background     1
    ##  6 blue fish           1
    ##  7 clear response      1
    ##  8 clear spring        1
    ##  9 clear water         1
    ## 10 cloud hung          1
    ## # ℹ 46 more rows

The only ADJ-NOUN collocation seen more than once was ‘third week’. In a
larger data set we would expect to find more and higher-frequency
ADJ-NOUN collocations.

However, when manipulating the data this way, the onus is on the user to
know and understand what transformations should be created.

#### Repairing the sentence

For this next example we’re going to convert all pos_tag == ADJ and
pos_tag == “NOUN” to their lemma, and stitch the sentences back together
so that they’re ready for visualisations. We’ll make use of case_when
and the now-familiar grouped summarise paste trick. If we group by
universal_message_id we’ll get back a 100 row data frame which we can
join back to our original data frame.

``` r
annotations <- annotations %>%
  mutate(token =
           case_when(pos_tag == "ADJ" ~ lemma,
                     pos_tag == "NOUN" ~ lemma,
                     TRUE ~ lemma)) %>%
  select(token, universal_message_id) %>%
  summarise(sentence = paste0(token, collapse = " "), 
            .by = universal_message_id)
```

Once we have the information regarding the co-occurrences of nouns and
adjectives within our documents, we are able to evidence what entities
appear throughout our data, as well as the type of language used in
conjunction with and toward them. We can later add to this, by
visualizing the frequency of terms appearing within the same document as
well as those that are explicitly used one after another, just like the
example above, where we see ‘hot sun’ appear as most frequent.

## Other languages - Spanish

The workflow for Spanish is very similar to English. We’ll select
language = “spanish” and then we’ll take a look at the output for a
Spanish document. We’ll take a paragraph from El Pais and store it in a
data frame named ‘spanish’

> “Hace muchos años, cuando llegó a La Habana, encontró el mejor acto de
> amor —el estudio de la escritura, que es aún mejor que el estudio de
> la vida— por parte de la joven Yalenis Velazco, quien dedicó un
> intenso ensayo a su obra.”

``` r
spanish_model <- limpiar_pos_import_model("spanish") # Load the model 

spanish <- spanish %>%
  limpiar_pos_annotate(text, id, spanish_model, udpate_progress = 0) # Extract Pos Tags  
```

    ## 2025-12-10 12:30:47.955884 Annotating text fragment 1/1

``` r
spanish %>%
  select(token, lemma, pos_tag) # Select relevant columns
```

    ## # A tibble: 49 × 3
    ##    token  lemma  pos_tag
    ##    <chr>  <chr>  <chr>  
    ##  1 Hace   hacer  VERB   
    ##  2 muchos mucho  DET    
    ##  3 años   año    NOUN   
    ##  4 ,      ,      PUNCT  
    ##  5 cuando cuando SCONJ  
    ##  6 llegó  llegar VERB   
    ##  7 a      a      ADP    
    ##  8 La     el     DET    
    ##  9 Habana habana PROPN  
    ## 10 ,      ,      PUNCT  
    ## # ℹ 39 more rows

We see immediately that ‘hace’ a conjugation of the verb ‘hacer’ is
converted to hacer, muchos -\> mucho, años -\> año. These changes would
generally be agreeable, they’ll help us to reduce the overall number of
words in our data set, and our text-based visualisations should be
cleaner. However, it is *always* a good idea to carefully consider the
effects of any transformation you perform on data, rather than doing it
blindly.

We can convert all verbs to lemma and stitch the document back together
using the same tricks as we did for English:

``` r
spanish %>%
  mutate(
    token = ifelse(pos_tag == "VERB", lemma, token)
  ) %>%
  summarise(.by = id,
            text = paste0(token, collapse = " "))
```

    ## # A tibble: 1 × 2
    ##      id text                                                                    
    ##   <dbl> <chr>                                                                   
    ## 1     1 hacer muchos años , cuando llegar a La Habana , encontrar el mejor acto…

Clearly the sentence is now ungrammatical, but for a topic modelling
workflow or some n-gram networks, the data will be cleaner and the
counts will better reflect the real frequencies for each verb.

No models are 100% correct, so we expect to see the occasional false
output. This is particularly true when it comes to languages other than
English which tend to have less training data, and be more grammatically
complex.
