# Guía de Integración: Base de Datos de Ventas con TypeORM y TypeScript

Este documento contiene la explicación completa, la mapeación de tablas y la configuración de **TypeORM** para una API de Node.js con TypeScript utilizando la base de datos `ventas_db`.

---

## 1. Esquema de Base de Datos (MySQL / MariaDB)

El modelo de datos consta de 4 tablas principales estructuradas de la siguiente manera:

- **`categorias`**: Almacena las categorías de los productos.
- **`productos`**: Almacena el catálogo de productos, su precio, stock y categoría asociada.
- **`ventas`**: Encabezado de las ventas realizadas (cliente, fecha y total).
- **`detalle_ventas`**: Detalle de cada artículo vendido dentro de una venta, con referencia al producto, cantidad y subtotal.

```sql
CREATE DATABASE IF NOT EXISTS ventas_db;
USE ventas_db;

CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    categoria_id INT,
    CONSTRAINT fk_productos_categorias 
        FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
) ENGINE=InnoDB;

CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    cliente VARCHAR(100) NOT NULL,
    total DECIMAL(10, 2) DEFAULT 0.00
) ENGINE=InnoDB;

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

---

## 2. Conceptos Clave de TypeORM

1. **Entidades (`Entities`)**: Son clases de TypeScript que representan cada una de las tablas de la base de datos. Se definen con el decorador `@Entity()`.
2. **Decoradores de Columnas**:
   - `@PrimaryGeneratedColumn()`: Identifica una llave primaria autoincrementable.
   - `@Column()`: Mapea una columna regular especificando su tipo, longitud o valores por defecto.
3. **Relaciones**:
   - `@OneToMany`: Una entidad se relaciona con múltiples instancias de otra (Ej. Una Categoría tiene muchos Productos).
   - `@ManyToOne`: Múltiples registros se relacionan con uno solo (Ej. Muchos Detalles pertenecen a una Venta).
   - `@JoinColumn`: Especifica el nombre de la columna física de la Foreign Key en la base de datos.

---

## 3. Definición de Entidades en TypeORM

### Entidad `Categoria` (`Categoria.ts`)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from "typeorm";
import { Producto } from "./Producto";

@Entity("categorias")
export class Categoria {
    @PrimaryGeneratedColumn({ name: "categoria_id" })
    categoriaId!: number;

    @Column({ type: "varchar", length: 50, nullable: false })
    nombre!: string;

    // Relación Uno a Muchos: Una categoría tiene muchos productos
    @OneToMany(() => Producto, (producto) => producto.categoria)
    productos!: Producto[];
}
```

---

### Entidad `Producto` (`Producto.ts`)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from "typeorm";
import { Categoria } from "./Categoria";
import { DetalleVenta } from "./DetalleVenta";

@Entity("productos")
export class Producto {
    @PrimaryGeneratedColumn({ name: "producto_id" })
    productoId!: number;

    @Column({ type: "varchar", length: 100, nullable: false })
    nombre!: string;

    @Column({ type: "decimal", precision: 10, scale: 2, nullable: false })
    precio!: number;

    @Column({ type: "int", default: 0 })
    stock!: number;

    @Column({ name: "categoria_id", nullable: true })
    categoriaId!: number;

    // Relación Muchos a Uno: Muchos productos pertenecen a una categoría
    @ManyToOne(() => Categoria, (categoria) => categoria.productos, { onDelete: "SET NULL" })
    @JoinColumn({ name: "categoria_id" })
    categoria!: Categoria;

    // Relación Uno a Muchos: Un producto puede estar en varios detalles de venta
    @OneToMany(() => DetalleVenta, (detalle) => detalle.producto)
    detallesVenta!: DetalleVenta[];
}
```

---

### Entidad `Venta` (`Venta.ts`)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from "typeorm";
import { DetalleVenta } from "./DetalleVenta";

@Entity("ventas")
export class Venta {
    @PrimaryGeneratedColumn({ name: "venta_id" })
    ventaId!: number;

    @Column({ type: "datetime", default: () => "CURRENT_TIMESTAMP" })
    fecha!: Date;

    @Column({ type: "varchar", length: 100, nullable: false })
    cliente!: string;

    @Column({ type: "decimal", precision: 10, scale: 2, default: 0.00 })
    total!: number;

    // Relación Uno a Muchos con operaciones en cascada
    @OneToMany(() => DetalleVenta, (detalle) => detalle.venta, { cascade: true })
    detalles!: DetalleVenta[];
}
```

---

### Entidad `DetalleVenta` (`DetalleVenta.ts`)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from "typeorm";
import { Venta } from "./Venta";
import { Producto } from "./Producto";

@Entity("detalle_ventas")
export class DetalleVenta {
    @PrimaryGeneratedColumn({ name: "detalle_id" })
    detalleId!: number;

    @Column({ name: "venta_id" })
    ventaId!: number;

    @Column({ name: "producto_id" })
    productoId!: number;

    @Column({ type: "int", nullable: false })
    cantidad!: number;

    @Column({ type: "decimal", precision: 10, scale: 2, name: "precio_unitario", nullable: false })
    precioUnitario!: number;

    @Column({ type: "decimal", precision: 10, scale: 2, nullable: false })
    subtotal!: number;

    // Relación Muchos a Uno con Venta
    @ManyToOne(() => Venta, (venta) => venta.detalles, { onDelete: "CASCADE" })
    @JoinColumn({ name: "venta_id" })
    venta!: Venta;

    // Relación Muchos a Uno con Producto
    @ManyToOne(() => Producto, (producto) => producto.detallesVenta)
    @JoinColumn({ name: "producto_id" })
    producto!: Producto;
}
```

---

## 4. Configuración de la Conexión (`data-source.ts`)

Para conectar TypeORM con MySQL o MariaDB utilizando tus credenciales de base de datos:

```typescript
import "reflect-metadata";
import { DataSource } from "typeorm";
import { Categoria } from "./entities/Categoria";
import { Producto } from "./entities/Producto";
import { Venta } from "./entities/Venta";
import { DetalleVenta } from "./entities/DetalleVenta";

export const AppDataSource = new DataSource({
    type: "mysql", // O "mariadb"
    host: "localhost",
    port: 3306,
    username: "tu_usuario",
    password: "tu_password",
    database: "ventas_db",
    synchronize: false, // Se mantiene false ya que las tablas fueron creadas previamente por SQL
    logging: true,
    entities: [Categoria, Producto, Venta, DetalleVenta],
    subscribers: [],
    migrations: [],
});
```

---

## 5. Ejemplo de Inicialización de la Aplicación

```typescript
import { AppDataSource } from "./data-source";

AppDataSource.initialize()
    .then(() => {
        console.log("¡Conexión exitosa a la base de datos ventas_db!");
    })
    .catch((error) => {
        console.error("Error al conectar con la base de datos:", error);
    });
```