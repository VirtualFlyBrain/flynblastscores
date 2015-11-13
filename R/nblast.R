#' Fetch precomputed nblast scores between flycircuit neurons
#' @inheritParams flycircuit::fc_nblast
#'
#' @export
flycircuit_nblast<-function (query, target, normalisation = c("normalised", "mean", "raw")) {
  normalisation=match.arg(normalisation)
  flycircuit::fc_nblast(query, target, scoremat = "allbyallblastcv4.5",
                        normalisation = normalisation)
}

#' NBLAST a single flycircuit neuron against database and return scores
#'
#' @param query A flycircuit identifier
#' @param n The number of scores to return
#' @return a data.frame in descending score order with columns \itemize{
#'
#'   \item id Flycircuit Neuron name
#'
#'   \item score NBLAST score
#'
#'   }
#' @examples \dontrun{
#' ## example of remote call via curl
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/R/flycircuit_topn -d 'query="FruMARCM-M002262_seg001"'
#' # (return value looks like this and includes sesion key)
#' /ocpu/tmp/x05f62b2975/R/.val
#' /ocpu/tmp/x05f62b2975/messages
#' /ocpu/tmp/x05f62b2975/stdout
#' /ocpu/tmp/x05f62b2975/source
#' /ocpu/tmp/x05f62b2975/console
#' /ocpu/tmp/x05f62b2975/info
#' /ocpu/tmp/x05f62b2975/files/DESCRIPTION
#'
#' # now collect results
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/tmp/x05f62b2975/R/.val/json
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/tmp/x05f62b2975/R/.val/csv
#'
#' # specify number of hits, use "neuron" identifier
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/R/flycircuit_topn -d 'query="fru-M-200266"&n=10'
#' }
#' @export
flycircuit_topn<-function (query, n=50, ...) {
  if(length(query)!=1) stop("Expects exactly one query neuron")
  sc=flycircuit_nblast(query,...)
  topn=sort(sc, decreasing = TRUE)[seq_len(n)]
  data.frame(id=fc_neuron(names(topn)), score=unname(topn))
}
