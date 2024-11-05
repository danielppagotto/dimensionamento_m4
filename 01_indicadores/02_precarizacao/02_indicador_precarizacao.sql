
-- Indicador para calcular distribuicao de vinculos

WITH
    CNES_VINC 
    AS (
        SELECT 
            SUBSTR(PF.COMPETEN, 1, 4) AS ano, 
            a.regiao, 
            a.uf_sigla, 
            a.cod_macrorregiao,
            a.macrorregiao,
            a.cod_regsaud, 
            a.regiao_saude, 
            CASE
                WHEN LENGTH(PF.CODUFMUN) = 7 THEN SUBSTR(PF.CODUFMUN, 1, 6)
                WHEN PF.CODUFMUN LIKE '53%' THEN '530010'
                ELSE PF.CODUFMUN
            END AS cod_ibge, 
            a.municipio,
            a.latitude, 
            a.longitude,
            PF.CBO, 
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
                ELSE 'Outros'
            END AS categoria,
            PF.VINCULAC, 
            CASE
                WHEN SUBSTR(VINCULAC, 1, 4) = '0101' OR
                     SUBSTR(VINCULAC, 1, 4) = '0102' OR 
                     SUBSTR(VINCULAC, 1, 4) = '0105' OR
                     SUBSTR(VINCULAC, 1, 3) = '100'  THEN 'Protegido'
                WHEN 
                     SUBSTR(VINCULAC, 1, 4) = '0103' OR
                     SUBSTR(VINCULAC, 1, 4) = '0104' OR 
                     SUBSTR(VINCULAC, 1, 2) = '02' OR
                     SUBSTR(VINCULAC, 1, 2) = '03' OR
                     SUBSTR(VINCULAC, 1, 4) = '0401' OR
                     SUBSTR(VINCULAC, 1, 4) = '0402' OR
                     SUBSTR(VINCULAC, 1, 2) = '07' OR
                     SUBSTR(VINCULAC, 1, 2) = '08' OR 
                     SUBSTR(VINCULAC, 1, 2) = '09' THEN 'Precarizado'
                WHEN 
                     SUBSTR(VINCULAC, 1, 2) = '05' OR 
                     SUBSTR(VINCULAC, 1, 2) = '06' OR 
                     SUBSTR(VINCULAC, 1, 4) = '0403' THEN 'Outros'
                ELSE 'Sem informação'
            END categorias_vinculos,
            v.DESCRIÇÃO, 
            TP_UNID,
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
        END nivel_atencao
           FROM Dados.cnes.PF PF
        LEFT JOIN Dados.cnes."VINCULAC.parquet" v            
            ON PF.VINCULAC = v.CHAVE
        LEFT JOIN "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" a 
            ON SUBSTR(PF.CODUFMUN, 1, 6) = CAST(a.cod_municipio AS CHARACTER)
        WHERE SUBSTR(PF.COMPETEN, 5, 2) = '01' 
        
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
    nivel_atencao,
    categorias_vinculos, 
    COUNT(*) as quantidade,
    ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (PARTITION BY ano,
                                                                regiao,
                                                                uf_sigla, 
                                                                cod_macrorregiao,
                                                                macrorregiao,
                                                                cod_regsaud, 
                                                                regiao_saude,
                                                                cod_ibge,
                                                                municipio,
                                                                categoria,
                                                                nivel_atencao,
                                                                latitude,
                                                                longitude),2) as percentual
FROM 
    CNES_VINC
WHERE 
    ano > 2009 
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
    categoria,
    nivel_atencao,
    categorias_vinculos
ORDER BY 
    ano,
    cod_ibge,
    categoria,
    nivel_atencao,
    categorias_vinculos