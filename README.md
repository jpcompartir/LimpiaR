
<img src="man/figures/SHARExLimpiaR.png" align="center" width="100%" style="padding: 25px 50px 25px 0px;"/>

<!-- badges: start -->

[![pkgdown](https://github.com/jpcompartir/LimpiaR/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/jpcompartir/LimpiaR/actions/workflows/pkgdown.yaml)
[![R-CMD-check](https://github.com/jpcompartir/LimpiaR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jpcompartir/LimpiaR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## What is LimpiaR?

LimpiaR is an R library of functions for cleaning & pre-processing text
data. The name comes from ‘limpiar’ the Spanish verb’to clean’.
Generally when calling a LimpiaR function, you can think of it as
‘clean…’.

LimpiaR is primarily used for cleaning unstructured text data, such as
that which comes from social media or reviews. In its initial release,
it is focused around the Spanish language, however, some of its
functions are language-ambivalent.

## Installation

You can install the development version of LimpiaR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jpcompartir/LimpiaR")
```

# LimpiaR Functions Overview

LimpiaR provides a comprehensive suite of text cleaning and processing
functions, primarily focused on preparing text data for machine learning
and analytics tasks. Below you’ll find the functions organised by their
primary purpose.

Functions for editing the text variable in place.

| Function | Description | Language Support | Primary Use Case | Notes |
|----|----|----|----|----|
| [limpiar_accents](https://jpcompartir.github.io/LimpiaR/reference/limpiar_accents.html) | Removes accented characters | Language-agnostic | Text normalisation | Useful for reducing token complexity |
| [limpiar_spaces](https://jpcompartir.github.io/LimpiaR/reference/limpiar_spaces.html) | Removes redundant spaces | Language-agnostic | Text cleaning | Also standardises punctuation spacing |
| [limpiar_url](https://jpcompartir.github.io/LimpiaR/reference/limpiar_url.html) | Removes URLs from text | Language-agnostic | Text cleaning | Handles various URL formats |
| [limpiar_repeat_chars](https://jpcompartir.github.io/LimpiaR/reference/limpiar_repeat_chars.html) | Normalises repeated characters | Spanish-focused | Text normalisation | Handles laugh patterns (jajaja) |
| [limpiar_shorthands](https://jpcompartir.github.io/LimpiaR/reference/limpiar_shorthands.html) | Expands common abbreviations | Spanish-focused | Text normalisation | e.g., “porq” → “porque” |
| [limpiar_tags](https://jpcompartir.github.io/LimpiaR/reference/limpiar_tags.html) | Normalises social media tags | Language-agnostic | Social media prep | Handles @mentions and \#hashtags |
| [limpiar_stopwords](https://jpcompartir.github.io/LimpiaR/reference/limpiar_stopwords.html) | Removes common stopwords | Spanish-focused | Text analysis | Offers “sentiment” and “topics” modes |
| [limpiar_slang](https://jpcompartir.github.io/LimpiaR/reference/limpiar_slang.html) | Normalises dialectal variations | Spanish-focused | Text normalisation | Handles multiple Spanish dialects |
| [limpiar_emojis_es](https://jpcompartir.github.io/LimpiaR/reference/limpiar_emojis_es.html) | Converts emojis to Spanish text | Spanish | Text normalisation | Spanish-specific emoji descriptions |
| [limpiar_recode_emojis](https://jpcompartir.github.io/LimpiaR/reference/limpiar_recode_emojis.html) | Recodes emojis to text | Language-agnostic | Text normalisation | General emoji handling |
| [limpiar_remove_emojis](https://jpcompartir.github.io/LimpiaR/reference/limpiar_remove_emojis.html) | Removes emojis completely | Language-agnostic | Text cleaning | Complete emoji removal |
| [limpiar_pp_products](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pp_products.html) | Replaces product mentions | English/Spanish | Entity normalisation | For product analysis |
| [limpiar_pp_companies](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pp_companies.html) | Replaces company mentions | English/Spanish | Entity normalisation | For company analysis |
| [limpiar_non_ascii](https://jpcompartir.github.io/LimpiaR/reference/limpiar_non_ascii.html) | Removes non-ASCII characters | Language-agnostic | Text cleaning | Less aggressive than alphanumeric |
| [limpiar_alphanumeric](https://jpcompartir.github.io/LimpiaR/reference/limpiar_alphanumeric.html) | Keeps only letters/numbers | Language-agnostic | Text cleaning | Most aggressive cleaning |

## Removing Posts

Functions for removing unwanted posts entirely (rather than cleaning).

| Function | Description | Language Support | Primary Use Case | Notes |
|----|----|----|----|----|
| [limpiar_duplicates](https://jpcompartir.github.io/LimpiaR/reference/limpiar_duplicates.html) | Removes duplicate content | Language-agnostic | Data cleaning | Also removes protected content |
| [limpiar_retweets](https://jpcompartir.github.io/LimpiaR/reference/limpiar_retweets.html) | Removes retweet content | Language-agnostic | Social media cleaning | Identifies RT patterns |
| [limpiar_spam_grams](https://jpcompartir.github.io/LimpiaR/reference/limpiar_spam_grams.html) | Removes spam-like patterns | Language-agnostic | Content filtering | Uses n-gram analysis |

## Utility

Miscellaneous functions designed to speed up aspects of cleaning text.

| Function | Description | Language Support | Primary Use Case | Notes |
|----|----|----|----|----|
| [limpiar_inspect](https://jpcompartir.github.io/LimpiaR/reference/limpiar_inspect.html) | Viewable pane for pattern matches | Language-agnostic | Data exploration | Interactive viewing |
| [limpiar_na_cols](https://jpcompartir.github.io/LimpiaR/reference/limpiar_na_cols.html) | Removes NA-heavy columns | Language-agnostic | Data cleaning | Configurable threshold |
| [limpiar_link_click](https://jpcompartir.github.io/LimpiaR/reference/limpiar_link_click.html) | Makes URLs clickable and short | Language-agnostic | UI enhancement | For Shiny/DataTable |
| [limpiar_ex_subreddits](https://jpcompartir.github.io/LimpiaR/reference/limpiar_ex_subreddits.html) | Extracts subreddit names | Language-agnostic | Reddit analysis | URL parsing |

## Parts of Speech Processing

A collection of functions that collectively make up a Parts of Speech
(POS) analysis workflow.

| Function | Description | Language Support | Primary Use Case | Notes |
|----|----|----|----|----|
| [limpiar_pos_import_model](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pos_import_model.html) | Imports Parts of Speech models and caches | 65+ languages | POS analysis prep | Uses UDPipe models |
| [limpiar_pos_annotate](https://jpcompartir.github.io/LimpiaR/reference/limpiar_pos_annotate.html) | Performs POS analysis | 65+ languages | Text analysis | Includes dependency parsing |
