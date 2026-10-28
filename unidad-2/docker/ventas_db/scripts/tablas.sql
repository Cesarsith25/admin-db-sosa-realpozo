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
