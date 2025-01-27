SELECT 
    a.ano,
    h.regiao,
    a.uf_sigla, 
    a.cod_macrorregiao, 
    h.macrorregiao, 
    a.cod_regsaud, 
    a.regiao_saude,
    a.cod_ibge, 
    h.municipio, 
    a.latitude, 
    a.longitude, 
    COUNT(DISTINCT co_ies) as qtd_ies_cursos,
    a.tp_categoria_administrativa
FROM "Open Analytics Layer"."Educação"."Número de vagas, matriculados, concluintes, ingressantes e inscritos em curso superior" a
LEFT JOIN
    "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" h
    ON a.cod_ibge = CAST(h.cod_municipio AS CHARACTER)
GROUP BY 
       ano,
       h.regiao, 
       a.uf_sigla, 
       a.cod_macrorregiao, 
       h.macrorregiao, 
       a.cod_regsaud, 
       a.regiao_saude, 
       cod_ibge, 
       h.municipio, 
       a.latitude, 
       a.longitude,
       a.tp_categoria_administrativa
