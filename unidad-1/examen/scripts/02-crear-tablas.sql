USE refugio_selva_viva;

CREATE TABLE bioma (
    id_bioma INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL UNIQUE,
    clima VARCHAR(40) NOT NULL CHECK (clima IN ('TROPICAL','ARIDO','TEMPLADO','FRIO')),
    PRIMARY KEY (id_bioma)
) ENGINE=InnoDB;


CREATE TABLE especie (
    id_especie INT NOT NULL AUTO_INCREMENT,
    nombre_comun VARCHAR(100) NOT NULL,
    nombre_cientifico VARCHAR(150) NOT NULL UNIQUE,
    id_bioma INT NOT NULL,
    habito VARCHAR(20) NOT NULL CHECK (habito IN ('DIURNO','NOCTURNO','CREPUSCULAR')),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('MAMIFERO','AVE','REPTIL','ANFIBIO')),
    PRIMARY KEY (id_especie),
    UNIQUE (id_especie, id_bioma, tipo)
) ENGINE=InnoDB;


CREATE TABLE recinto (
    id_recinto INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    id_bioma INT NOT NULL,
    tipo_permitido VARCHAR(20) NOT NULL CHECK (tipo_permitido IN ('MAMIFERO','AVE','REPTIL','ANFIBIO')),
    capacidad_maxima INT NOT NULL CHECK (capacidad_maxima > 0),
    cupo_disponible INT NOT NULL CHECK (cupo_disponible >= 0),
    PRIMARY KEY (id_recinto),
    UNIQUE (id_recinto, id_bioma, tipo_permitido),
    CHECK (cupo_disponible <= capacidad_maxima)
) ENGINE=InnoDB;


CREATE TABLE animal (
    id_animal INT NOT NULL AUTO_INCREMENT,
    num_expediente VARCHAR(20) NOT NULL UNIQUE,
    id_especie INT NOT NULL,
    id_bioma_especie INT NOT NULL,
    tipo_especie VARCHAR(20) NOT NULL,
    id_recinto INT NULL,
    id_bioma_recinto INT NULL,
    tipo_recinto VARCHAR(20) NULL,
    alias VARCHAR(60) NULL,
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M','H','D')),
    fecha_ingreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_salud VARCHAR(20) NOT NULL CHECK (estado_salud IN ('CRITICO','GRAVE','ESTABLE','RECUPERADO')),
    situacion VARCHAR(20) NOT NULL DEFAULT 'EN_RESGUARDO' CHECK (situacion IN ('EN_RESGUARDO','TRASLADADO','LIBERADO','FALLECIDO')),
    PRIMARY KEY (id_animal),
    CHECK (
        (id_recinto IS NULL AND id_bioma_recinto IS NULL AND tipo_recinto IS NULL)
        OR (id_recinto IS NOT NULL AND id_bioma_recinto IS NOT NULL AND tipo_recinto IS NOT NULL)
    ),
    CHECK (
        id_recinto IS NULL
        OR (id_bioma_especie = id_bioma_recinto AND tipo_especie = tipo_recinto)
    ),
    CHECK (
        (situacion = 'EN_RESGUARDO' AND id_recinto IS NOT NULL)
        OR (situacion <> 'EN_RESGUARDO' AND id_recinto IS NULL)
    )
) ENGINE=InnoDB;


CREATE TABLE evaluacion_medica (
    id_evaluacion INT NOT NULL AUTO_INCREMENT,
    id_animal INT NOT NULL,
    veterinario VARCHAR(100) NOT NULL,        -- usuario MySQL del veterinario (ej. usr_vet_mendoza@localhost)
    fecha_evaluacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diagnostico TEXT NOT NULL,
    tratamiento TEXT NULL,
    peso_kg DECIMAL(7,2) NULL CHECK (peso_kg > 0),
    estado_salud VARCHAR(20) NOT NULL CHECK (estado_salud IN ('CRITICO','GRAVE','ESTABLE','RECUPERADO')),
    observaciones TEXT NULL,
    PRIMARY KEY (id_evaluacion)
) ENGINE=InnoDB;


CREATE TABLE bitacora_movimiento (
    id_movimiento INT NOT NULL AUTO_INCREMENT,
    id_animal INT NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL CHECK (tipo_movimiento IN ('INGRESO','TRASLADO_INTERNO','TRASLADO_EXTERNO','ALTA')),
    id_recinto_origen INT NULL,
    id_recinto_destino INT NULL,
    institucion_destino VARCHAR(150) NULL,
    motivo VARCHAR(255) NOT NULL,
    fecha_movimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    registrado_por VARCHAR(100) NOT NULL,     -- usuario MySQL que registró el movimiento (CURRENT_USER())
    PRIMARY KEY (id_movimiento),
    CHECK (
        (tipo_movimiento = 'INGRESO'
            AND id_recinto_origen IS NULL AND id_recinto_destino IS NOT NULL AND institucion_destino IS NULL)
        OR (tipo_movimiento = 'TRASLADO_INTERNO'
            AND id_recinto_origen IS NOT NULL AND id_recinto_destino IS NOT NULL
            AND id_recinto_origen <> id_recinto_destino AND institucion_destino IS NULL)
        OR (tipo_movimiento = 'TRASLADO_EXTERNO'
            AND id_recinto_origen IS NOT NULL AND id_recinto_destino IS NULL AND institucion_destino IS NOT NULL)
        OR (tipo_movimiento = 'ALTA'
            AND id_recinto_origen IS NOT NULL AND id_recinto_destino IS NULL)
    )
) ENGINE=InnoDB;
