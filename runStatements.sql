SET search_path TO edificios;

-- consulta 1
SELECT e.nombre AS edificio, d.numero AS depto, d.piso,
       gc.anio, gc.mes, tg.descripcion AS tipo_gasto,
       gc.monto_base AS monto_adeudado FROM depto d
JOIN edificio e ON e.id = d.id_edificio
JOIN gasto_comun gc ON gc.id_edificio = d.id_edificio
JOIN tipo_gg tg ON tg.id = gc.id_tipo_gg AND tg.id_tipo_depto = d.id_tipo
LEFT JOIN pago_gg_depto p
	ON p.id_depto = d.id
    AND p.id_gasto_comun = gc.id
WHERE p.id IS NULL
  AND make_date(gc.anio, gc.mes, 1) <= current_date
  AND AGE(date_trunc('month', current_date), make_date(gc.anio, gc.mes, 1)) <= INTERVAL '2 months'
ORDER BY e.nombre, d.numero, gc.anio, gc.mes;

-- consulta 2
SELECT e.nombre AS edificio, gc.anio, gc.mes,
SUM(p.monto_pagado) AS total_recaudado
FROM pago_gg_depto p
JOIN gasto_comun gc ON gc.id = p.id_gasto_comun
JOIN edificio e ON e.id = gc.id_edificio
GROUP BY e.id, e.nombre, gc.anio, gc.mes
ORDER BY e.nombre, gc.anio, gc.mes;

-- consulta 3, total gastos del edificio pagados por mes

SELECT e.nombre AS edificio, pg.anio, pg.mes, SUM(pg.monto) AS total_gastos_pagados
FROM pago_gasto_edificio pg
JOIN edificio e ON e.id = pg.id_edificio
GROUP BY e.id, e.nombre, pg.anio, pg.mes
ORDER BY e.nombre, pg.anio, pg.mes;

-- consulta 4 tipo detpo con gastos comunes mas caro
SELECT td.id, td.nombre, AVG(gc.monto_base) AS promedio_gasto
FROM tipo_depto td
JOIN tipo_gg tgg ON td.id = tgg.id_tipo_depto
JOIN gasto_comun gc ON gc.id_tipo_gg = tgg.id
GROUP BY td.id, td.nombre
ORDER BY promedio_gasto DESC
FETCH FIRST 1 ROWS WITH TIES;

-- consulta 5 lista de edificios por comuna con la cantidad de deptos
SELECT e.nombre AS edificio, e.id_comuna AS comuna, COUNT(d.id) AS total_deptos
FROM comuna c
JOIN edificio e ON c.id = e.id_comuna
LEFT JOIN depto d ON e.id = d.id_edificio
GROUP BY c.id, e.id
ORDER BY c.nombre, e.nombre;

-- consulta 6 administrador con mas edificios a cargo
SELECT a.nombre AS administrador, a.rut, COUNT(e.id) AS total_edificios
FROM administrador a
JOIN edificio e ON a.id = e.id_admin
GROUP BY a.id
ORDER BY total_edificios DESC
LIMIT 1;

-- consulta 7 departamento con mas habitantes por piso, por edificio
SELECT e.nombre AS edificio, d.piso, d.numero AS depto, d.habitantes
FROM depto d
JOIN edificio e ON e.id = d.id_edificio
WHERE d.habitantes = (
    SELECT MAX(d2.habitantes)
    FROM depto d2
    WHERE d2.id_edificio = d.id_edificio
      AND d2.piso = d.piso
)
ORDER BY e.nombre, d.piso;

-- consulta 8 cantidad de deptos por tipo en cada edificio
SELECT e.nombre AS edificio, td.nombre AS tipo_depto, COUNT(d.id) as cantidad_tipo
FROM depto d
JOIN edificio e ON e.id = d.id_edificio
JOIN tipo_depto td ON td.id = d.id_tipo
GROUP BY e.nombre, td.nombre
ORDER BY e.nombre;

-- consulta 9 lista de edificios que menos gasta por mes.
WITH GastosPorEdificio AS (
    SELECT e.id, e.nombre AS edificio, pg.anio, pg.mes, SUM(pg.monto) AS total_gastos
    FROM pago_gasto_edificio pg
    JOIN edificio e ON e.id = pg.edificio
    GROUP BY e.id, e.nombre, pg.anio, pg.mes
),
RankingGastos AS (
    SELECT edificio, anio, mes, total_gastos,
           RANK() OVER(PARTITION BY anio, mes ORDER BY total_gastos ASC) as rnk
    FROM GastosPorEdificio
)
SELECT edificio, anio, mes, total_gastos
FROM RankingGastos
WHERE rnk = 1
ORDER BY anio, mes, edificio;

-- consulta 10 lista de tipos de departamentos más pequeños por edificio.
WITH TiposPorEdificio AS (
    SELECT DISTINCT e.id, e.nombre AS edificio, td.nombre AS tipo_depto, td.metros_cuadrados
    FROM depto d
    JOIN edificio e ON e.id = d.edificio
    JOIN tipo_depto td ON td.id = d.tipo
),
RankingTamanio AS (
    SELECT edificio, tipo_depto, metros_cuadrados,
           RANK() OVER(PARTITION BY id ORDER BY metros_cuadrados ASC) as rnk
    FROM TiposPorEdificio
)
SELECT edificio, tipo_depto, metros_cuadrados
FROM RankingTamanio
WHERE rnk = 1
ORDER BY edificio;