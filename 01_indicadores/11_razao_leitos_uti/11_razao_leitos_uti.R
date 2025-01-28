
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


query <- 'SELECT * FROM "Open Analytics Layer".Infraestrutura."Razão de Leitos de UTI por população"'


leitos <- sqlQuery(channel, 
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


leitos$ano <- as.integer(leitos$ano)
leitos$qtd_UTI <- as.integer(leitos$qtd_UTI)
leitos$qtd_UTIP <- as.integer(leitos$qtd_UTIP)
leitos$qtd_UTIN <- as.integer(leitos$qtd_UTIN)


leitos_goias <- 
  leitos |> 
  filter(uf_sigla == "GO") |> 
  group_by(ano)  |> 
  summarise(qtd_UTI = sum(qtd_UTI),
            qtd_UTIP = sum(qtd_UTIP),
            qtd_UTIN = sum(qtd_UTIN))


leitos_com_populacao <-
  leitos_goias |>
  left_join(populacao_go, by = "ano") |>
  mutate(UTI = 10000 * (qtd_UTI/pop)) |> 
  mutate(UTIP = 10000 * (qtd_UTIP/pop)) |> 
  mutate(UTIN = 10000 * (qtd_UTIN/pop)) 


leitos_goias_long <- leitos_com_populacao |> 
  pivot_longer(cols = c(UTI, UTIP, UTIN), 
               names_to = "tipo_uti", 
               values_to = "valor_uti")



# Criação do Gráfico ------------------------------------------------------


a <- leitos_goias_long |> 
  ggplot(aes(x = ano, y = valor_uti, color = tipo_uti, group = tipo_uti)) +
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Razão (total de leitos de UTI por 10 mil habitantes)") +
  ggtitle("Evolução da razão de leitos de UTI por população em Goiás",
          "Fonte: CNES-Leitos, competência de janeiro de cada ano; população de acordo com projeções SVSA") +
  scale_color_discrete(
    name = "Tipo",
    labels = c("UTI" = "Leitos de UTI", "UTIP" = "Leitos de UTI Pediátrica", "UTIN" = "Leitos de UTI Neonatal")
  ) +  
  theme(
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.caption = element_text(size = 14, hjust = 0, color = "grey30")
  ) +
  scale_x_continuous(breaks = seq(min(leitos_goias_long$ano), max(leitos_goias_long$ano), by = 1))


a


ggsave(filename = "razao_leitos_uti.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


