
# Code working on specific DB list in EirnchR
# GOdb <- c("GO_Biological_Process_2023", "GO_Cellular_Component_2023", "GO_Molecular_Function_2023","KEGG_2021_Human")

#' EnrichR2GOplot
#' @import dplyr
#' @param DEPs    dataframe DEPs have two columns that "GeneName" and "logFC"
#' @param GOdb   Working on default GOdb setting, GOdb <- c("GO_Biological_Process_2023", "GO_Cellular_Component_2023", "GO_Molecular_Function_2023","KEGG_2021_Human")
#' @param cutoff minimum significant adj.p-value for EnrichR  enrichment analysis
#'
#' @return Return Results of list, Gene Ontology, KEGG, and GOplot input (circ)
#' @export
#'
#' @examples
#' GOdb <- c("GO_Biological_Process_2023", "GO_Cellular_Component_2023", "GO_Molecular_Function_2023","KEGG_2021_Human")
#' colnames(DEPs) <- c("GeneName","logFC")
#' EnrichR2GOplot(DEPs, GOdb, 0.05)
#'
#'
#'
EnrichR2GOplot <- function(DEPs,GOdb, cutoff){
    if(missing(cutoff)){
        cutoff = 0.05
    }

    Merge_enrichR_export <- Merge_enrichR_forGOplot(DEPs,GOdb,cutoff)
    GO.result.all <- Merge_enrichR_export$EnrichR.GO

    #tag processing
    GOID.list <- GO.result.all$Term %>% stringr::str_split("\\(GO:")
    terms <- GOID.list %>% sapply(`[`,1)
    termIDs <- GOID.list %>% sapply(`[`,2) %>% gsub("\\)","", .) %>% paste0("GO:",.)

    GO.result.all$Term <- terms
    GO.result.all$ID <- termIDs

    GO.all.parse <- GO.result.all %>%
                        subset(., select=c("Category","ID","Term","Adjusted.P.value","Genes"))

    colnames(GO.all.parse) <- c("Category","ID","Term","adj_pval","Genes")
    DEPs <- DEPs %>% subset(select=c("GeneName","logFC"))
    colnames(DEPs) <- c("ID","logFC")
    GO.all.parse$Genes<- gsub(";",",",GO.all.parse$Genes)
    sig.GO.all.parse <- GO.all.parse %>% filter(adj_pval <= cutoff)


    Merge_enrichR_export$circ <- GOplot::circle_dat(sig.GO.all.parse, DEPs)

    return(Merge_enrichR_export)
}







