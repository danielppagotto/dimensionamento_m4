
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Distribuição dos tipos de vínculos de profissionais"'


precarizacao <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


precarizacao_enf <- 
  precarizacao |> 
  filter(nivel_atencao == "Primária" &
        categoria == "Enfermeiro" & 
        ano == "2024", 
        categorias_vinculos == "Precarizado") |> 
  mutate(percentual = as.numeric(percentual),
        quantidade = as.numeric(quantidade))


mun <- read_municipality(code_muni="all", 
                         year=2022,
                         showProgress = FALSE)


estados_br <- read_state(year = 2020)


mun <- mun |> 
  mutate(code_muni = 
           as.character(code_muni)) |> 
  mutate(code_muni = substr(code_muni, 1, 6))


mun2 <- mun |> 
  left_join(precarizacao_enf, by= c("code_muni" = "cod_ibge"))


mun_sf <- st_as_sf(mun2)


mun_sf$percentual[is.na(mun_sf$percentual)] <- 0



# Criação do mapa ------------------------------------------------------------


a <- ggplot() +
  geom_sf(data = mun_sf, 
          aes(fill = percentual, 
              geometry = geom)) +

  scale_fill_gradientn(colors = c("#02592e", 
                                  "#d4e302",
                                  "#D92B3A"), 
                       values = 
                         rescale(c(0,50,100)), 
                       limits = c(0,100),
                       breaks = c(0, 50, 100)) + 
  theme_minimal() +
  labs(fill = "% de vínculos precários") +
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
  ggtitle("Precarização de Vínculos de Enfermagem na Atenção Primária à Saúde",
          "Fonte: CNES-Profissionais, competência de janeiro de 2024")


a


ggsave(filename = "precarizacao.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


