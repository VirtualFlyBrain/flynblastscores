#' Fetch precomputed nblast scores between flycircuit neurons
#' @inheritParams flycircuit::fc_nblast
#' @export
flycircuit_nblast<-function (query, target, normalisation = c("normalised", "mean", "raw")) {
  normalisation=match.arg(normalisation)
  flycircuit::fc_nblast(query, target, scoremat = "allbyallblastcv4.5",
                        normalisation = normalisation)
}

#' NBLAST a single flycircuit neuron against database and return scores
#'
#' @param query A flycircuit identifier
#' @param n The number of scores to return (if \code{n=0} or \code{n} is greater
#'   than the number of scores, then all scores are returned.
#' @param ... Additional arguments passed to \code{\link{flycircuit_nblast}}
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
#'
#' ## simple version collecting json results directly (RECOMMENDED)
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/R/flycircuit_topn/json \
#'   -d 'query="FruMARCM-M002262_seg001"'
#' # top 3 hits only
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/R/flycircuit_topn/json \
#'   -d 'query="FruMARCM-M002262_seg001"&n=3'
#'
#' ## more flexible version
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/R/flycircuit_topn \
#'   -d 'query="FruMARCM-M002262_seg001"'
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
#' curl http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/R/flycircuit_topn \
#'   -d 'query="fru-M-200266"&n=10'
#' }
#' @export
flycircuit_topn<-function (query, n=50, ...) {
  if(length(query)!=1) stop("Expects exactly one query neuron")
  sc=flycircuit_nblast(query,...)
  topn=sort(sc, decreasing = TRUE)
  if(is.finite(n) && n>0 && n<length(topn)) topn=topn[seq_len(n)]
  data.frame(id=flycircuit::fc_neuron(names(topn)), score=unname(topn),
             stringsAsFactors = FALSE)
}

gmr_from_path<-function(x){
  sub("GMR_([0-9]{1,2}[A-H][0-9]{2})_.*","\\1",basename(x))
}

#' @description \code{flycircuit_gmr_topn} finds the top GMR Gal4 lines matching
#'   a FlyCircuit neuron query.
#' @examples
#' # NBLAST a flycircuit neuron
#' qid="VGlut-F-100184"
#' res=flycircuit_gmr_topn(qid)
#' res
#'
#' # return all results
#' resall=flycircuit_gmr_topn(qid, n=0)
#' nrow(resall)
#'
#' # look at co-registered top hits on VFB
#' if(require('vfbr')){
#'  # find vfb ids for hits
#'  vfbids=vfbr::gmr_vfbid(res$id)
#'  # find vfb id for query
#'  qvfbid=vfb_tovfbids(qid)
#'  # stack browser URL for query neuron and top 10 hits
#'  u=vfb_stack_url(rev(c(qvfbid, vfbids[1:10])), clear = TRUE)
#'  \dontrun{
#'  browseURL(u)
#'  }
#' }
#'
#' @export
#' @rdname flycircuit_topn
flycircuit_gmr_topn<-function(query, n=50) {
  if(length(query)!=1) stop("Expects exactly one query neuron")
  query=flycircuit::fc_gene_name(query)
  scoremat <- flycircuit::fc_attach_bigmat('scall.sampled.bm')
  sc=scoremat[,query]
  topn=sort(sc, decreasing = TRUE)
  if(is.finite(n) && n>0 && n<length(topn)) topn=topn[seq_len(n)]

  self_score=flycircuit::fc_nblast(query, query,normalisation = )
  data.frame(id=gmr_from_path(names(topn)), score=unname(topn)/self_score,
             stringsAsFactors = FALSE)
}
