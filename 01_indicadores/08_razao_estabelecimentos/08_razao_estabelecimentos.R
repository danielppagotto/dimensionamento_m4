
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


query <- 'SELECT * FROM "Open Analytics Layer".Infraestrutura."Razão de estabelecimentos de saúde por população"'


estabelecimentos <- sqlQuery(channel, 
                   query,
                   as.is = TRUE)


populacao_query <- 'SELECT * FROM "Open Analytics Layer".Territorial."População SVS por município e ano"'


populacao <- sqlQuery(channel, 
                      populacao_query, 
                      as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


populacao$populacao <- as.integer(populacao$populacao)


populacao_go <- 
  populacao |>
  filter(uf_sigla == "GO") |>
  group_by(ano) |>
  summarise(pop = sum(populacao))


estabelecimentos$ano <- as.integer(estabelecimentos$ano)
estabelecimentos$numero_estabelecimentos <- as.integer(estabelecimentos$numero_estabelecimentos)


