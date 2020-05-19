#' Make a package map
#' 
#' Using [pkgapi::map_package()]
#' 
#' @param path (character) path to a package, default: current directory
#' @return the output from [pkgapi::map_package()]; a thin wrapper around
#' that fxn
make_pkg_map <- function(path = ".") {
  pkgapi::map_package(path)
}
