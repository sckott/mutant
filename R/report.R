mutant_report <- function(x) {
  # prepare report
  mutrep <- 'xx'
  # write to disk
  json <- jsonlite::toJSON(mutrep, auto_unbox = TRUE)
  jsonlite::write_json(json, "path")
  # write to cli
  # cat("write results to cli")
}
