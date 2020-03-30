
## Reporte COVID-19
[Revise el Reporte Interactivo aquí](https://lorenzoleon.github.io/covid19_mex_Reportes/HTML_REPORTE_COVID_REV_v2_light.html)

Autor: [@lolo7no](https://twitter.com/lolo7no)
<p>
  Este es un esfuerzo de [Guzmart_](https://twitter.com/guzmart_) y mío para crear un reporte sistemático de los datos publicados por la Sec de Salud en México. Es un esfuerzo de accesibilidad a datos y de transparencia sobre el proceso para crear estos datos. Creemos en los datos abiertos y que mientras más personas sepan cómo tratarlos mejor informados estaremos como ciudadanía.
  
  Recuerda, si puedes #QuedateEnCasa, manten #SusanaDistancia si no y #lavateLasManos
<p>
  Descargue los datos de este reporte desde en el repositorio de [GITHUB](https://github.com/guzmart/covid19_mex)

### Este es un ejemplo de una gráfica simple de Casos Acumulados
La siguiente gráfica presenta la evolución del brote del virus COVID-19 en México. Al igual que otros países en América Latina, y acorde con estudios sobre la velocidad de crecimiento del brote del virus en la región, las curvas de crecimiento del brote en México son una línea recta en escala logarítmica. La gráfica permite seleccionar la temporalidad que el usuario requiera para su visualización.
<p>
Otra forma de observar la tendencia de crecimiento es por medio de la contabilización de los nuevos casos confirmados por día: es decir, cuántas confirmaciones se capturaron en la fecha de publicación. La siguiente gráfica, además, muestra que no existe un crecimiento constante sino que tiende a haber variaciones a lo largo del tiempo.

```r
caption <- "Elaboración propia con datos de la Secretaría de Salud | <a href='https://twitter.com/lolo7no'>@lolo7no</a> <a href='https://twitter.com/guzmart_'>@guzmart_</a>"
titulo <- "Número de casos confirmados de COVID-19 en México"
subtitulo <- paste0("Fecha de corte: ",str_sub(max(data_fecha_acumulado$fecha_corte), end = -1))

accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

datos_acumulados <- data_fecha_acumulado%>%
  mutate(Fecha = as.Date(fecha_corte),
         #fff = format(Fecha, format = "%d-%B"),
         `Casos Acumulados` = n_acumulada,
         `Casos Nuevos` = n) %>%
  mutate(
    fff = as.numeric(Fecha)
  )%>%
  select(Fecha, `Casos Acumulados`,`Casos Nuevos`, fff) %>%
  pivot_longer(cols = starts_with("Casos") , values_to= "Casos")%>%
  accumulate_by(~fff)%>%
  mutate(
    `Tipo de Casos` = name
  )
grafica <- ggplot(datos_acumulados, 
         aes(x = Fecha,
             frame = frame, 
             opacity = 1,
             y = Casos,
             color = `Tipo de Casos`)) +
  geom_line() +
  scale_x_date(date_breaks = "3 day",
               limits = c(
                 min(as.Date(data_fecha$fecha_corte)-0.7),
                 max(as.Date(data_fecha$fecha_corte)+0.7)
               ),
               expand = c(0,0)) +
  theme_minimal() + 
  labs(title=str_wrap(paste0(titulo,": ", subtitulo), width = 50),
       subtitle=subtitulo,
       x="",
       y="Número de casos") +
  theme(plot.title = element_text(size = 20, face = "bold", hjust = -.5),
        #plot.subtitle = element_text(size = 25),
        #plot.caption = element_text(size = 20),
        strip.text = element_text(size = 15),
        panel.spacing.x = unit(3, "lines"),
        text = element_text(family = "Arial Narrow"),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5),
        axis.title.y = element_text(size = 15),
        axis.text.y = element_text(size = 15))

unt <- enframe(unique(fig$Fecha), name = "id", value = "label")
unt$visible <-  ifelse(unt$id%%3 == 1,T,F)
unt$value <-  as.numeric(as.Date(unt$label))

plotly::ggplotly(grafica, tooltip = c("x", "y", "color"))%>%
plotly::layout(tickvalues ="",
               annotations = list(x = 1, 
                                  y = 0, 
                                  text = caption, 
                                  showarrow = F, 
                                  xref='paper', 
                                  yref='paper', 
                                  xanchor='right', 
                                  yanchor='auto', 
                                  xshift=0, 
                                  yshift=0,
                                  font=list(size=15, color="red"))
               )%>%
  plotly::animation_button(label = "Empezar")%>%
  plotly::animation_slider(visible=F, 
                           currentvalue = list(prefix = "YEAR ", 
                                               font = list(color="red")))
```
Esta es una versión estática similar
![linea de tiempo](https://github.com/LorenzoLeon/covid19_mex_Reportes/blob/master/linea_tiempo.png)
