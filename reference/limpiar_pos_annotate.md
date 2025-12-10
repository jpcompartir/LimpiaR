# Annotate Texts for Parts of Speech Analysis using udpipe models.

Take a data frame with a text and id variable and extract its parts of
speech using udpipe models which we import for a specific language with
`limpiar_pos_import_model`. This function will annotate the data frame
according to the language of the imported model.

## Usage

``` r
limpiar_pos_annotate(
  data,
  text_var,
  id_var,
  pos_model,
  ...,
  in_parallel = FALSE,
  dependency_parse = FALSE,
  update_progress = 100
)
```

## Arguments

- data:

  The data.frame or tibble object containing any texts that the user
  wishes to conduct parts of speech analysis on.

- text_var:

  Any texts or sentences the user wishes to perform the parts of speech
  annotations on.

- id_var:

  Unique identifier for each document. No default supplied. recommended
  to use 'universal_message_id' if using a social listening export.

- pos_model:

  A UDPipe model imported using `limpiar_pos_import_model` - must be of
  class 'udpipe_model'.

- ...:

  To enable the user to supply any additional arguments to
  udpipe::udpipe.

- in_parallel:

  A logical argument allowing the user to initiate parallel processing
  to speed the annotate function up. If set to TRUE, the function will
  select the number of available cores minus one, processing more
  efficiently(faster), leaving one core to manage other computations.
  The default is FALSE.

- dependency_parse:

  Whether to perform dependency parsing on tokens. The default is set to
  FALSE because parsing dependencies takes considerable time and they
  are not always needed.

- update_progress:

  The user has the option to state how often they would like a progress
  report of the annotation process, posted in the console by stating
  whether they want a message every 100, 500 or 1000 documents. This is
  useful when annotating large sets of data and serves as a sanity check
  to ensure the session hasn't used up all available memory and the
  annotations have stopped running.

## Value

Returns a data frame with documents broken up into both a token and
sentence level, in addition to the existing variables present in `data`
supplied to the function. The returned object contains the parts of
speech annotations in CONLL-U formatting, where each row is an
annotation of a word. To find out more on the formatting methods, read
[here](https://universaldependencies.org/format.html). The additional
arguments with tagged POS information are as follows:

- paragraph_id: The identifier indicating the paragraph the annotated
  token is derived from.

- sentence_id: Similar to paragraph_id but at a sentence level.

- sentence: The sentence the annotated token is derived from.

- token_id: Token index, integer starting at 1 for each new sentence.
  May be a range for multiword tokens or a decimal number for empty
  nodes.

- token: The token(or word) being annotated for parts of speech.

- lemma: The lemmatized version of the annotated token.

- pos_tag: The universal parts of speech tag of the token.
  [Here](https://universaldependencies.org/format.html) for more
  information.

- xpos: The treebank-specific parts of speech tag of the token.

- feats: The morphological features of the token, used for dependency
  parsing visualisations,.

- head_token_id: Indicating what is the token id of the head of the
  token, indicating to which other token in the sentence it is related.

- dependency_tag: The information regarding dependency parsing of
  tokens, displaying the type of relation the token has with the
  head_token_id. [Here](https://universaldependencies.org/format.html)
  for more information.

## Details

The leg work is done by udpipe. We have implemented it into LimpiaR
because:

1.  Taking data as its first argument allows it to integrate with
    Tidyerse workflows (it makes the function pipe-able)

2.  We want the mental model to be as consistent as possible, i.e. when
    using LimpiaR in the pre-processing pipeline the user mainly calls
    LimpiaR, and doesn't have to remember another package.

There are many potential workflows so we won't try to enumerate them
here. However, as clear use-cases emerge we will create new
limpiar_pos\_ functions on a case-by-case basis. An example workflow
would be to convert all adjectives and nouns to lemma and then visualise
the results.

## Examples

``` r
data <- dplyr::tibble(text = tolower(stringr::sentences[1:100]),
document = 1:100)
model <- LimpiaR::limpiar_pos_import_model(language = "english")
#> Downloading udpipe model from https://raw.githubusercontent.com/jwijffels/udpipe.models.ud.2.5/master/inst/udpipe-ud-2.5-191206/english-ewt-ud-2.5-191206.udpipe to /home/runner/work/_temp/Library/LimpiaR/model_cache/english-ewt-ud-2.5-191206.udpipe
#>  - This model has been trained on version 2.5 of data from https://universaldependencies.org
#>  - The model is distributed under the CC-BY-SA-NC license: https://creativecommons.org/licenses/by-nc-sa/4.0
#>  - Visit https://github.com/jwijffels/udpipe.models.ud.2.5 for model license details.
#>  - For a list of all models and their licenses (most models you can download with this package have either a CC-BY-SA or a CC-BY-SA-NC license) read the documentation at ?udpipe_download_model. For building your own models: visit the documentation by typing vignette('udpipe-train', package = 'udpipe')
#> Downloading finished, model stored at '/home/runner/work/_temp/Library/LimpiaR/model_cache/english-ewt-ud-2.5-191206.udpipe'
annotations <- limpiar_pos_annotate(data = data,
                                   text_var = text,
                                   id_var = document,
                                   pos_model = model,
                                   in_parallel = FALSE,
                                   dependency_parse = TRUE,
                                   progress = "100")
#> 2025-12-10 12:30:26.416985 Annotating text fragment 1/100
```
