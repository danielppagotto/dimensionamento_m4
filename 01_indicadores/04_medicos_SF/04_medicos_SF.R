
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


query <- 'SELECT * FROM "Open Analytics Layer".Profissionais."Razão de médicos de saúde da família por população"'


medicos <- sqlQuery(channel, 
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
  filter(uf_sigla == "BA") |>
  group_by(ano, macrorregiao) |>
  summarise(pop = sum(populacao))


medicos$ano <- as.integer(medicos$ano)
medicos$qtd_distinta_cpf_cbo <- as.integer(medicos$qtd_distinta_cpf_cbo)


medicos_familia <- 
  medicos |> 
  filter(uf_sigla == "BA") |> 
  group_by(ano, macrorregiao) |> 
  summarise(qtd_medicos = sum(qtd_distinta_cpf_cbo))


medicos_pop <-
  medicos_familia |> 
  left_join(populacao, by = c("ano", "macrorregiao")) |> 
  mutate(razao = 10000 * (qtd_medicos)/pop)



# Criação do Gráfico ------------------------------------------------------


a <- medicos_pop |> 
  ggplot(aes(x = ano, y = razao, col = macrorregiao)) + 
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Razão (total de médicos da família por 10.000 habitantes)") +
  ggtitle("Evolução da razão de médicos de saúde da família por população em macrorregiões de saúde na Bahia",
          "Fonte: CNES-Profissionais, competência de janeiro de cada ano; população de acordo com projeções SVSA") +
  theme(
    plot.title = element_text(size = 20, face = "bold"),
    plot.subtitle = element_text(size = 18),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    plot.caption = element_text(size = 14, hjust = 0, color = "grey30")
  ) +
  scale_x_continuous(breaks = seq(min(medicos_familia$ano), max(medicos_familia$ano), by = 1)) +
  labs(color = "Macrorregião")


a


ggsave(filename = "razao_medicos_familia.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


