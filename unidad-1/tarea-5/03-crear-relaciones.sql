USE inventario_ventas;

-- Cada línea de detalle pertenece a una compra  (1:N)
ALTER TABLE detalle_compra
    ADD CONSTRAINT fk_detalle_compra
    FOREIGN KEY (id_compra) REFERENCES compras(id_compra);

-- Cada línea de detalle referencia a un producto  (1:N)
ALTER TABLE detalle_compra
    ADD CONSTRAINT fk_detalle_producto
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto);

-- Cada pago pertenece a una compra  (1:N)
ALTER TABLE pagos
    ADD CONSTRAINT fk_pago_compra
    FOREIGN KEY (id_compra) REFERENCES compras(id_compra);