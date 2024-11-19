

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
  filter(regiao == "Região Centro-Oeste",
         ano %in% c(2018, 2019, 2021, 2022)) |> 
  group_by(ano, uf_sigla) |> 
  summarise(total = sum(qtd_ies_cursos), .groups = "drop")


# Criação do gráfico ------------------------------------------------------------

a <- ggplot(qtd_IES, aes(x = uf_sigla, y = total, fill = factor(ano))) + 
  geom_col(position = "dodge") +
  geom_text(aes(label = total), position = position_dodge(width = 0.9), vjust = -0.5, size = 5) +
  ggtitle("Comparação",
          "Fonte: Censo da Educação Superior") +
  labs(x = "Estado", 
       y = "Total", 
       fill = "Ano") +
  theme_minimal() +
  scale_x_discrete(labels = c("GO" = "Goiás", 
                              "DF" = "Distrito Federal", 
                              "MS" = "Mato Grosso do Sul", 
                              "MT" = "Mato Grosso")) +
  theme(
    plot.title = element_text(size = 20, face = "bold"), 
    plot.subtitle = element_text(size = 16),
    axis.title = element_text(size = 18),
    axis.title.x = element_text(size = 18, margin = margin(t = 20)),
    axis.title.y = element_text(size = 18, margin = margin(r = 20)),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16),
    legend.position = "top", 
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14)
  )

a

ggsave(filename = "razao_equipamentos.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)
