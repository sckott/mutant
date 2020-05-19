#' Mutation test
#' 
#' Run [testthat::test_dir()] on a mutated package
#' @importFrom withr with_dir
#' @importFrom pkgload load_all
#' @param x (character) complete path to the package
#' @return the output of [testthat::SilentReporter]
mutation_test <- function(x) {
  withr::with_dir(x, {
    Sys.setenv(NOT_CRAN = "true")
    pkgload::load_all()
    testres <- testthat::test_dir(file.path(x, "tests/testthat"),
      reporter = testthat::SilentReporter)
  })
  return(testres)
}
