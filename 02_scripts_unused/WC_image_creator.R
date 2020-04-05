tweets <- readRDS(file = "01_datos/tweets.rds")
custom_stop_words <- enframe(tm::stopwords("es")) %>% 
  bind_rows(enframe(c( "t", "rt"))) %>% 
  rename(palabra = value)
t_pal_mas_freq <- tweets %>% 
  # Extraer palabras de título y agrupar por título
  unnest_tokens(input = "texto", output = "palabra") %>% 
  # Quitar stopwords
  anti_join(custom_stop_words) %>%
  # Contar palabras
  count(palabra, sort = TRUE) %>% 
  # Quitar missing values
  drop_na() %>% 
  # palabras a mayúsculas
  mutate(palabra = toupper(palabra))
WC_topicos_twitter <- wordcloud2(head(t_pal_mas_freq, 100), 
                                 shape = "diamond", 
                                 size = 1, 
                                 #color = brewer.pal(n = 6, name = "Spectral"),
                                 fontWeight = "bold",
                                 minRotation = 1/pi, 
                                 maxRotation = 1/pi, 
                                 rotateRatio = 1
)
htmlwidgets::saveWidget(WC_topicos_twitter, file = "tmp.html",selfcontained = F)
webshot::webshot("tmp.html","03_graficas/WC_topicos_twitter.png", 
                 delay =5, vwidth = 1000, vheight=1000)

hashtags <- tweets %>% 
  select(id_str, hashtags)%>%unnest(cols = hashtags)%>%
  drop_na() %>%group_by(hashtags) %>% summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  filter(!stri_detect(hashtags, fixed = "covid", case_insensitive = T),
         !stri_detect(hashtags, fixed = "coronavirus", case_insensitive = T))
WC_hashtags_twitter <- wordcloud2(head(hashtags, 150), 
                                  shape = "circle", 
                                  size = 1, 
                                  #color = brewer.pal(n = 6, name = "Spectral"),
                                  fontWeight = "bold",
                                  minRotation = 0,#1/pi, 
                                  maxRotation = 0,#1/pi, 
                                  rotateRatio = 1
)
htmlwidgets::saveWidget(WC_hashtags_twitter, file = "tmp.html",selfcontained = F)
webshot::webshot("tmp.html","03_graficas/WC_hashtags_twitter.png", 
                 delay =5, vwidth = 1000, vheight=1000)

ats <- tweets %>% select(id_str, ats)%>%unnest(cols = ats)%>% mutate_all(tolower)%>%
  drop_na() %>%group_by(ats) %>% summarise(n = n()) %>% arrange(desc(n))
WC_menciones_twitter <- wordcloud2(head(ats, 100),
                                   shape = "diamond", 
                                   size = 1, 
                                   #color = brewer.pal(n = 6, name = "Spectral"),
                                   fontWeight = "bold",
                                   minRotation = 1/pi, 
                                   maxRotation = 1/pi, 
                                   rotateRatio = 1
)
htmlwidgets::saveWidget(WC_menciones_twitter, file = "tmp.html",selfcontained = F)
webshot::webshot("tmp.html","03_graficas/WC_ats_twitter.png", 
                 delay =5, vwidth = 1000, vheight=1000)
