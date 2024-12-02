WITH EQUIPAMENTOS AS (
    SELECT
        CAST(SUBSTRING(COMPETEN, 1, 4) AS INTEGER) AS ano,
        CASE
            WHEN LENGTH(CODUFMUN) = 7 THEN SUBSTR(CODUFMUN, 1, 6)
            WHEN CODUFMUN LIKE '53%' THEN '530010'
            ELSE CODUFMUN
        END AS cod_ibge,
        CASE
            WHEN CODEQUIP = '80' THEN 'Equipamento odontológico completo'
            WHEN CODEQUIP = '81' THEN 'Compressor odontológico'
            WHEN CODEQUIP = '82' THEN 'Fotopolimerizador'
            WHEN CODEQUIP = '83' THEN 'Caneta de alta rotação'
            WHEN CODEQUIP = '84' THEN 'Caneta de baixa rotação'
            WHEN CODEQUIP = '85' THEN 'Amalgamador'
            WHEN CODEQUIP = '86' THEN 'Aparelho de profilaxia c/ jato de bicarbonato'
        END AS equipamento,
        SUM(CASE WHEN IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS qtd_equip_sus,
        SUM(CASE WHEN IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS qtd_equip_nao_sus
    FROM 
        Dados.cnes.EQ eq
    WHERE 
        SUBSTRING(COMPETEN, 5, 2) = '01' AND
        ano >= 2010 AND
        TIPEQUIP = '7' AND
        CODEQUIP IN ('80', '81', '82', 
                    '83', '84', '85', 
                    '86')
    GROUP BY
        ano,
        CODEQUIP,
        cod_ibge
)

SELECT 
    e.ano,
    p.regiao,
    p.uf_sigla,
    p.cod_macrorregiao,
    p.macrorregiao,
    p.cod_regsaud,
    p.regiao_saude,
    e.cod_ibge,
    p.municipio,
    p.latitude,
    p.longitude,
    e.equipamento,
    e.qtd_equip_sus,
    e.qtd_equip_nao_sus,
    p.populacao,
    CAST(qtd_equip_sus AS FLOAT) / CAST(p.populacao AS FLOAT) * 10000 AS equip_pop_sus,        
    CAST(qtd_equip_nao_sus AS FLOAT) / CAST(p.populacao AS FLOAT) * 10000 AS equip_pop_nao_sus
FROM 
    EQUIPAMENTOS e
LEFT JOIN 
    "Open Analytics Layer".Territorial."População SVS por município e ano" p
    ON e.cod_ibge = p.cod_ibge AND e.ano = p.anoWITH EQUIPAMENTOS AS (
    SELECT
        CAST(SUBSTRING(COMPETEN, 1, 4) AS INTEGER) AS ano,
        CASE
            WHEN LENGTH(CODUFMUN) = 7 THEN SUBSTR(CODUFMUN, 1, 6)
            WHEN CODUFMUN LIKE '53%' THEN '530010'
            ELSE CODUFMUN
        END AS cod_ibge,
        CASE
            WHEN CODEQUIP = '80' THEN 'Equipamento odontológico completo'
            WHEN CODEQUIP = '81' THEN 'Compressor odontológico'
            WHEN CODEQUIP = '82' THEN 'Fotopolimerizador'
            WHEN CODEQUIP = '83' THEN 'Caneta de alta rotação'
            WHEN CODEQUIP = '84' THEN 'Caneta de baixa rotação'
            WHEN CODEQUIP = '85' THEN 'Amalgamador'
            WHEN CODEQUIP = '86' THEN 'Aparelho de profilaxia c/ jato de bicarbonato'
        END AS equipamento,
        SUM(CASE WHEN IND_SUS = '1' THEN QT_EXIST ELSE 0 END) AS qtd_equip_sus,
        SUM(CASE WHEN IND_NSUS = '1' THEN QT_EXIST ELSE 0 END) AS qtd_equip_nao_sus
    FROM 
        Dados.cnes.EQ eq
    WHERE 
        SUBSTRING(COMPETEN, 5, 2) = '01' AND
        ano >= 2010 AND
        TIPEQUIP = '7' AND
        CODEQUIP IN ('80', '81', '82', 
                    '83', '84', '85', 
                    '86')
    GROUP BY
        ano,
        CODEQUIP,
        cod_ibge
)

SELECT 
    e.ano,
    p.regiao,
    p.uf_sigla,
    p.cod_macrorregiao,
    p.macrorregiao,
    p.cod_regsaud,
    p.regiao_saude,
    e.cod_ibge,
    p.municipio,
    p.latitude,
    p.longitude,
    e.equipamento,
    e.qtd_equip_sus,
    e.qtd_equip_nao_sus,
    p.populacao,
    CAST(qtd_equip_sus AS FLOAT) / CAST(p.populacao AS FLOAT) * 10000 AS equip_pop_sus,        
    CAST(qtd_equip_nao_sus AS FLOAT) / CAST(p.populacao AS FLOAT) * 10000 AS equip_pop_nao_sus
FROM 
    EQUIPAMENTOS e
LEFT JOIN 
    "Open Analytics Layer".Territorial."População SVS por município e ano" p
    ON e.cod_ibge = p.cod_ibge AND e.ano = p.ano
