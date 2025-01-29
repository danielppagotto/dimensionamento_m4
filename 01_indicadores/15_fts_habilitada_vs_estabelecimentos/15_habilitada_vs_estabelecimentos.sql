WITH 
CNES_TRATADO     
    AS( 
        SELECT 
            substr(pf.COMPETEN, 1, 4) AS ano,
            PF.uf, 
            PF.CPF_PROF,
            PF.CBO,
            CASE 
                WHEN substr(PF.CBO, 1, 4) = '2515' THEN 'Psicólogos'
                WHEN substr(PF.CBO, 1, 4) = '2241' THEN 'Profissionais de Educação Física'
                WHEN substr(PF.CBO, 1, 4) = '2235' THEN 'Enfermeiros' 
                WHEN PF.CBO = '322205' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322210' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322215' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322220' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322245' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322230' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322235' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '322250' THEN 'Técnicos e Auxiliares de Enfermagem'
                WHEN PF.CBO = '251605' THEN 'Assistentes Sociais'
                WHEN PF.CBO = '223710' THEN 'Nutricionistas'
                WHEN substr(PF.CBO, 1, 4) = '2234' THEN 'Farmacêuticos'
                WHEN PF.CBO = '223305' THEN 'Médicos Veterinários'
                WHEN substr(PF.CBO, 1, 4) = '2238' THEN 'Fonoaudiólogos'
                WHEN substr(PF.CBO, 1, 3) = '225' THEN 'Médicos'
                WHEN substr(PF.CBO, 1, 4) = '2232' THEN 'Cirurgiões-Dentistas'
                WHEN PF.CBO = '322410' THEN 'Técnicos e Auxiliares em Prótese Dentária' 
                WHEN PF.CBO = '322420' THEN 'Técnicos e Auxiliares em Prótese Dentária'
                WHEN PF.CBO = '322405' THEN 'Técnicos e Auxiliares em Saúde Bucal'
                WHEN PF.CBO = '322415' THEN 'Técnicos e Auxiliares em Saúde Bucal'
            END AS categoria
        FROM Dados.cnes.PF
        WHERE 
            substr(COMPETEN, 5, 2) = '01' AND
            (substr(PF.CBO, 1, 4) = '2515' OR
            substr(PF.CBO, 1, 4) = '2241' OR
            substr(PF.CBO, 1, 4) = '2235' OR
            PF.CBO = '322205' OR
            PF.CBO = '322210' OR
            PF.CBO = '322215' OR
            PF.CBO = '322220' OR
            PF.CBO = '322245' OR
            PF.CBO = '322230' OR
            PF.CBO = '322235' OR
            PF.CBO = '322250' OR
            PF.CBO = '251605' OR
            PF.CBO = '223710' OR
            substr(PF.CBO, 1, 4) = '2234' OR
            PF.CBO = '223305' OR
            substr(PF.CBO, 1, 4) = '2238' OR
            substr(PF.CBO, 1, 3) = '225' OR
            substr(PF.CBO, 1, 4) = '2232' OR
            PF.CBO = '322410' OR
            PF.CBO = '322420' OR
            PF.CBO = '322405' OR
            PF.CBO = '322415')
    ),

CONTAGEM
    AS(
        SELECT 
            ano, 
            uf,
            categoria, 
            COUNT(DISTINCT CPF_PROF) AS atuantes
        FROM CNES_TRATADO
        WHERE 
            categoria <> 'NULL' AND
            ano = 2024
        GROUP BY 
            ano, 
            UF, 
            categoria 
    )

SELECT
    A.uf, 
    A.categoria,
    A.atuantes,
    B.qtd_2024 AS habilitados,
    CAST(A.atuantes AS FLOAT) / CAST(B.qtd_2024 AS FLOAT) * 100 AS percentual
FROM CONTAGEM A
JOIN
    Dados.conselhos."conselhos_2024.parquet" B
    ON A.uf = B.uf_sigla and A.categoria = B.categoria
ORDER BY
    uf
