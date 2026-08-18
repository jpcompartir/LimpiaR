# Timing and scaling benchmark for limpiar_near_duplicates().
#
# With no arguments, runs the synthetic scaling benchmark and writes
# corpus_1e5.csv and removed_r.csv for the datasketch comparison:
#   Rscript dev_docs/benchmarks/bench_near_duplicates.R
#
# With a CSV path (and optionally a text column name, default "text"),
# benchmarks that file instead:
#   Rscript dev_docs/benchmarks/bench_near_duplicates.R ~/data/trust/trust_slice.csv text
#
# For true peak memory, run one corpus per process under /usr/bin/time -l
# (macOS) and read "maximum resident set size". To test behaviour on a
# low-memory machine, cap R's vector heap first, e.g.
# R_MAX_VSIZE=1000000000 Rscript dev_docs/benchmarks/bench_near_duplicates.R

suppressMessages(devtools::load_all(quiet = TRUE))

args <- commandArgs(trailingOnly = TRUE)

if (length(args) >= 1) {
  csv_path <- args[[1]]
  text_col <- if (length(args) >= 2) args[[2]] else "text"

  df <- readr::read_csv(csv_path, show_col_types = FALSE)
  df <- dplyr::filter(df, !is.na(.data[[text_col]]))
  cat(sprintf(
    "%s: %d documents, %.0f words on average\n",
    basename(csv_path), nrow(df),
    mean(stringr::str_count(df[[text_col]], "\\S+"))
  ))

  t <- system.time(
    out <- limpiar_near_duplicates(df, dplyr::all_of(text_col), similarity = 0.7)
  )
  cat(sprintf(
    "%6.1fs elapsed | removed %d in %d groups\n",
    t[["elapsed"]], nrow(out$deleted), nrow(out$duplicates)
  ))
} else {
  source(file.path("dev_docs", "benchmarks", "bench_corpus.R"))

  for (n in c(10^3, 10^4, 10^5, 2 * 10^5)) {
    df <- make_corpus(n)
    gc(reset = TRUE)
    t <- system.time(out <- limpiar_near_duplicates(df, text, similarity = 0.7))
    cat(sprintf(
      "n=%6d | %6.1fs elapsed | removed %d in %d groups\n",
      n, t[["elapsed"]], nrow(out$deleted), nrow(out$duplicates)
    ))
  }

  # Write the corpus and removal ids so the datasketch benchmark and the
  # comparison script can use identical inputs.
  df <- make_corpus(10^5)
  readr::write_csv(
    tibble::tibble(id = seq_len(nrow(df)), text = df$text),
    file.path("dev_docs", "benchmarks", "corpus_1e5.csv")
  )
  out <- limpiar_near_duplicates(df, text, similarity = 0.7)
  readr::write_csv(
    dplyr::select(out$deleted, document),
    file.path("dev_docs", "benchmarks", "removed_r.csv")
  )
}
