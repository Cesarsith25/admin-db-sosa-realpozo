USE inventario_ventas;

START TRANSACTION;

-- Cabecera de la compra
INSERT INTO compras (fecha_compra, estado, total)
VALUES (NOW(), 'PENDIENTE', 0.00);

SET @id_compra = LAST_INSERT_ID();

-- Descontar stock (10 - 2 = 8)  -> cumple CHECK (stock >= 0)
UPDATE producto
SET    stock = stock - 2
WHERE  id_producto = 1;

-- Insertar el detalle
INSERT INTO detalle_compra (id_compra, id_producto, cantidad, precio_unitario, subtotal)
SELECT @id_compra, id_producto, 2, precio, precio * 2
FROM   producto
WHERE  id_producto = 1;

-- Actualizar el total de la cabecera
UPDATE compras
SET    total = (SELECT SUM(subtotal) FROM detalle_compra WHERE id_compra = @id_compra)
WHERE  id_compra = @id_compra;

-- Registrar el pago (monto > 0)  -> cumple CHECK (monto > 0)
INSERT INTO pagos (id_compra, monto, metodo_pago)
VALUES (@id_compra, (SELECT total FROM compras WHERE id_compra = @id_compra), 'TARJETA');

-- Marcar la compra como COMPLETADA
UPDATE compras
SET    estado = 'COMPLETADA'
WHERE  id_compra = @id_compra;

-- Confirmar: los cambios se guardan de forma definitiva
COMMIT;

-- ---- Verificación ----
SELECT * FROM producto        WHERE id_producto = 1; -- stock ahora en 8
SELECT * FROM compras         WHERE id_compra   = @id_compra;
SELECT * FROM detalle_compra  WHERE id_compra   = @id_compra;
SELECT * FROM pagos           WHERE id_compra   = @id_compra;