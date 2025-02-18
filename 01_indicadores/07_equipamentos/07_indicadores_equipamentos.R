
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


query <- 'SELECT * FROM "Open Analytics Layer".Infraestrutura."Razão de equipamentos por população"'


equipamentos <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)


populacao_query <- 'SELECT * FROM "Open Analytics Layer".Territorial."População SVS por município e ano"'


populacao <- sqlQuery(channel, 
                      populacao_query, 
                      as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


populacao$populacao <- as.integer(populacao$populacao)


populacao <- 
  populacao |>
  filter(uf_sigla == "GO") |>
  group_by(ano, macrorregiao) |>
  summarise(pop = sum(populacao))


equipamentos$ano <- as.integer(equipamentos$ano)
equipamentos$soma_populacao <- as.integer(equipamentos$soma_populacao)
equipamentos$soma_quantidade_equip_n_sus <- as.integer(equipamentos$soma_quantidade_equip_n_sus)
equipamentos$soma_quantidade_equip_sus <- as.integer(equipamentos$soma_quantidade_equip_sus)


equip_mc_goias <- 
  equipamentos |> 
  filter(uf_sigla == "GO") |> 
  group_by(ano,macrorregiao) |> 
  summarise(equipamentos_sus = sum(soma_quantidade_equip_sus),
            equipamentos_nsus = sum(soma_quantidade_equip_n_sus)) 


equip_pop <-
  equip_mc_goias |>
  left_join(populacao, by = c("ano", "macrorregiao")) |>
  mutate(razao = 10000 * (equipamentos_sus + equipamentos_nsus)/pop) |> 
  mutate(Macrorregião = substr(macrorregiao, 13, 27))



# Criação do Gráfico ------------------------------------------------------


a <- equip_pop |> 
  ggplot(aes(x = ano, y = razao, col = Macrorregião)) + 
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Razão (total de equipamentos por 10 mil habitantes)") +
  labs(caption = "* foram considerados os seguintes aparelhos: raio-x, tomógrafo, mamógrafo e ressonância") +
  ggtitle("Evolução da razão de equipamentos* por população em macrorregiões de saúde em Goiás",
          "Fonte: CNES-Equipamentos, competência de janeiro de cada ano, população de acordo com projeções SVSA") +
  theme(
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.caption = element_text(size = 14, hjust = 0, color = "grey30")
  ) +
  scale_x_continuous(breaks = seq(min(equip_mc_goias$ano), max(equip_mc_goias$ano), by = 1)) 


a


ggsave(filename = "razao_equipamentos.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


