SELECT DISTINCT
    a.ano,
    b.regiao,
    b.uf_sigla,
    a.trimestre,
    a.prof AS categoria,
    ROUND(a.Rend_medio, 2) AS rendimento_medio
FROM 
    Dados.pnadc.rendimentos a
LEFT JOIN 
    "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" b
    ON a.UF = b.uf