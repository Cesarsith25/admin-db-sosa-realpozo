USE refugio_selva_viva;

START TRANSACTION;

-- 1. Identificar al Tucán y los recintos de origen y destino
SET @id_animal = (SELECT id_animal FROM animal  WHERE num_expediente = 'EXP-2026-002');
SET @origen    = (SELECT id_recinto FROM recinto WHERE nombre = 'Cuarentena Aves');
SET @destino   = (SELECT id_recinto FROM recinto WHERE nombre = 'Aviario General');

-- 2. Actualizar la ubicación del animal (recinto, bioma y tipo del destino)
--    Aviario General es AVE / Selva tropical -> cumple el CHECK de compatibilidad de área
UPDATE animal a
JOIN   recinto r ON r.id_recinto = @destino
SET    a.id_recinto       = r.id_recinto,
       a.id_bioma_recinto = r.id_bioma,
       a.tipo_recinto     = r.tipo_permitido
WHERE  a.id_animal = @id_animal;

-- 3. Liberar un lugar en el origen (5 + 1 = 6)  -> cumple CHECK (cupo <= capacidad)
UPDATE recinto
SET    cupo_disponible = cupo_disponible + 1
WHERE  id_recinto = @origen;

-- 4. Ocupar un lugar en el destino (9 - 1 = 8)  -> cumple CHECK (cupo >= 0)
UPDATE recinto
SET    cupo_disponible = cupo_disponible - 1
WHERE  id_recinto = @destino;

-- 5. Registrar el movimiento en la bitácora
INSERT INTO bitacora_movimiento (id_animal, tipo_movimiento, id_recinto_origen, id_recinto_destino, motivo, fecha_movimiento, registrado_por)
VALUES (@id_animal, 'TRASLADO_INTERNO', @origen, @destino, 'Fin de cuarentena, apto para aviario', NOW(), CURRENT_USER());

-- Confirmar
COMMIT;

-- ---- Verificación ----
SELECT * FROM animal              WHERE id_animal = @id_animal;           -- ahora en Aviario General
SELECT * FROM recinto             WHERE id_recinto IN (@origen, @destino); -- 6 y 8
SELECT * FROM bitacora_movimiento WHERE id_animal = @id_animal ORDER BY fecha_movimiento;
