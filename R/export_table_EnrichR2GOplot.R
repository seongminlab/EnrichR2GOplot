#' Export table from EnrichR2GOplot results
#' @import dplyr
#' @param export_from_EnrichR2GOplot  return from EnrichR2GOplot()
#' @param DEPs    dataframe DEPs have two columns that "GeneName" and "logFC"
#' @param cutoff minimum significant adj.p-value for EnrichR  enrichment analysis
#'
#' @return export table format GO result and KEGG results
#' @export
#'
#' @examples
#'
#' result <- EnrichR2GOplot(DEPs,GOdb, 0.05)
#'
#' export <- export_table_EnrichR2GOplot(result, DEPs, 0.05)
#'
export_table_EnrichR2GOplot <- function(export_from_EnrichR2GOplot , DEPs, cutoff){
        if(missing(cutoff)){
            cutoff = 0.05
        }

        EnrichR.GO <- export_from_EnrichR2GOplot$EnrichR.GO

        GOID.list <- EnrichR.GO$Term %>% stringr::str_split("\\(GO:")
        terms <- GOID.list %>% sapply(`[`,1)
        termIDs <- GOID.list %>% sapply(`[`,2) %>% gsub("\\)","", .) %>% paste0("GO:",.)

        EnrichR.GO$Term <- terms
        EnrichR.GO$ID <- termIDs

        EnrichR.GO.parse <- EnrichR.GO %>% subset(.,select=c("Category","ID","Term","Overlap","Adjusted.P.value","Odds.Ratio","Combined.Score","Genes"))
        EnrichR.GO.parse$Genes<- gsub(";",",",EnrichR.GO.parse$Genes)
        EnrichR.GO.parse <- EnrichR.GO.parse %>% subset(Adjusted.P.value <= cutoff)


        circ_result <- export_from_EnrichR2GOplot$circ %>% dplyr::select(c("term","zscore")) %>% unique()
        colnames(circ_result) <- c("Term","Z.score")

        export_GOTable <- dplyr::left_join(EnrichR.GO.parse,  circ_result , by="Term")



        KEGG.result <- export_from_EnrichR2GOplot$EnrichR.KEGG

        KEGG.parse <-KEGG.result %>% subset(.,select=c("Category","ID","Term","Overlap","Adjusted.P.value","Odds.Ratio","Combined.Score","Genes"))
        KEGG.parse$Genes<- gsub(";",",",KEGG.parse$Genes)

        KEGG.parse_forGOplot <- KEGG.parse %>% subset(., select=c("Category","ID","Term","Adjusted.P.value","Genes"))
        colnames(KEGG.parse_forGOplot) <- c("Category","ID","Term","adj_pval","Genes")

        DEPs_forKEGG <- DEPs %>% subset(select=c("GeneName","logFC"))
        colnames(DEPs_forKEGG) <- c("ID","logFC")
        KEGG.circ.result <- GOplot::circle_dat(KEGG.parse_forGOplot,DEPs_forKEGG)

        KEGG.circ.result <- KEGG.circ.result %>% select(c("term","zscore")) %>% unique
        colnames(KEGG.circ.result) <- c("Term","Zscore")

        export_KEGGTable <- dplyr::left_join(KEGG.parse,  KEGG.circ.result , by="Term")

        export <- list( Export.EnrichR2GOplot.GO = export_GOTable, Export.EnrichR2GOplot.KEGG = export_KEGGTable  )


        #Running circle



        }



