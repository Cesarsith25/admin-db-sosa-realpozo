# Guía Rápida: Procedimientos Almacenados (Stored Procedures)

Un **Procedimiento Almacenado** es una **función o bloque de código guardado** directamente en la base de datos. Permite ejecutar lógica de negocio directamente en el servidor MySQL sin necesidad de reescribir las mismas consultas SQL en tu aplicación.

---

## 🛠️ Estructura Básica de un Stored Procedure

```sql
DELIMITER //

CREATE PROCEDURE nombre_del_procedimiento(
    IN parametro_entrada TIPO_DATO,
    OUT parametro_salida TIPO_DATO
)
BEGIN
    -- Lógica o consultas SQL
    SELECT * FROM tabla WHERE columna = parametro_entrada;
END //

DELIMITER ;
```

### Explicación de las componentes principales:

1. **`DELIMITER //`**: Cambia temporalmente el delimitador por defecto (`;`) a `//`. Esto evita que MySQL corte la ejecución al encontrar un `;` interno dentro del procedimiento.
2. **`CREATE PROCEDURE`**: Define el nombre del procedimiento y la lista de parámetros.
3. **Parámetros (`IN` / `OUT`)**:
   * **`IN`**: Datos que recibe el procedimiento desde el exterior.
   * **`OUT`**: Variables donde el procedimiento deposita un valor de retorno.
4. **`BEGIN ... END`**: Encierran las instrucciones SQL que conforman la lógica del procedimiento.
5. **`DELIMITER ;`**: Devuelve el delimitador habitual de MySQL a `;`.

---

## 💡 Ejemplos Prácticos con el Modelo de Ventas

A continuación se presentan dos ejemplos aplicados a la base de datos de comercio (`categorias`, `productos`, `ventas`, `detalle_ventas`).

---

### Ejemplo 1: Consultar Productos por Categoría (Parámetro `IN`)

Este procedimiento recibe el ID de una categoría (`p_categoria_id`) y realiza un `JOIN` para devolver todos los productos correspondientes junto con el nombre de su categoría.

```sql
DELIMITER //

CREATE PROCEDURE sp_obtener_productos_por_categoria(
    IN p_categoria_id INT
)
BEGIN
    SELECT 
        p.producto_id,
        p.nombre AS producto,
        c.nombre AS categoria,
        p.precio,
        p.stock
    FROM productos p
    JOIN categorias c ON p.categoria_id = c.categoria_id
    WHERE p.categoria_id = p_categoria_id;
END //

DELIMITER ;
```

#### ¿Cómo se ejecuta?

```sql
-- Consultar todos los productos pertenecientes a la Categoría 1
CALL sp_obtener_productos_por_categoria(1);
```

---

### Ejemplo 2: Total Vendido por un Cliente (Parámetros `IN` y `OUT`)

Este procedimiento recibe el nombre de un cliente (`p_cliente`) y calcula la suma total del dinero gastado sumando los subtotales de la tabla `detalle_ventas`. El total se deposita en el parámetro de salida `p_total_comprado`.

```sql


CREATE PROCEDURE sp_calcular_total_cliente(
    IN p_cliente VARCHAR(100),
    OUT p_total_comprado DECIMAL(10,2)
)
BEGIN
    SELECT IFNULL(SUM(dv.subtotal), 0)
    INTO p_total_comprado
    FROM ventas v
    JOIN detalle_ventas dv ON v.venta_id = dv.venta_id
    WHERE v.cliente = p_cliente;
END 

```

#### ¿Cómo se ejecuta y lee el resultado?

```sql
-- 1. Ejecutar el procedimiento pasando el nombre del cliente y una variable @total
CALL sp_calcular_total_cliente('Carlos Gómez', @total);

-- 2. Mostrar el valor retornado en la variable
SELECT @total AS total_gastado_carlos;
```