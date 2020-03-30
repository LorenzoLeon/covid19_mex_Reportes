
## Reporte COVID-19

Autor: [@lolo7no](https://twitter.com/lolo7no)

<b>Información Pública - Secretaría de Salud</b>
<p>
Desde el inicio de la crisis mundial de salud debida al brote del virus COVID-19, el rápido crecimiento del contagio y la desinformación sobre la enfermedad han sido dos de los principales retos a combatir para los gobiernos de los países afectados. En México, la Secretaría de Salud Federal combate en dos frentes. Por un lado, garantizar la suficiencia de recursos e infraestructura médica necesaria para atender al público cuando se alcancen los puntos más críticos de contagio en el país. Y, por otro lado, a través de la Dirección General de Epidemiología, la Secretaría publica diariamente un informe técnico con los casos sospechosos y positivos al COVID-19 en todo el país. 

Si bien este esfuerzo gubernamental busca combatir la desinformación en el tema, los formatos de presentación de los datos no permiten un análisis sintético del fenómeno. En este marco nace la siguiente propuesta. Con el fin de dar garantía al derecho humano de acceso a la información oportuna y completa, que resulta además en este caso de interés público, ponemos a disposición del público el siguiente reporte interactivo sobre la evolución del COVID-19 en México.

<p>
Descargue los datos de este reporte desde en el repositorio de [GITHUB](https://github.com/guzmart/covid19_mex)
<p>

### Número de casos positivos a COVID-19 en México según fecha de reporte oficial

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

![linea de tiempo](https://github.com/LorenzoLeon/covid19_mex_Reportes/blob/master/linea_del_tiempo.png)
