-- ==========================================================
-- DATOS INICIALES MÍNIMOS
-- ==========================================================

INSERT INTO tipo_usuarios (nombre_tipo_usuario, descripcion_tipo) VALUES
('Administrador', 'Acceso total'),
('Usuario',       'Realiza simulaciones');

INSERT INTO estados (nombre_estado, descripcion_estado) VALUES
('En Progreso', 'Simulación en curso'),
('Completada',  'Simulación finalizada'),
('Abandonada',  'No completada');

INSERT INTO tipo_comentario (nombre_tipo_comentario, descripcion_tipo) VALUES
('Ayuda',       'Solicitud de ayuda al usuario'),
('Opinion',     'Opinión general sobre el sistema'),
('Sugerencia',  'Sugerencia de mejora'),
('Problema',    'Reporte de error o problema');

INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id) VALUES
('Admin', 'admin@ciberseguridad.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1);
