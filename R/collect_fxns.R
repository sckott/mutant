#' Collect functions into an environment
#' @param path (character) path to a package, default: current directory
#' @return an enironment with functions in the environment
collect_fxns <- function(path) {
  tenv <- new.env()
  get_fxns(get_files(path), env = tenv)
  return(tenv)
  ## attempt to expand path on the file path for the fxn
  ## just as pkgapi has, but doesn't seem to be working
  # for (i in seq_along(names(myenv))) {
  #   tmp <- get(names(myenv)[i], envir = myenv)
  #   attr(attr(tmp, "srcref"), "srcfile")
  # }
}
get_files <- function(path = ".") {
  has_pkg("pkgapi")
  df <- pkgapi::map_package(path)$defs
  file.path(path, unique(df$file))
}
get_fxns <- function(x, env) {
  invisible(lapply(x, source, local = env, keep.source = TRUE))
}

# function(x) {
#   as.numeric(ranks_ref[which(sapply(ranks_ref$ranks, function(z) {
#     any(unlist(strsplit(z, split = ",")) == x)
#   }, USE.NAMES = FALSE)), "rankid"])
# }
