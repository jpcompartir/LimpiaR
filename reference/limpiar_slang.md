# Clean slang from multiple Spanish dialects

Replaces slang phrases from various Spanish dialects with everyday
terms. Function's primary use is to normalise text for Deep Learning
sentiment algorithm. Care should be taken when using this function, e.g.
panda -\> grupo, as that is by far the most common usage in the texts we
use. However, in a data set where many people talk about panda bears or
'oso panda', there will be unwanted changes. I have tried to avoid this
problem where possible, by including things like 'me la suda' instead of
changing 'suda'.

## Usage

``` r
limpiar_slang(df, text_var = mention_content)
```

## Arguments

- df:

  Name of Data Frame or Tibble object

- text_var:

  Name of text variable/character vector

## Value

Data Frame or Tibble object with text variable altered

## Examples

``` r
if (FALSE) { # \dontrun{
df %>%
limpiar_slang(text_var = text_var)} # }
```
