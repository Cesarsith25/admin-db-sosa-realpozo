
USE inventario_ventas;

START TRANSACTION;

-- 1. Cabecera de la compra (se inserta dentro de la transacción)
INSERT INTO compras (fecha_compra, estado, total)
VALUES (NOW(), 'PENDIENTE', 0.00);

SET @id_compra = LAST_INSERT_ID();

-- 2. Intento de descontar más stock del disponible (5 - 8 = -3)
--    ==> ERROR 3819: Check constraint 'chk_stock_no_negativo' is violated.
UPDATE producto
SET stock = stock - 8
WHERE id_producto = 3;

-- 3. La regla se rompió: se DESHACE todo. La cabecera del paso 1
--    no queda guardada (no hay orden huérfana).
ROLLBACK;

-- ---- Verificación ----
SELECT * FROM producto WHERE id_producto = 3; -- stock intacto en 5
SELECT * FROM compras  ORDER BY id_compra DESC LIMIT 3; -- la cabecera NO se guardó