
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Razão de profissionais por população"'


profissionais <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


profissionais$populacao <- as.integer(profissionais$populacao)
profissionais$total <- as.integer(profissionais$total)


profissionaiss <- 
  profissionais |> 
  filter(ano %in% c(2014, 2024),
         categoria == "Agente Comunitário de Saúde") |>
  group_by(ano, regiao) |> 
  summarise(pop = sum(populacao),
            total = sum(total)) |> 
  mutate(razao = 10000 * (total)/pop)



# Criação do gráfico ------------------------------------------------------------


a <- 
  ggplot(profissionaiss, aes(x = regiao, y = razao, fill = factor(ano))) +
  geom_col(position = "dodge") +  
  geom_text(aes(label = round(razao, 2)),    
            position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 5) + 
  ggtitle("Comparação da razão de agentes comunitários da saúde por população nas regiões do Brasil",
          "Fonte: CNES-Profissionais, competência de janeiro de cada ano; população de acordo com projeções SVSA") +
  labs(x = "Região",
       y = "Razão (total de ACS por 10.000 habitantes)",
       fill = "Ano") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 20),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 16),
        axis.text.y = element_text(size = 16),
        legend.position = "top", 
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14))


a


ggsave(filename = "razao_profissionais.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


