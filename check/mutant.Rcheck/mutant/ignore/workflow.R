path <- "../../ropensci/phylocomr//"

# workflow
## collect fxns into an environment
collect_fxns(path)
## make pkg map for later
pkgmap <- make_pkg_map(path)
## parse fxns with getParseData
fxns <- parse_fxns()
## mutate something
mut_fxns <- mutate(fxns)
## write a new package with test suite to a tempdir
new_fxns <- make_fxns(mut_fxns)
path <- write_mutated_pkg(pkg_path = path, fxns = new_fxns)
## run test suite & collect diagnostics
mutout <- mutation_test(path)
## create report
mutant_report(mutout)
