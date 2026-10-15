# Control 1: Base de datos de edificios

Scripts SQL para PostgreSQL que crean el esquema `edificios`, cargan los datos y ejecutan las consultas.

## Archivos

- `dbCreate.sql`: crea el esquema `edificios` y todas las tablas.
- `loadData.sql`: carga los datos de prueba.
- `runStatements.sql`: contiene las 10 consultas (`SELECT`).

## Requisitos

- PostgreSQL instalado y en ejecución.
- Un usuario con permisos para crear bases de datos.

## Ejecución

Desde la carpeta que contiene los scripts, ejecutar en la terminal:

### Linux o macOS

```bash
createdb edificios_db
psql -v ON_ERROR_STOP=1 -d edificios_db -f dbCreate.sql \
  && psql -v ON_ERROR_STOP=1 -d edificios_db -f loadData.sql \
  && psql -d edificios_db -f runStatements.sql
```

Los comandos están encadenados con `&&` y se usa `ON_ERROR_STOP=1`, por lo que:

1. Primero se crea la base de datos y se ejecuta `dbCreate.sql`, que crea el esquema y las tablas.
2. Luego se ejecuta `loadData.sql`, que carga los datos.
3. Los `SELECT` de `runStatements.sql` solo se ejecutan si la creación y la carga terminaron sin errores. Si alguno de los pasos anteriores falla, la secuencia se detiene.

Cada script comienza con `SET search_path TO edificios;`, por lo que no es necesario indicar el esquema en las consultas.

### Windows


1. Agregar la carpeta `bin` de PostgreSQL al `PATH` (por ejemplo `C:\Program Files\PostgreSQL\17\bin`), o abrir la terminal "SQL Shell (psql)" que ya la incluye.
2. En Windows normalmente hay que indicar el usuario (`-U postgres`) y escribir la contraseña cuando se solicite.
3. Antes de ejecutar los scripts, configurar la terminal en UTF-8 para que las tildes y la `Ñ` se carguen y se muestren correctamente. Se necesitan **los dos** comandos: `chcp 65001` cambia la terminal a UTF-8 y `PGCLIENTENCODING` le indica a psql que use UTF-8.
   - CMD:
```
     chcp 65001
     set PGCLIENTENCODING=UTF8
```
   - PowerShell:
```powershell
     chcp 65001
     $env:PGCLIENTENCODING="UTF8"
```
   Estos comandos solo aplican a la ventana actual; si se abre una terminal nueva, hay que repetirlos.

#### CMD o PowerShell 7 o superior


```
createdb -U postgres edificios_db
psql -U postgres -v ON_ERROR_STOP=1 -d edificios_db -f dbCreate.sql && psql -U postgres -v ON_ERROR_STOP=1 -d edificios_db -f loadData.sql && psql -U postgres -d edificios_db -f runStatements.sql
```

#### Windows PowerShell 5.1

Esta versión no soporta `&&`. Se revisa el código de salida de cada paso:

```powershell
createdb -U postgres edificios_db
psql -U postgres -v ON_ERROR_STOP=1 -d edificios_db -f dbCreate.sql
if ($LASTEXITCODE -eq 0) { psql -U postgres -v ON_ERROR_STOP=1 -d edificios_db -f loadData.sql }
if ($LASTEXITCODE -eq 0) { psql -U postgres -d edificios_db -f runStatements.sql }
```

Con esto los `SELECT` solo se ejecutan si la creación y la carga terminaron sin errores.

## Borrar todo y volver a empezar


```bash
dropdb edificios_db
```

## Resumen de comandos

Los comandos se ejecutan uno a uno, en este orden. Si alguno muestra un error, no se debe continuar con el siguiente.

### Linux y macOS

1. Crear la base de datos:
   ```bash
   createdb edificios_db
   ```
2. Crear el esquema y las tablas:
   ```bash
   psql -v ON_ERROR_STOP=1 -d edificios_db -f dbCreate.sql
   ```
3. Cargar los datos:
   ```bash
   psql -v ON_ERROR_STOP=1 -d edificios_db -f loadData.sql
   ```
4. Ejecutar las consultas:
   ```bash
   psql -d edificios_db -f runStatements.sql
   ```
5. Borrar la base de datos (para empezar de cero):
   ```bash
   dropdb edificios_db
   ```

### Windows (CMD o PowerShell)
1. Configurar la terminal en UTF-8 (CMD):
   ```
   chcp 65001
   set PGCLIENTENCODING=UTF8
   ```

2. Crear la base de datos:
   ```
   createdb -U postgres edificios_db
   ```
3. Crear el esquema y las tablas:
   ```
   psql -U postgres -v ON_ERROR_STOP=1 -d edificios_db -f dbCreate.sql
   ```
4. Cargar los datos:
   ```
   psql -U postgres -v ON_ERROR_STOP=1 -d edificios_db -f loadData.sql
   ```
5. Ejecutar las consultas:
   ```
   psql -U postgres -d edificios_db -f runStatements.sql
   ```
6. Borrar la base de datos (para empezar de cero):
   ```
   dropdb -U postgres edificios_db
   ```
