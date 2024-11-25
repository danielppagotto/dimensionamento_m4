
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


query <- 'SELECT * FROM "Open Analytics Layer".Infraestrutura."Razão de leitos por população"'


leitos <- sqlQuery(channel, 
                  query,
                  as.is = TRUE)



# tratamento dos dados ----------------------------------------------------


leitos$populacao <- as.integer(leitos$populacao)
leitos$quantidade_sus <- as.integer(leitos$quantidade_sus)


razao_leitos <- 
  leitos |> 
  filter (ano == '2024') |> 
  group_by(ano, regiao) |> 
  summarise(
    qtd_sus = sum(quantidade_sus),
    pop = sum(populacao)) |>
  mutate(razao_sus = 10000 * (qtd_sus)/pop) |>
  drop_na() |>
  mutate(regiao = str_replace(regiao, "Região ", ""))



# Criação do Gráfico ------------------------------------------------------


razao_leitos <- razao_leitos |> 
  mutate(regiao = factor(regiao, levels = rev(razao_leitos$regiao[order(razao_leitos$razao_sus)])))

a <- razao_leitos |> 
  ggplot(aes(x = regiao, y = razao_sus, fill = regiao)) +
  geom_col(position = "dodge") +  
  geom_text(aes(label = round(razao_sus, 2)),    
            position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 5) + 
  ggtitle("Razão de leitos do SUS por população nas regiões do Brasil em 2024",
          "Fonte: CNES-Leitos, competência de janeiro de cada ano; população de acordo com projeções SVSA") +
  labs(x = "Região",
       y = "Razão (total de leitos por 10.000 habitantes)",
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


ggsave(filename = "razao_leitos.jpeg", plot = a,
       dpi = 400, width = 16, height = 8)


