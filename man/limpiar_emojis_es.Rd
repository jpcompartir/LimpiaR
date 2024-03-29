% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/limpiar_emojis_es.R
\name{limpiar_emojis_es}
\alias{limpiar_emojis_es}
\title{Replace emojis with a Spanish textual description}
\usage{
limpiar_emojis_es(df, text_var = mention_content, with_emoji_tag = FALSE)
}
\arguments{
\item{df}{Name of Data Frame or Tibble Object}

\item{text_var}{Name of text variable}

\item{with_emoji_tag}{Whether to replace with snakecase linked words or not}
}
\value{
The Data Frame or Tibble object with most emojis cleaned from the text variable
}
\description{
Spanish version of limpiar_emojis function.
Main usage is for pre-processing the text variable as part of Deep Learning pipeline.
The most important argument is whether or not to add the emoji tag, which will also print in snake case.
}
\examples{

limpiar_examples \%>\% limpiar_emojis_es() \%>\% dplyr::select(mention_content)
}
