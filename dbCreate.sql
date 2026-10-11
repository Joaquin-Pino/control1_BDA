CREATE SCHEMA IF NOT EXISTS edificios;
SET search_path TO edificios;

CREATE TABLE comuna (
  id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre varchar(100) NOT NULL
);

CREATE TABLE administrador (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre varchar(100) NOT NULL,
  rut varchar(12) NOT NULL,
  UNIQUE (rut)
);

CREATE TABLE edificio (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  comuna smallint NOT NULL REFERENCES comuna (id),
  admin integer NOT NULL REFERENCES administrador (id),
  nombre varchar(100) NOT NULL
);

CREATE TABLE tipo_depto (
  id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre varchar(100) NOT NULL,
  metros_cuadrados numeric(50) NOT NULL
);

CREATE TABLE depto (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  edificio integer NOT NULL REFERENCES edificio (id),
  tipo smallint NOT NULL REFERENCES tipo_depto (id),
  numero varchar(10) NOT NULL,
  piso smallint NOT NULL,
  habitantes smallint NOT NULL,
  CHECK (habitantes >= 0)
);

CREATE TABLE tipo_gg (
  id smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tipo_depto smallint NOT NULL REFERENCES tipo_depto (id),
  descripcion varchar(100) NOT NULL
);

CREATE TABLE gasto_comun (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mes smallint NOT NULL,
  anio smallint NOT NULL,
  fec_emision date NOT NULL,
  monto_base bigint NOT NULL,
  edificio integer NOT NULL REFERENCES edificio (id),
  tipo_gg smallint NOT NULL REFERENCES tipo_gg (id),
  UNIQUE (edificio, tipo_gg, mes, anio)
);

CREATE TABLE pago_gg_depto (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  depto integer NOT NULL REFERENCES depto (id),
  gasto_comun integer NOT NULL REFERENCES gasto_comun (id),
  fecha_pago date NOT NULL,
  monto_pagado bigint NOT NULL,
  UNIQUE (depto, gasto_comun),
  CHECK (monto_pagado > 0)
);

CREATE TABLE gasto_edificio (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  descripcion varchar(200) NOT NULL
);

CREATE TABLE pago_gasto_edificio (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  edificio integer NOT NULL REFERENCES edificio (id),
  gasto integer NOT NULL REFERENCES gasto_edificio (id),
  monto bigint NOT NULL,
  mes smallint NOT NULL,
  anio smallint NOT NULL,
  CHECK (monto > 0),
  CHECK (mes BETWEEN 1 AND 12)
);