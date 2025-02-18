WITH retencao AS (
----Cirurgiões-dentistas
    SELECT
        SUBSTRING(ano, 1, 4) AS ano,
        regiao_saude AS cod_regsaud,
        'Cirurgiões-dentistas' as categoria,
        retention AS taxa
    FROM
    Dados.retencao."Cirurgiões-dentistas_retencao_ano.parquet"    
    UNION ALL

---- Médicos
    SELECT
        SUBSTRING (ano, 1, 4) AS ano,
        regiao_saude AS cod_regsaud,
        'Médicos' AS categoria,
        retention AS taxa
    FROM
        Dados.retencao."Médico_retencao_ano.parquet"
    UNION ALL

---- Enfermeiros
    SELECT
        SUBSTRING (ano, 1, 4) AS ano,
        regiao_saude AS cod_regsaud,
        'Enfermeiros' AS categoria,
        retention AS taxa
    FROM
        Dados.retencao."Enfermeiro_retencao_ano.parquet"
    UNION ALL

---- Técnicos e Auxiliares de Enfermagem
    SELECT
    SUBSTRING(ano, 1, 4) AS ano,
    regiao_saude AS cod_regsaud,
    'Técnicos e Aux. de Enfermagem' AS categoria,
    retention AS taxa
    FROM
        Dados.retencao."Técnicos e auxiliares de enfermagem_retencao_ano.parquet"
    UNION ALL

---- Técnicos e Auxiliares de Saúde Bucal
    SELECT
    SUBSTRING(ano, 1, 4) AS ano,
    regiao_saude AS cod_regsaud,
    'Técnicos e Aux. de Saúde Bucal' AS categoria,
    retention AS taxa
    FROM
        Dados.retencao."Técnico ou Auxiliar de Saúde Bucal_retencao_ano.parquet"
)

SELECT DISTINCT
    a.ano,
    b.regiao,
    b.uf_sigla,
    a.cod_regsaud,
    b.regiao_saude,
    a.categoria,
    a.taxa
FROM 
    retencao a
LEFT JOIN
    "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" b
    ON a.cod_regsaud = CAST(b.cod_regsaud AS INTEGER)