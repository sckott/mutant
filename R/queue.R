#' @title mutant queue
#' @description queue R6 class, for queueing mutant jobs
#' @importFrom liteq ensure_queue publish try_consume
#' @importFrom rappdirs user_data_dir
#' @importFrom uuid UUIDgenerate
#' @examples \dontrun{
#' x <- queue$new()
#' x
#' x$q
#' x$queue_path()
#' x$messages()
#' z <- list(
#'   path = tempfile(), 
#'   mutant_location = list(
#'     `some-file.R` = 
#'       list(line1 = 45, line2 = 46, column = 4, from = "==", to = ">")))
#' x$publish(as.character(jsonlite::toJSON(z)))
#' x
#' x$messages()
#' mssg <- x$consume()
#' mssg
#' mssg$title
#' mssg$message
#' jsonlite::fromJSON(mssg$message)
#' x$messages()
#' x$done(mssg)
#' x$messages()
#' x
#' }
queue <- R6::R6Class(
  'queue',
  public = list(
    #' @field q (liteq_queue) the liteq queue object
    q = NULL,
    #' @field qpath (character) path to the queue on disk
    qpath = NULL,

    #' @description print method for `queue` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<queue> ", sep = "\n")
      cat(paste0("  queue path: ", self$qpath), sep = "\n")
      msgs <- self$messages()
      if (NROW(msgs) == 0) {
        cat("  messages: empty", sep = "\n")
      } else {
        cat("  messages (first 10): ", sep = "\n")
        print(head(msgs, n = 10))
      }
      invisible(self)
    },

    #' @description Create a new queue object
    #' @return A new `queue` object
    #' @param temporary (logical) create a temporary queue that is cleaned up
    #' at the end of your R session? default: `TRUE`. if `FALSE`, we use
    #' [rappdirs::user_data_dir()] to cache the file. use `$queue_path()`
    #' to get the path for the queue
    initialize = function(temporary = TRUE) {
      assert(temporary, "logical")
      if (temporary) db_path <- tempfile()
      if (!temporary) {
        db_path <- file.path(rappdirs::user_data_dir("R/mutant"),
          basename(tempfile()))
      }
      self$qpath <- db_path
      self$q <- liteq::ensure_queue("jobs", db = db_path)
      return(self)
    },

    #' @description publish a job into the queue
    #' @param message (character) job message, a JSON string with fields
    #' `path` and `mutant_location`, for the file path to the mutated 
    #' package to test and information on the location of the mutation,
    #' respectively
    #' @param title (character) job title, a UUID, generated from
    #' [uuid::UUIDgenerate()]
    publish = function(message, title = uuid::UUIDgenerate()) {
      assert(title, "character")
      assert(message, "character")
      liteq::publish(self$q, title = title, message = message)
    },

    #' @description consume a job from the queue
    consume = function() liteq::try_consume(self$q),

    #' @description tell the queue the job can be removed from the queue
    #' @param message (character) message object, of class `liteq_message`
    done = function(message) liteq::ack(message),

    #' @description list jobs in the queue
    messages = function() liteq::list_messages(self$q),
    #' @description count jobs in the queue
    count = function() liteq::message_count(self$q),

    #' @description fetch the queue path. `NULL` if there's no queue
    queue_path = function() self$qpath,

    #' @description destroy the queue - in practice this only means
    #' deleting the SQLite file
    destroy = function() unlink(self$qpath, recursive = TRUE)
  ),
  private = list()
)
