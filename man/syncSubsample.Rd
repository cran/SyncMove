\name{syncSubsample}
\alias{syncSubsample}
\title{
    Subsamples Temporal Data to Synchronal Events    
} 
\description{
    Subsamples temporal records of different entities to a data set
    which only includes records that occur at predefined and equally
    spaced synchronization events.  A subsample is created for each
    possible combination of entities (unless restricted by argument
    \emph{minEntities}, \emph{maxEntities} or \emph{mustEntities}).
} 
\usage{
    syncSubsample(
        x,
        startSearch = min(as.character(x$study.local.timestamp)),
        endSearch = max(as.character(x$study.local.timestamp)),
        syncIntervalSecs = 3600,
        syncAccuracySecs = 60,
        minEntities = 2,
        maxEntities = length(unique(x$individual.local.identifier)),
        mustEntities = NULL,
        completeSyncsOnly = TRUE,
        fast = TRUE
    )
}
\arguments{
    \item{x}{
        a data frame with the following columns (further columns are
	allowed, but will be ignored):
	
	\emph{individual.local.identifier}: character, entity ID

	\emph{study.local.timestamp}: character, time of format
	"YYYY-MM-DD HH:MM:SS"
	
	Such a data frame can be created by importing data from
	www.movebank.org.

	
	If the output is to be processed with function \code{mci} the
	data frame must also contain the following columns:

	\emph{utm.easting}: numeric, planar x coordinate.  Although the
        name indicates UTM coordinates other planar coordinate systems
        are also allowed.
        
        \emph{utm.northing}: analogue to \emph{utm.easting}
    } 
    \item{startSearch}{
        character, time of format "YYYY-MM-DD HH:MM:SS" as the start
	time for the creation of synchronization events.  Default is
	the minimum timestamp in the data.	
    } 
    \item{endSearch}{
        analogue to \emph{startSearch}.
    } 
    \item{syncIntervalSecs}{
        numeric, interval between synchronization events in seconds.
	(e.g., \emph{60*60*24*3} defines a three day interval)	
    } 
    \item{syncAccuracySecs}{
        numeric, accuracy for synchronization events in seconds.
        (e.g., \emph{60*60*2} defines a two hour accuracy)	
    } 
    \item{minEntities}{
        numeric, minimum number of entities to be included in the
	synchronization events.	
    } 
    \item{maxEntities}{
        analogue to \emph{minEntities}
    } 
    \item{mustEntities}{
        character, vector of IDs of entities which have to be included in
        the synchronization events.	
    } 
    \item{completeSyncsOnly}{
        boolean, if TRUE (default) only events will appear in the output
	where each entity of a given combination of entities has a
	record.  If FALSE also events with no records for some entities
        will appear in the output.	
    } 
    \item{fast}{
        boolean, if TRUE (default) synchronized subsamples are created
	only for those combinations of entities that seem to be the most
	prominent in the input data.  If FALSE synchronized subsamples
	are created for all combinations of entities in the input data.
	See details.	
    } 
} 
\details{
    The synchronization events are created with a start time as the first
    synchronization event (argument \emph{startSearch}) and an interval
    between following synchronization events.  Each synchronization
    event has an accuracy.  All records of a given combination of
    entities which fall into \emph{synchronization events + - accuracy}
    are selected for the subsample.  If there is more than one record
    for an entity in a \emph{synchronization event + - accuracy} the
    record that is closest to the synchronization event is selected. The
    arguments \emph{startSearch}, \emph{syncIntervalSecs} and
    \emph{syncAccuracySecs} must be chosen with respect to the input
    data in order to get good synchronization results.

    Running the function with \emph{fast = FALSE} one can find the
    combination of entities with the maximum number of synchronization
    events.  However, an input data set with more then 8 to 10 entities
    should be processed with \emph{fast = TRUE}.  Otherwise the
    calculations can take a long time.  (For input data with 10 entities
    there are more than 1000 possible combinations of entities.)    

    The synchronization events are numbered from 1 to n.  These numbers
    are referred to as sync IDs.  If no records are present at a given
    synchronization event the ID for this event will not appear in the
    output subsample. Thus the sync IDs in the subsample show if
    subsequent pairs of synchronized events exist (e.g., sync ID
    1 and 2, sync ID 2 and 3, ...).  Such pairs can be used to calculate
    the Movement Coordination Index, see function \code{mci}.
} 
\value{
    List, returns a list with 3 elements named \emph{overview},
    \emph{data}, and \emph{entities}.    
    \item{overview}{
        An overview of the synchronized subsamples for all possible
	combinations of entities.  Each row refers to the respective
	element in the \emph{data} and \emph{entities} lists (see
	below).  E.g., for the data described in row 1 see
	<output>$data[[1]] and <output>$entities[[1]].  The overview
	table contains the following columns:

	\emph{numberOfEntities}: the number of entities used for
	creating the subsample
	
	\emph{numberOfSyncs}: number of synchronized events in the
	subsample

	\emph{numberOfSubsequentSyncs}: number subsequent synchronized
	events (see details)
	
	\emph{firstEvent}: time of first synchronization event

	\emph{lastEvent}: analogue to \emph{lastEvent}

	\emph{syncIntervalSecs}: interval used for creating the
	synchronization events
	
	\emph{syncAccuracySecs}: accuracy of the synchronization events
    } 
    \item{data}{
        A list containing the subsampled data described in the overview.
        The subsamples have the same columns as the input data set plus
	the additional columns \emph{syncTime} and \emph{syncID} for the
        time and ID of the synchronization events respectively.	
    } 
    \item{entities}{
        A list containing the entity combinations used for creating the
	synchronized subsamples.	
    } 
} 
\author{
    Martin Rimmler (maintainer, martin.rimmler[AT]gmail.com),
    Thomas Mueller
}
\examples{
    # load example data
    data(gazelleRelocations)

    # subsample sychronal events
    syncRelocs <- syncSubsample(x = gazelleRelocations,
                                startSearch = "2007-09-05 00:00:00",
                                syncIntervalSecs = 3600*24*16,
                                syncAccuracySecs = 3600*24)

    # show results overview
    syncRelocs$overview

    # show first subsample
    syncRelocs$data[[1]]

    # show entities of first subsample
    syncRelocs$entities[[1]]
}
