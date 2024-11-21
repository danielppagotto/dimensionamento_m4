
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


query <- 'SELECT * FROM "Open Analytics Layer"."Educação"."Quantidade de IES com cursos de saúde por município"'


IES <- sqlQuery(channel, 
                query,
                as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


IES$qtd_ies_cursos <- as.integer(IES$qtd_ies_cursos)


qtd_IES <- 
  IES |> 
  filter(cod_ibge %in% c("120040", "130260", "160030", "150140", "110020", "140010", "172100"),
         ano %in% c(2021, 2022)) |> 
  group_by(ano, uf_sigla) |> 
  summarise(total = sum(qtd_ies_cursos), .groups = "drop")



# Criação do gráfico ------------------------------------------------------------


a <- ggplot(qtd_IES, aes(x = uf_sigla, y = total, fill = factor(ano))) + 
  geom_col(position = "dodge") +
  geom_text(aes(label = total), position = position_dodge(width = 0.9), vjust = -0.5, size = 5) +
  ggtitle("Comparação da Quantidade de IES nas Capitais do Norte do Brasil entre 2021 e 2022",
          "Fonte: Censo da Educação Superior") +
  labs(x = "Capital", 
       y = "Total", 
       fill = "Ano") +
  theme_minimal() +
  scale_x_discrete(labels = c("AC"="Rio Branco", 
                              "AM"="Manaus", 
                              "AP"="Macapá", 
                              "PA"="Belém", 
                              "RO"="Porto Velho", 
                              "RR"="Boa Vista", 
                              "TO"="Palmas")) +
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


ggsave(filename = "quantidade_ies_saude.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


