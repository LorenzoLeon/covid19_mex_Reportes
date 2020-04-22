setwd("~/Desktop/extra/COVID-19-Opinion/")


## Build PDFs
rmarkdown::render(input = "AnalisisParametria.Rmd", 
                  output_format = "pdf_document",  output_file = "AnalisisParametria")
rm(list = ls(all.names = TRUE))
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "pdf_document",  output_file = "RedesSociales")
rm(list = ls(all.names = TRUE))


### Build Webpage
rmarkdown::render(input = "AnalisisParametria.Rmd", 
                  output_format = "html_document", output_file = "index")
rm(list = ls(all.names = TRUE))
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "html_document", output_file = "RedesSociales")
rm(list = ls(all.names = TRUE))
rmarkdown::render(input = "OpinionPublica.Rmd", 
                  output_format = "html_document", output_file = "OpinionPublica")
rm(list = ls(all.names = TRUE))

