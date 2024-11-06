-- Indicador de carga horária média de profissionais

WITH 
    CONSULTA_INICIAL 
    AS(
        SELECT
            SUBSTR(PF.COMPETEN, 1, 4) AS ano,
            h.regiao,
            h.uf_sigla,
            h.cod_macrorregiao,
            h.macrorregiao,
            h.cod_regsaud,
            h.regiao_saude,
            PF.CPF_PROF,
            CASE
                WHEN LENGTH(h.cod_municipio) = 7 THEN SUBSTR(h.cod_municipio, 1, 6)
                WHEN h.cod_municipio LIKE '53%' THEN '530010'
                ELSE h.cod_municipio
            END AS cod_ibge,
            h.municipio,
            h.latitude,
            h.longitude,
            CASE 
                WHEN substr(PF.CBO, 1, 4) = '2515' THEN 'Psicólogo'
                WHEN substr(PF.CBO, 1, 4) = '2241' THEN 'Profissional de Educação Física'
                WHEN substr(PF.CBO, 1, 4) = '2235' THEN 'Enfermeiro' 
                WHEN PF.CBO = '322205' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322210' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322215' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322220' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322245' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322230' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322235' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '322250' THEN 'Técnico ou Auxiliar de Enfermagem'
                WHEN PF.CBO = '251605' THEN 'Assistente Social'
                WHEN PF.CBO = '223710' THEN 'Nutricionista'
                WHEN substr(PF.CBO, 1, 4) = '2234' THEN 'Farmacêutico'
                WHEN substr(PF.CBO, 1, 4) = '3251' THEN 'Técnico em Farmácia'
                WHEN PF.CBO = '223305' THEN 'Médico Veterinário'
                WHEN substr(PF.CBO, 1, 4) = '2238' THEN 'Fonoaudiólogo'
                WHEN substr(PF.CBO, 1, 3) = '225' THEN 'Médico'
                WHEN PF.CBO = '221105' THEN 'Biólogo'
                WHEN PF.CBO = '221205' THEN 'Biomédico'
                WHEN substr(PF.CBO, 1, 4) = '2236' THEN 'Fisioterapeuta'
                WHEN PF.CBO = '223905' THEN 'Terapeuta Ocupacional'
                WHEN substr(PF.CBO, 1, 4) = '2232' THEN 'Cirurgião Dentista'
                WHEN PF.CBO = '322410' THEN 'Técnico ou Auxiliar de Prótese Dentária' 
                WHEN PF.CBO = '322420' THEN 'Técnico ou Auxiliar de Prótese Dentária'
                WHEN PF.CBO = '322405' THEN 'Técnico ou Auxiliar de Saúde Bucal'
                WHEN PF.CBO = '322415' THEN 'Técnico ou Auxiliar de Saúde Bucal'
                WHEN PF.CBO = '324115' THEN 'Técnico em Radiologia e Imagenologia'
                WHEN PF.CBO = '324120' THEN 'Técnico em Radiologia e Imagenologia'
                WHEN PF.CBO = '515105' THEN 'Agente Comunitário de Saúde'
            END AS categoria,
            SUM(PF.HORAOUTR) AS HORA_OUTR, 
            SUM(PF.HORAHOSP) AS HORA_HOSP, 
            SUM(PF.HORA_AMB) AS HORA_AMB
        FROM Dados.cnes.PF PF
        LEFT JOIN "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" h
            ON PF.CODUFMUN = CAST(h.cod_municipio AS CHARACTER)
        WHERE
            SUBSTRING(PF.COMPETEN, 5, 2) = '01' AND
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
            substr(PF.CBO, 1, 4) = '3251' OR
            PF.CBO = '223305' OR
            substr(PF.CBO, 1, 4) = '2238' OR
            substr(PF.CBO, 1, 3) = '225' OR
            PF.CBO = '221105' OR
            PF.CBO = '221205' OR
            substr(PF.CBO, 1, 4) = '2236' OR
            PF.CBO = '223905' OR
            substr(PF.CBO, 1, 4) = '2232' OR
            PF.CBO = '322410' OR
            PF.CBO = '322420' OR
            PF.CBO = '322405' OR
            PF.CBO = '322415' OR           
            PF.CBO = '324115' OR
            PF.CBO = '324120' OR
            PF.CBO = '515105')
        GROUP BY
            SUBSTR(PF.COMPETEN, 1, 4),
            h.regiao,
            h.uf_sigla,
            h.cod_macrorregiao,
            h.macrorregiao,
            h.cod_regsaud,
            PF.CPF_PROF,
            h.regiao_saude,
            cod_ibge,
            h.municipio,
            h.latitude,
            h.longitude,
            categoria
    ), 
    SEGUNDA_CONSULTA 
    AS(
        SELECT 
            ano, 
            regiao, 
            uf_sigla,
            cod_macrorregiao,
            macrorregiao,
            cod_regsaud,
            regiao_saude,
            cod_ibge,
            municipio,
            latitude,
            longitude,
            categoria,
            CPF_PROF,
            HORA_OUTR,
            HORA_HOSP,
            HORA_AMB,
            HORA_OUTR + HORA_HOSP + HORA_AMB AS HORAS
        FROM CONSULTA_INICIAL
    )


SELECT 
    ano, 
    regiao, 
    uf_sigla,
    cod_macrorregiao,
    macrorregiao,
    cod_regsaud,
    regiao_saude,
    cod_ibge,
    municipio,
    latitude,
    longitude,
    categoria,
    AVG(HORAS) AS MEDIA_PROF 
FROM SEGUNDA_CONSULTA
GROUP BY 
    ano, 
    regiao, 
    uf_sigla,
    cod_macrorregiao,
    macrorregiao,
    cod_regsaud,
    regiao_saude,
    cod_ibge,
    municipio,
    latitude,
    longitude,
    categoria