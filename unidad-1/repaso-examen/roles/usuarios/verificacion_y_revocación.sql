SHOW GRANTS FOR 'maria'@'localhost';
SHOW GRANTS FOR 'rol_profesor';


REVOKE UPDATE ON escuela.calificaciones FROM 'rol_profesor';


DROP USER 'juan'@'localhost';
DROP ROLE 'rol_estudiante';