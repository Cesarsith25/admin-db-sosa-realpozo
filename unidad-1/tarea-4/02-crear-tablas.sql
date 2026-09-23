USE inventario_ventas;

CREATE TABLE producto (
    id_producto INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    PRIMARY KEY (id_producto),
    CONSTRAINT chk_precio_positivo CHECK (precio > 0),
    CONSTRAINT chk_stock_no_negativo CHECK (stock >= 0)
) ENGINE=InnoDB;


CREATE TABLE compras (
    id_compra INT NOT NULL AUTO_INCREMENT,
    fecha_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (id_compra),
    CONSTRAINT chk_total_no_negativo CHECK (total >= 0)
) ENGINE=InnoDB;


CREATE TABLE detalle_compra (
    id_detalle INT NOT NULL AUTO_INCREMENT,
    id_compra INT NOT NULL, 
    id_producto INT NOT NULL, 
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_detalle),
    CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT chk_subtotal_positivo CHECK (subtotal > 0)
) ENGINE=InnoDB;


CREATE TABLE pagos (
    id_pago INT NOT NULL AUTO_INCREMENT,
    id_compra INT NOT NULL,   
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(40) NOT NULL DEFAULT 'TARJETA',
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pago),
    CONSTRAINT chk_monto_positivo CHECK (monto > 0)
) ENGINE=InnoDB;