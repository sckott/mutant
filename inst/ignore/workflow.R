path <- "../randgeo/"

# workflow
## collect fxns into an environment
env <- collect_fxns(path)
# ls.str(env)
## make pkg map for later
pkgmap <- make_pkg_map(path)
## parse fxns with getParseData
# fxns <- parse_fxns(env)
## mutate something
fxns <- as.list(env)
mut_fxns <- mutate(fxns)
# what fxn was mutated?
which(vapply(mut_fxns, function(x) attr(x, "mutated"), logical(1)))
## write a new package with test suite to a tempdir
new_fxns <- make_fxns(mut_fxns)
newpath <- write_mutated_pkg(pkg_path = path, fxns = new_fxns, map = pkgmap)
newpath
 # list.files(path)
## run test suite & collect diagnostics
x=newpath
mutout <- mutation_test(newpath)
# mutout
dplyr::select(data.frame(mutout), file, context, test, nb, failed, skipped, error, warning, passed)
## create report
# mutant_report(mutout)
