FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=root

VOLUME ["/var/lib/mysql"]

COPY 01-crear-base-datos.sql /docker-entrypoint-initdb.d/
COPY 02-crear-tablas.sql /docker-entrypoint-initdb.d/
COPY 03-crear-relaciones.sql /docker-entrypoint-initdb.d/
COPY 04-insertar-registros.sql /docker-entrypoint-initdb.d/
EXPOSE 3306