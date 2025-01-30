
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


query <- 'SELECT * FROM "Open Analytics Layer".Infraestrutura."Razão de equipamentos de odontologia por população"'


equipamentos <- sqlQuery(channel, 
                         query,
                         as.is = TRUE)


populacao_query <- 'SELECT * FROM "Open Analytics Layer".Territorial."População SVS por município e ano"'


populacao <- sqlQuery(channel, 
                      populacao_query, 
                      as.is = TRUE)



# Tratamento dos dados -------------------------------------------------------


populacao$populacao <- as.integer(populacao$populacao)


populacao_mt <- 
  populacao |>
  filter(uf_sigla == "MT") |>
  group_by(ano, macrorregiao) |>
  summarise(pop = sum(populacao))


equipamentos$qtd_equip_sus <- as.integer(equipamentos$qtd_equip_sus)  
equipamentos$qtd_equip_nao_sus <- as.integer(equipamentos$qtd_equip_nao_sus)


equip_filtro <-
  equipamentos |> 
  filter(uf_sigla == 'MT',
         ano %in% c("2014", "2024")) |>
  group_by(ano, macrorregiao) |> 
  summarise(
    total_sus = sum(qtd_equip_sus, na.rm = TRUE),
    .groups = 'drop'
  )


equip_pop <-
  equip_filtro |>
  left_join(populacao_mt, by = c("macrorregiao", "ano")) |>
  mutate(razao_sus = 10000 * (total_sus)/pop) |> 
  mutate(macrorregiao = gsub("Macrorregião ?", "", macrorregiao)) 



# Criação do gráfico ------------------------------------------------------------


a <- 
  ggplot(equip_pop, aes(x = macrorregiao, y = razao_sus, fill = factor(ano))) +
  geom_col(position = "dodge") +  
  geom_text(aes(label = round(razao_sus, 2)),    
            position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 5) + 
  ggtitle("Comparação da razão de equipamentos de odontologia por população nas\nmacrorregiões de saúde do Mato Grosso",
          "Fonte: CNES-Equipamentos, competência de janeiro de cada ano; população de acordo com projeções SVSA") +
  labs(x = "Macrorregião",
       y = "Razão (total de equipamentos por 10 mil habitantes)",
       fill = "Ano") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        legend.position = "top", 
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14))


a


ggsave(filename = "razao_equip_odonto.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


