
library(tidyverse)
library(RODBC)
library(geobr)
library(scales)
library(sf) 
library(ggrepel) 
library(ggspatial) 


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

query <- 'SELECT * FROM "Open Analytics Layer"."Epidemiológico".Mortalidade."Taxa de mortalidade por homicídios"'


homicidios <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)


# tratamento dos dados ----------------------------------------------------

homicidios$populacao <- as.integer(homicidios$populacao)
homicidios$obitos_ano_homicidio <- as.integer(homicidios$obitos_ano_homicidio)
homicidios$taxa_homicidios_por_populacao <- as.numeric(homicidios$taxa_homicidios_por_populacao)

mortalidade <- 
  homicidios |> 
  drop_na() |> 
  filter(ano == "2023") |> 
  group_by(ano, uf_sigla) |> 
  summarise(
    pop = sum(populacao, na.rm = TRUE),
    obitos = sum(obitos_ano_homicidio, na.rm = TRUE)) |> 
  mutate(razao = 100000 * obitos / pop)


# Criação do Gráfico ------------------------------------------------------

a <- mortalidade %>%
  ggplot(aes(x = "", y = razao, fill = Região, label = sprintf("%.1f%%", razao))) +
  geom_bar(stat = "identity", width = 2, color = "black", size = 1) +
  coord_polar(theta = "y") +  # Faz o gráfico circular (pizza)
  ggtitle("Distribuição da Taxa de Homicídios por Região em 2023", 
          "Fonte: Sistema de Informação sobre Mortalidade (SIM)") +
  labs(fill = "Região") +
  geom_text(aes(label = sprintf("%.1f%%", razao)), position = position_stack(vjust = 0.5), size = 7) +
  theme_void() +
  theme(
    legend.position = "right",
    legend.box.margin = margin(0, 10, 0, -20),
    legend.margin = margin(0, 0, -10, -10),
    plot.margin = margin(-1.5, 1, -1.5, 1, "mm"),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18))

a

ggsave(filename = "homicidios.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)

