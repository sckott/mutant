### ---------
mutant_report <- function(x) {
  # prepare report
  mutrep <- 'xx'
  # write to disk
  json <- jsonlite::toJSON(mutrep, auto_unbox = TRUE)
  jsonlite::write_json(json, "path")
  # write to cli
  # cat("write results to cli")
}

mutation_test <- function(mut_pkg_path) {
  origwd <- getwd()
  setwd(mut_pkg_path)
  on.exit(setwd(origwd))
  devtools::install(upgrade_dependencies = FALSE, quiet = TRUE)
  # sys::exec_internal(sprintf("R CMD BUILD .%s", basename(mut_pkg_path)))
  # sys::exec_wait(sprintf("R CMD BUILD %s && %s", mut_pkg_path))
  #tout=testthat::test_file(tfile, reporter = testthat::ListReporter)
  #setwd(mut_pkg_path)
  testthat::test_package("phylocomr", reporter = testthat::ListReporter)
}

write_mutated_pkg <- function(pkg_path, fxns) {
  # temp dir
  mut_pkg_path <- file.path(tempdir(), "mutant", sample(1:1000, 1), basename(pkg_path))

  # create dir
  dir.create(mut_pkg_path, recursive = TRUE)

  # copy the whole pkg
  invisible(file.copy(from = pkg_path, to = mut_pkg_path, recursive = TRUE))
  #list.files(mut_pkg_path, full.names = TRUE, recursive = TRUE)

  # remove R files, and make R dir
  unlink(file.path(mut_pkg_path, "R"), recursive = TRUE, force = TRUE)
  dir.create(file.path(mut_pkg_path, "R"), recursive = TRUE)

  # replace the R files
  ff_map <- filename_from_fxnname(fxns, pkgmap)
  invisible(lapply(split(ff_map, ff_map$file), function(a) {
    for (i in seq_len(NROW(a))) {
      fname <- names(fxns[names(fxns) %in% a$fun_name[i]])
      fun <- fxns[names(fxns) %in% a$fun_name[i]][[1]]
      fun <- paste0(fname, " <- ", fun, "\n\n")
      cat(fun, file = file.path(mut_pkg_path, a$file[i]), append = TRUE)
    }
  }))

  # return mutant pkg path
  return(mut_pkg_path)
}

collect_fxns <- function(path) {
  get_fxns(get_files(path), env = myenv)
}

#parse_fxns()
parse_fxns <- function() {
  stats::setNames(lapply(ls(envir = myenv), function(z) {
    pp <- parse(text = deparse(get(z, envir = myenv)), keep.source = TRUE)
    getParseData(pp)
  }), ls(envir = myenv))
}

mutate <- function(x) {
  lapply(x, mutate_one)
}

mutate_one <- function(x) {
  # e.g., replace any EQ with a different one
  out <- x[x$token == "EQ", "text"]
  if (length(out) == 0) {
    return(structure(x, mutated = FALSE))
  } else {
    if (length(out) > 1) {
      for (i in seq_along(out)) {
        x[x$token == "EQ" & x$text == out[i], "text"] <- replace_eq(out[i])
      }
    } else {
      x[x$token == "EQ", "text"] <- replace_eq(out)
    }
  }
  return(x)
}

make_fxn <- function(x) {
  paste0(getParseText(x, x[which(x$token == "expr")[1], "id"]), collapse = "")
}
make_fxns <- function(x) lapply(x, make_fxn)

myenv <- new.env()

get_files <- function(path = ".") functionMap:::r_package_files(path)

get_fxns <- function(x, env) invisible(lapply(x, source, local = env,
                                              keep.source = TRUE))

make_pkg_map <- function(x) {
  tmp <- functionMap::map_r_package(x)
  one <- tmp$edge_df[, -2]
  names(one)[1] <- "fxn"
  two <- tmp$edge_df[, -1]
  names(two)[1] <- "fxn"
  df <- rbind(one, two)[, c('fxn', 'line', 'file')]
  df[!duplicated(df), ]
}

filename_from_fxnname <- function(fxns, map) {
  lsa <- lapply(names(fxns), function(z) {
    matched <- map[map$fxn %in% z, ]
    data.frame(
      fun_name = z,
      first_line = matched[1, "line"],
      file = matched$file[1],
      stringsAsFactors = FALSE
    )
  })
  df <- do.call("rbind.data.frame", lsa)
  df[ order(df$file), ]
}

replace_eq <- function(x) {
  eq_ops <- c("==", "!=", "<=", ">=", ">", "<")
  sample(eq_ops[!eq_ops %in% x], size = 1)
}


# function(x) {
#   as.numeric(ranks_ref[which(sapply(ranks_ref$ranks, function(z) {
#     any(unlist(strsplit(z, split = ",")) == x)
#   }, USE.NAMES = FALSE)), "rankid"])
# }
