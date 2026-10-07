# 1. Imagen base oficial de MySQL
FROM mysql:8.0

# 2. Copiamos los scripts SQL de inicialización al directorio especial.
# Los archivos .sql en esta carpeta se ejecutarán en orden alfabético (ej. 01_schema.sql, 02_indexes.sql)
COPY ./scripts/crear.sql /docker-entrypoint-initdb.d/
COPY ./scripts/cuentas.sql /docker-entrypoint-initdb.d/
COPY ./scripts/information.sql /docker-entrypoint-initdb.d/