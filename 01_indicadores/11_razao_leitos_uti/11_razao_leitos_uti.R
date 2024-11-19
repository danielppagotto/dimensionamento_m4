
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



# tratamento dos dados ----------------------------------------------------


leitos$populacao <- as.integer(leitos$populacao)
leitos$qtd_UTI <- as.integer(leitos$qtd_UTI)
leitos$qtd_UTIP <- as.integer(leitos$qtd_UTIP)
leitos$qtd_UTIN <- as.integer(leitos$qtd_UTIN)


leitos_goias <- 
  leitos |> 
  filter(uf_sigla == "GO") |> 
  group_by(ano, uf_sigla) |> 
  summarise(pop = sum(populacao),
            qtd_UTI = sum(qtd_UTI),
            qtd_UTIP = sum(qtd_UTIP),
            qtd_UTIN = sum(qtd_UTIN)) |> 
  mutate(UTI = 10000 * (qtd_UTI/pop)) |> 
  mutate(UTIP = 10000 * (qtd_UTIP/pop)) |> 
  mutate(UTIN = 10000 * (qtd_UTIN/pop)) 


leitos_goias_long <- leitos_goias |> 
  pivot_longer(cols = c(UTI, UTIP, UTIN), 
               names_to = "tipo_uti", 
               values_to = "valor_uti")



# Criação do Gráfico ------------------------------------------------------


a <- leitos_goias_long |> 
  ggplot(aes(x = ano, y = valor_uti, color = tipo_uti, group = tipo_uti)) +
  geom_line(size = 1.5) + 
  theme_minimal() + 
  xlab("Ano") +
  ylab("Razão (total de leitos de UTI por 10.000 habitantes)") +
  ggtitle("Evolução da Razão de Leitos de UTI por População em Goiás",
          "Fonte: CNES-Leitos, competência de janeiro de cada ano; população de acordo com projeções SVSA") +
  scale_color_discrete(
    name = "Tipo",
    labels = c("UTI" = "Leitos de UTI", "UTIP" = "Leitos de UTI Pediátrica", "UTIN" = "Leitos de UTI Neonatal")  # Alterando apenas os rótulos
  ) +  
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


ggsave(filename = "razao_leitos_uti.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


