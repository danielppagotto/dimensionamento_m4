WITH consulta_all AS (

    ---------- Competência 2010
    SELECT
        2010 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2010') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(CAST(qt_matricula_curso AS INTEGER)) AS qt_matricula_total,
        SUM(COALESCE(CAST(c.QT_INGRESSO_PROCESSO_SELETIVO AS INTEGER),0)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(COALESCE(CAST(c.QT_VAGAS_ANUAL_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_INTEGRAL_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_MATUTINO_PRES AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOTURNO_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_VESPERTINO_PRES AS INTEGER),0) ) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSCRITOS_ANO_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_INTEGRAL_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_MATUTINO_PRES AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_NOTURNO_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_VESPERTINO_PRES AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2010"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4)

    UNION ALL

    ---------- Competência 2011
    SELECT
        2011 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2011') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '6' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(CAST(c.QT_MATRICULA_CURSO AS INTEGER)) AS qt_matricula_total,
    SUM(COALESCE(CAST(c.QT_INGRESSO_PROCESSO_SELETIVO AS INTEGER),0)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(COALESCE(CAST(c.QT_VAGAS_ANUAL_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_INTEGRAL_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_MATUTINO_PRES AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOTURNO_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_VESPERTINO_PRES AS INTEGER),0) ) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSCRITOS_ANO_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_INTEGRAL_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_MATUTINO_PRES AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_NOTURNO_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_VESPERTINO_PRES AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2011"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '6' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4)

    UNION ALL

    ---------- Competência 2012
    SELECT
        2012 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2012') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '6' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(CAST(c.QT_MATRICULA_CURSO AS INTEGER)) AS qt_matricula_total,
    SUM(COALESCE(CAST(c.QT_INGRESSO_OUTRA_FORMA AS INTEGER),0) + COALESCE(CAST(c.QT_INGRESSO_PROCESSO_SELETIVO AS INTEGER),0)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(COALESCE(CAST(c.QT_VAGAS_ANUAL_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_INTEGRAL_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_MATUTINO_PRES AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOTURNO_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_VESPERTINO_PRES AS INTEGER),0) ) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSCRITOS_ANO_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_INTEGRAL_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_MATUTINO_PRES AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_NOTURNO_PRES AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_VESPERTINO_PRES AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2012"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '6' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4)

    UNION ALL

    ---------- Competência 2013
    SELECT
        2013 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2013') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4) AS ano_funcionamento,
        SUM(CAST(c.QT_MATRICULA_CURSO AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.QT_INGRESSO_CURSO AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(COALESCE(CAST(c.QT_VAGAS_PRINCIPAL_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PRINCIPAL_INTEGRAL AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_PRINCIPAL_MATUTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PRINCIPAL_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_PRINCIPAL_VESPERTINO AS INTEGER),0) ) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSCRITOS_PRINCIPAL_VESP AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_PRINCIPAL_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_PRINCIPAL_MATU AS INTEGER),0) + COALESCE(CAST(c.QT_INSCRITOS_PRINCIPAL_INTE AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSCRITOS_PRINCIPAL_EAD AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2013"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4)

    UNION ALL

    ---------- Competência 2014
    SELECT
        2014 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2014') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4) AS ano_funcionamento,
        SUM(CAST(c.QT_MATRICULA_CURSO AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.QT_INGRESSO_CURSO AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(COALESCE(CAST(c.QT_VAGAS_NOVAS_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOVAS_INTEGRAL AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_NOVAS_MATUTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOVAS_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_NOVAS_VESPERTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PROG_ESP_EAD AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_PROG_ESP_INTEGRAL AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PROG_ESP_MATUTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_PROG_ESP_NOTURNO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PROG_ESP_VESPERTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_REMANESC_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_REMANESC_INTEGRAL AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_REMANESC_MATUTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_REMANESC_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_REMANESC_VESPERTINO AS INTEGER),0) ) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_INT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_MAT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_NOT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_VESP AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_EAD AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_INT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_MAT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_NOT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_VESP AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_INT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_MAT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_NOT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_VESP AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2014"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4)

    UNION ALL

    ---------- Competência 2015
    SELECT
        2015 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2015') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4) AS ano_funcionamento,
        SUM(CAST(c.QT_MATRICULA_CURSO AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.QT_INGRESSO_CURSO AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(COALESCE(CAST(c.QT_VAGAS_NOVAS_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOVAS_INTEGRAL AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_NOVAS_MATUTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_NOVAS_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_NOVAS_VESPERTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PROG_ESP_EAD AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_PROG_ESP_INTEGRAL AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PROG_ESP_MATUTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_PROG_ESP_NOTURNO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_PROG_ESP_VESPERTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_REMANESC_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_REMANESC_INTEGRAL AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_REMANESC_MATUTINO AS INTEGER),0) + COALESCE(CAST(c.QT_VAGAS_REMANESC_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_VAGAS_REMANESC_VESPERTINO AS INTEGER),0) ) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_INT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_MAT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_NOT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_VESP AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_EAD AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_INT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_MAT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_NOT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_VESP AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_INT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_MAT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_NOT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_VESP AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2015"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4)

    UNION ALL

    ---------- Competência 2016
    SELECT
        2016 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2016') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO_CURSO) = 7 THEN SUBSTR(c.CO_MUNICIPIO_CURSO, 1, 6) 
        WHEN c.CO_MUNICIPIO_CURSO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO_CURSO
    END AS cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4) AS ano_funcionamento,
        SUM(CAST(c.QT_MATRICULA_CURSO AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.QT_INGRESSO_CURSO AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.QT_CONCLUINTE_CURSO AS INTEGER)) AS qt_concluinte_total,
        SUM(CAST(c.QT_VAGAS_TOTAIS AS INTEGER)) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_INT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_MAT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_NOT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_NOVAS_VESP AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_EAD AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_INT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_MAT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_NOT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_PROG_ESP_VESP AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_INT AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_NOT AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_VESP AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGAS_REMAN_MAT AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2016"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.CO_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.CO_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4)

    UNION ALL

    ---------- Competência 2017
    SELECT
        2017 as competencia,
    CASE
        WHEN c.CO_OCDE = '721M01' THEN 'Medicina'
        WHEN c.CO_OCDE = '723E01' THEN 'Enfermagem'
        WHEN c.CO_OCDE = '421C01' THEN 'Biologia'
        WHEN c.CO_OCDE = '724O01' THEN 'Odontologia'
        WHEN c.CO_OCDE = '726N02' THEN 'Nutrição'
        WHEN c.CO_OCDE = '727F01' THEN 'Farmácia'
        WHEN c.CO_OCDE = '762S01' THEN 'Serviço Social'
        WHEN c.CO_OCDE = '311P02' THEN 'Psicologia'
        WHEN c.CO_OCDE = '641M01' THEN 'Medicina Veterinária'
        WHEN c.CO_OCDE = '421B07' THEN 'Biomedicina'
        WHEN c.CO_OCDE = '726F01' THEN 'Fisioterapia'
        WHEN c.CO_OCDE = '726T01' THEN 'Terapia Ocupacional'
        WHEN c.CO_OCDE = '726F03' THEN 'Fonoaudiologia'
    END AS tp_ocde,
        concat(c.co_ies, '_2017') as chave_ies,
        c.co_ies,
        c.co_curso,
    CASE
        WHEN LENGTH(c.CO_MUNICIPIO) >= 7 THEN SUBSTR(c.CO_MUNICIPIO, 1, 6) 
        WHEN c.CO_MUNICIPIO LIKE '53%' THEN '530010' 
        ELSE c.CO_MUNICIPIO
    END AS cod_ibge,
    CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '6' THEN 'Privada confessional'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4) AS ano_funcionamento,
        SUM(CAST(c.qt_matricula_total AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.qt_ingresso_total AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.qt_concluinte_total AS INTEGER)) AS qt_concluinte_total,
        SUM(CAST(c.qt_vaga_total AS INTEGER)) AS qt_vaga_total,
    SUM(COALESCE(CAST(c.QT_INSC_VAGA_NOVA_INTEGRAL AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGA_NOVA_MATUTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGA_NOVA_VESPERTINO AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGA_NOVA_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGA_NOVA_EAD AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGA_REMAN_INTEGRAL AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGA_REMAN_MATUTINO AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGA_REMAN_VESPERTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_VAGA_REMAN_NOTURNO AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_VAGA_REMAN_EAD AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_PROG_ESP_INTEGRAL AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_PROG_ESP_MATUTINO AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_PROG_ESP_VESPERTINO AS INTEGER),0) + COALESCE(CAST(c.QT_INSC_PROG_ESP_NOTURNO AS INTEGER),0) +
    COALESCE(CAST(c.QT_INSC_PROG_ESP_EAD AS INTEGER),0) ) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2017"."dm_curso.parquet" c
    WHERE
        (c.TP_ATRIBUTO_INGRESSO = '0' AND c.TP_NIVEL_ACADEMICO = '1')
        and (c.CO_OCDE in ('721M01', '723E01','421C01','724O01','726N02','727F01','762S01'
                           '311P02','641M01','421B07','726F01','726T01','726F03'))
    GROUP BY
    c.CO_OCDE,
        c.co_ies,
        c.co_curso,
        cod_ibge,
    CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '6' THEN 'Privada confessional'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
        ELSE 'ERRO'
    END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4)

    UNION ALL 

    ---------- Competência 2018
    SELECT
        2018 as competencia,
        CASE
            WHEN c.CO_CINE_ROTULO = '0912M01' THEN 'Medicina'
            WHEN c.CO_CINE_ROTULO = '0913E01' THEN 'Enfermagem'
            WHEN c.CO_CINE_ROTULO = '0511B01' THEN 'Biologia'
            WHEN c.CO_CINE_ROTULO = '0911O01' THEN 'Odontologia'
            WHEN c.CO_CINE_ROTULO = '0915N01' THEN 'Nutrição'
            WHEN c.CO_CINE_ROTULO = '0916F01' THEN 'Farmácia'
            WHEN c.CO_CINE_ROTULO = '0923S01' THEN 'Serviço Social'
            WHEN c.CO_CINE_ROTULO = '0313P01' THEN 'Psicologia'
            WHEN c.CO_CINE_ROTULO = '0841M01' THEN 'Medicina Veterinária'
            WHEN c.CO_CINE_ROTULO = '0914B01' THEN 'Biomedicina'
            WHEN c.CO_CINE_ROTULO = '0915F01' THEN 'Fisioterapia'
            WHEN c.CO_CINE_ROTULO = '0915T01' THEN 'Terapia Ocupacional'
            WHEN c.CO_CINE_ROTULO = '0915F02' THEN 'Fonoaudiologia'
        END AS tp_ocde,
        concat(c.co_ies, '_2018') as chave_ies,
        c.co_ies,
        c.co_curso,
        CASE
            WHEN LENGTH(c.CO_MUNICIPIO) >= 7 THEN SUBSTR(c.CO_MUNICIPIO, 1, 6) 
            WHEN c.CO_MUNICIPIO LIKE '53%' THEN '530010' 
            ELSE c.CO_MUNICIPIO
        END AS cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4) AS ano_funcionamento,
        SUM(CAST(c.qt_matricula_total AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.qt_ingresso_total AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.qt_concluinte_total AS INTEGER)) AS qt_concluinte_total,
        SUM(CAST(c.qt_vaga_total AS INTEGER)) AS qt_vaga_total,
        SUM(CAST(c.qt_inscrito_total AS INTEGER)) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2018"."dm_curso.parquet" c
    WHERE
        (
            c.TP_ATRIBUTO_INGRESSO = '0'
            AND c.TP_NIVEL_ACADEMICO = '1'
        )
        and (c.CO_CINE_ROTULO in ('0912M01','0913E01','0511B01','0911O01','0915N01',
                                  '0916F01','0923S01','0313P01','0841M01','0914B01', 
                                  '0915F01','0915T01','0915F02'))
    GROUP BY
        c.CO_CINE_ROTULO,
        c.co_ies,
        c.co_curso,
        cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 7, 4)


    UNION ALL 
    ---------- Competência 2019
    SELECT
        2019 as competencia,
                CASE
                    WHEN c.CO_CINE_ROTULO = '0912M01' THEN 'Medicina'
                    WHEN c.CO_CINE_ROTULO = '0913E01' THEN 'Enfermagem'
                    WHEN c.CO_CINE_ROTULO = '0511B01' THEN 'Biologia'
                    WHEN c.CO_CINE_ROTULO = '0911O01' THEN 'Odontologia'
                    WHEN c.CO_CINE_ROTULO = '0915N01' THEN 'Nutrição'
                    WHEN c.CO_CINE_ROTULO = '0916F01' THEN 'Farmácia'
                    WHEN c.CO_CINE_ROTULO = '0923S01' THEN 'Serviço Social'
                    WHEN c.CO_CINE_ROTULO = '0313P01' THEN 'Psicologia'
                    WHEN c.CO_CINE_ROTULO = '0841M01' THEN 'Medicina Veterinária'
                    WHEN c.CO_CINE_ROTULO = '0914B01' THEN 'Biomedicina'
                    WHEN c.CO_CINE_ROTULO = '0915F01' THEN 'Fisioterapia'
                    WHEN c.CO_CINE_ROTULO = '0915T01' THEN 'Terapia Ocupacional'
                    WHEN c.CO_CINE_ROTULO = '0915F02' THEN 'Fonoaudiologia'
        END AS tp_ocde,
        concat(c.co_ies, '_2019') as chave_ies,
        c.co_ies,
        c.co_curso,
        CASE
            WHEN LENGTH(c.CO_MUNICIPIO) >= 7 THEN SUBSTR(c.CO_MUNICIPIO, 1, 6) 
            WHEN c.CO_MUNICIPIO LIKE '53%' THEN '530010' 
            ELSE c.CO_MUNICIPIO
        END AS cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(CAST(c.qt_matricula_total AS INTEGER)) AS qt_matricula_total,
        SUM(CAST(c.qt_ingresso_total AS INTEGER)) AS qt_ingresso_total,
        SUM(CAST(c.qt_concluinte_total AS INTEGER)) AS qt_concluinte_total,
        SUM(CAST(c.qt_vaga_total AS INTEGER)) AS qt_vaga_total,
        SUM(CAST(c.qt_inscrito_total AS INTEGER)) AS qt_inscrito_total
    FROM
        Dados."inep_censo_superior"."2019"."sup_curso_2019.parquet" c
    WHERE
        (
            c.TP_ATRIBUTO_INGRESSO = '0'
            AND c.TP_NIVEL_ACADEMICO = '1'
        )
        and (c.CO_CINE_ROTULO in ('0912M01','0913E01','0511B01','0911O01','0915N01',
                                  '0916F01','0923S01','0313P01','0841M01','0914B01', 
                                  '0915F01','0915T01','0915F02'))
    GROUP BY
        c.CO_CINE_ROTULO,
        c.co_ies,
        c.co_curso,
        cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END,
        SUBSTR(c.DT_INICIO_FUNCIONAMENTO, 6, 4)

    UNION ALL
    ---------- Competência 2020
    SELECT 
        2020 as competencia,
        CASE
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0912M01' THEN 'Medicina'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0913E01' THEN 'Enfermagem'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0511B01' THEN 'Biologia'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0911O01' THEN 'Odontologia'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0915N01' THEN 'Nutrição'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0916F01' THEN 'Farmácia'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0923S01' THEN 'Serviço Social'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0313P01' THEN 'Psicologia'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0841M01' THEN 'Medicina Veterinária'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0914B01' THEN 'Biomedicina'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0915F01' THEN 'Fisioterapia'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0915T01' THEN 'Terapia Ocupacional'
            WHEN substr(c.CO_CINE_ROTULO2, 2, 7) = '0915F02' THEN 'Fonoaudiologia'
        END AS tp_ocde,
        concat(c.co_ies, '_2020') as chave_ies,
        CAST(c.co_ies AS varchar) as co_ies,
        CAST(c.co_curso AS varchar) as co_curso,
        CASE
            WHEN LENGTH(c.CO_MUNICIPIO) >= 7 THEN SUBSTR(c.CO_MUNICIPIO, 1, 6) 
            WHEN c.CO_MUNICIPIO LIKE '53%' THEN '530010' 
            ELSE c.CO_MUNICIPIO
        END AS cod_ibge,        
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(co.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(c.QT_MAT) AS qt_matricula_total,
        SUM(c.QT_ING) AS qt_ingresso_total,
        SUM(c.QT_CONC) AS qt_concluinte_total,
        SUM(c.QT_VG_TOTAL) AS qt_vaga_total,
        SUM(c.QT_INSCRITO_TOTAL) AS qt_inscrito_total
    FROM 
        Dados."inep_censo_superior"."2020"."atualizados"."microdados_cadastro_cursos_2020.parquet" c 
    LEFT JOIN 
        Dados."inep_censo_superior"."2019"."sup_curso_2019.parquet" co ON CAST(co.co_curso as varchar) = CAST(c.co_curso as varchar)
    WHERE 
        SUBSTR(c.CO_CINE_ROTULO2, 2, 7) in ('0912M01','0913E01','0511B01','0911O01','0915N01',
                                  '0916F01','0923S01','0313P01','0841M01','0914B01', 
                                  '0915F01','0915T01','0915F02')
    GROUP BY
        SUBSTR(c.CO_CINE_ROTULO2, 2, 7),
        c.co_ies,
        c.co_curso,
        cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END,
        ano_funcionamento

 UNION ALL

---------- Competência 2021
    SELECT 
        2021 as competencia,
        CASE
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0912M01' THEN 'Medicina'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0913E01' THEN 'Enfermagem'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0511B01' THEN 'Biologia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0911O01' THEN 'Odontologia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915N01' THEN 'Nutrição'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0916F01' THEN 'Farmácia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0923S01' THEN 'Serviço Social'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0313P01' THEN 'Psicologia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0841M01' THEN 'Medicina Veterinária'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0914B01' THEN 'Biomedicina'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915F01' THEN 'Fisioterapia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915T01' THEN 'Terapia Ocupacional'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915F02' THEN 'Fonoaudiologia'
        END AS tp_ocde,
        concat(c.co_ies, '_2021') as chave_ies,
        CAST(c.co_ies AS varchar) as co_ies,
        CAST(c.co_curso AS varchar) as co_curso,
        CASE
            WHEN LENGTH(c.CO_MUNICIPIO) >= 7 THEN SUBSTR(c.CO_MUNICIPIO, 1, 6) 
            WHEN c.CO_MUNICIPIO LIKE '53%' THEN '530010' 
            ELSE c.CO_MUNICIPIO
        END AS cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(co.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(c.QT_MAT) AS qt_matricula_total,
        SUM(c.QT_ING) AS qt_ingresso_total,
        SUM(c.QT_CONC) AS qt_concluinte_total,
        SUM(c.QT_VG_TOTAL) AS qt_vaga_total,
        SUM(c.QT_INSCRITO_TOTAL) AS qt_inscrito_total
    FROM 
        Dados."inep_censo_superior"."2021"."microdados_cadastro_cursos_2021.parquet" c 
    LEFT JOIN 
        Dados."inep_censo_superior"."2019"."sup_curso_2019.parquet" co ON CAST(co.co_curso as varchar) = CAST(c.co_curso as varchar)
    WHERE 
        SUBSTR(c.CO_CINE_ROTULO, 2, 7) in ('0912M01','0913E01','0511B01','0911O01','0915N01',
                                  '0916F01','0923S01','0313P01','0841M01','0914B01', 
                                  '0915F01','0915T01','0915F02')
    GROUP BY
        SUBSTR(c.CO_CINE_ROTULO, 2, 7),
        c.co_ies,
        c.co_curso,
        cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END,
        ano_funcionamento

 UNION ALL
---------- Competência 2022

    SELECT 
        2022 as competencia,
        CASE
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0912M01' THEN 'Medicina'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0913E01' THEN 'Enfermagem'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0511B01' THEN 'Biologia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0911O01' THEN 'Odontologia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915N01' THEN 'Nutrição'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0916F01' THEN 'Farmácia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0923S01' THEN 'Serviço Social'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0313P01' THEN 'Psicologia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0841M01' THEN 'Medicina Veterinária'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0914B01' THEN 'Biomedicina'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915F01' THEN 'Fisioterapia'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915T01' THEN 'Terapia Ocupacional'
            WHEN substr(c.CO_CINE_ROTULO, 2, 7) = '0915F02' THEN 'Fonoaudiologia'
        END AS tp_ocde,
        concat(c.co_ies, '_2022') as chave_ies,
        CAST(c.co_ies AS varchar) as co_ies,
        CAST(c.co_curso AS varchar) as co_curso,
        CASE
            WHEN LENGTH(c.CO_MUNICIPIO) >= 7 THEN SUBSTR(c.CO_MUNICIPIO, 1, 6) 
            WHEN c.CO_MUNICIPIO LIKE '53%' THEN '530010' 
            ELSE c.CO_MUNICIPIO
        END AS cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END as tp_categoria_administrativa,
        SUBSTR(co.DT_INICIO_FUNCIONAMENTO, 6, 4) AS ano_funcionamento,
        SUM(c.QT_MAT) AS qt_matricula_total,
        SUM(c.QT_ING) AS qt_ingresso_total,
        SUM(c.QT_CONC) AS qt_concluinte_total,
        SUM(c.QT_VG_TOTAL) AS qt_vaga_total,
        SUM(c.QT_INSCRITO_TOTAL) AS qt_inscrito_total
    FROM 
        Dados."inep_censo_superior"."2022"."MICRODADOS_CADASTRO_CURSOS_2022.parquet" c 
    LEFT JOIN 
        Dados."inep_censo_superior"."2019"."sup_curso_2019.parquet" co ON CAST(co.co_curso as varchar) = CAST(c.co_curso as varchar)
    WHERE 
        SUBSTR(c.CO_CINE_ROTULO, 2, 7) in ('0912M01','0913E01','0511B01','0911O01','0915N01',
                                  '0916F01','0923S01','0313P01','0841M01','0914B01', 
                                  '0915F01','0915T01','0915F02')
    GROUP BY
        SUBSTR(c.CO_CINE_ROTULO, 2, 7),
        c.co_ies,
        c.co_curso,
        cod_ibge,
        CASE
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '1' THEN 'Pública Federal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '2' THEN 'Pública Estadual'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '3' THEN 'Pública Municipal'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '4' THEN 'Privada com fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '5' THEN 'Privada sem fins lucrativos'
            WHEN c.TP_CATEGORIA_ADMINISTRATIVA = '7' THEN 'Especial'
            ELSE 'ERRO'
        END,
        ano_funcionamento
)

SELECT
    a.competencia AS ano, 
    b.regiao,
    b.uf_sigla,
    b.cod_macrorregiao,
    b.macrorregiao,
    b.cod_regsaud,
    b.regiao_saude,
    cod_ibge,
    b.municipio,
    b.latitude,
    b.longitude,
    a.tp_ocde AS curso, 
    a.chave_ies, 
    a.co_ies, 
    a.co_curso, 
    a.tp_categoria_administrativa,
    a.ano_funcionamento AS ano_fundacao_ies,
    a.qt_matricula_total,
    a.qt_ingresso_total,
    a.qt_concluinte_total,
    a.qt_vaga_total,
    a.qt_inscrito_total
FROM consulta_all a
LEFT JOIN "Open Analytics Layer".Territorial."Hierarquia completa dos municípios" b
            ON a.cod_ibge = CAST(b.cod_municipio AS CHARACTER)
