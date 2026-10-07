USE refugio_selva_viva;

INSERT INTO bioma (nombre, clima) VALUES
('Selva tropical', 'TROPICAL'),
('Desierto', 'ARIDO'),
('Bosque templado', 'TEMPLADO'),
('Humedal', 'TROPICAL');

INSERT INTO especie (nombre_comun, nombre_cientifico, id_bioma, habito, tipo) VALUES
('Jaguar', 'Panthera onca', 1, 'NOCTURNO', 'MAMIFERO'),
('Tucán pico canoa', 'Ramphastos sulfuratus', 1, 'DIURNO', 'AVE'),
('Iguana verde', 'Iguana iguana', 1, 'DIURNO', 'REPTIL'),
('Ocelote', 'Leopardus pardalis', 1, 'NOCTURNO', 'MAMIFERO'),
('Guacamaya roja', 'Ara macao', 1, 'DIURNO', 'AVE'),
('Boa constrictor', 'Boa constrictor', 1, 'NOCTURNO', 'REPTIL');

-- cupo_disponible = capacidad_maxima - animales que ya están dentro
INSERT INTO recinto (nombre, id_bioma, tipo_permitido, capacidad_maxima, cupo_disponible) VALUES
('Felinos - Zona A', 1, 'MAMIFERO', 4, 3),     -- 1 ocelote
('Cuarentena Aves', 1, 'AVE', 6, 5),           -- 1 tucán
('Aviario General', 1, 'AVE', 10, 9),          -- 1 guacamaya
('Reptilario 1', 1, 'REPTIL', 2, 0);           -- 2 boas (LLENO)

-- id_bioma_especie / tipo_especie  = datos de la especie
-- id_bioma_recinto / tipo_recinto  = datos del recinto   (deben coincidir)
INSERT INTO animal (num_expediente, id_especie, id_bioma_especie, tipo_especie, id_recinto, id_bioma_recinto, tipo_recinto, alias, sexo, fecha_ingreso, estado_salud) VALUES
('EXP-2025-014', 4, 1, 'MAMIFERO', 1, 1, 'MAMIFERO', 'Pinto', 'H', '2025-11-10 09:30:00', 'ESTABLE'),
('EXP-2026-002', 2, 1, 'AVE',      2, 1, 'AVE',      'Kiwi',  'M', '2026-09-20 11:00:00', 'ESTABLE'),
('EXP-2025-021', 5, 1, 'AVE',      3, 1, 'AVE',      'Roja',  'H', '2025-12-02 16:15:00', 'RECUPERADO'),
('EXP-2026-010', 6, 1, 'REPTIL',   4, 1, 'REPTIL',   NULL,    'D', '2026-03-05 10:00:00', 'ESTABLE'),
('EXP-2026-011', 6, 1, 'REPTIL',   4, 1, 'REPTIL',   NULL,    'D', '2026-03-05 10:05:00', 'GRAVE');

INSERT INTO bitacora_movimiento (id_animal, tipo_movimiento, id_recinto_origen, id_recinto_destino, motivo, fecha_movimiento, registrado_por) VALUES
(1, 'INGRESO', NULL, 1, 'Rescate por decomiso de tráfico ilegal', '2025-11-10 09:30:00', 'usr_recepcion1@localhost'),
(2, 'INGRESO', NULL, 2, 'Ingreso a cuarentena por rescate', '2026-09-20 11:00:00', 'usr_recepcion1@localhost'),
(3, 'INGRESO', NULL, 3, 'Entrega voluntaria de particular', '2025-12-02 16:15:00', 'usr_recepcion1@localhost'),
(4, 'INGRESO', NULL, 4, 'Decomiso en operativo PROFEPA', '2026-03-05 10:00:00', 'usr_recepcion1@localhost'),
(5, 'INGRESO', NULL, 4, 'Decomiso en operativo PROFEPA', '2026-03-05 10:05:00', 'usr_recepcion1@localhost');

INSERT INTO evaluacion_medica (id_animal, veterinario, fecha_evaluacion, diagnostico, tratamiento, peso_kg, estado_salud, observaciones) VALUES
(1, 'usr_vet_mendoza@localhost', '2025-11-10 12:00:00', 'Deshidratación moderada', 'Suero subcutáneo 3 días', 9.80, 'GRAVE', 'Ingreso por tráfico'),
(1, 'usr_vet_mendoza@localhost', '2025-11-20 10:00:00', 'Recuperación favorable', NULL, 10.40, 'ESTABLE', NULL),
(2, 'usr_vet_mendoza@localhost', '2026-09-20 13:00:00', 'Plumaje dañado, sin parásitos', 'Vitaminas vía oral', 0.45, 'ESTABLE', 'Mantener en cuarentena'),
(5, 'usr_vet_mendoza@localhost', '2026-03-05 12:00:00', 'Lesión por aplastamiento', 'Antiinflamatorio y reposo', 6.20, 'GRAVE', NULL);

-- ---- Índices para consultas frecuentes ----
CREATE INDEX idx_animal_estado_salud ON animal (estado_salud);
CREATE INDEX idx_animal_situacion ON animal (situacion);
CREATE INDEX idx_evaluacion_animal_fecha ON evaluacion_medica (id_animal, fecha_evaluacion);
CREATE INDEX idx_bitacora_animal_fecha ON bitacora_movimiento (id_animal, fecha_movimiento);
CREATE INDEX idx_bitacora_tipo ON bitacora_movimiento (tipo_movimiento);
