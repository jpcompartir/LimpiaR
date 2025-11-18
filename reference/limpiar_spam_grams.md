# Remove posts containing spam-like n-grams

\#' Function identifies posts which contain suspicious-looking n-gram
patterns. Posts can then be removed, the pattern inspected, and the
posts that were removed too. You can re-assign your current data frame
to the 'clean' data frame through the third element of the list.

## Usage

``` r
limpiar_spam_grams(data, text_var, n_gram, min_freq)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

- n_gram:

  Number of words in the n-gram i.e. n = 2 = bigram

- min_freq:

  Minimum number of times n-gram should be seen to be removed

## Value

A list of 3 data frames 1. suspicious-looking n-grams, 2. data with them
removed, 3. rows of data frame that were removed
