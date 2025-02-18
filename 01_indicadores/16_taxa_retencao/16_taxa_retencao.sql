WITH retencao AS (
----Cirurgiões-dentistas
    SELECT
<<<<<<< HEAD
        SUBSTRING(ano, 1, 4) AS ano,
        regiao_saude AS cod_regsaud,
        'Cirurgiões-dentistas' as categoria,
        retention AS taxa
    FROM
    Dados.retencao."Cirurgiões-dentistas_retencao_ano.parquet"    
=======
        regiao_saude AS cod_regsaud,
        'Cirurgiões-dentistas' as categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Cirurgiões-dentistas_retencao_geral.parquet"  
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
    UNION ALL

---- Médicos
    SELECT
<<<<<<< HEAD
        SUBSTRING (ano, 1, 4) AS ano,
        regiao_saude AS cod_regsaud,
        'Médicos' AS categoria,
        retention AS taxa
    FROM
        Dados.retencao."Médico_retencao_ano.parquet"
=======
        regiao_saude AS cod_regsaud,
        'Médicos' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Médico_retencao_geral.parquet"
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
    UNION ALL

---- Enfermeiros
    SELECT
<<<<<<< HEAD
        SUBSTRING (ano, 1, 4) AS ano,
        regiao_saude AS cod_regsaud,
        'Enfermeiros' AS categoria,
        retention AS taxa
    FROM
        Dados.retencao."Enfermeiro_retencao_ano.parquet"
=======
        regiao_saude AS cod_regsaud,
        'Enfermeiros' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Enfermeiro_retencao_geral.parquet"
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
    UNION ALL

---- Técnicos e Auxiliares de Enfermagem
    SELECT
<<<<<<< HEAD
    SUBSTRING(ano, 1, 4) AS ano,
    regiao_saude AS cod_regsaud,
    'Técnicos e Aux. de Enfermagem' AS categoria,
    retention AS taxa
    FROM
        Dados.retencao."Técnicos e auxiliares de enfermagem_retencao_ano.parquet"
=======
        regiao_saude AS cod_regsaud,
        'Técnicos e Aux. de Enfermagem' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Técnicos e auxiliares de enfermagem_retencao_geral.parquet"
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
    UNION ALL

---- Técnicos e Auxiliares de Saúde Bucal
    SELECT
<<<<<<< HEAD
    SUBSTRING(ano, 1, 4) AS ano,
    regiao_saude AS cod_regsaud,
    'Técnicos e Aux. de Saúde Bucal' AS categoria,
    retention AS taxa
    FROM
        Dados.retencao."Técnico ou Auxiliar de Saúde Bucal_retencao_ano.parquet"
)

SELECT DISTINCT
    a.ano,
=======
        regiao_saude AS cod_regsaud,
        'Técnicos e Aux. de Saúde Bucal' AS categoria,
        retencao_geral AS taxa
    FROM
        Dados.retencao."Técnico ou Auxiliar de Saúde Bucal_retencao_geral.parquet"
)

SELECT DISTINCT
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
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
<<<<<<< HEAD
    ON a.cod_regsaud = CAST(b.cod_regsaud AS INTEGER)
=======
    ON a.cod_regsaud = CAST(b.cod_regsaud AS INTEGER)
>>>>>>> 7ee83f97fa6a90354bf1d7f1d5627ab65b587670
