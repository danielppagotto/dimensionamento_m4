
library(tidyverse)
library(arrow)
library(patchwork)
library(geojsonio)
library(geojsonsf)
library(geobr)
library(scales)
library(ggspatial) 
library(sf)
library(readxl)
library(leaflet)
library(RODBC)


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


query <- 'SELECT * FROM Dados.retencao."Médico_retencao_geral.parquet"'


retencao <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


estados_br <- read_state(year = 2020,
                         showProgress = FALSE)

spdf <- 
  geojson_read("~/GitHub/dimensionamento_m4/shape_file_regioes_saude.json", 
               what = "sp")

spdf_fortified <- 
  sf::st_as_sf(spdf) |> 
  distinct_all()

taxa_retencao <- 
  retencao |> 
  mutate(regiao_saude = as.numeric(regiao_saude)) |> 
  left_join(spdf_fortified, 
            by = c("regiao_saude" = "reg_id")) |> 
  rename(taxa = retencao_geral)



# Criação do mapa ------------------------------------------------------------

a <- ggplot() +
  geom_sf(data = taxa_retencao, 
          aes(fill = taxa, geometry = geometry), 
          color = "#d3d4d4") +
  geom_sf(data = estados_br, 
          fill = NA, 
          color = "#4c4d4a", 
          size = 0.1) + 
  scale_fill_gradientn(colors = c("#D92B3A", 
                                  "#d4e302",
                                  "#02592e")) +
  theme_minimal() +
  labs(fill = "Relative gap") +
  theme(
    legend.position = "none",
    legend.justification = "center",
    legend.box = "horizontal",
    axis.title = element_text(size = 18),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.title = element_text(size = 18, face = "bold"),
    plot.subtitle = element_text(size = 16),
    panel.border = element_rect(color = "black", 
                                fill = NA, 
                                size = 1), 
    plot.margin = margin(10, 10, 10, 10)) +
  ggtitle("Distribuição das taxas de retenção de médicos agregadas\npor regiões de saúde do Brasil em 2024",
          "Fonte: CNES-PF, competência de janeiro de 2024") 


a

ggsave(filename = "01_indicadores/16_taxa_retencao/retencao.jpeg",plot = a,
       dpi = 500, height = 8, width = 8)

