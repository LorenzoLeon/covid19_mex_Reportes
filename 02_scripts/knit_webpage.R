setwd("~/Desktop/extra/covid19_mex_Reportes/")


## Build PDFs
rm(list = ls(all.names = TRUE))
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "pdf_document",  output_file = "RedesSociales")

### Build Webpage
rm(list = ls(all.names = TRUE))
rmarkdown::render(input = "DatosSalud.Rmd", 
                  output_format = "html_document", output_file = "DatosSalud")
rm(list = ls(all.names = TRUE))
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "html_document", output_file = "index")



