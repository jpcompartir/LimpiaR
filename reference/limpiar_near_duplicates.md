# Remove near-duplicate posts

Finds groups of posts whose text is nearly identical, keeps the first
post of each group, and removes the rest. Two posts count as near
duplicates when the Jaccard similarity of their shingle sets is at least
`similarity`, where a shingle is a run of `shingle_size` consecutive
words. Text is lowercased and stripped of punctuation before shingling,
but the returned data keeps your original text.

The default engine uses minhash signatures with locality sensitive
hashing (LSH), so it scales to hundreds of thousands of documents
without comparing every pair. The method is probabilistic. Every removal
is confirmed with an exact similarity calculation, so precision does not
depend on chance, but a small share of true near-duplicate pairs close
to the threshold can be missed. Results are reproducible for a fixed
`seed`, and raising `n_hashes` reduces the number of missed pairs at a
linear cost in compute time. See
[`vignette("near_duplicates")`](https://jpcompartir.github.io/LimpiaR/articles/near_duplicates.md)
for guidance on choosing parameters.

Documents with fewer than `shingle_size` words produce no shingles, so
they are always kept. The function adds a `document` column holding the
original row number, overwriting any existing column with that name.

## Usage

``` r
limpiar_near_duplicates(
  data,
  text_var = mention_content,
  similarity = 0.7,
  shingle_size = 3,
  n_hashes = 100,
  engine = c("lsh"),
  seed = 42
)
```

## Arguments

- data:

  Name of your Data Frame or Tibble object

- text_var:

  Name of your text variable. Can be given as a 'string' or a symbol -
  should refer to a column inside `data`

- similarity:

  Jaccard similarity threshold between 0 and 1. Pairs of documents at or
  above the threshold are treated as near duplicates.

- shingle_size:

  Number of consecutive words in each shingle.

- n_hashes:

  Number of minhash functions in each document's signature. More hashes
  find more of the true near-duplicate pairs and take longer to run.

- engine:

  Method used to find near-duplicate pairs. Currently only `"lsh"` is
  available.

- seed:

  Integer seed for the random hash functions. The same data, parameters,
  and seed always return the same result.

## Value

A list of three tibbles:

- `duplicates`: one row per near-duplicate group, with the kept
  document's row number (`group`), its text, the number of removed
  documents (`n_duplicates`), and the mean and minimum similarity of the
  removed documents to the kept one.

- `data`: the input data with near duplicates removed.

- `deleted`: the removed rows, each tagged with its `group` and its
  `similarity` to the document that was kept.

## Examples

``` r
near_dupes <- limpiar_examples %>%
  limpiar_near_duplicates(mention_content, similarity = 0.5)

near_dupes$duplicates
#> # A tibble: 2 × 5
#>   group mention_content              n_duplicates mean_similarity min_similarity
#>   <int> <chr>                               <int>           <dbl>          <dbl>
#> 1     1 mi amigo sancho es un wn de…            1           0.875          0.875
#> 2     4 nos han metido en una muy d…            1           1              1    
near_dupes$data
#> # A tibble: 8 × 6
#>   doc_id author_name  mention_content mention_url platform_interactions document
#>    <int> <chr>        <chr>           <chr>       <lgl>                    <int>
#> 1      1 don_quijote  "mi amigo sanc… www.twitte… NA                           1
#> 2      3 edmond_dant… "@don_quijote … www.twitte… NA                           3
#> 3      4 el_sordo     "nos han metid… www.fakebo… NA                           4
#> 4      6 robert_jord… "   Lo q no te… www.youtub… NA                           6
#> 5      7 anselmo      "a mi es muy g… www.twitte… NA                           7
#> 6      8 maria        "ayyy nooo @ro… www.twitte… NA                           8
#> 7      9 pablo        "todos se unen… www.instag… NA                           9
#> 8     10 pilar        "a mi me gusta… www.instag… NA                          10
near_dupes$deleted
#> # A tibble: 2 × 8
#>   doc_id author_name  mention_content mention_url platform_interactions document
#>    <int> <chr>        <chr>           <chr>       <lgl>                    <int>
#> 1      2 sancho_panza RT mi amigo sa… www.twitte… NA                           2
#> 2      5 commander_m… nos han metido… www.fakebo… NA                           5
#> # ℹ 2 more variables: group <int>, similarity <dbl>
```
