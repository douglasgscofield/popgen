Population genetics
-------------------

A collection of tools for population genetics, so far a few R scripts for loading,
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
Excel as a delimited text file, into an annotated `data.frame`.  Several
functions are provided for accessing and printing this data.  GenAlEx and its
documentation are available at <http://www.anu.edu.au/BoZo/GenAlEx/>.

    > source("readGenalex-0.2.R")
    > refgt <- readGenalex("reference_genotypes.txt")
    > refgt
        id Site loc1 loc1.2 loc2 loc2.2 loc3 loc3.2 loc4 loc4.2 loc5 loc5.2
    1 ref1    1    3      3    2      3    2      2    3      3    4      3
    2 ref2    1    2      3    1      1    2      4    3      3    6      1
    3 ref3    1    3      3    2      3    2      2    3      1    4      2
    4 ref4    1    3      3    2      1    2      2    3      1    2      3
    5 ref5    1    1      1    1      3    2      5    3      3    6      2
    6 ref6    1    1      1    2      1    2      5    2      3    3      1
    > attributes(refgt)
    $names
     [1] "id"     "Site"   "loc1"   "loc1.2" "loc2"   "loc2.2" "loc3"   ...
    $row.names
    [1] 1 2 3 4 5 6
    
    $class
    [1] "data.frame"
    
    $n.loci
    [1] 5
    
    $ploidy
    [1] 2
    
    $n.samples
    [1] 6
     
    ...
