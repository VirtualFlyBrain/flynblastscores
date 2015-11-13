#' @importFrom flycircuit load_si_data
.onAttach <- function(libname, pkgname) {
  options(rgl.useNULL=TRUE)
  options('flycircuit.scoremat'="allbyallblastcv4.5.ff")
  flycircuit::fc_attach_bigmat('allbyallblastcv4.5.ff')
  invisible()
}
