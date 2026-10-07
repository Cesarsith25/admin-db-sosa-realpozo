USE refugio_selva_viva;

START TRANSACTION;

-- 1. Obtener el recinto destino (cupo disponible: 0, LLENO)
SET @id_recinto = (SELECT id_recinto FROM recinto WHERE nombre = 'Reptilario 1');

-- 2. Registrar a la Iguana (esta inserción SÍ se ejecuta dentro de la transacción)
--    Iguana = REPTIL / Selva tropical, igual que Reptilario 1 -> área compatible
INSERT INTO animal (num_expediente, id_especie, id_bioma_especie, tipo_especie, id_recinto, id_bioma_recinto, tipo_recinto, alias, sexo, fecha_ingreso, estado_salud)
SELECT 'EXP-2026-003', e.id_especie, e.id_bioma, e.tipo, r.id_recinto, r.id_bioma, r.tipo_permitido, NULL, 'D', NOW(), 'ESTABLE'
FROM   especie e
CROSS JOIN recinto r
WHERE  e.nombre_cientifico = 'Iguana iguana'
AND    r.id_recinto = @id_recinto;

SET @id_animal = LAST_INSERT_ID();

-- 3. Intento de restar cupo a un recinto lleno (0 - 1 = -1)
--    ==> ERROR 3819: Check constraint 'recinto_chk_N' is violated. (CHECK cupo_disponible >= 0)
UPDATE recinto
SET    cupo_disponible = cupo_disponible - 1
WHERE  id_recinto = @id_recinto;

-- 4. La regla se rompió: se DESHACE todo. La Iguana del paso 2
--    no queda guardada (no hay registro parcial).
ROLLBACK;

-- ---- Verificación ----
SELECT * FROM animal  WHERE num_expediente = 'EXP-2026-003'; -- 0 filas: la Iguana NO se guardó
SELECT * FROM recinto WHERE nombre = 'Reptilario 1';         -- cupo intacto en 0
SELECT * FROM bitacora_movimiento ORDER BY id_movimiento DESC LIMIT 3; -- sin movimiento nuevo
