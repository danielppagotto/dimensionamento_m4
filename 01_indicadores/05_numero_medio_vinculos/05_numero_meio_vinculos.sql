WITH 
CNES_TRATADO     
    AS( 
        SELECT 
            substr(pf.COMPETEN, 1, 4) AS ano,
            CASE
                WHEN LENGTH(pf.codufmun) = 7 THEN SUBSTR(pf.codufmun, 1, 6)
                WHEN pf.codufmun LIKE '53%' THEN '530010' 
                ELSE pf.codufmun
            END AS cod_ibge,
            PF.uf, 
            PF.CPF_PROF,
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
            END AS categoria
        FROM Dados.cnes.PF
        WHERE substr(COMPETEN, 5, 2) = '01'   
    ),

CONTAGEM
    AS(
        SELECT uf,
               cod_ibge,
               ano,
               categoria,
               CPF_PROF, 
               COUNT(*) as total
        FROM CNES_TRATADO
        WHERE categoria <> 'NULL'
        GROUP BY uf, 
                 cod_ibge, 
                 ano,
                 categoria, 
                 CPF_PROF 
    ),

CONTAGEM_MEDIA 
    As(
        SELECT uf,
               cod_ibge, 
               ano,
               categoria, 
               AVG(total) AS vinc_medio
        FROM CONTAGEM
        GROUP BY uf,
                 cod_ibge, 
                 ano,
                 categoria
    )
    
SELECT  
    A.ano, 
    B.regiao, 
    B.uf_sigla,
    cod_macrorregiao, 
    B.macrorregiao,
    cod_regsaud, 
    B.regiao_saude, 
    cod_ibge, 
    B.municipio, 
    B.latitude, 
    B.longitude,
    A.categoria, 
    A.vinc_medio
FROM CONTAGEM_MEDIA A
LEFT JOIN "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" B
  ON A.cod_ibge = CAST(B.cod_municipio AS CHARACTER)