CREATE DATABASE IF NOT EXISTS mydatabase;
USE mydatabase;

CREATE TABLE IF NOT EXISTS usuarios ( id INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(50) NOT NULL, email VARCHAR(50) NOT NULL ); 

INSERT INTO usuarios (nombre, email) VALUES ('Juan Perez', 'juan@example.com');