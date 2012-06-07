checkNullAlleles
----------------

Compare genotypes against a set of reference genotypes and look for genotypes
that differ in a way consistent with the occurrence of a null allele, that is,
heterozygous in the reference and homozygous matching one of the alleles in
the heterozygous reference.

The function is called as:

    checkNullAlleles(refgt, comparegt, quiet=FALSE)

which checks for null alleles in `comparegt`, when compared against `refgt`.  `refgt`
and `comparegt` may be filenames (files must be in GenAlEx format) or they may be
a GenAlEx dataframe loaded earlier using the `readGenalex()` function.

Set `quiet=TRUE` if you don't want `checkNullAlleles` to print informational 
messages in addition to the null allele reports.

The reference and compare genotypes are in GenAlEx format, and are either read
in within `checkNullAlleles()` or are presented as dataframes read by
`readGenalex()`.  `readGenalex()` and its associated functions must be available,
and can be found at 

    https://github.com/douglasgscofield/popgen

