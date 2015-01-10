Population genetics
===================

A collection of tools for population genetics, so far a few R scripts for loading,
converting and checking population genetics datasets.

* * *

checkNullAlleles
----------------

An R function to compare genotypes against a set of reference genotypes and
look for genotypes that differ in a way consistent with the occurrence of a
null allele, that is, heterozygous in the reference and homozygous matching one
of the alleles in the heterozygous reference.


convertHapSNPsToArlequin
------------------------

An R function to convert a file containing population-specific haplotype SNPs
in a simple format to an Arlequin project file.  A number of options are
provided for controlling the output.

