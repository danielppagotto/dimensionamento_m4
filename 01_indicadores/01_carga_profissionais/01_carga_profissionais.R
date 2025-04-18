
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Carga horária média de profissionais de saúde"'


horas <- sqlQuery(channel, 
                  query,
                  as.is = TRUE)



# tratamento dos dados ----------------------------------------------------

carga_horaria <- 
  horas |> 
  filter(ano == '2024',
         uf_sigla == 'MS',
         categoria %in% c("Enfermeiro", 
                          "Médico", 
                          "Técnico ou Auxiliar de Enfermagem"))


# Criação do gráfico ------------------------------------------------------------


a <- 
  ggplot(carga_horaria, aes(x = categoria, y = MEDIA_PROF, fill = categoria)) +
  geom_boxplot() + 
  ggtitle("Distribuição da carga horária de profissionais de saúde no Mato Grosso do Sul em 2024",
          "Fonte: CNES-Profissionais, competência de janeiro de 2024") +
  labs(x = "Categoria profissional",
       y = "Carga horária") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        legend.position = "none")


a


ggsave(filename = "carga_horaria.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


