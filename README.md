# EnrichR2GOplot

Gene Ontology analysis and visualization pipeline  
Package capsuling "EnrichR" and "GOplot" pkg

see Vigentee file
```
./vigentees/introduction.html
```



# Installation

```
if (!require("devtools", quietly = TRUE))
    install.packages("devtools")
if (!require("tidyverse", quietly = TRUE))
    install.packages("tidyverse")
if (!require("GOplot", quietly = TRUE))
    install.packages("GOplot")
if (!require("enrichR", quietly = TRUE))
    install.packages("enrichR")

devtools::install_github("seongminlab/EnrichR2GOplot")
```

## 1.Example dataset for EncirhR to GOdb

```
data(DEPs)
head(DEPs)
```

```
data(GOdb)
print(GOdb)
```

```
# Minimum cut-off of adj.p-value for encirhment analysis by EnrichR,  you can use 1 (not use for p-value filter) or 0.01 (strict cut-off)
cutoff <- 0.05
```

## 2. EnrichR2GOplot

```
result <- EnrichR2GOplot(DEPs, GOdb,cutoff)

GO.result <- result$EnrichR.GO
KEGG.result <- result$EnrichR.KEGG
circ <- result$circ
```

## 3. Visualize circ with GOplot pkg

see other visualize options <https://wencke.github.io>

```
GOBar(circ, display="multiple")
```

```
GOBubble(circ, labels = 3)
```

```
GOBubble(circ, title = 'Bubble plot with background colour', display = 'multiple', bg.col = T, labels = 3)  
```

## 4. Export GO and KEGG results by EnrichR & GOplot

```
#result <- EnrichR2GOplot(DEPs, GOdb,cutoff)
export <- export_table_EnrichR2GOplot(result, DEPs, cutoff)
```

```
output_xlsx <- createWorkbook()
sheet1 <- "GeneOntologyResults"
sheet2 <- "KEGG_Results"

addWorksheet(output_xlsx , sheet1)
addWorksheet(output_xlsx , sheet2)

writeDataTable(output_xlsx,sheet1,export$Export.EnrichR2GOplot.GO)
writeDataTable(output_xlsx,sheet2,export$Export.EnrichR2GOplot.KEGG)

saveWorkbook(output_xlsx, file = "Export_DEPs_EnrichR2GOplot_Aug_2023.xlsx")

```

------------------------------------------------------------------------

# Options

Support two functions\
1. Uniprot Accession to Gene Name\
2. Running EnrichR and export by table

## 1. Uniprot Accession to Gene Name

```
Accession <- c("O95905-1","P04439-2","P08246")
Uniprot_to_GeneNames <- UniprotAccession2GeneName(Accession)
```

```
rmarkdown::paged_table(Uniprot_to_GeneNames)
```

## 2. Run EnrichR with user selected GO database

database were selected from EnrichR homepage

```
library(enrichR)
setEnrichrSite("Enrichr")
dbs <- listEnrichrDbs()
head(dbs)
```


```
Select_DB <- c("GO_Molecular_Function_2015","GO_Cellular_Component_2015","GO_Cellular_Component_2015")
#or others.... 
```



```
data(DEPs)
Genes <- data.frame(GeneName = DEPs$GeneName) 
print(Select_DB)
```


```
rmarkdown::paged_table(Genes)
```

```
#Run EnrichR with selected database
DEPs2EncirhR(Genes, Select_DB)
```

```
sessionInfo()
```
