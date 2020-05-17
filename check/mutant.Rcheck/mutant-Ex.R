pkgname <- "mutant"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('mutant')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("mutate")
### * mutate

flush(stderr()); flush(stdout())

### Name: mutate
### Title: Mutate many
### Aliases: mutate

### ** Examples

## Not run: 
##D mutate()
## End(Not run)



cleanEx()
nameEx("mutate_one")
### * mutate_one

flush(stderr()); flush(stdout())

### Name: mutate_one
### Title: Mutate one
### Aliases: mutate_one

### ** Examples

## Not run: 
##D mutate_one()
## End(Not run)



cleanEx()
nameEx("parse_fxns")
### * parse_fxns

flush(stderr()); flush(stdout())

### Name: parse_fxns
### Title: Parse functions
### Aliases: parse_fxns
### Keywords: internal

### ** Examples

## Not run: 
##D parse_fxns()
## End(Not run)



cleanEx()
nameEx("run_test")
### * run_test

flush(stderr()); flush(stdout())

### Name: run_test
### Title: Run tests a single time
### Aliases: run_test run_tests
### Keywords: internal

### ** Examples

## Not run: 
##D path <- '/Users/sckott/github/ropensci/rredlist'
##D pkgmap <- make_pkg_map(path)
##D 
##D # single test
##D res <- run_test(pkgmap)
##D class(res)
##D res[[1]]
##D 
##D # many tests
##D out <- run_tests(pkgmap, times = 2)
##D length(out)
##D out[[1]]
##D out[[2]]
## End(Not run)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
