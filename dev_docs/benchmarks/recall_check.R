# Recall check for limpiar_near_duplicates() against exact ground truth.
#
# Builds a 3,000 document corpus, computes the exact Jaccard similarity of
# every pair that shares at least one shingle, and compares the documents the
# function removes with the documents an exhaustive comparison says are
# removable. 3,000 documents keeps the exhaustive step tractable; it is
# quadratic, which is the reason the package uses LSH in the first place.
#
# Run from the package root with: Rscript dev_docs/benchmarks/recall_check.R

suppressMessages(devtools::load_all(quiet = TRUE))
suppressMessages(library(dplyr))
source(file.path("dev_docs", "benchmarks", "bench_corpus.R"))

df <- make_corpus(3000)
threshold <- 0.7

data_id <- mutate(df, document = row_number())
trip <- LimpiaR:::nd_shingles(data_id, "text", 3)
sizes <- count(trip, document, name = "size")

truth <- trip %>%
  inner_join(trip, by = "shingle_id", relationship = "many-to-many") %>%
  filter(document.x < document.y) %>%
  count(document.x, document.y, name = "common") %>%
  inner_join(rename(sizes, document.x = document, size_x = size), by = "document.x") %>%
  inner_join(rename(sizes, document.y = document, size_y = size), by = "document.y") %>%
  mutate(jaccard = common / (size_x + size_y - common)) %>%
  filter(jaccard >= threshold - 1e-9)

members <- sort(unique(c(truth$document.x, truth$document.y)))
roots <- LimpiaR:::nd_union_find(
  match(truth$document.x, members),
  match(truth$document.y, members),
  length(members)
)
true_removed <- members[roots != seq_along(roots)]

for (seed in c(42, 1, 7)) {
  out <- limpiar_near_duplicates(df, text, similarity = threshold, seed = seed)
  cat(sprintf(
    "seed %3d | true removable %d | found %d | doc recall %.3f | removals outside truth %d\n",
    seed,
    length(true_removed),
    nrow(out$deleted),
    mean(true_removed %in% out$deleted$document),
    length(setdiff(out$deleted$document, true_removed))
  ))
}
