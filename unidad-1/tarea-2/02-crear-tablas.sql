USE `sosa-realpozo`;

-- --------- CLIENTES (dueños de las mascotas) ---------
CREATE TABLE clientes (
    rut             VARCHAR(20)  NOT NULL,          -- documento de identidad (RUT/DNI)
    nombre_completo VARCHAR(100) NOT NULL,
    telefono        VARCHAR(20),
    correo          VARCHAR(100),
    PRIMARY KEY (rut)
) ENGINE=InnoDB;

-- --------- VETERINARIOS ---------
CREATE TABLE veterinarios (
    rut             VARCHAR(20)  NOT NULL,          -- documento de identidad
    nombre_completo VARCHAR(100) NOT NULL,
    especialidad    VARCHAR(80),
    telefono        VARCHAR(20),
    PRIMARY KEY (rut)
) ENGINE=InnoDB;

-- --------- MEDICAMENTOS ---------
CREATE TABLE medicamentos (
    codigo           VARCHAR(20)   NOT NULL,        -- código identificador
    nombre_comercial VARCHAR(100)  NOT NULL,
    laboratorio      VARCHAR(80),
    precio_unitario  DECIMAL(10,2),
    PRIMARY KEY (codigo)
) ENGINE=InnoDB;

-- --------- MASCOTAS (1 cliente : N mascotas) ---------
CREATE TABLE mascotas (
    id_mascota       INT          NOT NULL AUTO_INCREMENT,
    nombre           VARCHAR(60)  NOT NULL,
    especie          VARCHAR(40),
    raza             VARCHAR(60),
    fecha_nacimiento DATE,
    rut_cliente      VARCHAR(20)  NOT NULL,         -- FK -> clientes
    PRIMARY KEY (id_mascota)
) ENGINE=InnoDB;

-- --------- ATENCIONES MÉDICAS (1 mascota + 1 veterinario) ---------
CREATE TABLE atenciones (
    id_atencion     INT           NOT NULL AUTO_INCREMENT,
    fecha_hora      DATETIME      NOT NULL,
    diagnostico     TEXT,
    costo_base      DECIMAL(10,2),
    id_mascota      INT           NOT NULL,         -- FK -> mascotas
    rut_veterinario VARCHAR(20)   NOT NULL,         -- FK -> veterinarios
    PRIMARY KEY (id_atencion)
) ENGINE=InnoDB;

-- --------- PRESCRIPCIONES (tabla intermedia N:M Atenciones-Medicamentos) ---------
CREATE TABLE prescripciones (
    id_atencion        INT          NOT NULL,       -- FK -> atenciones
    codigo_medicamento VARCHAR(20)  NOT NULL,       -- FK -> medicamentos
    cantidad           INT          NOT NULL,
    indicaciones       VARCHAR(255),                -- ej: '1 pastilla cada 8 horas por 5 días'
    PRIMARY KEY (id_atencion, codigo_medicamento)   -- clave primaria compuesta
) ENGINE=InnoDB;
