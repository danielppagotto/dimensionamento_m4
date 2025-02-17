WITH retencao AS (
----Cirurgiões-dentistas
    SELECT
        regiao_saude AS cod_regsaud,
        'Cirurgiões-dentistas' as categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Cirurgiões-dentistas_retencao_geral.parquet"  
    UNION ALL

---- Médicos
    SELECT
        regiao_saude AS cod_regsaud,
        'Médicos' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Médico_retencao_geral.parquet"
    UNION ALL

---- Enfermeiros
    SELECT
        regiao_saude AS cod_regsaud,
        'Enfermeiros' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Enfermeiro_retencao_geral.parquet"
    UNION ALL

---- Técnicos e Auxiliares de Enfermagem
    SELECT
        regiao_saude AS cod_regsaud,
        'Técnicos e Aux. de Enfermagem' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Técnicos e auxiliares de enfermagem_retencao_geral.parquet"
    UNION ALL

---- Técnicos e Auxiliares de Saúde Bucal
    SELECT
        regiao_saude AS cod_regsaud,
        'Técnicos e Aux. de Saúde Bucal' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Técnico ou Auxiliar de Saúde Bucal_retencao_geral.parquet"
)

SELECT DISTINCT
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
