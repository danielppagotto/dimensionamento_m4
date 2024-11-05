WITH
    medicos_familia 
    AS (
    SELECT
        SUBSTR(PF.COMPETEN, 1, 4) AS ano,
        h.regiao,
        h.uf_sigla,
        h.cod_macrorregiao,
        h.macrorregiao,
        h.cod_regsaud,
        h.regiao_saude,
        CASE
            WHEN LENGTH(codufmun) = 7 THEN SUBSTR(codufmun, 1, 6)
            WHEN codufmun LIKE '53%' THEN '530010'
            ELSE codufmun
        END AS cod_ibge,
        h.municipio,
        h.latitude,
        h.longitude,
    COUNT(DISTINCT CONCAT(CPF_PROF, CBO)) AS qtd_distinta_cpf_cbo,
    SUM(pf.HORAOUTR+pf.HORAHOSP+pf.HORA_AMB) AS ch_total,
    CAST((CAST((SUM(pf.HORAOUTR+pf.HORAHOSP+pf.HORA_AMB)) AS FLOAT)/CAST(40 AS FLOAT)) AS FLOAT) AS FTE_40
    FROM Dados.cnes.PF 
    LEFT JOIN 
        "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" h
        ON PF.CODUFMUN = CAST(h.cod_municipio AS CHARACTER)
    WHERE
        substr(pf.COMPETEN, 5, 2) = '01' AND
        pf.CBO = '225142' OR -- Médico da estratégia de saúde da família
        pf.CBO = '225130' -- Médico de família e comunidade
    GROUP BY
        ano,
        h.regiao,
        h.uf_sigla,
        h.cod_macrorregiao,
        h.macrorregiao,
        h.cod_regsaud,
        h.regiao_saude,
        cod_ibge,
        h.municipio,
        h.latitude,
        h.longitude
    )

SELECT 
    a.ano,
    a.regiao,
    a.uf_sigla,
    a.cod_macrorregiao,
    a.macrorregiao,
    a.cod_regsaud,
    a.regiao_saude,
    a.cod_ibge,
    a.municipio,
    a.latitude,
    a.longitude,
    a.qtd_distinta_cpf_cbo,
    a.ch_total,
    a.FTE_40,
    b.populacao,
    (CAST(a.qtd_distinta_cpf_cbo AS FLOAT) / CAST(b.populacao AS FLOAT)) * 1000 AS medicos_populacao,
    (CAST(a.FTE_40 AS FLOAT) / CAST(b.populacao AS FLOAT)) * 1000 AS FTE_populacao    
FROM medicos_familia a
LEFT JOIN 
    "Open Analytics Layer".Territorial."População SVS por município e ano" b
    ON a.cod_ibge = b.cod_ibge AND a.ano = b.ano