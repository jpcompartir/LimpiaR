# Inspect every post and URL which contains a pattern

Produces a viewable data frame with posts matching a regular expression
and Useful for investigating suspected spam posts, or other patterns of
interest. Set the name of the title to avoid new frames overwriting old
ones.

## Usage

``` r
limpiar_inspect(
  data,
  pattern,
  text_var = mention_content,
  url_var = mention_url,
  title = "inspect",
  open_view = TRUE,
  ignore_case = TRUE
)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- pattern:

  Pattern you wish to inspect e.g. "link bio"

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

- url_var:

  Name of the data frame's URL-column

- title:

  Name of the viewable pane

- open_view:

  For testing purposes, default is set to TRUE

- ignore_case:

  Whether the pattern should ignore the upper case/lower case
  distinction

## Details

add boundary tags e.g. `\\b` to either side of your pattern if you wish
to only match words rather than parts of words. For example,
`pattern="cats"` will match '#cats', but also 'catch up'. If we add a
word boundary: `pattern = \\bcats\\b` we won't match either '#cats' or
'catch up'.

## Examples

``` r
df <- data.frame(
text_variable = rbind("check me out", "don't look at me"),
text_url = rbind("www.twitter.com", "www.facebook.com"))
limpiar_inspect(df, "check", text_var = text_variable, url_var = text_url)
```
