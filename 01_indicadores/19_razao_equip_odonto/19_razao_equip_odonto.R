
library(tidyverse)
library(RODBC)
library(geobr)
library(scales)
library(sf) 
library(ggrepel) 
library(ggspatial)
library(viridis)
library(patchwork)
library(hrbrthemes)
library(fmsb)
library(colormap)




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


populacao <- 
  populacao |>
  filter(uf_sigla == "MT",
         ano == '2024') |>
  group_by(macrorregiao) |>
  summarise(pop = sum(populacao))


equipamentos$quantidade_equip_sus <- as.integer(equipamentos$quantidade_equip_sus)  
equipamentos$quantidade_equip_nao_sus <- as.integer(equipamentos$quantidade_equip_nao_sus)

equip_filtro <-
  equipamentos |> 
  filter(uf_sigla == 'MT',
         ano == '2024') |>
  group_by(macrorregiao) |> 
  summarise(
    total_sus = sum(quantidade_equip_sus, na.rm = TRUE),
    total_nsus = sum(quantidade_equip_nao_sus, na.rm = TRUE),
    .groups = 'drop' # Opcional, evita mensagens sobre agrupamento
  )


equip_pop <-
  equip_filtro |>
  left_join(populacao, by = c("macrorregiao")) |>
  mutate(razao_sus = 10000 * (total_sus)/pop) |> 
  mutate(macrorregiao = gsub("Macrorregião ?", "", macrorregiao))



# Criação do mapa ------------------------------------------------------------


equip_pop_selecionado <- equip_pop |>
  select(macrorregiao, razao_sus)


equip_pop_wide <- equip_pop_selecionado |>
  pivot_wider(
    names_from = macrorregiao,  
    values_from = razao_sus,   
    values_fn = list(razao_sus = sum) 
  )


radar_data <- rbind(rep(25,5) , rep(0,5) , equip_pop_wide)


# Custom the radarChart !
par(mar=c(0,0,0,0))
radarchart(radar_data, 
          axistype=1,
          pcol=rgb(0.2,0.5,0.5,0.9), 
          pfcol=rgb(0.2,0.5,0.5,0.3), 
          plwd=4,
          cglcol="grey",
          cglty=1, 
          axislabcol="grey", 
          caxislabels=seq(0,25,5), 
          cglwd=0.8,
          vlcex=0.8
)

# Adicionar título com personalização
title(main = "Razão de Equipamentos Odontológicos SUS por Macrorregião", 
      col.main = "black",         # Cor do título
      font.main = 2,              # Tipo de fonte (negrito)
      cex.main = 1.5,             # Tamanho do título
      family = "Arial")           # Fonte (se disponível)

#titulo grid
grid.text("Razão de Equipamentos Odontológicos SUS por Macrorregião", 
          x = 0.5, y = 0.99,  # Posição do título
          gp = gpar(fontsize = 20, fontface = "bold", col = "black"))
