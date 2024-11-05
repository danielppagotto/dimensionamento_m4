WITH 
profissionais_CH AS (
    SELECT
        CASE                
            WHEN LENGTH(pf.codufmun) = 7 THEN SUBSTR(pf.codufmun, 1, 6)
            WHEN pf.codufmun LIKE '53%' THEN '530010' 
            ELSE pf.codufmun
        END AS cod_ibge,
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
        CASE
            WHEN 
                pf.TP_UNID = '01' OR 
                pf.TP_UNID = '02' OR 
                pf.TP_UNID = '32' OR
                pf.TP_UNID = '40' OR
                pf.TP_UNID = '71' OR
                pf.TP_UNID = '72' OR
                pf.TP_UNID = '74' THEN 'Primária'
            WHEN 
                pf.TP_UNID = '04' OR
                pf.TP_UNID = '15' OR
                pf.TP_UNID = '20' OR
                pf.TP_UNID = '21' OR
                pf.TP_UNID = '22' OR
                pf.TP_UNID = '36' OR
                pf.TP_UNID = '39' OR
                pf.TP_UNID = '42' OR
                pf.TP_UNID = '61' OR
                pf.TP_UNID = '62' OR
                pf.TP_UNID = '69' OR
                pf.TP_UNID = '70' OR
                pf.TP_UNID = '73' OR
                pf.TP_UNID = '79' OR
                pf.TP_UNID = '83' THEN 'Secundária'
            WHEN 
                pf.TP_UNID = '05' OR
                pf.TP_UNID = '07' THEN 'Terciária'
            ELSE 'OUTROS/MÚLTIPLOS' 
        END AS nivel_atencao,
        substr(pf.COMPETEN, 1, 4) AS ano,
        SUM(pf.HORAOUTR+pf.HORAHOSP+pf.HORA_AMB) AS ch_total
    FROM Dados.cnes.pf pf
    WHERE
        substr(pf.COMPETEN, 5, 2) = '01' AND
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
        cod_ibge, 
        ano,
        categoria,
        nivel_atencao
)

SELECT 
    ch.ano,
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
    ch.categoria,
    ch.nivel_atencao,
    ch.ch_total,
    CAST((CAST(ch.ch_total AS FLOAT)/CAST(40 AS FLOAT)) AS FLOAT) AS FTE_40
FROM profissionais_CH ch
LEFT JOIN "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" m
    ON CAST(ch.cod_ibge AS INTEGER) = m.cod_municipio
WHERE ch.categoria IS NOT NULL
