
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Razão de profissionais por população segundo padronização de FTE"'


fte <- sqlQuery(channel, 
                     query,
                     as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


fte$ch_total <- as.integer(fte$ch_total)


fte_40 <- fte |> 
  filter(categoria == "Enfermeiro",
         nivel_atencao == "Primária",
         cod_ibge %in% c("292740", "230440", "211130", 
                         "250750", "261160", "221100", 
                         "240810", "280030", "270430", 
                         "240810", "211130"))



# Criação do gráfico ------------------------------------------------------------


a <- fte_40 |> 
  ggplot(aes(x = ano, y = FTE_40, color = factor(cod_ibge), group = cod_ibge)) +  # Usando 'cod_ibge' para distinguir as linhas
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Número de profissionais em FTE") + 
  ggtitle("Evolução da Métrica FTE de Enfermeiros nas Capitais do Nordeste",
          "Fonte: CNES-Profissionais, competência de janeiro de cada ano") +
  scale_color_discrete(name = "Capital", 
                       labels = c("292740" = "Salvador (BA)", 
                                  "230440" = "Fortaleza (CE)", 
                                  "211130" = "São Luís (MA)", 
                                  "250750" = "João Pessoa (PB)", 
                                  "261160" = "Recife (PE)", 
                                  "221100" = "Teresina (PI)", 
                                  "240810" = "Natal (RN)", 
                                  "280030" = "Aracaju (SE)", 
                                  "270430" = "Maceió (AL)")) +  # Personalizando os rótulos da legenda
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


ggsave(filename = "razao_profissionais_fte.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


