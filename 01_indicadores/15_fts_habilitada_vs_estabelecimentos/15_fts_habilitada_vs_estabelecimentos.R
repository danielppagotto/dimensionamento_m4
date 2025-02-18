
library(tidyverse)
library(RODBC)
library(geobr)
library(scales)
library(sf) 
library(ggrepel) 
library(ggspatial)
library(ggplot2)



# Leitura dos dados -------------------------------------------------------


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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Percentual de força de trabalho habilitada atuando em estabelecimentos de saúde"'


trabalho <- sqlQuery(channel, 
                     query,
                     as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


trabalho$atuantes <- as.integer(trabalho$atuantes)
trabalho$habilitados <- as.integer(trabalho$habilitados)


força_trabalho <- 
  trabalho |> 
  filter(categoria == "Enfermeiros", uf %in% c("GO", "MS", "MT", "DF")) |> 
  group_by(uf) |>
  summarise(percentual = 100 * sum(atuantes) / sum(habilitados)) |> 
  drop_na()



# Criação do gráfico ------------------------------------------------------------


a <- força_trabalho |> 
  ggplot(aes(x = percentual, y = reorder(uf, percentual))) + 
  geom_col() +  # Troquei geom_line por geom_col para representar barras
  theme_minimal() + 
  xlab("Percentual (%)") +
  ylab("UF") +
  ggtitle("Percentual de enfermeiros atuantes em estabelecimentos de saúde\nem relação aos habilitados por UF do Centro-Oeste",
          "Fonte: CNES-Profissionais e conselhos das profissões de saúde, competência de janeiro de 2024") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        legend.position = "top", 
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14))


a


ggsave(filename = "habilitada_vs_estabelecimentos.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


