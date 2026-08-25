# Changelog

## LimpiaR 1.2.0

- Introduced
  [`limpiar_near_duplicates()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_near_duplicates.md)
  for finding and removing near-duplicate documents at scale. It uses
  minhash signatures with locality sensitive hashing, implemented in R
  with no new compiled dependencies, and handles 100,000 documents in
  seconds on a laptop. Candidate pairs are verified with exact Jaccard
  similarity before removal, and results are reproducible through a
  `seed` argument. The `engine` argument leaves room for other methods
  later.
- Updated the `near_duplicates.Rmd` vignette with guidance on when to
  use
  [`limpiar_near_duplicates()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_near_duplicates.md)
  and how to set its parameters.
- Raised the minimum dplyr version to 1.1.0 and added purrr to Imports.

## LimpiaR 1.1.1

- Small fix for tests failing following a package change in the CI/CD VM

## LimpiaR 1.1.0

- Breaking Change - refactoring `limpiar_emojis` into
  `limpiar_recode_emojis` and `limpiar_remove_emojis` - `limpiar_emojis`
  no longer exists so code using it would need to be updated.
- Introduced `limpiar_non_ascii` and `limpiar_alphanumeric` to make
  removing special characters quicker and easier
- Introduced `limpiar_wrap_string` for reading outputs in {DT}’s Data
  Tables and {plotly} hovers.
- Introduced a vignette - `near_duplicates.Rmd` for using the
  `limpiar_spam_grams` function to remove near duplicates.
- Updated the `limpiar_intro.Rmd` vignette.
- behind doors improvements to documentation, error handling, and tests

## LimpiaR 1.0.0

### Parts of Speech Workflow

- Import & download models with `limpiar_pos_import`
  - Multilingual
  - Caching support
- Annotate models with `limpiar_pos_annotate`
- Removal of the `limpiar_df` function (be mindful about individual
  cleaning steps!)
