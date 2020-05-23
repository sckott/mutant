#' Make mutations across many functions
#' 
#' Goal here is to input many functions but only 
#' make one mutation in one the functions to better isolate 
#' the effect of the mutation. See Details.
#' 
#' @importFrom astr ast_decompose ast_modify ast_recompose
#' @param x a list of output from [parse_fxns()]
#' @keywords internal
#' @return a list of the above
#' @family mutate
#' @details use a while loop internally; attempt to mutate each function
#' until we make a successful mutation, and then return the complete
#' set of functions with one function with one mutation
#' @examples \dontrun{
#' foo <- function(x) {
#'   if (x == 1) x else 5
#' }
#' bar <- function(w) {
#'   if (w == 10) w else 5
#' }
#' mutate(list(foo, bar))
#' }
mutate <- function(x) {
  assert(x, "list")
  x <- lapply(x, function(w) {
    z <- astr::ast_decompose(w)
    attr(z, "mutated") <- FALSE
    z
  })
  x_length <- length(x)
  mut_length <- length(mutaters$new()$muts)
  max_iterations <- x_length * mut_length
  not_done <- TRUE
  i <- 0
  j <- 0
  while (not_done) {
    i <- (i %% x_length) + 1
    j <- j + 1
    x[[i]] <- mutate_one(x[[i]])
    if (attr(x[[i]], "mutated")) not_done <- FALSE
    if (j == max_iterations) break
  }
  return(x)
}

#' Make a mutation in one function
#' 
#' @param x a data.frame, the output of [utils::getParseData()], called
#' from [parse_fxns()]
#' @keywords internal
#' @return the same data.frame as in `x`, but with a single mutation
#' @note uses [astr::ast_modify()] internally
#' @examples \dontrun{
#' foo <- function(x) {
#'   if (x == 1) x else 5
#' }
#' mutate_one(foo)
#' mutate_one(astr::ast_decompose(foo))
#' }
mutate_one <- function(x) {
  UseMethod("mutate_one")
}
#' @rdname mutate_one
mutate_one.default <- function(x) {
  stop("no `mutate_one` method for ", class(x)[1L], call. = FALSE)
}
#' @rdname mutate_one
mutate_one.function <- function(x) {
  x_dec <- astr::ast_decompose(x)
  mutate_one(x_dec)
}
#' @rdname mutate_one
mutate_one.ast <- function(x) {
  mut <- mutaters$new()$random()
  res <- suppressMessages(astr::ast_modify(x,
    from = mut$from, to = mut$to,
    if_many = "random", no_match = message))
  ret <- if (is.null(res)) x else res
  attr(ret, "mutated") <- !is.null(res)
  return(ret)
}
