# Compare limpiar_near_duplicates() and datasketch removal sets on the shared
# 100,000 document corpus.
#
# Run bench_near_duplicates.R first (writes corpus_1e5.csv and removed_r.csv), then
# the datasketch benchmark (writes removed_py.csv), then this script from the
# package root. For each document only datasketch removed, we find its most
# similar other document by exact Jaccard, which shows how many of those
# removals were justified at the threshold.

suppressMessages(devtools::load_all(quiet = TRUE))
suppressMessages(library(dplyr))

bench_dir <- file.path("dev_docs", "benchmarks")
r_removed <- readr::read_csv(file.path(bench_dir, "removed_r.csv"), show_col_types = FALSE)$document
py_removed <- readr::read_csv(file.path(bench_dir, "datasketch", "removed_py.csv"), show_col_types = FALSE)$document

cat("LimpiaR removed:", length(r_removed), "| datasketch removed:", length(py_removed), "\n")
cat("share of LimpiaR's removals also removed by datasketch:", round(mean(r_removed %in% py_removed), 3), "\n")

py_only <- setdiff(py_removed, r_removed)
cat("datasketch-only removals:", length(py_only), "\n")

df <- readr::read_csv(file.path(bench_dir, "corpus_1e5.csv"), show_col_types = FALSE) %>%
  mutate(document = row_number())
trip <- LimpiaR:::nd_shingles(df, "text", 3)
sets <- split(trip$shingle_id, trip$document)

set.seed(1)
sample_docs <- sample(py_only, 300)
best <- purrr::map_dbl(sample_docs, function(d) {
  s <- sets[[as.character(d)]]
  candidates <- setdiff(unique(trip$document[trip$shingle_id %in% s]), d)
  if (!length(candidates)) {
    return(0)
  }
  max(purrr::map_dbl(
    as.character(candidates),
    function(other) LimpiaR:::nd_jaccard(s, sets[[other]])
  ))
})
cat(
  "sampled datasketch-only removals with a true Jaccard >= 0.7 to any document:",
  sum(best >= 0.7 - 1e-9), "of", length(sample_docs), "\n"
)
cat("median best Jaccard among those removals:", round(median(best), 3), "\n")
