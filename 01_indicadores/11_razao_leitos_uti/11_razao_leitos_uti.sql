SELECT
    substr(lt.COMPETEN, 1, 4) as ano,
    B.regiao,
    B.uf_sigla,
    B.cod_macrorregiao,
    B.macrorregiao,
    B.cod_regsaud,
    B.regiao_saude,
    CASE
        WHEN LENGTH(lt.CODUFMUN) = 7 THEN SUBSTR(lt.CODUFMUN, 1, 6)
        WHEN lt.CODUFMUN LIKE '53%' THEN '530010'
        ELSE lt.CODUFMUN
    END AS cod_ibge,
    B.municipio,
    B.latitude,
    B.longitude,
    SUM(
        CASE
            WHEN CODLEITO IN (61,74,75,76,83,85,86) THEN QT_SUS
            ELSE 0
        END
        ) AS qtd_UTI,
    SUM(
        CASE
            WHEN CODLEITO IN (62,77,78,79) THEN QT_SUS
            ELSE 0
        END
        ) AS qtd_UTIP,
    SUM(
        CASE
            WHEN CODLEITO IN (63,80,81,82) THEN QT_SUS
            ELSE 0
        END
        ) AS qtd_UTIN,
    SUM(lt.QT_SUS) AS quantidade_sus,
    SUM(lt.QT_NSUS) AS quantidade_nao_sus,
    C.populacao,
    CAST((SUM(lt.QT_SUS) + SUM(lt.QT_NSUS)) AS FLOAT) / CAST(C.populacao AS FLOAT) * 1000 AS total_populacao
FROM dados.cnes.lt
LEFT JOIN 
    "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" B
    ON lt.CODUFMUN = CAST(B.cod_municipio AS CHARACTER)
LEFT JOIN 
    "Open Analytics Layer".Territorial."População SVS por município e ano" C
    ON lt.CODUFMUN = C.cod_ibge AND CAST(substr(lt.COMPETEN, 1, 4) AS INTEGER)  = C.ano
WHERE 
    substr(lt.COMPETEN, 5, 2) = '01' AND
    CODLEITO IN (61,62,63,74,75,76,77,78,79,80,81,82,83,85,86)
GROUP BY 
    regiao,
    uf_sigla,
    cod_ibge, 
    cod_macrorregiao, 
    macrorregiao, 
    cod_regsaud, 
    regiao_saude, 
    municipio, 
    latitude, 
    longitude, 
    competen,
    C.populacao