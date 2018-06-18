library(RefManageR)
bib=ReadBib('data-raw/NBLAST.bib')
dput(bib, 'inst/CITATION')
