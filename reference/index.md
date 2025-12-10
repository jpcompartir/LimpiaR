# Package index

## Cleaning Posts

Functions for editing the text variable in place.

- [`limpiar_accents()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_accents.md)
  : Clean accented characters

- [`limpiar_spaces()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_spaces.md)
  : Clean redundant spaces

- [`limpiar_url()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_url.md)
  : Clean URLs from the text variable

- [`limpiar_repeat_chars()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_repeat_chars.md)
  : Clean repeated charaaaacters

- [`limpiar_shorthands()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_shorthands.md)
  : Clean shorthands and abbreviations

- [`limpiar_tags()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_tags.md)
  : Clean user handles and hashtags

- [`limpiar_stopwords()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_stopwords.md)
  : Clean stop words for visualisations

- [`limpiar_slang()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_slang.md)
  : Clean slang from multiple Spanish dialects

- [`limpiar_recode_emojis()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_recode_emojis.md)
  : Recode emojis with a textual description

- [`limpiar_remove_emojis()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_remove_emojis.md)
  :

  Completely Remove *Most* Emojis from Text

- [`limpiar_emojis_es()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_emojis_es.md)
  : Replace emojis with a Spanish textual description

- [`limpiar_pp_products()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pp_products.md)
  : Replace entities for the Peaks&Pit classifier

- [`limpiar_pp_companies()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pp_companies.md)
  : Remove known companies for pits & peaks

- [`limpiar_non_ascii()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_non_ascii.md)
  : Remove non-ASCII characters except those with latin accents

- [`limpiar_alphanumeric()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_alphanumeric.md)
  : Remove everything except letters, numbers, and spaces

## Removing Posts

Functions for removing unwanted posts entirely (rather than cleaning).

- [`limpiar_duplicates()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_duplicates.md)
  : Clean the text variable of duplicate posts
- [`limpiar_retweets()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_retweets.md)
  : Clean retweets from the text variable
- [`limpiar_spam_grams()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_spam_grams.md)
  : Remove posts containing spam-like n-grams

## Utility Functions

Miscellaneous functions designed to speed up aspects of cleaning text.

- [`limpiar_inspect()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_inspect.md)
  : Inspect every post and URL which contains a pattern
- [`limpiar_na_cols()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_na_cols.md)
  : Clean NA-heavy columns from a Data Frame or Tibble
- [`limpiar_link_click()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_link_click.md)
  : Prepare a URL column to be clickable in Shiny/Data Table
- [`limpiar_link_click_reverse()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_link_click_reverse.md)
  : Reverses (inverts) limpiar_link_click
- [`limpiar_ex_subreddits()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_ex_subreddits.md)
  : Quickly extract subreddits from a link variable
- [`limpiar_wrap()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_wrap.md)
  : Wrap strings for visual ease

## Processing Parts of Speech

A collection of functions that collectively make up a Parts of Speech
(POS) analysis workflow.

- [`limpiar_pos_import_model()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pos_import_model.md)
  : Import UDPipe models to begin Parts of Speech Analysis
- [`limpiar_pos_annotate()`](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pos_annotate.md)
  : Annotate Texts for Parts of Speech Analysis using udpipe models.
