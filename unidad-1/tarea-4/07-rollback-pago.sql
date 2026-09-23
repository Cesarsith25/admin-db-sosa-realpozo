USE inventario_ventas;

START TRANSACTION;

-- 1. Cabecera de la compra
INSERT INTO compras (fecha_compra, estado, total)
VALUES (NOW(), 'PENDIENTE', 0.00);

SET @id_compra = LAST_INSERT_ID();

-- 2. Descontar stock de "Mouse Inalámbrico" (id 2): 50 - 1 = 49 (válido)
UPDATE producto
SET stock = stock - 1
WHERE id_producto = 2;

-- 3. Insertar el detalle (válido)
INSERT INTO detalle_compra (id_compra, id_producto, cantidad, precio_unitario, subtotal)
SELECT @id_compra, id_producto, 1, precio, precio * 1
FROM producto
WHERE id_producto = 2;

-- 4. Intento de pago INVÁLIDO (monto = 0.00)
--    ==> ERROR 3819: Check constraint 'chk_monto_positivo' is violated.
INSERT INTO pagos (id_compra, monto, metodo_pago)
VALUES (@id_compra, 0.00, 'TARJETA');

-- 5. El pago falló: se revierte TODO (stock + detalle + cabecera).
ROLLBACK;

-- ---- Verificación ----
SELECT * FROM producto WHERE id_producto = 2; -- stock restaurado a 50
SELECT * FROM compras ORDER BY id_compra DESC LIMIT 3; -- sin orden huérfana
SELECT * FROM detalle_compra ORDER BY id_detalle DESC LIMIT 3; -- sin detalle huérfano