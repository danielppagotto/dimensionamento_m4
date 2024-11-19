
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


query <- 'SELECT * FROM "Open Analytics Layer"."Educação"."Quantidade de vagas, matriculados, concluintes e inscritos em curso superior por município"'


educacao <- sqlQuery(channel, 
                     query,
                     as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


educacao$vagas <- as.integer(educacao$vagas)


educacao_vagas <- educacao |> 
  filter(curso == "Medicina",
         uf_sigla %in% c("PR", "SC", "RS"),
         ano %in% c(2018, 2022)) |>
  group_by(ano, uf_sigla) |>
  summarise(total_vagas = sum(vagas), .groups = "drop")
  


# Criação do gráfico ------------------------------------------------------------


a <- ggplot(educacao_vagas, aes(x = uf_sigla, y = total_vagas, fill = factor(ano))) + 
  geom_col(position = "dodge") +
  geom_text(aes(label = total_vagas), position = position_dodge(width = 0.9), vjust = -0.5, size = 5) +
  ggtitle("Comparação do Número de Vagas no Curso de Medicina nos Estados do Sul do Brasil",
          "Fonte: Censo da Educação Superior") +
  labs(x = "Estado", 
       y = "Total de vagas de medicina", 
       fill = "Ano") +
  theme_minimal() +
  scale_x_discrete(labels = c("PR" = "Paraná", "SC" = "Santa Catarina", "RS" = "Rio Grande do Sul")) +
  theme(
    plot.title = element_text(size = 20, face = "bold"), 
    plot.subtitle = element_text(size = 16),
    axis.title = element_text(size = 18),
    axis.title.x = element_text(size = 18, margin = margin(t = 20)),
    axis.title.y = element_text(size = 18, margin = margin(r = 20)),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16),
    legend.position = "top", 
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14)
  )


a


ggsave(filename = "qtd_vagas_municipios.jpeg", plot = a,
       dpi = 400, width = 16, height = 10)

