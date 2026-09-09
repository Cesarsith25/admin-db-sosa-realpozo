FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=mydatabase

# Declaración explícita de volumen
VOLUME ["/var/lib/mysql"]
COPY schema.sql /docker-entrypoint-initdb.d/
EXPOSE 3306