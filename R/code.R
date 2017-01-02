path <- "../taxa/"

extract_funcs <- function(path) {
  get_fxns(get_files(path), env = myenv)
  # xml <- xml_parse_data(parse(text = paste0(deparse(myenv$which_ranks), collapse = ""), keep.source = TRUE))
  # xml_doc <- xml2::read_xml(xml)
  # xml2::xml_find_all(xml_doc, "//EQ")
  pp <- parse(text = paste0(deparse(myenv$which_ranks), collapse = ""), keep.source = TRUE)
  parse_data <- getParseData(pp)

  # e.g., replace any EQ with a different one
  out <- parse_data[parse_data$token == "EQ", "text"]
  parse_data[parse_data$token == "EQ", "text"] <- replace_eq(out)

  # remake fxn
  new_fxn <- paste0(parse_data$text, collapse = "")

  # write to file
  tfile <- tempfile(fileext = ".R")
  writeLines(new_fxn, con = file(tfile))
}

get_files <- function(path = ".") functionMap:::r_package_files(path)

myenv <- new.env()

get_fxns <- function(x, env) invisible(lapply(x, source, local = env))

replace_eq <- function(x) {
  eq_ops <- c("==", "!=", "<=", ">=", ">", "<")
  sample(eq_ops[!eq_ops %in% x], size = 1)
}


# function(x) {
#   as.numeric(ranks_ref[which(sapply(ranks_ref$ranks, function(z) {
#     any(unlist(strsplit(z, split = ",")) == x)
#   }, USE.NAMES = FALSE)), "rankid"])
# }
