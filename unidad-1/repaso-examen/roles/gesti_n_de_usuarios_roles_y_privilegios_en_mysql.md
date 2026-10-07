# Gestión de Usuarios, Roles y Privilegios en MySQL

## Conceptos Fundamentales

* **Usuario:** La identidad única que se conecta a la base de datos, definida por un nombre y un host de origen (ej. `'juan'@'localhost'`).
* **Rol:** Un contenedor o conjunto con un grupo de privilegios predefinidos. Se asigna a los usuarios para facilitar la administración.
* **Privilegio:** El permiso específico para ejecutar una acción concreta (ej. `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `DROP`) sobre una base de datos, tabla o columna.

---

## Ejemplo Práctico

Caso de uso: **Sistema de Gestión Escolar**

### 1. Roles
* `rol_director`
* `rol_profesor`
* `rol_estudiante`

### 2. Usuarios
* `carlos` (Director)
* `maria` (Profesora)
* `juan` (Estudiante)

### 3. Privilegios por Rol
* **`rol_director`**: Control total (`ALL PRIVILEGES`).
* **`rol_profesor`**: Lectura y modificación de calificaciones (`SELECT`, `UPDATE`).
* **`rol_estudiante`**: Solo lectura de sus materias y notas (`SELECT`).

---

## Implementación SQL

### Crear Roles

```sql
-- CREAR ROLE
CREATE ROLE 'rol_director', 'rol_profesor', 'rol_estudiante';
```

### Asignación de Privilegios a los Roles

```sql
--- ASIGNACIÓN DE PRIVILEGIOS A LOS ROLES

-- Director: Acceso completo a la base de datos 'escuela'
GRANT ALL PRIVILEGES ON escuela.* TO 'rol_director';

-- Profesor: Lectura y actualización en la tabla 'cuentas'
GRANT SELECT, UPDATE ON escuela.cuentas TO 'rol_profesor';

-- Estudiante: Solo lectura en la tabla 'cuentas'
GRANT SELECT ON escuela.cuentas TO 'rol_estudiante';
```

### Creación de Usuarios

```sql
--- CREACIÓN DE USUARIOS

CREATE USER 'carlos'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'maria'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'juan'@'localhost' IDENTIFIED BY '1234';
```

### Asignación de Roles a Usuarios

```sql
--- ASIGNACIÓN DE ROLES A USUARIOS

GRANT 'rol_director' TO 'carlos'@'localhost';
GRANT 'rol_profesor' TO 'maria'@'localhost';
GRANT 'rol_estudiante' TO 'juan'@'localhost';
```

### Activación de Roles

```sql
-- Definir que todos los roles asignados se activen por defecto al conectar
SET DEFAULT ROLE ALL TO 'carlos'@'localhost', 'maria'@'localhost', 'juan'@'localhost';

FLUSH PRIVILEGES;
```

### Verificación y Revocación

```sql
-- verificacion_y_revocación

SHOW GRANTS FOR 'maria'@'localhost';
SHOW GRANTS FOR 'rol_profesor';

REVOKE UPDATE ON escuela.calificaciones FROM 'rol_profesor';

DROP USER 'juan'@'localhost';
DROP ROLE 'rol_estudiante';
```