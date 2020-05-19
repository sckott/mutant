### binary operators
ops <- expand.grid(
  a = c("==", "!=", "<=", ">=", ">", "<"), 
  b = c("==", "!=", "<=", ">=", ">", "<"),
  stringsAsFactors = FALSE)
ops <- ops[!apply(ops, 1, function(x) x[1] == x[2]),]
row.names(ops) <- NULL

make_ops <- function(ops) {
  out <- vector("list", NROW(ops))
  for (i in seq_len(NROW(ops))) {
    out[[i]] <- list(
      name = sprintf("replace_op_%s_%s", ops[i,1], ops[i,2]),
      description = "replace an operator, e.g., replace == with >=",
      from = ops[i,1],
      to = ops[i,2]
    )
  }
  return(out)
}

# replace_op <- list(
#   name = "replace_op",
#   description = "replace an operator, e.g., replace == with >=",
#   from = "==|!=|<=|>=|>|<",
#   to = sample(c("==", "!=", "<=", ">=", ">", "<"), size = 1)
#   # fun = function(x) {
#   #   eq_ops <- c("==", "!=", "<=", ">=", ">", "<")
#   #   sample(eq_ops[!eq_ops %in% x], size = 1)
#   # }
# )

### bools
bool_true2false <- list(
  name = "bool_true2false",
  description = "changes TRUE to FALSE",
  from = "TRUE",
  to = "FALSE"
)
bool_false2true <- list(
  name = "bool_false2true",
  description = "changes FALSE to TRUE",
  from = "FALSE",
  to = "TRUE"
)

#' mutaters
#' @keywords internal
#' @importFrom R6 R6Class
#' @examples \dontrun{
#' x <- mutaters$new()
#' x
#' # select mutater by name
#' x$muts$bool_false2true
#' # fetch a random mutater
#' z <- x$random()
#' z
#' z$name
#' z$description
#' z$from
#' z$to
#' }
mutaters <- R6::R6Class(
  'mutaters',
  public = list(
    #' @field mutater (character) a mutater name
    mutater = NULL,
    muts = list(),

    #' @description print method for `mutaters` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<mutaters> ", sep = "\n")
      for (i in seq_along(self$muts)) {
        cat(paste0("  mutant name: ", self$muts[[i]]$name), sep = "\n")
      }
      invisible(self)
    },

    #' @description Create a new mutaters object
    #' @return A new `mutaters` object
    initialize = function() {
      self$muts <- c(list(bool_true2false, bool_false2true), make_ops(ops))
      names(self$muts) <- vapply(self$muts, "[[", "", "name")
    },

    random = function() {
      if (length(self$muts) == 0) stop("no mutaters found")
      sample(self$muts, size = 1)[[1]]
    }
  ),
  private = list()
)
