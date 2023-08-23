



cutoff=0.05
Merge_enrichR_forGOplot <- function(DEPs,GOdb, cutoff){
    if(missing(cutoff)){
        cutoff = 0.05
    }

    GO.result <- DEPs2EncirhR(DEPs, GOdb)
    GO.result$GO_Biological_Process_2023$Category <- "BP"
    GO.result$GO_Cellular_Component_2023$Category <- "CC"
    GO.result$GO_Molecular_Function_2023$Category <- "MF"
    GO.result$KEGG_2021_Human$Category <- "KEGG"

    GO.result.all <- rbind(
        GO.result$GO_Biological_Process_2023 ,
        GO.result$GO_Cellular_Component_2023,
        GO.result$GO_Molecular_Function_2023
    )

    KEGG.result <- GO.result$KEGG_2021_Human
    KEGG.result$ID <- "KEGG"

    export.EnrichR <- list(EnrichR.GO=GO.result.all, EnrichR.KEGG=KEGG.result)


    return(export.EnrichR)

}
