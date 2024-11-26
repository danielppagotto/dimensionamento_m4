
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


populacao_query <- 'SELECT * FROM "Open Analytics Layer".Territorial."População SVS por município e ano"'


populacao <- sqlQuery(channel, 
                      populacao_query, 
                      as.is = TRUE)


# tratamento dos dados ----------------------------------------------------


populacao$populacao <- as.integer(populacao$populacao)


populacao <- 
  populacao |>
  filter (ano == '2023') |> 
  group_by(ano, regiao) |>
  summarise(pop = sum(populacao))


homicidios$ano <- as.integer(homicidios$ano)
homicidios$obitos_ano_homicidio <- as.integer(homicidios$obitos_ano_homicidio)
homicidios$taxa_homicidios_por_populacao <- as.numeric(homicidios$taxa_homicidios_por_populacao)


mortalidade <- 
  homicidios |> 
  drop_na() |> 
  filter(ano == "2023") |> 
  group_by(ano, regiao) |> 
  summarise(obitos = sum(obitos_ano_homicidio, na.rm = TRUE))

mortalidade_pop <-
  mortalidade |>
  left_join(populacao, by = c("ano", "regiao")) |>
  mutate(razao = 100000 * obitos / pop) |>
  drop_na() |>
  mutate(regiao = str_replace(regiao, "Região ", ""))



# Criação do Gráfico ------------------------------------------------------


a <- mortalidade_pop |> 
  ggplot(aes(x = fct_reorder(regiao, razao), y = razao, fill = regiao)) +
  geom_col(position = "dodge") +  
  coord_flip() +
  geom_text(aes(label = round(razao, 2)),    
            position = position_dodge(width = 0.9), 
            hjust = -0.1, size = 5) + 
  ggtitle("Distribuição da taxa de homicídios por região do Brasil em 2023", 
          "Fonte: Sistema de Informação sobre Mortalidade (SIM)") +
  labs(x = "Região",
       y = "Taxa de homicídios (total de óbitos por 100.000 habitantes)",
       fill = "Região") +
  theme_minimal() +
  theme(plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        legend.position = "none", 
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14))


a


ggsave(filename = "taxa_homicidios.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


