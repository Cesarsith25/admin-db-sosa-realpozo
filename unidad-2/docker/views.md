# Ejemplo de Proyecto: Ventanas, Stored Procedures y Triggers en MySQL

Este repositorio contiene un ejemplo práctico de base de datos para explorar el uso de **Funciones de Ventana (Window Functions)**, **Procedimientos Almacenados (Stored Procedures)** y **Disparadores (Triggers)** en MySQL 8.0+.

El escenario simula un **sistema de ventas e inventario** compuesto por 4 tablas relacionadas: categorías, productos, ventas y detalle de ventas.

---

## Scripts SQL de Inicialización

Estas consultas corresponden al archivo de inicialización (por ejemplo, `init.sql`) que se ejecuta automáticamente al construir el contenedor mediante Docker.

### 1. Creación de Tablas Relacionadas

```sql

-- 1. Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS ventas_db;

-- 2. Seleccionar la base de datos para usarla
USE ventas_db;


-- Tabla 1: Categorías de productos
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Tabla 2: Catálogo e inventario de productos
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    categoria_id INT,
    CONSTRAINT fk_productos_categorias 
        FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
) ENGINE=InnoDB;

-- Tabla 3: Registro de ventas (Encabezado)
CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    cliente VARCHAR(100) NOT NULL,
    total DECIMAL(10, 2) DEFAULT 0.00
) ENGINE=InnoDB;

-- Tabla 4: Detalle de los artículos vendidos
CREATE TABLE detalle_ventas (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_detalle_ventas 
        FOREIGN KEY (venta_id) REFERENCES ventas(venta_id) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_productos 
        FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
) ENGINE=InnoDB;
```

### 2. Valores de tablas

```sql
-- Categorías iniciales
INSERT INTO categorias (categoria_id, nombre) VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Hogar');

-- Productos iniciales
INSERT INTO productos (producto_id, nombre, precio, stock, categoria_id) VALUES
(1, 'Laptop Pro 15', 1200.00, 15, 1),
(2, 'Smartphone X', 800.00, 30, 1),
(3, 'Audífonos Bluetooth', 150.00, 50, 1),
(4, 'Camiseta Algodón', 25.00, 100, 2),
(5, 'Chaqueta Impermeable', 120.00, 40, 2),
(6, 'Cafetera Expresso', 90.00, 20, 3);

-- Histórico de ventas
INSERT INTO ventas (venta_id, fecha, cliente, total) VALUES
(1, '2026-03-01 10:00:00', 'Carlos Gómez', 1350.00),
(2, '2026-03-02 11:30:00', 'Ana Martínez', 825.00),
(3, '2026-03-02 15:45:00', 'Carlos Gómez', 120.00),
(4, '2026-03-03 09:15:00', 'Luis Fernández', 90.00);

-- Detalle de las ventas
INSERT INTO detalle_ventas (detalle_id, venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 1, 1, 1200.00, 1200.00),
(2, 1, 3, 1, 150.00, 150.00),
(3, 2, 2, 1, 800.00, 800.00),
(4, 2, 4, 1, 25.00, 25.00),
(5, 3, 5, 1, 120.00, 120.00),
(6, 4, 6, 1, 90.00, 90.00);
```


---

## Guía de Ejecución en DBeaver

Para probar las consultas y scripts de este repositorio mediante **DBeaver**, sigue estos pasos:

1. **Conexión a la Base de Datos:**
   * Abre DBeaver y selecciona **Nueva conexión** -> **MySQL**.
   * **Host:** `localhost` (o la IP/puerto mapeado en tu `docker-compose.yml`, típicamente puerto `3306`).
   * **Database:** `ventas_db` (o el nombre definido en las variables de entorno de tu Docker).
   * **Username / Password:** Credenciales configuradas en tu contenedor.
   * Haz clic en **Test Connection** y guarda la conexión.

2. **Ejecución de Scripts:**
   * Abre un nuevo editor SQL en DBeaver (`Ctrl + Shift + O` / `Cmd + Shift + O`).
   * Selecciona el bloque de código que deseas probar y presiona `Ctrl + Enter` (o `Cmd + Enter`) para ejecutar la consulta actual, o `Alt + X` para ejecutar todo el script.

---

## 1. Funciones de Ventana (Window Functions)

Las **Funciones de Ventana** permiten realizar cálculos a través de un conjunto de filas relacionadas con la fila actual (un *frame* o ventana) **sin agrupar los resultados** en una sola fila como lo hace un `GROUP BY` tradicional. Mantienen el detalle de cada registro individual.

### Sintaxis General

```sql
FUNCION() OVER (
    PARTITION BY columna_agrupacion
    ORDER BY columna_ordenamiento
)
```

## 2 Ejemplo de ventana

```sql
CREATE OR REPLACE VIEW vw_ranking_productos_categoria AS
SELECT 
    c.nombre AS categoria,
    p.nombre AS producto,
    p.precio,
    ROW_NUMBER() OVER (PARTITION BY p.categoria_id ORDER BY p.precio DESC) AS numero_fila,
    RANK()       OVER (PARTITION BY p.categoria_id ORDER BY p.precio DESC) AS ranking,
    DENSE_RANK() OVER (PARTITION BY p.categoria_id ORDER BY p.precio DESC) AS ranking_denso
FROM productos p
JOIN categorias c ON p.categoria_id = c.categoria_id;

```
## Ver la ventana creada 
```sql
SELECT * FROM vw_ranking_productos_categoria;
```


### 📊 Funciones de Ventana: Diferencias entre ROW_NUMBER, RANK y DENSE_RANK

Las funciones de ventana sirven para asignar una posición o número secuencial a cada fila dentro de un grupo de datos, pero manejan los **empates (valores idénticos)** de forma diferente.

| Función | ¿Cómo numera? | Ejemplo de la carrera |
| :--- | :--- | :--- |
| 🔢 **`ROW_NUMBER()`** | Consecutivo estricto. **No le importan los empates**. | `1, 2, 3, 4` *(A uno le da el 2 y al otro el 3 de forma arbitraria)* |
| 🥇 **`RANK()`** | Asigna la misma posición a los empates, pero **deja huecos** en las siguientes posiciones. | `1, 2, 2, 4` *(Se salta el 3 porque hubo dos segundos lugares)* |
| 🥈 **`DENSE_RANK()`** | Asigna la misma posición a los empates, pero va **sin huecos** (consecutivo). | `1, 2, 2, 3` *(El siguiente puesto disponible es el 3)* |

---

#### 💡 Ejemplo práctico (Ordenando por precio de mayor a menor)

Imagina que tienes 4 productos con los precios: **\$100, \$80, \$80 y \$50**. Así respondería cada función:

* **`ROW_NUMBER()`**: `1`, `2`, `3`, `4` *(Ignora el empate de los productos de \$80)*
* **`RANK()`**: `1`, `2`, `2`, `4` *(Detecta el empate en el puesto 2 y se salta el puesto 3)*
* **`DENSE_RANK()`**: `1`, `2`, `2`, `3` *(Detecta el empate en el puesto 2 y continúa con el 3)*


##### 🔹 Opción B
```sql

CREATE OR REPLACE VIEW vw_ventas_acumuladas_producto AS
SELECT 
    dv.producto_id,
    v.fecha,
    v.cliente,
    dv.cantidad,
    dv.subtotal,
    -- Suma acumulada por producto ordenada por fecha
    SUM(dv.subtotal) OVER (
        PARTITION BY dv.producto_id 
        ORDER BY v.fecha
    ) AS acumulado_ingresos
FROM detalle_ventas dv
JOIN ventas v ON dv.venta_id = v.venta_id;
WHERE dv.producto_id = 5

```

---

#### 2. Cómo usarla en DBeaver pasando el ID

Una vez creada la función, la consultas igual que si fuera una vista o una tabla, pero pasándole el ID que tú quieras entre paréntesis:

```sql
-- Analizar el producto ID 5
SELECT * FROM vw_ventas_acumuladas_producto();

-- Analizar el producto ID 42
SELECT * FROM fn_analisis_producto_dinamico(42);
```


