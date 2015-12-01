#' Return the location in which external data (i.e. score matrices) are stored
#'
#' @return Character vector defining path
#' @export
flynblastscores_storage_dir<-function() {
  getOption('flycircuit.datadir')
}
