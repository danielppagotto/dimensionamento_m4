SELECT 
    substr(lt.COMPETEN, 1, 4) as ano,
    m.regiao,
    m.uf_sigla,
    m.cod_macrorregiao,
    m.macrorregiao,
    m.cod_regsaud,
    m.regiao_saude,
    CASE
        WHEN LENGTH(m.cod_municipio) = 7 THEN SUBSTR(m.cod_municipio, 1, 6)
        WHEN m.cod_municipio LIKE '53%' THEN '530010'
        ELSE m.cod_municipio
    END AS cod_ibge,    
    m.municipio,
    m.latitude,
    m.longitude,
    SUM(lt.QT_SUS) AS quantidade_sus,
    SUM(lt.QT_NSUS) AS quantidade_nao_sus,
    SUM(lt.QT_SUS) + SUM(lt.QT_NSUS) AS qt_total,
    C.populacao,
    CAST(SUM(lt.QT_SUS) + SUM(lt.QT_NSUS) AS FLOAT) / CAST(C.populacao AS FLOAT) * 1000 AS qt_total_populacao
FROM
    Dados.cnes.LT lt 
LEFT JOIN 
    "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" m 
    ON lt.CODUFMUN = CAST(m.cod_municipio AS CHAR)
LEFT JOIN 
    "Open Analytics Layer".Territorial."População SVS por município e ano" C
    ON lt.CODUFMUN = C.cod_ibge AND CAST(substr(lt.COMPETEN, 1, 4) AS INTEGER)  = C.ano
WHERE 
    substr(lt.COMPETEN, 5, 2) = '01'
GROUP BY
    ano,
    m.regiao,
    m.uf_sigla,
    m.cod_macrorregiao,
    m.macrorregiao,
    m.cod_regsaud,
    m.regiao_saude,
    cod_ibge,
    m.municipio,
    m.latitude,
    m.longitude,
    C.populacao;