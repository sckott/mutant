mutant
======



[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
![R-CMD-check](https://github.com/sckott/mutant/workflows/R-CMD-check/badge.svg)

`mutant` - mutation testing

(wikipedia: [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing) vs. [fuzzing](https://en.wikipedia.org/wiki/Fuzzing))

## info

- mutaters: in `mutaters.R`
  - currently only have: 
    - boolean replacement (TRUE -> FALSE, and vice versa)
    - binary operator replacement (e.g., > to >=)

## install


```r
remotes::install_github("sckott/astr", "sckott/mutant")
```

## current workflow

As of this writing (2020-05-18) ...


```r
# path to an R package with working tests in tests/
path <- "../randgeo/" 
## collect fxns into an environment
env <- collect_fxns(path)
ls.str(env)
## make pkg map for later
pkgmap <- make_pkg_map(path)
## parse fxns with getParseData
# fxns <- parse_fxns(env)
## mutate something
mut_fxns <- mutate(as.list(env))
# what fxn was mutated?
which(vapply(mut_fxns, function(x) attr(x, "mutated"), logical(1)))
## write a new package with test suite to a tempdir
new_fxns <- make_fxns(mut_fxns)
newpath <- write_mutated_pkg(pkg_path = path, fxns = new_fxns, map = pkgmap)
## run test suite & collect diagnostics
mutout <- mutation_test(newpath)
# mutout
dplyr::select(data.frame(mutout), file, context, test, nb, failed, skipped, error, warning, passed)
```

This will all be internal code however - only exposing probably a few functions to users to 
run mutation testing, do something with results, etc.

## To do

brainstorming high level steps:

1. map input package api
    - optionally map what test lines are linked to what code lines ([#10](https://github.com/sckott/mutant/issues/10))
2. generate mutants
    - each of these are full packages, which with a different mutation
3. put all mutants in a queue ([#2](https://github.com/sckott/mutant/issues/2))
4. test all mutants - pull jobs from the queue until all are done
5. collate results, write to disk

## Meta

* Please [report any issues or bugs](https://github.com/sckott/mutant/issues).
* License: MIT
* Get citation information for `mutant` in R doing `citation(package = 'mutant')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[coc]: https://github.com/sckott/mutant/blob/master/CODE_OF_CONDUCT.md
