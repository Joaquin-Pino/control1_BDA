-- consulta 1
SELECT e.nombre AS edificio, d.numero AS depto, d.piso,
       gc.anio, gc.mes, tg.descripcion AS tipo_gasto,
       gc.monto_base AS monto_adeudado FROM depto d
JOIN edificio e ON e.id = d.edificio
JOIN gasto_comun gc ON gc.edificio = d.edificio
JOIN tipo_gg tg ON tg.id = gc.tipo_gg AND tg.tipo_depto = d.tipo
LEFT JOIN pago_gg_depto p
	ON p.depto = d.id
    AND p.gasto_comun = gc.id
WHERE p.id IS NULL
  AND make_date(gc.anio, gc.mes, 1) <= current_date
  AND AGE(date_trunc('month', current_date), make_date(gc.anio, gc.mes, 1)) <= INTERVAL '2 months'
ORDER BY e.nombre, d.numero, gc.anio, gc.mes;

-- consulta 2
SELECT e.nombre AS edificio, gc.anio, gc.mes,
SUM(p.monto_pagado) AS total_recaudado
FROM pago_gg_depto p
JOIN gasto_comun gc ON gc.id = p.gasto_comun
JOIN edificio e ON e.id = gc.edificio
GROUP BY e.id, e.nombre, gc.anio, gc.mes
ORDER BY e.nombre, gc.anio, gc.mes;

-- consulta 3, total gastos del edificio pagados por mes

SELECT e.nombre AS edificio, pg.anio, pg.mes, SUM(pg.monto) AS total_gastos_pagados
FROM pago_gasto_edificio pg
JOIN edificio e ON e.id = pg.edificio
GROUP BY e.id, e.nombre, pg.anio, pg.mes
ORDER BY e.nombre, pg.anio, pg.mes;

-- consulta 4 tipo detpo con gastos comunes mas caro
SELECT td.nombre, gc.monto_base FROM tipo_depto td
JOIN tipo_gg tgg on td.id = tgg.tipo_depto
JOIN gasto_comun gc on gc.tipo_gg = tgg.id
ORDER BY gc.monto_base DESC
LIMIT 1;