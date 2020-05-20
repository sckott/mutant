#' mutant queue
#' @importFrom liteq xxx
#' @importFrom rappdirs user_cache_dir
#' @param x x
#' @param x x
queue <- function(temporary = TRUE) {
  assert(temporary, "logical")
  if (temporary) db_path <- tempfile()
  if (!temporary) {
    db_path <- file.path(rappdirs::user_data_dir("R/mutant"),
      basename(tempfile()))
  }
  q <- liteq::ensure_queue("jobs", db = db_path)

}

queue <- R6::R6Class(
  'queue',
  public = list(
    q = NULL,
    #' @description print method for `queue` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<queue> ", sep = "\n")
      for (i in seq_along(self$muts)) {
        cat(paste0("  mutant name: ", self$muts[[i]]$name), sep = "\n")
      }
      invisible(self)
    },

    #' @description Create a new queue object
    #' @return A new `queue` object
    initialize = function(temporary = TRUE) {
      assert(temporary, "logical")
      if (temporary) db_path <- tempfile()
      if (!temporary) {
        db_path <- file.path(rappdirs::user_data_dir("R/mutant"),
          basename(tempfile()))
      }
      self$q <- liteq::ensure_queue("jobs", db = db_path)
      return(self)
    },

    publish = function(title, message) {
      liteq::publish(self$q, title = title, message = message)
    },

    consume = function() {
      liteq::try_consume(self$q)
    }
  ),
  private = list()
)

