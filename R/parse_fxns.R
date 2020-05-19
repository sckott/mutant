#' Parse functions
#'
#' @keywords internal
#' @param env an environment with functions
#' @return a list of data.frame's, each of which is the output from 
#' [utils::getParseData()]; names of the list are the function names
#' @examples \dontrun{
#' path <- "../randgeo/"
#' env <- collect_fxns(path)
#' parse_fxns(env)
#' }
parse_fxns <- function(env) {
  stats::setNames(lapply(ls(envir = env), function(z) {
    pp <- parse(text = deparse(get(z, envir = env)), keep.source = TRUE)
    utils::getParseData(pp)
  }), ls(envir = env))
}
