# OS-agnostic check that the model_cache dir is being created
.onLoad <- function(libname, pkgame) {
  cache_dir <- file.path(normalizePath(system.file(package = "LimpiaR")), "model_cache")

  if (!dir.exists(cache_dir)) {
    # Potential problems in Virtual Machines?
    dir.create(cache_dir, recursive = TRUE)
  }
}
