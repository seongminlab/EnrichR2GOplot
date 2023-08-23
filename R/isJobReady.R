#' jobID for Uniprot accession to gene name
#'
#' @param jobId   jobID , function automatically call out by other functions
#' @import httr
#' @return return jobID to function UniprotAccession2GeneID
#' @export
#'
#' @examples
#' isJobReady(jobID)
isJobReady <- function(jobId) {

    pollingInterval = 5
    nTries = 20
    for (i in 1:nTries) {
        url <- paste("https://rest.uniprot.org/idmapping/status/", jobId, sep = "")
        r <- GET(url = url, accept_json())
        status <- content(r, as = "parsed")
        if (!is.null(status[["results"]]) || !is.null(status[["failedIds"]])) {
            return(TRUE)
        }
        if (!is.null(status[["messages"]])) {
            print(status[["messages"]])
            return (FALSE)
        }
        Sys.sleep(pollingInterval)
    }
    return(FALSE)
}
