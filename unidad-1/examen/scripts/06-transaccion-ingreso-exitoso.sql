USE refugio_selva_viva;

START TRANSACTION;

-- 1. Obtener el recinto destino (cupo disponible: 3)
SET @id_recinto = (SELECT id_recinto FROM recinto WHERE nombre = 'Felinos - Zona A');

-- 2. Registrar al Jaguar
--    Bioma y tipo se toman de la especie y del recinto -> cumple el CHECK de compatibilidad de área
INSERT INTO animal (num_expediente, id_especie, id_bioma_especie, tipo_especie, id_recinto, id_bioma_recinto, tipo_recinto, alias, sexo, fecha_ingreso, estado_salud)
SELECT 'EXP-2026-001', e.id_especie, e.id_bioma, e.tipo, r.id_recinto, r.id_bioma, r.tipo_permitido, 'Balam', 'M', NOW(), 'GRAVE'
FROM   especie e
CROSS JOIN recinto r
WHERE  e.nombre_cientifico = 'Panthera onca'
AND    r.id_recinto = @id_recinto;

SET @id_animal = LAST_INSERT_ID();

-- 3. Restar 1 al cupo (3 - 1 = 2)  -> cumple CHECK (cupo_disponible >= 0)
UPDATE recinto
SET    cupo_disponible = cupo_disponible - 1
WHERE  id_recinto = @id_recinto;

-- 4. Registrar el evento en la bitácora de trazabilidad
INSERT INTO bitacora_movimiento (id_animal, tipo_movimiento, id_recinto_origen, id_recinto_destino, motivo, fecha_movimiento, registrado_por)
VALUES (@id_animal, 'INGRESO', NULL, @id_recinto, 'Rescate de ejemplar víctima de tráfico ilegal', NOW(), CURRENT_USER());

-- Confirmar: los cambios se guardan de forma definitiva
COMMIT;

-- ---- Verificación ----
SELECT * FROM animal              WHERE num_expediente = 'EXP-2026-001';
SELECT * FROM recinto             WHERE id_recinto = @id_recinto; -- cupo ahora en 2
SELECT * FROM bitacora_movimiento WHERE id_animal  = @id_animal;
