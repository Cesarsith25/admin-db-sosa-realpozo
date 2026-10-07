USE refugio_selva_viva;

-- CREAR ROLE
CREATE ROLE 'rol_recepcion', 'rol_veterinario', 'rol_admin_refugio';


-- ASIGNACIÓN DE PRIVILEGIOS A LOS ROLES

-- Recepción: lectura e inserción sobre animales y bitácora de movimientos
GRANT SELECT, INSERT ON refugio_selva_viva.animal TO 'rol_recepcion';
GRANT SELECT, INSERT ON refugio_selva_viva.bitacora_movimiento TO 'rol_recepcion';

-- Recepción: actualización EXCLUSIVAMENTE sobre el campo de disponibilidad del recinto
-- (SELECT es necesario para consultar el cupo y usar WHERE en el UPDATE)
GRANT SELECT ON refugio_selva_viva.recinto TO 'rol_recepcion';
GRANT UPDATE (cupo_disponible) ON refugio_selva_viva.recinto TO 'rol_recepcion';

-- Recepción: catálogos de consulta (sin acceso a evaluacion_medica, sin DELETE)
GRANT SELECT ON refugio_selva_viva.especie TO 'rol_recepcion';
GRANT SELECT ON refugio_selva_viva.bioma TO 'rol_recepcion';

-- Veterinario: lectura, inserción y actualización de expedientes clínicos
GRANT SELECT, INSERT, UPDATE ON refugio_selva_viva.evaluacion_medica TO 'rol_veterinario';

-- Veterinario: lectura de animales y actualización SOLO del estado de salud
GRANT SELECT ON refugio_selva_viva.animal TO 'rol_veterinario';
GRANT UPDATE (estado_salud) ON refugio_selva_viva.animal TO 'rol_veterinario';

-- Administrador: acceso completo a la base de datos 'refugio_selva_viva'
GRANT ALL PRIVILEGES ON refugio_selva_viva.* TO 'rol_admin_refugio';


-- CREACIÓN DE USUARIOS
-- El personal del refugio se representa con estos usuarios de MySQL:
-- recepcionista, veterinario y administrador (no hay tabla de personal).

CREATE USER 'usr_recepcion1'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'usr_vet_mendoza'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'usr_admin_selva'@'localhost' IDENTIFIED BY '1234';


-- ASIGNACIÓN DE ROLES A USUARIOS

GRANT 'rol_recepcion' TO 'usr_recepcion1'@'localhost';
GRANT 'rol_veterinario' TO 'usr_vet_mendoza'@'localhost';
GRANT 'rol_admin_refugio' TO 'usr_admin_selva'@'localhost';


-- Definir que todos los roles asignados se activen por defecto al conectar
SET DEFAULT ROLE ALL TO 'usr_recepcion1'@'localhost', 'usr_vet_mendoza'@'localhost', 'usr_admin_selva'@'localhost';


FLUSH PRIVILEGES;


-- verificacion
SHOW GRANTS FOR 'usr_recepcion1'@'localhost';
SHOW GRANTS FOR 'rol_recepcion';
SHOW GRANTS FOR 'rol_veterinario';
