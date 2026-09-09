USE `sosa-realpozo`;

-- Cada mascota pertenece a un cliente  (1:N)
ALTER TABLE mascotas
    ADD CONSTRAINT fk_mascota_cliente
    FOREIGN KEY (rut_cliente) REFERENCES clientes(rut);

-- Cada atención es de una mascota  (1:N)
ALTER TABLE atenciones
    ADD CONSTRAINT fk_atencion_mascota
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota);

-- Cada atención la realiza un veterinario  (1:N)
ALTER TABLE atenciones
    ADD CONSTRAINT fk_atencion_veterinario
    FOREIGN KEY (rut_veterinario) REFERENCES veterinarios(rut);

-- Una prescripción enlaza una atención con un medicamento  (N:M)
ALTER TABLE prescripciones
    ADD CONSTRAINT fk_prescripcion_atencion
    FOREIGN KEY (id_atencion) REFERENCES atenciones(id_atencion);

ALTER TABLE prescripciones
    ADD CONSTRAINT fk_prescripcion_medicamento
    FOREIGN KEY (codigo_medicamento) REFERENCES medicamentos(codigo);
