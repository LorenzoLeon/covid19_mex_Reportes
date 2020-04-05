setwd("~/Desktop/extra/covid19_mex_Reportes/")

rmarkdown::render(input = "AnalisisParametria.Rmd", 
                  output_format = "pdf_document",  output_file = "AnalisisParametria.pdf")
rmarkdown::render(input = "AnalisisParametria.Rmd", 
                  output_format = "html_document", output_file = "index.html")

rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "pdf_document",  output_file = "RedesSociales")
rmarkdown::render(input = "RedesSociales.Rmd", 
                  output_format = "html_document", output_file = "RedesSociales")


rmarkdown::render(input = "OpinionPublica.Rmd", 
                  output_format = "pdf_document",  output_file = "OpinionPublica")
rmarkdown::render(input = "OpinionPublica.Rmd", 
                  output_format = "html_document", output_file = "OpinionPublica")

rmarkdown::render(input = "DatosSalud.Rmd", 
                  output_format = "pdf_document",  output_file = "DatosSalud")
rmarkdown::render(input = "DatosSalud.Rmd", 
                  output_format = "html_document", output_file = "DatosSalud")

