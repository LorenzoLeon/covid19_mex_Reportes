setwd("~/Desktop/extra/covid19_mex_Reportes/")


## Build PDFs
rmarkdown::render(input = "AnalisisParametria.Rmd", 
                  output_format = "pdf_document",  output_file = "AnalisisParametria")
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "pdf_document",  output_file = "RedesSociales")
rmarkdown::render(input = "OpinionPublica.Rmd", 
                  output_format = "pdf_document",  output_file = "OpinionPublica")

### Build Webpage
rmarkdown::render(input = "AnalisisParametria.Rmd", 
                  output_format = "html_document", output_file = "index")
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "html_document", output_file = "RedesSociales")
rmarkdown::render(input = "OpinionPublica.Rmd", 
                  output_format = "html_document", output_file = "OpinionPublica")
rmarkdown::render(input = "DatosSalud.Rmd", 
                  output_format = "html_document",
                  output_file = "DatosSalud")#, params = "ask")

