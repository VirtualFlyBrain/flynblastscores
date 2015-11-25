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
#'   \item id Flycircuit Neuron name (or GMR id for \code{flycircuit_gmr_topn})
#'
#'   \item score NBLAST score (normalised -1 (bad) to +1 (perfect)). Scores
#'   above 0 are potentially interesting, scores above about 0.4 seriously
#'   interesing.
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

gmr_from_path<-function(x){
  sub("GMR_([0-9]{1,2}[A-H][0-9]{2})_.*","\\1",basename(x))
}

#' @description \code{flycircuit_gmr_topn} finds the top GMR Gal4 lines matching
#'   a FlyCircuit neuron query.
#' @examples
#' flycircuit_gmr_topn("VGlut-F-200269")
#' @export
flycircuit_gmr_topn<-function(query, n=50) {
  if(length(query)!=1) stop("Expects exactly one query neuron")
  query=fc_gene_name(query)
  sc=scall.sampled[,query]
  topn=sort(sc, decreasing = TRUE)[seq_len(n)]
  self_score=fc_nblast(query, query,normalisation = )
  data.frame(id=gmr_from_path(names(topn)), score=unname(topn)/self_score)
}
