# Copyright (c) 2008-2011, Douglas G. Scofield douglasgscofield@gmail.com
#
# Read genotype data file in GenAlEx format. GenAlEx and its documentation are
# available from http://www.anu.edu.au/BoZo/GenAlEx/
#
# GenAlEx format is derived from its described cell formats in Excel, and is for
# now assumed to be held in a delimited file exported in this format.
#
# num.loci      num.samples num.pops    num.pop1   num.pop2     ...
# title         blank       blank       label.pop1 label.pop2   ...
# sample.header pop.header  name.loc1   blank      name.loc2    blank ...
# id.sample1    id.pop1     loc1.al1    loc1.al2   loc2.al1     loc2.al2 ...
# id.sample2    id.pop1     loc1.al1    loc1.al2   loc2.al1     loc2.al2 ...
#
# Calling readGenalex() for a file first reads the top 3 header lines, then
# reads the remainder of the file checking for consistency with the data
# description from the header lines.

.readGenalexVersion <- "0.2"

readGenalex <- function(file, sep="\t", ploidy=2)
{
    if (ploidy != 2) warning("ploidy other than 2 not tested")
    fcon <- file(description=file, open="rt")
    header <- .readGenalexHeader(fcon, sep, ploidy)
    raw.data <- .readGenalexData(fcon, sep, header$data.column.names,
                                 header$n.samples, header$n.loci, 
                                 ploidy)
    close(fcon)
    dat <- .readGenalexJoinData(header, raw.data)
    attr(dat, "data.file.name") <- file
    attr(dat, "genetic.data.format") <- "genalex"
    dat
}

dropGenalexLoci <- function(dat, drop.loci, quiet=FALSE)
{
    if (is.null(drop.loci)) return(dat)
    locus.names <- attr(dat, "locus.names")
    if (! all(drop.loci %in% locus.names))  
        if (any(drop.loci %in% locus.names)) # at least one matches
          drop.loci <- drop.loci[drop.loci %in% locus.names]
        else
          if (quiet) 
              return(dat) 
          else 
              stop("locus not present")
    att <- attributes(dat)
    dat <- dat[,-computeGenalexColumns(dat, drop.loci)]
    for (a in names(att))
        if (! a %in% c("names","n.loci","locus.names","locus.columns"))
            attr(dat,a) <- att[[a]]
    locus.names <- locus.names[! locus.names %in% drop.loci]
    attr(dat, "n.loci") <- length(locus.names)
    attr(dat, "locus.names") <- locus.names
    attr(dat, "locus.columns") <- which(names(dat) %in% locus.names)
    dat
}

printGenalexGenotype <- function(dat, rows, callout.locus=NULL, 
                                   sep=" ", allele.sep="/", 
                                   callout.char="*", label=NULL)
{
    cols <- names(dat)
    ploidy <- attr(dat, "ploidy")
    for (row in rows) {
        cat(paste(sep=sep, collapse=sep, dat[row,cols[1:2]]))
        if (! is.null(label))
            cat("", label)
        full.gt <- ""
        for (col in seq(from=3, to=length(cols), by=ploidy)) {
            gt <- paste(collapse=allele.sep, dat[row,col:(col+ploidy-1)])
            if (cols[col] %in% callout.locus) 
                gt <- paste(sep="", callout.char, gt, callout.char)
            full.gt <- paste(sep=sep, collapse=sep, full.gt, gt)
        }
        cat(full.gt,"\n")
    }
}

reorderGenalexLoci <- function(dat, loci)
{
    existing.loci <- attr(dat, "locus.names")
    if (! all(existing.loci %in% loci)) 
        stop("not all existing loci in reorder list")
    newdata <- dat[,1:2]
    for (locus in loci) {
        newdata <- cbind(newdata, getGenalexLocus(dat, locus))
    }
    names.newdata <- names(newdata)
    attributes(newdata) <- attributes(dat)
    names(newdata) <- names.newdata
    attr(newdata,"locus.names") <- loci
    newdata
}

computeGenalexColumns <- function(dat, locus, ploidy=NULL)
{
    if (is.null(ploidy)) ploidy <- attr(dat,"ploidy")
    as.vector(sapply(attr(dat, "locus.columns")[attr(dat, "locus.names") %in% locus],
                     function(x) x:(x+ploidy-1)))
}

putGenalexLocus <- function(dat, locus, newdata)
{
    is.genalex(dat)
    dat[, computeGenalexColumns(dat,locus)] <- newdata
    dat
}

getGenalexLocus <- function(dat, locus, pop=NULL)
{
    is.genalex(dat)
    if (! is.null(pop)) {
        pop.column <- attr(dat, "pop.title")
        dat <- subset(dat, dat[[pop.column]] %in% pop)
    }
    dat[, computeGenalexColumns(dat,locus)]
}

.readGenalexJoinData <- function(header, dat)
{
    names(dat) <- header$data.column.names
    # names(dat) <- c(header$sample.title, header$pop.title,
    #                  unlist(lapply(header$locus.names, 
    #                                function(x) c(x, 
    #                                              paste(sep=".", x, 
    #                                                    seq(2, header$ploidy, 1))))))
    dat[[header$pop.title]] <- factor(dat[[header$pop.title]])
    if (any(sort(levels(dat[[header$pop.title]])) != sort(header$pop.labels))) {
        err <- paste(collapse=",",sort(header$pop.labels)[sort(levels(dat[[header$pop.title]])) != sort(header$pop.labels)])
        stop("population labels ",err," do not match in header and data")
    }
    pops.in.order <- names(header$pop.sizes)
    if (any(table(dat[[header$pop.title]])[pops.in.order] != header$pop.sizes)) {
        err <- paste(collapse=",",header$pop.labels[table(dat[[header$pop.title]]) != header$pop.sizes])
        stop("population sizes ",err," do not match in header and data")
    }
    for (nm in names(header)) attr(dat, nm) <- header[[nm]]
    dat
}

.readGenalexHeader <- function(con, sep, ploidy)
{
    dlines <- readLines(con=con, n=3, ok=FALSE)
    dlines <- lapply(dlines, function(x) unlist(strsplit(x, sep, perl=TRUE)))
    dlines[[1]] <- as.numeric(dlines[[1]])
    header <- list(n.loci=dlines[[1]][1], 
                   ploidy=ploidy,
                   n.samples=dlines[[1]][2], 
                   n.pops=dlines[[1]][3],
                   dataset.title=dlines[[2]][1],
                   sample.title=dlines[[3]][1],
                   pop.title=dlines[[3]][2])
    header$pop.labels <- dlines[[2]][4:(4+header$n.pops-1)]
    pop.sizes <- dlines[[1]][4:(4+header$n.pops-1)]
    names(pop.sizes) <- header$pop.labels
    header$pop.sizes <- pop.sizes
    header$locus.columns <- seq(from=3, to=(3+(header$n.loci-1)*ploidy), by=ploidy)
    header$locus.names <- dlines[[3]][header$locus.columns]
    header$data.column.names <- c(header$sample.title, header$pop.title,
                                  unlist(lapply(header$locus.names, 
                                                function(x) c(x, 
                                                              paste(sep=".", x, 
                                                                    seq(2, header$ploidy, 1))))))
    ####
    header
}

.readGenalexData <- function(con, sep, col.names, n.samples, n.loci, ploidy)
{
    classes <- c("character","character",rep("character",n.loci*ploidy))
    # switch to scan() so that we can handle data lines that contain more trailing column 
    # separators than data dolumns, due to what Excel does when exporting tab-delimited files
    # dat <- read.table(file=con, sep=sep, header=FALSE, nrows=n.samples, 
    #                   col.names=col.names, colClasses=classes, flush=TRUE)
    what <- sapply(classes, do.call, list(0))
    names(what) <- col.names
    dat <- scan(file=con, what=what, nmax=n.samples, flush=TRUE, quiet=TRUE)
    dat <- as.data.frame(dat, stringsAsFactors=FALSE)
    ####
    dat
}

is.genalex <- function(checkdata)
{
    if (attr(checkdata,"genetic.data.format") != "genalex")
        stop("data not genalex format")
    TRUE
}

