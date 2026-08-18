# Timing and scaling benchmark for limpiar_near_duplicates().
#
# Run from the package root with: Rscript dev_docs/benchmarks/bench_limpiar.R
#
# For true peak memory, run one size per process under /usr/bin/time -l
# (macOS) and read "maximum resident set size". To test behaviour on a
# low-memory machine, cap R's vector heap first, e.g.
# R_MAX_VSIZE=1000000000 Rscript dev_docs/benchmarks/bench_limpiar.R

suppressMessages(devtools::load_all(quiet = TRUE))
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
