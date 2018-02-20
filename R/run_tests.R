#' Run tests a single time
#'
#' @keywords internal
#' @param map a function map as returned from [make_pkg_map()]
#' @param n (integer) number of times to run tests
#' @return an object of class `testthat_results`
#' @details uses [testthat::SilentReporter] as the reporter
#' in [testthat::test_package()]
#' @examples \dontrun{
#' path <- '/Users/sckott/github/ropensci/rredlist'
#' pkgmap <- make_pkg_map(path)
#'
#' # single test
#' res <- run_test(pkgmap)
#' class(res)
#' res[[1]]
#'
#' # many tests
#' out <- run_tests(pkgmap, times = 2)
#' length(out)
#' out[[1]]
#' out[[2]]
#' }
run_test <- function(map) {
  origwd <- getwd(); setwd(map$rpath)
  on.exit(setwd(origwd))
  Sys.setenv(NOT_CRAN = "true")
  testres <- testthat::test_package(
    map$package,
    reporter = testthat::SilentReporter)
  return(testres)
}

#' @export
#' @rdname run_test
run_tests <- function(map, n = 1) {
  rep_times(run_test(map), n)
}

# repeat something `n` times, `replicate` but w/ arguments in sensible order
rep_times <- function(expr, n) {
  sapply(integer(n), eval.parent(substitute(function(...) expr)),
         simplify = FALSE)
}
