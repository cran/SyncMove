\name{mci}
\alias{mci}
\title{Movement Coordination Index (MCI)}
\description{
    Computes the Movement Coordination Index as described in
    Mueller, T., et al. (2011).
}
\usage{mci(x)}
\arguments{
    \item{x}{
        data frame of synchronized relocations of a set of individuals.
        The data frame must containing the following columns:

        \emph{syncID}: numeric (integer), ID marking the synchronization
        event.  For each synchronization event every individual must have a
        record.  Therefore each ID must appear as often as every other ID
        (e.g. not c(1,1,1,2,2,3,3,3) but c(1,1,1,2,2,2,3,3,3)).
        
        \emph{utm.easting}: numeric, planar x coordinate.  Although the
        name indicates UTM coordinates other planar coordinate systems are
        also allowed.
        
        \emph{utm.northing}: analogue to \emph{utm.easting}

        (Further columns are allowed, but will be ignored.  Usually a column
        naming the individual is present in the data frame.)
        
        Such a data frame is returned by the function \code{syncSubsample}
        in package \code{SyncMove} (<output>$data[[i]]) with the argument
        \sQuote{completeSyncsOnly} set to TRUE.
    }    
}
\value{
    Returns a numeric vector of MCI values, one for each pair of
    subsequent synchronization events.
}
\author{
    Martin Rimmler (maintainer, martin.rimmler[AT]gmail.com),
    Thomas Mueller
}
\references{
    Mueller, T., et al. (2011) How landscape dynamics link
    individual- to population-level movement patterns: 
    a multispecies comparison of ungulate relocation data,
    Global Ecology and Biogeography, \bold{20}, pages 683--694.
}
\examples{
    # load example data
    data(gazelleRelocations) 

    # create input data frame
    syncRelocs <- syncSubsample(x = gazelleRelocations,
                                startSearch = "2007-09-05 00:00:00",
                                syncIntervalSecs = 3600*24*16,
                                syncAccuracySecs = 3600*24) 

    # calculate MCI
    mci(syncRelocs$data[[1]])
}
