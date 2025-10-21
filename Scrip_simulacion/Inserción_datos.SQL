-- ==========================================================
-- SCRIPT 2: DATOS INICIALES MÍNIMOS
-- ==========================================================
USE ciberseguridad_educacion;

-- ==========================================================
-- CATÁLOGOS BÁSICOS
-- ==========================================================

INSERT INTO tipos_usuarios (nombre_tipo_usuario, descripcion_tipo) VALUES
('Administrador', 'Acceso total al sistema'),
('Usuario',       'Usuario que realiza simulaciones');

INSERT INTO estados (nombre_estado, descripcion_estado) VALUES
('En Progreso', 'Simulación actualmente en curso'),
('Completada',  'Simulación finalizada correctamente'),
('Abandonada',  'Simulación no completada por el usuario');

INSERT INTO tipos_comentarios (nombre_tipo_comentario, descripcion_tipo) VALUES
('Ayuda',       'Solicitud de ayuda o asistencia'),
('Opinion',     'Opinión general sobre el sistema'),
('Sugerencia',  'Sugerencia de mejora o nueva funcionalidad'),
('Problema',    'Reporte de error o problema técnico');

-- ==========================================================
-- USUARIO ADMINISTRADOR INICIAL
-- ==========================================================

INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id) VALUES
('Administrador Sistema', 'admin@ciberseguridad.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1);

-- ==========================================================
-- CONSULTAS DE VERIFICACIÓN
-- ==========================================================

SELECT 'TIPOS DE USUARIOS' AS tabla;
SELECT * FROM tipos_usuarios WHERE deleted = FALSE;

SELECT 'ESTADOS' AS tabla;
SELECT * FROM estados WHERE deleted = FALSE;

SELECT 'TIPOS DE COMENTARIOS' AS tabla;
SELECT * FROM tipos_comentarios WHERE deleted = FALSE;

SELECT 'USUARIOS' AS tabla;
SELECT * FROM usuarios WHERE deleted = FALSE AND activo = TRUE;