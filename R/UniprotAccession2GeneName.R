#Accession <- c("O95905-1","P04439-2","P08246","P62805)


#' UniprotAccession2GeneName
#' Version update 1.1
#' @import dplyr
#' @import httr
#' @param Accession Uniprot Accession ID,  support to isoforms format Oxxxx-1 , Import by Vector format ,  Verification required for legacy Accession number such as A00XXXX
#'
#' @return  Return dataframe that have Three columns "Input accession" ,
#' @export
#'
#' @examples
#' Accession <- c("O95905-1","P04439-2","P08246")
#' UniprotAccession2GeneName(Accession)
#'
UniprotAccession2GeneName <- function(Accession){
    Entry <- strsplit(Accession, "-") %>% as.data.frame() %>% .[1,]  %>% unname
    Import <- data.frame(Accession, Entry %>% t)
    colnames(Import) <- c("Accession","Entry")

    getResultsURL <- function(redirectURL) {    # Function from Uniprot API resource
        if (grepl("/idmapping/results/", redirectURL, fixed = TRUE)) {
            url <- gsub("/idmapping/results/", "/idmapping/stream/", redirectURL)
        } else {
            url <- gsub("/results/", "/results/stream/", redirectURL)
        }
    }
    files = list(
        ids = paste(unique(Import$Entry),collapse=" ,") ,    # important!!
        from = "UniProtKB_AC-ID",
        to = "Gene_Name"
    )
    r <- POST(url = "https://rest.uniprot.org/idmapping/run", body = files, encode = "multipart", accept_json())
    submission <- content(r, as = "parsed")

    if (isJobReady(submission[["jobId"]])) {   # Function from isJobReady.R file
        url <- paste("https://rest.uniprot.org/idmapping/details/", submission[["jobId"]], sep = "")
        r <- GET(url = url, accept_json())
        details <- content(r, as = "parsed")
        url <- getResultsURL(details[["redirectURL"]])
        # Using TSV format see: https://www.uniprot.org/help/api_queries#what-formats-are-available
        url <- paste(url, "?format=tsv", sep = "")
        r <- GET(url = url, accept_json())
        resultsTable = read.table(text = content(r), sep = "\t", header=TRUE)
        #print(resultsTable)
        unique.resultTable<- resultsTable %>% rename(., all_of(c(Entry="From",Genes="To")))  %>% aggregate(.,Genes~.,FUN=paste,collapse=",") %>% data.frame
        resultsTable <- unique.resultTable %>% mutate(File=as.character(Genes)) %>% separate(File,c("GeneName"), sep=",")  %>% select(c(Entry,GeneName))

        return(full_join(Import,resultsTable,by="Entry" ))
    }
}

