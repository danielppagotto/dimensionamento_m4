WITH IBGE_ALL AS (    
    SELECT
        '2005' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2005 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2007' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2007 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2009' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2009 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2011' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2011 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2013' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2013 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2015' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2015 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2017' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2017 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2019' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2019 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2021' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2021 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
    UNION ALL
    SELECT
        '2023' AS ano, 
        uf_sigla,
        CASE
            WHEN LENGTH(cod_ibge) = 7 THEN SUBSTR(cod_ibge, 1, 6)
            WHEN cod_ibge LIKE '53%' THEN '530010' 
            ELSE cod_ibge
        END AS cod_ibge,
        municipio,
        rede,
        IDEB_2023 AS IDEB
    FROM Dados.ideb."ideb_anos_iniciais.parquet"
)

SELECT
    a.ano,
    b.regiao,
    a.uf_sigla,
    b.cod_macrorregiao,
    b.macrorregiao,
    b.cod_regsaud,
    b.regiao_saude,
    a.cod_ibge,
    a.municipio,
    b.latitude,
    b.longitude,
    a.rede,
    a.IDEB
FROM IBGE_ALL a
LEFT JOIN 
    "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" b
    ON a.cod_ibge = CAST(b.cod_municipio AS CHARACTER)
WHERE
    IDEB IS NOT NULL