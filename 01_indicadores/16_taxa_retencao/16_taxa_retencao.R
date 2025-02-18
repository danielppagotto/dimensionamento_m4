
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Taxa de Retenção de Profissionais"'


retencao <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


taxa_retencao <- 
  retencao |> 
  filter(ano == '2024',
         categoria == "Enfermeiros") |> 
  mutate(regiao = str_replace(regiao, "Região ", ""))



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


a


ggsave(filename = "taxa_retencao.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


