
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Número médio de vínculos"'


vinculos <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


media_vinculos <- 
  vinculos |> 
  filter(categoria == "Médico",
         ano == "2024")


mun <- 
  read_municipality(code_muni="all", 
                         year=2022,
                         showProgress = FALSE) |>
  filter(substr(code_muni, 1, 2) == "43") |>
  mutate(code_muni = as.character(code_muni)) |>
  mutate(code_muni = substr(code_muni, 1, 6))


mun2 <- 
  mun |> 
  left_join(media_vinculos, by= c("code_muni" = "cod_ibge"))


mun_sf <- st_as_sf(mun2)


mun_sf$vinc_medio[is.na(mun_sf$vinc_medio)] <- 0



# Criação do mapa ------------------------------------------------------------


a <- ggplot() +
  geom_sf(data = mun_sf, 
          aes(fill = vinc_medio, geometry = geom)) +
  
scale_fill_gradientn(colors = c("#FAE9A0", "#B6960D", "#796409"), 
                     values = rescale(c(1, 3, 5)), 
                     limits = c(1, 5),
                     breaks = c(1, 3, 5)) +
  theme_minimal() +
  labs(fill = "Média de vínculos") +
  theme(legend.position = "bottom",
        legend.justification = "center",
        legend.box = "horizontal",
        axis.text.x = element_text(size = 18),  
        axis.text.y = element_text(size = 18),
        legend.text = element_text(size = 18),
        plot.title = element_text(size = 20)) +
  annotation_north_arrow(location = "tr",  
                         which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl",  
                   width_hint = 0.3)  +
  ggtitle("Número Médio de Vínculos de Médicos no Rio Grande do Sul",
          "Fonte: CNES-Profissionais, competência de janeiro de 2024")


a


ggsave(filename = "vinculos.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


