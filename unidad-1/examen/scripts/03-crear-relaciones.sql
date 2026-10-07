USE refugio_selva_viva;

-- Cada especie pertenece a un bioma  (1:N)
ALTER TABLE especie
    ADD CONSTRAINT fk_especie_bioma
    FOREIGN KEY (id_bioma) REFERENCES bioma(id_bioma);

-- Cada recinto corresponde a un bioma  (1:N)
ALTER TABLE recinto
    ADD CONSTRAINT fk_recinto_bioma
    FOREIGN KEY (id_bioma) REFERENCES bioma(id_bioma);

-- Cada animal es de una especie  (1:N)
-- Llave compuesta: garantiza que bioma y tipo copiados sean los reales de la especie
ALTER TABLE animal
    ADD CONSTRAINT fk_animal_especie
    FOREIGN KEY (id_especie, id_bioma_especie, tipo_especie)
    REFERENCES especie(id_especie, id_bioma, tipo);

-- Cada animal se ubica en un recinto  (1:N)
-- Llave compuesta: garantiza que bioma y tipo copiados sean los reales del recinto
ALTER TABLE animal
    ADD CONSTRAINT fk_animal_recinto
    FOREIGN KEY (id_recinto, id_bioma_recinto, tipo_recinto)
    REFERENCES recinto(id_recinto, id_bioma, tipo_permitido);

-- Cada evaluación médica pertenece a un animal  (1:N)
ALTER TABLE evaluacion_medica
    ADD CONSTRAINT fk_evaluacion_animal
    FOREIGN KEY (id_animal) REFERENCES animal(id_animal);

-- Cada movimiento pertenece a un animal  (1:N)
ALTER TABLE bitacora_movimiento
    ADD CONSTRAINT fk_movimiento_animal
    FOREIGN KEY (id_animal) REFERENCES animal(id_animal);

-- Recinto de origen del movimiento  (1:N)
ALTER TABLE bitacora_movimiento
    ADD CONSTRAINT fk_movimiento_origen
    FOREIGN KEY (id_recinto_origen) REFERENCES recinto(id_recinto);

-- Recinto de destino del movimiento  (1:N)
ALTER TABLE bitacora_movimiento
    ADD CONSTRAINT fk_movimiento_destino
    FOREIGN KEY (id_recinto_destino) REFERENCES recinto(id_recinto);
