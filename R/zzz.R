assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
        paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

has_pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("install ", x, call. = FALSE)
  }
}
