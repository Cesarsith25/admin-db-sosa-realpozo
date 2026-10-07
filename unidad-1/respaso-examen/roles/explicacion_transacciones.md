# Transacciones en MySQL

## ¿Qué es una Transacción?

Una **transacción** es un conjunto de operaciones SQL que se ejecutan como una única unidad de trabajo indivisible. 

Sigue el principio del **"todo o nada"**:
* Si todas las operaciones tienen éxito, los cambios se guardan permanentemente (**`COMMIT`**).
* Si alguna instrucción falla, se revierten absolutamente todos los cambios realizados desde el inicio (**`ROLLBACK`**), dejando la base de datos intacta.

---

## Estructura DDL Inicial (Tablas y Datos)

```sql
CREATE TABLE cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titular VARCHAR(100) NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL CHECK (saldo >= 0)
) ENGINE=InnoDB;

CREATE TABLE historial_transferencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cuenta_origen_id INT NOT NULL,
    cuenta_destino_id INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cuenta_origen_id) REFERENCES cuentas(id),
    FOREIGN KEY (cuenta_destino_id) REFERENCES cuentas(id)
) ENGINE=InnoDB;

-- Datos de prueba
INSERT INTO cuentas (titular, saldo) VALUES
('Juan Pérez', 1000.00),     -- ID: 1
('María López', 500.00),     -- ID: 2
('Pedro Navajas', 1000.00);   -- ID: 3
```

---

## Ejemplo 1: Transacción Completa (Exitosa)

**Escenario:** Juan (ID 1) le transfiere $200.00 a María (ID 2).

```sql
-- 1. Iniciar la transacción
START TRANSACTION;

-- 2. Restar $200 de la cuenta de Juan
UPDATE cuentas 
SET saldo = saldo - 200.00 
WHERE id = 1;

-- 3. Sumar $200 a la cuenta de María
UPDATE cuentas 
SET saldo = saldo + 200.00 
WHERE id = 2;

-- 4. Registrar la transferencia en el historial
INSERT INTO historial_transferencias (cuenta_origen_id, cuenta_destino_id, monto) 
VALUES (1, 2, 200.00);

-- 5. Confirmar y guardar permanentemente los cambios
COMMIT;
```

**Resultado:** 
* Juan se queda con $800.00.
* María con $700.00.
* El historial contiene el registro del traspaso.

---

## Ejemplo 2: Transacción Fallida (Manejo con `ROLLBACK`)

### Caso A: Fallo por Violación de Restricción (`CHECK`)

**Escenario:** Juan (ID 1) intenta transferir $1,500.00 a Pedro (ID 3). Juan solo tiene $800.00 disponibles.

```sql
START TRANSACTION;

-- Intentar restar dinero ($2000.00 a un saldo de $1000.00)
-- Fallará por la restricción CHECK (saldo >= 0)
UPDATE cuentas SET saldo = saldo - 2000.00 WHERE id = 1;

-- Esta instrucción no debería consolidarse
UPDATE cuentas SET saldo = saldo + 2000.00 WHERE id = 2;

-- Intentar registrar la transferencia
INSERT INTO historial_transferencias (cuenta_origen_id, cuenta_destino_id, monto) 
VALUES (1, 2, 2000.00);

-- Se cancela la transacción y se revierten todos los cambios
ROLLBACK;
```

---

### Caso B: Fallo por Llave Foránea Inválida

**Escenario:** Se descuenta dinero de Juan para enviarlo a una cuenta inexistente (ID 99).

```sql
START TRANSACTION;

-- 1. Se resta el dinero de Juan de forma correcta
UPDATE cuentas 
SET saldo = saldo - 100.00 
WHERE id = 1;

-- 2. Intentar registrar la transferencia a una cuenta que NO existe (ID 99)
-- ESTA INSTRUCCIÓN FALLA por violación de FOREIGN KEY
INSERT INTO historial_transferencias (cuenta_origen_id, cuenta_destino_id, monto) 
VALUES (1, 99, 100.00);

-- 3. Abortar la transacción para revertir el descuento hecho a Juan
ROLLBACK;
```

**Resultado tras el `ROLLBACK`:**
* La resta realizada en la cuenta de Juan se revierte.
* Ningún cambio afecta a la base de datos, el saldo de Juan sigue intacto.