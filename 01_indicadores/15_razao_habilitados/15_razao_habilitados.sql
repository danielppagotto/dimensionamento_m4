SELECT
    A.uf_sigla AS uf,
    A.categoria,
    A.qtd_2024 AS habilitados,
    B.populacao,
    CAST(A.qtd_2024 * 10000 AS FLOAT) / B.populacao AS taxa_populacao
FROM
    dados.conselhos."conselhos_2024.parquet" A
LEFT JOIN   (
            SELECT 
                C.uf_sigla,
                SUM(C.populacao) AS populacao
            FROM 
                "Open Analytics Layer".Territorial."População SVS por município e ano" C
            WHERE 
                C.ano = 2024
            GROUP BY 
                C.uf_sigla
            ) B 
ON A.uf_sigla = B.uf_sigla
WHERE
    A.categoria NOT IN (
        'Obstetrizes',
        'Técnicos de Farmácia',
        'Médicos-veterinários',
        'Técnicos Nutricionistas'
    )
ORDER BY
    A.uf_sigla
