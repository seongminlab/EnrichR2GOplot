
# default Godb data setting
#GOdb <- c("GO_Biological_Process_2023", "GO_Cellular_Component_2023", "GO_Molecular_Function_2023","KEGG_2021_Human")

#' DEPs to EnrichR
#' @import enrichR
#' @param DEPs   as Data Frame that have "GeneName" Column in dataframe, essential
#' @param GOdb Define by enrichR pacakge, find from "https://maayanlab.cloud/Enrichr/#libraries"
#'
#' @return return Gene ontology results,  you can any database in EnrichR
#' @export
#'
#' @examples
#' DEPs2EncirhR(DEPs, GOdb)
DEPs2EncirhR <- function(DEPs, GOdb){
    library(enrichR)
    setEnrichrSite("Enrichr")
    GO.results <- enrichr(DEPs$GeneName, GOdb)
    return(GO.results)
}
