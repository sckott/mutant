#' Write mutated package
#' @param pkg_path (character) path to the original package. we don't overwrite
#' any files in the original path/location
#' @param fxns (list) list of functions, output of [make_fxns()]
#' @param map (list) package map, output of [make_pkg_map()]
#' @keywords internal
write_mutated_pkg <- function(pkg_path, fxns, map) {
  # temp dir
  # mut_pkg_path <- file.path(tempdir(), "mutant", sample(1:1000, 1), basename(pkg_path))
  mut_pkg_path <- file.path(tempdir(), "mutant", sample(1:1000, 1))

  # create dir
  dir.create(mut_pkg_path, recursive = TRUE)

  # copy the whole pkg
  invisible(file.copy(from = pkg_path, to = mut_pkg_path, recursive = TRUE))
  #list.files(mut_pkg_path, full.names = TRUE, recursive = TRUE)

  # remove R files, and make R dir
  unlink(file.path(mut_pkg_path, map$name, "R"), recursive = TRUE, force = TRUE)
  dir.create(file.path(mut_pkg_path, map$name, "R"), recursive = TRUE)

  # replace the R files
  ff_map <- filename_from_fxnname(fxns, map)
  invisible(lapply(split(ff_map, ff_map$file), function(a) {
    for (i in seq_len(NROW(a))) {
      fname <- names(fxns[names(fxns) %in% a$fun_name[i]])
      fun <- fxns[names(fxns) %in% a$fun_name[i]][[1]]
      fun <- paste0(sprintf("`%s`", fname), " <- ", fun, "\n\n")
      cat(fun, file = file.path(mut_pkg_path, map$name, a$file[i]), append = TRUE)
    }
  }))

  # return mutant pkg path
  return(file.path(mut_pkg_path, map$name))
}

# get filenames from function names
#
# path <- '/Users/sckott/github/ropensci/randgeo'
# fxns <- xx
# map <- make_pkg_map(path)
# filename_from_fxnname(fxns, map)
filename_from_fxnname <- function(fxns, map) {
  lsa <- lapply(names(fxns), function(z) {
    matched <- map$defs[map$defs$name %in% z, ]
    data.frame(
      fun_name = z,
      first_line = matched[1, "line1"],
      last_line = matched[1, "line2"],
      file = matched$file[1],
      # src = extract_src(fxns[names(fxns) %in% z][[1]]),
      stringsAsFactors = FALSE
    )
  })
  df <- do.call("rbind.data.frame", lsa)
  df[ order(df$file), ]
}

# extract_src <- function(w) {
#   # srcref <- attr(w, "srcref")
#   sf <- attr(w, "srcfile")
#   sf$filename
#   sf$lines
#   # cat(sf$lines, sep = "\n")
#   # names(sf)
# }
