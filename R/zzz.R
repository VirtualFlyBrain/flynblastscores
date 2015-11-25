#' @importFrom flycircuit load_si_data
.onAttach <- function(libname, pkgname) {
  options(rgl.useNULL=TRUE)
  options('flycircuit.scoremat'="allbyallblastcv4.5.ff")
  load_si_data('allbyallblastcv4.5.ff')
  scall.sampled=load_si_data("scall.sampled.rds")
  invisible()
}
