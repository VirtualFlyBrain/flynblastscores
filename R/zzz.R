#' @importFrom flycircuit load_si_data
.onLoad <- function(libname, pkgname) {
  # don't want to use rgl if we are in batch mode
  if(!interactive())
    options(rgl.useNULL=TRUE)

  options('flycircuit.scoremat'="allbyallblastcv4.5.ff")
  tryCatch(
    flycircuit::load_si_data('allbyallblastcv4.5.ff'),
    error=function(e) warning(e)
  )
  tryCatch(
    flycircuit::load_si_data("scall.sampled.bm.desc"),
    error=function(e) warning(e)
  )

  invisible()
}
