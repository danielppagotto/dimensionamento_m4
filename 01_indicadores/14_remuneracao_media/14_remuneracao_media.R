
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

query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Remuneração média de profissionais por UF"'


remuneracao <- sqlQuery(channel, 
                   query,
                   as.is = TRUE)


# tratamento dos dados ----------------------------------------------------

remuneracao_media <- 
  remuneracao |> 
  filter(uf_sigla == "MG") |>
  group_by(ano, categoria) |> 
  summarise(media_rendimento = mean(rendimento_medio, na.rm = TRUE))


# Criação do Gráfico ------------------------------------------------------

a <- remuneracao_media |> 
  ggplot(aes(x = ano, y = media_rendimento, col = categoria)) + 
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Média de remuneração") +
  ggtitle("Evolução da remuneração média de profissionais da saúde em Minas Gerais",
          "Fonte: PNADc") +
  labs(color = "Categoria Profissional") +
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

ggsave(filename = "remuneracao_media.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)

