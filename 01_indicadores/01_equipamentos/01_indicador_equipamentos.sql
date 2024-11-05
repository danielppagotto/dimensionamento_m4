
-- Indicador para calcular razao de equipamentos

WITH POPULACIONAL AS (
    SELECT 
        ano, 
        SUBSTR(COD_MUN, 1, 6) AS codufmun, 
        SUM(POP) AS POP 
    FROM Dados.populacional."POP_SVS.parquet" 
    GROUP BY ano, SUBSTR(COD_MUN, 1, 6)

    UNION ALL

    SELECT 
        2022 AS ano, 
        SUBSTR(COD_MUN, 1, 6) AS codufmun, 
        SUM(POP) AS POP 
    FROM Dados.populacional."POP_SVS.parquet" 
    WHERE ano = 2021
    GROUP BY SUBSTR(COD_MUN, 1, 6)

    UNION ALL

    SELECT 
        2023 AS ano, 
        SUBSTR(COD_MUN, 1, 6) AS codufmun, 
        SUM(POP) AS POP 
    FROM Dados.populacional."POP_SVS.parquet" 
    WHERE ano = 2021
    GROUP BY SUBSTR(COD_MUN, 1, 6)

    UNION ALL

    SELECT 
        2024 AS ano, 
        SUBSTR(COD_MUN, 1, 6) AS codufmun, 
        SUM(POP) AS POP 
    FROM Dados.populacional."POP_SVS.parquet" 
    WHERE ano = 2021
    GROUP BY SUBSTR(COD_MUN, 1, 6)
),
EQUIPAMENTOS AS (
    SELECT
        CAST(SUBSTRING(COMPETEN, 1, 4) AS INTEGER) AS ano,
        CAST(CONCAT(SUBSTRING(COMPETEN, 5, 2)) AS INTEGER) AS mes,
        SUBSTR(codufmun, 1, 6) AS CODUFMUN,
        SUM(CASE WHEN IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS quantidade_equip_sus,
        SUM(CASE WHEN IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS quantidade_equip_n_sus,
        SUM(CASE WHEN CODEQUIP IN ('02', '03', '16', '17') AND IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_mamografo_sus,
        SUM(CASE WHEN CODEQUIP IN ('04', '05', '06', '07', '08', '09', '10') AND IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_raiox_sus,
        SUM(CASE WHEN CODEQUIP IN ('12') AND IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_ressonancia_sus,
        SUM(CASE WHEN CODEQUIP IN ('11') AND IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_tomografo_sus,
        SUM(CASE WHEN CODEQUIP IN ('02', '03', '16', '17') AND IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_mamografo_n_sus,
        SUM(CASE WHEN CODEQUIP IN ('04', '05', '06', '07', '08', '09', '10') AND IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_raiox_n_sus,
        SUM(CASE WHEN CODEQUIP IN ('12') AND IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_ressonancia_n_sus,
        SUM(CASE WHEN CODEQUIP IN ('11') AND IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS soma_quantidade_tomografo_n_sus
    FROM Dados.cnes.EQ eq
    WHERE
        ano >= 2010
        and mes = 1
        and TIPEQUIP = '1'
    GROUP BY
        ano,
        mes,
        SUBSTR(codufmun, 1, 6)
)

SELECT
    e.ano,
    m.regiao,
    m.uf_sigla,
    m.cod_macrorregiao,
    m.macrorregiao,
    m.cod_regsaud,
    m.regiao_saude,
    m.cod_municipio AS cod_ibge,
    m.municipio,
    m.latitude,
    m.longitude,
    p.pop AS soma_populacao,
    e.soma_quantidade_mamografo_sus,
    e.soma_quantidade_raiox_sus,
    e.soma_quantidade_tomografo_sus,
    e.soma_quantidade_ressonancia_sus,
    (e.soma_quantidade_mamografo_sus + e.soma_quantidade_raiox_sus + e.soma_quantidade_tomografo_sus + e.soma_quantidade_ressonancia_sus) AS soma_quantidade_equip_sus,
    e.soma_quantidade_mamografo_n_sus,
    e.soma_quantidade_raiox_n_sus,
    e.soma_quantidade_tomografo_n_sus,
    e.soma_quantidade_ressonancia_n_sus,
    (e.soma_quantidade_mamografo_n_sus + e.soma_quantidade_raiox_n_sus + e.soma_quantidade_tomografo_n_sus + e.soma_quantidade_ressonancia_n_sus) AS soma_quantidade_equip_n_sus,
    CAST(soma_quantidade_equip_sus AS FLOAT) / CAST(p.pop AS FLOAT) * 1000 AS equipamento_1000_habitantes_sus,
    CAST(soma_quantidade_equip_n_sus AS FLOAT) / CAST(p.pop AS FLOAT) * 1000 AS equipamento_1000_habitantes_n_sus
FROM EQUIPAMENTOS e
LEFT JOIN POPULACIONAL p ON e.ano = p.ano AND e.CODUFMUN = p.codufmun
LEFT JOIN "Analytics Layer".Territorial."Municípios - Hierarquia Completa" m ON e.CODUFMUN = m.cod_municipio