
library(tidyverse)
library(RODBC)
library(geobr)
library(scales)
library(sf) 
library(ggrepel) 
library(ggspatial) 



# Leitura dos Dados -------------------------------------------------------


dremio_host <- Sys.getenv("endereco")
dremio_port <- Sys.getenv("port")
dremio_uid <- Sys.getenv("uid")
dremio_pwd <- Sys.getenv("datalake")


channel <- odbcDriverConnect(sprintf("DRIVER=Dremio Connector;
                                     HOST=%s;
                                     PORT=%s;
                                     UID=%s;
                                     PWD=%s;
                                     AUTHENTICATIONTYPE=Basic Authentication;
                                     CONNECTIONTYPE=Direct", 
                                     dremio_host, 
                                     dremio_port, 
                                     dremio_uid, 
                                     dremio_pwd))


query <- 'SELECT * FROM "Open Analytics Layer"."Educação"."Qualidade da educação nos anos iniciais do ensino fundamental"'


educacao <- sqlQuery(channel, 
                     query,
                     as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


edu_final <-
  educacao |> 
  filter(rede == "Estadual" &
           ano == "2023")


mun <- 
  read_municipality(code_muni="all", 
                    year=2022,
                    showProgress = FALSE) |>
  filter(substr(code_muni, 1, 2) == "35") |>
  mutate(code_muni = as.character(code_muni)) |> 
  mutate(code_muni = substr(code_muni, 1, 6)) |> 
  left_join(edu_incial, by= c("code_muni" = "cod_ibge"))


edu_municipio <- 
  mun |>
  group_by(code_muni) |>  
  summarise(IDEB_medio = mean(IDEB, na.rm = TRUE)) 


mun_sf <- st_as_sf(edu_municipio)



# Criação do mapa ------------------------------------------------------------


a <- ggplot() +
  geom_sf(data = mun_sf, 
          aes(fill = IDEB_medio, 
              geometry = geom)) +
  scale_fill_gradientn(colors = c('#FEE090', '#F46D43', '#A50026'),
                       values = rescale(c(5, 7.15, 9.3)),
                       limits = c(5, 9.3), 
                       breaks = c(5, 7.15, 9.3))+ 
  theme_minimal() +
  labs(fill = "Média do IDEB ", 
       title = "Qualidade da educação de escolas estaduais nos anos finais do\nensino fundamental em São Paulo",
       subtitle = "Fonte: Índice de Desenvolvimento da Educação Básica - INEP, competência de 2023") +
  theme(
    legend.position = "bottom",
    legend.justification = "center",
    legend.box = "horizontal",
    legend.text = element_text(size = 18),
    legend.title = element_text(size = 16, margin = margin(b = 20)), 
    axis.text.x = element_text(size = 18),  
    axis.text.y = element_text(size = 18),
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 16)
  ) +
  annotation_north_arrow(location = "tr",  
                         which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl",  
                   width_hint = 0.3)


a


ggsave(filename = "educacao_anos_finais.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


