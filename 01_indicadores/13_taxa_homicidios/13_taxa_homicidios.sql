WITH quantidade_homicidio AS (
    SELECT
        substr(DTOBITO, -4) AS ano,
        CASE
            WHEN LENGTH(CODMUNRES) = 7 THEN SUBSTR(CODMUNRES, 1, 6)
            WHEN CODMUNRES LIKE '53%' THEN '530010'
            ELSE CODMUNRES
        END AS cod_ibge,
        COUNT(*) AS obitos_ano_homicidio
    FROM Dados.sim.do
    WHERE
        CAUSABAS LIKE 'X85%' OR CAUSABAS LIKE 'X86%' OR CAUSABAS LIKE 'X87%' 
        OR CAUSABAS LIKE 'X88%' OR CAUSABAS LIKE 'X89%' OR CAUSABAS LIKE 'X90%' 
        OR CAUSABAS LIKE 'X91%' OR CAUSABAS LIKE 'X92%' OR CAUSABAS LIKE 'X93%' 
        OR CAUSABAS LIKE 'X94%' OR CAUSABAS LIKE 'X95%' OR CAUSABAS LIKE 'X96%' 
        OR CAUSABAS LIKE 'X97%' OR CAUSABAS LIKE 'X98%' OR CAUSABAS LIKE 'X99%' 
        OR CAUSABAS LIKE 'Y00%' OR CAUSABAS LIKE 'Y01%' OR CAUSABAS LIKE 'Y02%' 
        OR CAUSABAS LIKE 'Y03%' OR CAUSABAS LIKE 'Y04%' OR CAUSABAS LIKE 'Y05%' 
        OR CAUSABAS LIKE 'Y06%' OR CAUSABAS LIKE 'Y07%' OR CAUSABAS LIKE 'Y08%' 
        OR CAUSABAS LIKE 'Y09%' 
        OR CAUSABAS LIKE 'Y22%' OR CAUSABAS LIKE 'Y23%' OR CAUSABAS LIKE 'Y24%' 
        OR CAUSABAS LIKE 'Y35%' 
        OR CAUSABAS IN ('Y871', 'Y890')
    GROUP BY
        cod_ibge,
        ano
)

SELECT 
    a.ano,
    b.regiao, 
    b.uf_sigla, 
    b.cod_macrorregiao,
    b.macrorregiao,
    b.cod_regsaud, 
    b.regiao_saude,
    a.cod_ibge,
    b.municipio,
    b.latitude,
    b.longitude,
    a.obitos_ano_homicidio,
    CAST(c.populacao AS NUMERIC) as populacao,
    CASE
        WHEN c.populacao = 0 THEN 0  -- Se a população for zero, a taxa também será zero
        ELSE (a.obitos_ano_homicidio / CAST(c.populacao AS DECIMAL)) * 100000
    END AS taxa_homicidios_por_populacao
FROM quantidade_homicidio a
LEFT JOIN "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" b
    ON a.cod_ibge = CAST(b.cod_municipio AS CHARACTER)
LEFT JOIN "Open Analytics Layer".Territorial."População SVS por município e ano" c
    ON a.cod_ibge = CAST(c.cod_ibge AS CHARACTER) AND a.ano = c.ano     
WHERE 
    obitos_ano_homicidio IS NOT NULL AND
    ano > '2009'