#' Make functions from [utils::getParseData()] output
#' 
#' @param x for `make_fxn`, a data.frame, as output from
#' [utils::getParseData()]; for `make_fxns`, a list of those
#' @keywords internal
#' @return for `make_fxn` a function as a character string;
#' for `make_fxns`, a list of those
#' @examples \dontrun{
#' foo <- function(x) {
#'   if (x == 1) x else 5
#' }
#' foo
#' f <- mutate_one(foo)
#' f
#' x = f
#' make_fxn(f)
#' 
#' bar <- function(w) {
#'   if (w == 10) w else 5
#' }
#' g <- mutate_one(bar)
#' make_fxns(list(f, g))
#' }
make_fxn <- function(x) {
  assert(x, "ast")
  expr <- attr(x, "expr")
  expr[,"text"][1]
}
#' @rdname make_fxn
make_fxns <- function(x) {
  assert(x, "list")
  lapply(x, make_fxn)
}
