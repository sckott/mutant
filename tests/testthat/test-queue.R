test_that("queue", {
  expect_is(queue, "R6ClassGenerator")

  x <- queue$new()
  expect_is(x, "R6")
  expect_is(x, "queue")
  expect_output(x$print(), "<queue>")
  expect_output(x$print(), "queue path")
  expect_output(x$print(), "messages: empty")
  expect_is(x$q, "liteq_queue")
  expect_is(x$qpath, "character")
  expect_is(x$queue_path(), "character")
  expect_identical(x$qpath, x$queue_path())
  expect_is(x$messages(), "data.frame")
  expect_equal(NROW(x$messages()), 0)
  expect_equal(x$count(), 0)

  z <- list(
    path = tempfile(), 
    mutant_location = list(
      `some-file.R` = 
        list(line1 = 45, line2 = 46, column = 4, from = "==", to = ">")))
  x$publish(as.character(jsonlite::toJSON(z)))

  expect_equal(x$count(), 1)

  res <- x$messages()
  expect_is(res, "data.frame")
  expect_equal(NROW(res), 1)
  expect_type(res$id, "integer")
  expect_is(res$title, "character")
  expect_is(res$status, "character")
  expect_equal(res$status, "READY")

  # cleanup
  x$destroy()
})
