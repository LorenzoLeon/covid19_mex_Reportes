require(srvyr)
require(dplyr)
require(tidyverse)

d <- foreign::read.dbf("~/../Downloads/tic_2019_usuarios.dbf")%>% 
  rename_all(tolower)



d_redes <- d %>% 
  rename_all(tolower) %>% 
  select(
    fac_per, upm, estrato, sexo, nivel,edad,
    p7_13, starts_with("p7_14")
  )%>%
  mutate(
    edad = as.numeric(edad),
    edad = case_when(
      edad<11 ~ "0 a 10 años",
      edad>10&edad<21 ~ "11 a 20 años",
      edad>20&edad<31 ~ "21 a 30 años",
      edad>30&edad<41 ~ "31 a 40 años",
      edad>40&edad<51 ~ "41 a 50 años",
      edad>50&edad<61 ~ "51 a 60 años",
      edad>60&edad<71 ~ "61 a 70 años",
      edad>70&edad<81 ~ "71 a 80 años",
      edad>80~ "80 años o más"
    ),
    sexo = as.numeric(sexo),
    sexo = case_when(
      sexo == 1 ~ "Hombre",
      sexo == 2 ~ "Mujer",
      T ~ NA_character_
    ),
    nivel = as.numeric(nivel),
    nivel = case_when(
      nivel == 00 ~ "Ninguno",
      nivel == 01 ~ "Preescolar o kínder",
      nivel == 02 ~ "Primaria",
      nivel == 03 ~ "Secundaria",
      nivel == 04 ~ "Normal básica",
      nivel == 05 ~ "Estudio técnico terminal con secundaria",
      nivel == 06 ~ "Preparatoria o bachillerato",
      nivel == 07 ~ "Estudio técnico superior con preparatoria terminada",
      nivel == 08 ~ "Licenciatura o ingeniería",
      nivel == 09 ~ "Especialidad",
      nivel == 10 ~ "Maestría",
      nivel == 11 ~ "Doctorado",
      nivel == 99 ~ "No sabe",
      T ~ NA_character_
    ),
    estrato = as.numeric(estrato),
    estrato = case_when(
      estrato == 1 ~ "Bajo",
      estrato == 2 ~ "Medio bajo",
      estrato == 3 ~ "Medio alto",
      estrato == 4 ~ "Alto",
      T ~ NA_character_
    )
  )%>% 
  mutate_at(vars(starts_with("p7_")), ~ifelse(is.na(.), 3, .)) %>%
  mutate_all(factor) %>% 
  mutate(
    fac_per=as.numeric(fac_per)
  )%>%
  rename(
    var_Redes_Sociales =p7_13 ,
    var_Facebook =p7_14_1  ,
    var_Twitter =p7_14_2 ,
    var_Instagram =p7_14_3  ,
    var_Linkedin =p7_14_4 ,
    var_Snapchat =p7_14_5  ,
    var_Whatsapp =p7_14_6 ,
    var_Youtube =p7_14_7  ,
    var_Pinterest =p7_14_8 ,
    var_Messenger =p7_14_9  ,
    var_Tumblr =p7_14_10 ,
    var_Otras =p7_14_11,
  ) 





prop.table(table(d_redes$sexo, d_redes$edad))
table(d_redes$sexo, d_redes$edad)
table(d_redes$sexo)

redes <- names(d_redes)[7:18]
props_redes <- data.frame()
for(i in 1:length(redes)){
  print(redes[i])
  tempo <- d_redes %>% 
    dplyr::select(
      redes[i],sexo, edad, fac_per, upm, estrato
    ) %>% 
    srvyr::as_survey_design(
      ids=upm, 
      strata=estrato,
      weights=fac_per
    ) %>% 
    srvyr::group_by_at(vars(sexo, edad, starts_with("var_")),
                       .drop = T) %>% 
    srvyr::summarise(prop = survey_mean(na.rm = T)) %>% 
    rename(var = redes[i]) %>% 
    mutate(var_id = redes[i]) %>% 
    drop_na(var)
  
  props_redes <- bind_rows(props_redes, tempo)
}

props_redes <- props_redes %>% 
  mutate(
    var_id = stri_replace(var_id, fixed = "var_", ""),
    var_id = stri_replace_all(var_id, fixed = "_", " "),
    var_id = ifelse(stri_detect(var_id, fixed = "Sociales", case_insensitive = T), "REDES SOCIALES GENERAL", var_id),
    var= case_when(
      var == 1 ~ "Sí",
      var == 2~ "No",
      T ~ "NA"
    )
  )

props_redes <- props_redes %>%
  dplyr::mutate(
    var_id = ifelse(stri_detect(var_id, fixed = "Sociales", case_insensitive = T), "Redes Sociales\nGeneral", var_id),
    prop_se_90 = prop_se*1.96,
    prop_max= prop+prop_se_90,
    prop_min= prop-prop_se_90
  )

props_redes <- props_redes %>% 
  mutate(
    prop = ifelse(
      str_detect(sexo, "ombr"), prop*(-1), prop
    ),
    prop_max = ifelse(
      str_detect(sexo, "ombr"), prop_max*(-1), prop_max
    ),
    prop_min = ifelse(
      str_detect(sexo, "ombr"), prop_min*(-1), prop_min
    )
  )



saveRDS(props_redes, "GitHub/COVID-19-Opinion/01_datos/prop_internet.rds")
props_redes <- readRDS("GitHub/COVID-19-Opinion/01_datos/prop_internet.rds")

`%notin%` <- Negate(`%in%`)
ggplot(
  data = props_redes %>% filter(var == "Sí", var_id %notin% c("Otras", "Pinterest","Tumblr",
                                                              #"Messenger", "REDES SOCIALES GENERAL", 
                                                              "Linkedin")),
  aes(
    x = edad,
    y = prop,
    ymin = prop_min,
    ymax = prop_max,
    fill = var_id,
    label = ifelse(abs(prop)>.035,paste0(round(abs(prop) * 100, 0), "%"),NA)
  )) + 
  geom_col(position = "identity") + 
  geom_errorbar(width = .3)+
  geom_text(aes(y=prop_max*1.1),size = 3.5, color = "black") +
  labs(
    title = "Porcentaje de usuarios de redes sociales en México",
    subtitle = "En total, se registran 80.6 millones de usuarios de internet, equivalente al 70.1% de la población.",
    caption = "Elaboración de Parametría con datos del INEGI (ENDUTIH 2019)",
    x = "",
    y = ""
  ) +
  scale_y_continuous(
    limits = c(-1.2,1.2),
    breaks = seq(-1,1,.25),
    labels = paste0(
      c(as.character(seq(100,0,-25)),
        as.character(seq(25,100,25))), "%"
    )
  ) + 
  theme_minimal() +
  facet_wrap(~ var_id) +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 35, face = "bold"),
    plot.subtitle = element_text(size = 24),
    plot.caption = element_text(size = 20),
    strip.text = element_text(size = 15),
    panel.spacing.x = unit(3, "lines"),
    text = element_text(family = "Arial Narrow"),
    axis.text.x = element_text(size = 14, angle = 90),
    axis.text.y = element_text(size = 10)
  )+
  coord_flip() +
  geom_hline(yintercept = 0, color = "red")+
  ggsave("../Desktop/proporcionesInternet.pdf",  
         width = 15, height = 10, dpi = 1000)

####
