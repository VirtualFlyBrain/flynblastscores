# flynblastscores
R package to provide RESTful interface via opencpu to NBLAST scores for fly neurons

## Introduction

This package provides functions to simplify access to pre-computed 
[NBLAST](jefferislab.org/si/nblast) scores for fly neurons. There are two main
functions of interest 

`flycircuit_topn` returns scores for self-match queries for 
[flycircuit](http://flycircuit.tw) neurons.

`flycircuit_gmr_topn` returns scores for querying flycircuit neurons againt a
processed version of the [GMR Gal4 lines](flweb.janelia.org/cgi-bin/flew.cgi).

## Installation
Note that installing/using this package will trigger a one time download of about 1.5 Gb
of pre-computed NBLAST scores.

Currently there isn't a released version on [CRAN](http://cran.r-project.org/), 
but you  can use the **devtools** [1] package to install the development version:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferis/flynblastscores")
```

## Use

See 

http://vfbdev.inf.ed.ac.uk/ocpu/library/flynblastscores/man/flycircuit_topn

for more information


## Acknowledgements

Please be sure to cite the original data sources

* flycircuit.tw
* flweb.janelia.org/cgi-bin/flew.cgi

as well as the paper (currently available as a 
[biorxiv preprint](http://dx.doi.org/10.1101/006346)) describing the 
NBLAST algorithm if you use this package / data in published work.
