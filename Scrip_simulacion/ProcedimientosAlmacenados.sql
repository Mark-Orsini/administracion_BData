-- ==========================================================
-- SCRIPT 3: PROCEDIMIENTOS ALMACENADOS
-- ==========================================================
USE ciberseguridad_db;

-- ==========================================================
-- PROCEDIMIENTOS PARA LA TABLA usuarios
-- ==========================================================

-- Insertar usuario
DELIMITER $$
CREATE PROCEDURE sp_insertar_usuario (
    IN p_nombre VARCHAR(50),
    IN p_correo VARCHAR(100),
    IN p_contrasena VARCHAR(255),
    IN p_tipo_usuario_id INT
)
BEGIN
    INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id)
    VALUES (p_nombre, p_correo, p_contrasena, p_tipo_usuario_id);
END$$
DELIMITER ;

-- Borrado lógico
DELIMITER $$
CREATE PROCEDURE sp_borrar_usuario (IN p_usuario_id INT)
BEGIN
    UPDATE usuarios SET activo = FALSE WHERE usuario_id = p_usuario_id;
END$$
DELIMITER ;

-- Mostrar usuarios activos
DELIMITER $$
CREATE PROCEDURE sp_mostrar_usuarios_activos()
BEGIN
    SELECT * FROM usuarios WHERE activo = TRUE;
END$$
DELIMITER ;

-- Mostrar todos los usuarios
DELIMITER $$
CREATE PROCEDURE sp_mostrar_todos_usuarios()
BEGIN
    SELECT * FROM usuarios;
END$$
DELIMITER ;

-- ==========================================================
-- REPITE ESTA ESTRUCTURA PARA CADA TABLA: tipos_usuarios, estados, tipos_comentarios, simulaciones, comentarios
-- ==========================================================

-- Ejemplo para tipos_usuarios
DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_usuario (IN p_nombre VARCHAR(50), IN p_desc VARCHAR(255))
BEGIN
    INSERT INTO tipos_usuarios (nombre_tipo_usuario, descripcion_tipo) VALUES (p_nombre, p_desc);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_tipo_usuario (IN p_id INT)
BEGIN
    UPDATE tipos_usuarios SET activo = FALSE WHERE tipo_usuario_id = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_mostrar_tipos_usuarios_activos()
BEGIN
    SELECT * FROM tipos_usuarios WHERE activo = TRUE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_mostrar_todos_tipos_usuarios()
BEGIN
    SELECT * FROM tipos_usuarios;
END$$
DELIMITER ;