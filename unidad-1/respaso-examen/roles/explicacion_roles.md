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