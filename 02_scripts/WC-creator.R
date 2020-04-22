setwd("Desktop/extra/COVID-19-Opinion/")
tweets <- readRDS(file = "01_datos/tweets.rds")
require(wordcloud2)

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

t_pal_mas_freq <- t_pal_mas_freq %>% filter(!str_detect(palabra,"CLAU"))
head(t_pal_mas_freq, 20)
WC_topicos_twitter <- wordcloud2(head(t_pal_mas_freq, 100), 
                                 shape = "diamond", 
                                 size = .9, 
                                 #color = brewer.pal(n = 6, name = "Spectral"),
                                 fontWeight = "bold",
                                 minRotation = 1/pi, 
                                 maxRotation = 1/pi, 
                                 rotateRatio = 1
)
WC_topicos_twitter
saveWidgetFix(WC_topicos_twitter,libdir = "graph_dependencies", selfcontained = F,
              file = "03_graficas/WC_topicos_twitter.html")
webshot::webshot("03_graficas/WC_topicos_twitter.html","03_graficas/WC_topicos_twitter.png", 
                 delay =5, vwidth = 1000, vheight=800)
webshot::webshot("03_graficas/WC_topicos_twitter.html","03_graficas/WC_topicos_twitter.pdf", 
                 delay =5, vwidth = 1000, vheight=800)

hashtags <- tweets %>% 
  select(id_str, hashtags)%>%
  unnest(cols = hashtags)%>%
  mutate(hashtags = stri_trans_general(hashtags, "latin-ascii"))%>%
  drop_na() %>%group_by(hashtags) %>% summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  filter(!stri_detect(hashtags, fixed = "covid", case_insensitive = T),
         !stri_detect(hashtags, fixed = "coronavirus", case_insensitive = T))
head(hashtags, 20)
WC_hashtags_twitter <- wordcloud2(head(hashtags, 150), 
                                  shape = "circle", 
                                  size = .65, 
                                  #color = brewer.pal(n = 6, name = "Spectral"),
                                  fontWeight = "bold",
                                  minRotation = 0,#1/pi, 
                                  maxRotation = 0,#1/pi, 
                                  rotateRatio = 1
)
WC_hashtags_twitter
saveWidgetFix(WC_hashtags_twitter,libdir = "graph_dependencies", selfcontained = F,
              file = "03_graficas/WC_hashtags_twitter.html")
webshot::webshot("03_graficas/WC_hashtags_twitter.html","03_graficas/WC_hashtags_twitter.png", 
                 delay =5, vwidth = 1000, vheight=800)
webshot::webshot("03_graficas/WC_hashtags_twitter.html","03_graficas/WC_hashtags_twitter.pdf", 
                 delay =5, vwidth = 1000, vheight=800)


ats <- tweets %>% 
  select(id_str, ats)%>%
  unnest(cols = ats)%>%
  mutate_all(tolower)%>%
  drop_na() %>%
  group_by(ats) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))%>%
  filter(!stri_detect(ats, fixed = "Claudi", case_insensitive = T))
head(ats, 20)
WC_ats_twitter <- wordcloud2(head(ats, 100),
                                   shape = "diamond", 
                                   size = 1, 
                                   #color = brewer.pal(n = 6, name = "Spectral"),
                                   fontWeight = "bold",
                                   minRotation = 1/pi, 
                                   maxRotation = 1/pi, 
                                   rotateRatio = 1
)
WC_ats_twitter
saveWidgetFix(WC_ats_twitter,libdir = "graph_dependencies", selfcontained = F,
              file = "03_graficas/WC_ats_twitter.html")
webshot::webshot("03_graficas/WC_ats_twitter.html","03_graficas/WC_ats_twitter.png", 
                 delay =5, vwidth = 1000, vheight=800)
webshot::webshot("03_graficas/WC_ats_twitter.html","03_graficas/WC_ats_twitter.pdf", 
                 delay =5, vwidth = 1000, vheight=800)


headfreq <- head(t_pal_mas_freq, 20)
headhash <- head(hashtags, 20)
headats <- head(ats, 20)

tol <- bind_cols(headhash, headfreq, headats)
saveRDS(tol, "01_datos/tols.rds")
