
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
