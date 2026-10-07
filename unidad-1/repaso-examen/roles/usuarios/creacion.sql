-- CREAR ROLE
CREATE ROLE 'rol_director', 'rol_profesor', 'rol_estudiante';


--- ASIGNACIÓN DE PRIVILEGIOS A LOS ROLES

-- Director: Acceso completo a la base de datos 'escuela'
GRANT ALL PRIVILEGES ON escuela.* TO 'rol_director';

-- Profesor: Lectura y actualización en la tabla 'cuentas'
GRANT SELECT, UPDATE ON escuela.cuentas TO 'rol_profesor';

-- Estudiante: Solo lectura en la tabla 'cuentas'
GRANT SELECT ON escuela.cuentas TO 'rol_estudiante';


--- CREACIÓN DE USUARIOS

CREATE USER 'carlos'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'maria'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'juan'@'localhost' IDENTIFIED BY '1234';


--- ASIGNACIÓN DE ROLES A USUARIOS

GRANT 'rol_director' TO 'carlos'@'localhost';
GRANT 'rol_profesor' TO 'maria'@'localhost';
GRANT 'rol_estudiante' TO 'juan'@'localhost';



-- Definir que todos los roles asignados se activen por defecto al conectar
SET DEFAULT ROLE ALL TO 'carlos'@'localhost', 'maria'@'localhost', 'juan'@'localhost';


FLUSH PRIVILEGES;