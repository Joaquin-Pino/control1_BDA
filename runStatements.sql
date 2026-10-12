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


SELECT e.nombre AS edificio, gc.anio, gc.mes,
SUM(p.monto_pagado) AS total_recaudado
FROM pago_gg_depto p
JOIN gasto_comun gc ON gc.id = p.gasto_comun
JOIN edificio e ON e.id = gc.edificio
GROUP BY e.id, e.nombre, gc.anio, gc.mes
ORDER BY e.nombre, gc.anio, gc.mes;
