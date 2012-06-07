convertHapSNPsToArlequin
------------------------

An R function to convert a file containing population-specific haplotype SNPs
in a simple format to an Arlequin project file.  A number of options are
provided for controlling the output.

This tool is in no way affiliated with the Arlequin project, and its
capabilities are very limited.  It formats haplotypic SNP data and can format
very limited types of population structure. Arlequin's project file format can
contain much more information and a wider variety of data input formats (e.g.,
distance matrices) than the format used here.

The website for the current version of Arlequin (3.5) may be found at <http://popgen.unibe.ch/software/arlequin35/>.

* * *

### convertHapSNPsToArlequin.R

This file should be `source()`'d into R and defines the function `convertHapSNPsToArlequin()`

### example_data.txt

A very simple data file defining haplotypes for 13 individuals belonging to 3 populations

### example_output.arp

Contents in Arlequin project file format, which should be identical to the
output that should be produced by entering, within R:

    convertHapSNPsToArlequin(infile="example_data.txt")

As entered, the above will produce output to the file `example_data.txt.arp`.  Appending
`.arp` to the input filename is the default when no `outfile=` argument is provided.
To produce output directly within R without writing to a separate output
file, specify an empty output file name:

    convertHapSNPsToArlequin(infile="example_data.txt", outfile="")

