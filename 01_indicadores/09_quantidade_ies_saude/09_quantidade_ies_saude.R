
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

query <- 'SELECT * FROM "Open Analytics Layer"."Educação"."Quantidade de IES com cursos de saúde por município"'


IES <- sqlQuery(channel, 
                     query,
                     as.is = TRUE)


# tratamento dos dados ----------------------------------------------------

IES$qtd_ies_cursos <- as.integer(IES$qtd_ies_cursos)

qtd_IES <- 
  IES |> 
  filter(uf_sigla == "GO") |> 
  group_by(ano, tp_categoria_administrativa) |> 
  summarise(soma = sum(qtd_ies_cursos))


# Criação do Gráfico ------------------------------------------------------

a <- qtd_IES |> 
  ggplot(aes(x = ano, y = soma, col = tp_categoria_administrativa)) + 
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Razão de equipamentos por 10 mil habitantes") +
  labs(caption = "* foram considerados os seguintes aparelhos: raio-x, tomógrafo, mamógrafo e ressonância") +
  ggtitle("Evolução da razão de equipamentos* por população em macrorregiões de saúde em Goiás",
          "Fonte: CNES-Equipamentos, competência de janeiro de cada ano") +
  theme(
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.caption = element_text(size = 14, hjust = 0, color = "grey30")
  )
a

ggsave(filename = "razao_equipamentos.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)
