USE `sosa-realpozo`;

-- --------- CLIENTES ---------
INSERT INTO clientes (rut, nombre_completo, telefono, correo) VALUES
('11111111-1', 'Carlos Pérez Soto',      '+56911111111', 'carlos.perez@mail.com'),
('22222222-2', 'María González Rojas',   '+56922222222', 'maria.gonzalez@mail.com'),
('33333333-3', 'Jorge Muñoz Díaz',       '+56933333333', 'jorge.munoz@mail.com'),
('44444444-4', 'Andrea Silva Castro',    '+56944444444', 'andrea.silva@mail.com'),
('55555555-5', 'Pedro Ramírez León',     '+56955555555', 'pedro.ramirez@mail.com');

-- --------- VETERINARIOS ---------
INSERT INTO veterinarios (rut, nombre_completo, especialidad, telefono) VALUES
('90000001-1', 'Dra. Laura Fuentes',  'Medicina General', '+56990000001'),
('90000002-2', 'Dr. Felipe Torres',   'Cirugía',          '+56990000002'),
('90000003-3', 'Dra. Carla Herrera',  'Dermatología',     '+56990000003'),
('90000004-4', 'Dr. Nicolás Vega',    'Cardiología',      '+56990000004'),
('90000005-5', 'Dra. Paula Reyes',    'Odontología',      '+56990000005');

-- --------- MEDICAMENTOS ---------
INSERT INTO medicamentos (codigo, nombre_comercial, laboratorio, precio_unitario) VALUES
('MED001', 'Amoxicilina 250mg',     'Lab Chile',    4500.00),
('MED002', 'Meloxicam 1.5mg',       'Bayer',        6200.00),
('MED003', 'Antipulgas Bravecto',   'MSD',         25000.00),
('MED004', 'Vitamina B Complex',    'Drag Pharma',  3800.00),
('MED005', 'Omeprazol 10mg',        'Lab Chile',    2900.00);

-- --------- MASCOTAS (Carlos Pérez tiene 2 mascotas: Firulais y Nina) ---------
INSERT INTO mascotas (nombre, especie, raza, fecha_nacimiento, rut_cliente) VALUES
('Firulais', 'Perro', 'Labrador', '2020-05-14', '11111111-1'),
('Michi',    'Gato',  'Siamés',   '2021-08-02', '22222222-2'),
('Rocky',    'Perro', 'Bulldog',  '2019-11-20', '33333333-3'),
('Luna',     'Gato',  'Persa',    '2022-01-10', '44444444-4'),
('Toby',     'Perro', 'Poodle',   '2018-03-30', '55555555-5'),
('Nina',     'Perro', 'Beagle',   '2021-07-07', '11111111-1');

-- --------- ATENCIONES MÉDICAS ---------
-- (id_mascota 1..6 según el orden de inserción anterior)
INSERT INTO atenciones (fecha_hora, diagnostico, costo_base, id_mascota, rut_veterinario) VALUES
('2024-05-01 09:30:00', 'Control sano anual',        25000.00, 1, '90000001-1'),
('2024-05-02 11:00:00', 'Infección cutánea leve',    30000.00, 2, '90000003-3'),
('2024-05-03 15:45:00', 'Fractura pata trasera',     80000.00, 3, '90000002-2'),
('2024-05-04 10:15:00', 'Problema digestivo',        28000.00, 4, '90000001-1'),
('2024-05-05 16:00:00', 'Limpieza dental',           45000.00, 5, '90000005-5');

-- --------- PRESCRIPCIONES (N:M) ---------
-- La atención 2 receta 2 medicamentos -> demuestra la relación N:M
INSERT INTO prescripciones (id_atencion, codigo_medicamento, cantidad, indicaciones) VALUES
(1, 'MED004', 1, '1 comprimido al día por 15 días'),
(2, 'MED001', 2, '1 pastilla cada 12 horas por 7 días'),
(2, 'MED003', 1, 'Aplicar una vez, dosis única'),
(3, 'MED002', 3, '1 comprimido cada 24 horas por 3 días'),
(4, 'MED005', 1, '1 pastilla en ayunas por 10 días'),
(5, 'MED001', 1, '1 pastilla cada 8 horas por 5 días');
