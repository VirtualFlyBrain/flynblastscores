#' @importFrom flycircuit load_si_data
.onAttach <- function(libname, pkgname) {
  options(rgl.useNULL=TRUE)
  load_si_data("allbyallblastcv4.5.ff")
  options('flycircuit.scoremat'="allbyallblastcv4.5.ff")
  invisible()
}
