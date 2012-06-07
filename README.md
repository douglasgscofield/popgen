Population genetics
-------------------

A mish-mash of tools for population genetics, so far a few R scripts for loading,
converting and checking population genetics datasets.

* * *

### checkNullAlleles

An R function to compare genotypes against a set of reference genotypes and
look for genotypes that differ in a way consistent with the occurrence of a
null allele, that is, heterozygous in the reference and homozygous matching one
of the alleles in the heterozygous reference.

### convertHapSNPsToArlequin

An R function to convert a file containing population-specific haplotype SNPs
in a simple format to an Arlequin project file.  A number of options are
provided for controlling the output.

### readGenalex

An R function to read genotype data file in GenAlEx format, as exported from 
Excel as a delimited text file.  GenAlEx and its documentation are available
at <http://www.anu.edu.au/BoZo/GenAlEx/>.

