SELECT
    SUBSTRING(COMPETEN, 1, 4) AS ano,
    m.regiao,
    m.uf_sigla,
    m.cod_macrorregiao,
    m.macrorregiao,
    m.cod_regsaud,
    m.regiao_saude,
    CASE
        WHEN m.cod_municipio LIKE '53%' THEN '530010'
        ELSE m.cod_municipio
    END AS cod_ibge,
    m.municipio,
    m.latitude,
    m.longitude,
    TP_UNID AS tipo_de_unidade,
    UN.descricao_tratado AS descricao,
    CASE
        WHEN 
        TP_UNID = '01' OR 
        TP_UNID = '02' OR 
        TP_UNID = '32' OR
        TP_UNID = '40' OR
        TP_UNID = '71' OR
        TP_UNID = '72' OR
        TP_UNID = '74' THEN 'Primária'
        WHEN 
        TP_UNID = '04' OR
        TP_UNID = '15' OR
        TP_UNID = '20' OR
        TP_UNID = '21' OR
        TP_UNID = '22' OR
        TP_UNID = '36' OR
        TP_UNID = '39' OR
        TP_UNID = '42' OR
        TP_UNID = '61' OR
        TP_UNID = '62' OR
        TP_UNID = '69' OR
        TP_UNID = '70' OR
        TP_UNID = '73' OR
        TP_UNID = '79' OR
        TP_UNID = '83' THEN 'Secundária'
        WHEN 
        TP_UNID = '05' OR
        TP_UNID = '07' THEN 'Terciária'
        ELSE 'OUTROS/MÚLTIPLOS' 
    END nivel_atencao,
    CASE
        WHEN VINC_SUS = 1 THEN 'Sim'
        WHEN VINC_SUS = 0 THEN 'Não'
        ELSE 'Desconhecido'
    END AS vinculo_sus,
    COUNT(*) AS numero_estabelecimentos,
    populacao,
    (CAST(numero_estabelecimentos AS FLOAT) / NULLIF(CAST(populacao AS FLOAT), 0)) * 10000 AS estabelecimentos_pop
FROM
    dados.cnes.ST AS DS
LEFT JOIN
     "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" AS m
    ON DS.CODUFMUN = m.cod_municipio
LEFT JOIN
    Dados.cnes."TP_UNID.parquet" UN
    ON DS.TP_UNID = UN."TIPO DE ESTABELECIMENTO"
LEFT JOIN 
    "Open Analytics Layer".Territorial."População SVS por município e ano" C
    ON DS.CODUFMUN = C.cod_ibge AND CAST(substr(DS.COMPETEN, 1, 4) AS INTEGER)  = C.ano
WHERE
    SUBSTRING(COMPETEN, 5, 2) = '01'
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
    tipo_de_unidade,
    descricao,
    VINC_SUS,
    populacao