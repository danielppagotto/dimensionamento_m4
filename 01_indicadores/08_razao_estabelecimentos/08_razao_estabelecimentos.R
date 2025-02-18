
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


query <- 'SELECT * FROM "Open Analytics Layer".Infraestrutura."Razão de estabelecimentos de saúde por população"'


estabelecimentos <- sqlQuery(channel, 
                             query,
                             as.is = TRUE)


populacao_query <- 'SELECT * FROM "Open Analytics Layer".Territorial."População SVS por município e ano"'


populacao <- sqlQuery(channel, 
                      populacao_query, 
                      as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


populacao$populacao <- as.integer(populacao$populacao)


populacao_sul <- 
  populacao |>
  filter(ano >= 2015,
         regiao == 'Região Sul') |>
  group_by(ano, uf_sigla, municipio) |>
  summarise(pop = sum(populacao))


estabelecimentos$ano <- as.integer(estabelecimentos$ano)
estabelecimentos$numero_estabelecimentos <- as.integer(estabelecimentos$numero_estabelecimentos)


estabelecimentos_sul <-
  estabelecimentos |>
  filter(ano >= 2015,
         vinculo_sus == 'Sim',
         regiao == 'Região Sul') |>
  group_by(ano, uf_sigla, municipio) |>
  summarise(total = sum(numero_estabelecimentos))


estab_pop <-
  estabelecimentos_sul |>
  left_join(populacao_sul, by = c("ano", "uf_sigla", "municipio")) |>
  group_by(ano, uf_sigla, municipio) |>
  summarise(razao = 10000 * total/pop)


# Calcular estatísticas (média e erro padrão) por ano
estab_pop_summary <- 
  estab_pop |>
  group_by(ano, uf_sigla) |>
  summarise(
    mean_razao = mean(razao, na.rm = TRUE),
    sem_razao = sd(razao, na.rm = TRUE) / sqrt(n())
  )

# Criação do mapa ------------------------------------------------------------


a <- estab_pop_summary |>
  ggplot(aes(x = ano, y = mean_razao, color = uf_sigla)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = mean_razao - sem_razao, ymax = mean_razao + sem_razao, fill = uf_sigla), 
              alpha = 0.2, color = NA) +
<<<<<<< HEAD
  ggtitle("Evolução da razão de estabelecimentos por população nos estados da Região Sul do Brasil",
          "Fonte: CNES-Estabelecimentos, competência de janeiro de cada ano, população de acordo com projeções SVSA") +
  labs(
    x = "Ano",
    y = "Razão (total de estabelecimentos por 10.000 habitantes)",
=======
  ggtitle("Evolução da razão de estabelecimentos de saúde por população nos estados da Região Sul do Brasil",
          "Fonte: CNES-Estabelecimentos, competência de janeiro de cada ano, população de acordo com projeções SVSA") +
  labs(
    x = "Ano",
    y = "Razão (total de estabelecimentos por 10 mil habitantes)",
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
    color = "Estado",
    fill = "Estado"  
  ) +
  scale_color_discrete(
    labels = c("PR" = "Paraná", "SC" = "Santa Catarina", "RS" = "Rio Grande do Sul")  
  ) +
  scale_fill_discrete(
    labels = c("PR" = "Paraná", "SC" = "Santa Catarina", "RS" = "Rio Grande do Sul")  
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.caption = element_text(size = 14, hjust = 0, color = "grey30"),
    legend.position = "right" 
  ) +
  scale_x_continuous(
    breaks = seq(min(estab_pop_summary$ano), max(estab_pop_summary$ano), by = 1)
  )


a


ggsave(filename = "estabelecimentos.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)


