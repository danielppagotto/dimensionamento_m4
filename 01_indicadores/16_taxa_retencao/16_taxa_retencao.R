
library(tidyverse)
library(RODBC)
library(geobr)
library(scales)
library(sf) 
library(ggrepel) 
library(ggspatial) 
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Taxa de Retenção de Profissionais"'

query <- 'SELECT * FROM Dados.retencao."Médico_retencao_geral.parquet"'


retencao <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


<<<<<<< HEAD
taxa_retencao <- 
  retencao |> 
  filter(ano == '2024',
         categoria == "Enfermeiros") |> 
  mutate(regiao = str_replace(regiao, "Região ", ""))

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

a <- 
  ggplot(taxa_retencao, aes(x = regiao, y = taxa, fill = regiao)) +
  geom_boxplot() + 
  ggtitle("Distribuição das taxas de retenção de enfermeiros agregadas por regiões do Brasil em 2024",
          "Fonte: ???, competência de janeiro de 2024") +
  labs(x = "Região",
       y = "Taxa de retenção") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        legend.position = "none")
=======
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
  labs(fill = "Retenção", 
       x = "Longitude", 
       y = "Latitude") +
  annotation_north_arrow(location = "tr",  
                         which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotate("text", x = -Inf, y = Inf, label = "1", # Canto superior esquerdo
           hjust = -0.5, vjust = 1.5, size = 6) + 
  theme(
    legend.position = "right",
    legend.justification = "center",
    legend.box = "vertical",
    legend.key.height = unit(1, "cm"),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 14),
    axis.title = element_text(size = 18),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16),
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18),
    panel.border = element_rect(color = "black", 
                                fill = NA, 
                                size = 1), 
    plot.margin = margin(10, 10, 10, 10)) +
  ggtitle("Distribuição das taxas de retenção de médicos agregadas\npor regiões de saúde do Brasil",
          "Fonte: CNES-Profissionais")

>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670


a


<<<<<<< HEAD
ggsave(filename = "taxa_retencao.jpeg", plot = a,
=======
ggsave(filename = "taxa_retencao.jpeg",plot = a,
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
       dpi = 400, width = 16, height = 10)


