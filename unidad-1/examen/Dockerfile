FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=root

VOLUME ["/var/lib/mysql"]

# Se ejecutan en orden alfabético al iniciar el contenedor por primera vez
COPY scripts/01-crear-base-datos.sql /docker-entrypoint-initdb.d/
COPY scripts/02-crear-tablas.sql /docker-entrypoint-initdb.d/
COPY scripts/03-crear-relaciones.sql /docker-entrypoint-initdb.d/
COPY scripts/04-insertar-registros.sql /docker-entrypoint-initdb.d/
COPY scripts/05-roles-usuarios.sql /docker-entrypoint-initdb.d/
EXPOSE 3306