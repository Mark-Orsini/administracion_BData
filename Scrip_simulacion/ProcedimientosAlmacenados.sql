-- ==========================================================
-- SCRIPT 3: PROCEDIMIENTOS ALMACENADOS (4 POR TABLA)
-- ==========================================================
USE ciberseguridad_educacion;

-- ==========================================================
-- PROCEDIMIENTOS PARA: tipos_usuarios
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_usuario (
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(100),
    IN p_created_by INT
)
BEGIN
    INSERT INTO tipos_usuarios (nombre_tipo_usuario, descripcion_tipo, created_by)
    VALUES (p_nombre, p_descripcion, p_created_by);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_usuario (
    IN p_id INT,
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(100),
    IN p_updated_by INT
)
BEGIN
    UPDATE tipos_usuarios 
    SET nombre_tipo_usuario = p_nombre,
        descripcion_tipo = p_descripcion,
        updated_by = p_updated_by
    WHERE id_tipo_usuario = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_tipo_usuario (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tipos_usuarios 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE id_tipo_usuario = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_tipos_usuarios()
BEGIN
    SELECT * FROM tipos_usuarios WHERE deleted = FALSE;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: estados
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_estado (
    IN p_nombre VARCHAR(20),
    IN p_descripcion VARCHAR(100),
    IN p_created_by INT
)
BEGIN
    INSERT INTO estados (nombre_estado, descripcion_estado, created_by)
    VALUES (p_nombre, p_descripcion, p_created_by);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_estado (
    IN p_id INT,
    IN p_nombre VARCHAR(20),
    IN p_descripcion VARCHAR(100),
    IN p_updated_by INT
)
BEGIN
    UPDATE estados 
    SET nombre_estado = p_nombre,
        descripcion_estado = p_descripcion,
        updated_by = p_updated_by
    WHERE id_estado = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_estado (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE estados 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE id_estado = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_estados()
BEGIN
    SELECT * FROM estados WHERE deleted = FALSE;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: tipos_comentarios
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_tipo_comentario (
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(100),
    IN p_created_by INT
)
BEGIN
    INSERT INTO tipos_comentarios (nombre_tipo_comentario, descripcion_tipo, created_by)
    VALUES (p_nombre, p_descripcion, p_created_by);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_comentario (
    IN p_id INT,
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(100),
    IN p_updated_by INT
)
BEGIN
    UPDATE tipos_comentarios 
    SET nombre_tipo_comentario = p_nombre,
        descripcion_tipo = p_descripcion,
        updated_by = p_updated_by
    WHERE id_tipo_comentario = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_tipo_comentario (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE tipos_comentarios 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE id_tipo_comentario = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_tipos_comentarios()
BEGIN
    SELECT * FROM tipos_comentarios WHERE deleted = FALSE;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: usuarios
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_usuario (
    IN p_nombre VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_contrasena VARCHAR(255),
    IN p_tipo_usuario_id INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id, created_by)
    VALUES (p_nombre, p_correo, p_contrasena, p_tipo_usuario_id, p_created_by);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_usuario (
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_tipo_usuario_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE usuarios 
    SET nombre_usuario = p_nombre,
        correo = p_correo,
        tipo_usuario_id = p_tipo_usuario_id,
        updated_by = p_updated_by
    WHERE id_usuario = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_usuario (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE usuarios 
    SET deleted = TRUE, activo = FALSE, updated_by = p_updated_by
    WHERE id_usuario = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_usuarios()
BEGIN
    SELECT u.id_usuario, u.nombre_usuario, u.correo, u.activo, u.ultimo_ingreso,
           t.nombre_tipo_usuario, u.created_at
    FROM usuarios u
    INNER JOIN tipos_usuarios t ON u.tipo_usuario_id = t.id_tipo_usuario
    WHERE u.deleted = FALSE;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: simulaciones
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_simulacion (
    IN p_usuario_id INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO simulaciones (usuario_id, estado_id, created_by)
    VALUES (p_usuario_id, 1, p_created_by); -- Estado "En Progreso" por defecto
    
    SELECT LAST_INSERT_ID() AS id_simulacion;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_simulacion (
    IN p_id INT,
    IN p_estado_id INT,
    IN p_fecha_fin DATETIME,
    IN p_duracion INT,
    IN p_puntaje DECIMAL(5,2),
    IN p_fue_enganado BOOLEAN,
    IN p_updated_by INT
)
BEGIN
    UPDATE simulaciones 
    SET estado_id = p_estado_id,
        fecha_fin = p_fecha_fin,
        duracion_segundos = p_duracion,
        puntaje = p_puntaje,
        fue_enganado = p_fue_enganado,
        updated_by = p_updated_by
    WHERE id_simulacion = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_simulacion (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE simulaciones 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE id_simulacion = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_simulaciones_usuario (
    IN p_usuario_id INT
)
BEGIN
    SELECT s.id_simulacion, s.fecha_inicio, s.fecha_fin, s.duracion_segundos,
           s.puntaje, s.fue_enganado, e.nombre_estado
    FROM simulaciones s
    INNER JOIN estados e ON s.estado_id = e.id_estado
    WHERE s.usuario_id = p_usuario_id AND s.deleted = FALSE
    ORDER BY s.fecha_inicio DESC;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: datos_simulaciones
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_datos_simulacion (
    IN p_simulacion_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_correo VARCHAR(255),
    IN p_clave VARCHAR(255),
    IN p_fecha_nac DATE,
    IN p_genero VARCHAR(20),
    IN p_num_cuenta VARCHAR(50),
    IN p_cvc VARCHAR(5),
    IN p_fecha_venc VARCHAR(10),
    IN p_rut VARCHAR(20),
    IN p_direccion TEXT,
    IN p_correo_recup VARCHAR(255),
    IN p_telefono VARCHAR(30),
    IN p_clave_ant VARCHAR(255),
    IN p_created_by INT
)
BEGIN
    INSERT INTO datos_simulaciones (
        simulacion_id, nombre_falso, apellido_falso, correo_falso, clave_falso,
        fecha_nacimiento_falso, genero_falso, numero_cuenta_falso, cvc_falso,
        fecha_vencimiento_tarjeta_falso, rut_falso, direccion_falso,
        correo_recuperacion_falso, numero_telefono_falso, clave_anterior_falso, created_by
    ) VALUES (
        p_simulacion_id, p_nombre, p_apellido, p_correo, p_clave,
        p_fecha_nac, p_genero, p_num_cuenta, p_cvc,
        p_fecha_venc, p_rut, p_direccion,
        p_correo_recup, p_telefono, p_clave_ant, p_created_by
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_datos_simulacion (
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_correo VARCHAR(255),
    IN p_updated_by INT
)
BEGIN
    UPDATE datos_simulaciones 
    SET nombre_falso = p_nombre,
        apellido_falso = p_apellido,
        correo_falso = p_correo,
        updated_by = p_updated_by
    WHERE id_datos = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_datos_simulacion (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE datos_simulaciones 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE id_datos = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_datos_simulacion (
    IN p_simulacion_id INT
)
BEGIN
    SELECT * FROM datos_simulaciones 
    WHERE simulacion_id = p_simulacion_id AND deleted = FALSE;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: opiniones_usuarios
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_insertar_opinion (
    IN p_usuario_id INT,
    IN p_simulacion_id INT,
    IN p_tipo_comentario_id INT,
    IN p_calificacion INT,
    IN p_comentario TEXT,
    IN p_es_anonima BOOLEAN,
    IN p_created_by INT
)
BEGIN
    INSERT INTO opiniones_usuarios (
        usuario_id, simulacion_id, tipo_comentario_id, calificacion, 
        comentario, es_anonima, created_by
    ) VALUES (
        p_usuario_id, p_simulacion_id, p_tipo_comentario_id, p_calificacion,
        p_comentario, p_es_anonima, p_created_by
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_opinion (
    IN p_id INT,
    IN p_calificacion INT,
    IN p_comentario TEXT,
    IN p_updated_by INT
)
BEGIN
    UPDATE opiniones_usuarios 
    SET calificacion = p_calificacion,
        comentario = p_comentario,
        updated_by = p_updated_by
    WHERE id_opinion = p_id AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_opinion (
    IN p_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE opiniones_usuarios 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE id_opinion = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_listar_opiniones_usuario (
    IN p_usuario_id INT
)
BEGIN
    SELECT o.id_opinion, o.calificacion, o.comentario, o.created_at,
           t.nombre_tipo_comentario, o.es_anonima
    FROM opiniones_usuarios o
    INNER JOIN tipos_comentarios t ON o.tipo_comentario_id = t.id_tipo_comentario
    WHERE o.usuario_id = p_usuario_id AND o.deleted = FALSE
    ORDER BY o.created_at DESC;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS PARA: estadisticas_usuarios
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_crear_estadistica_usuario (
    IN p_usuario_id INT,
    IN p_created_by INT
)
BEGIN
    INSERT INTO estadisticas_usuarios (usuario_id, created_by)
    VALUES (p_usuario_id, p_created_by);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_estadistica_usuario (
    IN p_usuario_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE estadisticas_usuarios e
    SET 
        total_simulaciones = (
            SELECT COUNT(*) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND deleted = FALSE
        ),
        simulaciones_completadas = (
            SELECT COUNT(*) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND estado_id = 2 AND deleted = FALSE
        ),
        duracion_promedio = (
            SELECT AVG(duracion_segundos) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND duracion_segundos IS NOT NULL AND deleted = FALSE
        ),
        puntaje_promedio = (
            SELECT AVG(puntaje) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND puntaje IS NOT NULL AND deleted = FALSE
        ),
        veces_enganado = (
            SELECT COUNT(*) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND fue_enganado = TRUE AND deleted = FALSE
        ),
        veces_detectado = (
            SELECT COUNT(*) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND fue_enganado = FALSE AND deleted = FALSE
        ),
        primera_simulacion = (
            SELECT MIN(fecha_inicio) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND deleted = FALSE
        ),
        ultima_simulacion = (
            SELECT MAX(fecha_inicio) FROM simulaciones 
            WHERE usuario_id = p_usuario_id AND deleted = FALSE
        ),
        updated_by = p_updated_by
    WHERE e.usuario_id = p_usuario_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_borrar_estadistica_usuario (
    IN p_usuario_id INT,
    IN p_updated_by INT
)
BEGIN
    UPDATE estadisticas_usuarios 
    SET deleted = TRUE, updated_by = p_updated_by
    WHERE usuario_id = p_usuario_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_obtener_estadistica_usuario (
    IN p_usuario_id INT
)
BEGIN
    SELECT * FROM estadisticas_usuarios 
    WHERE usuario_id = p_usuario_id AND deleted = FALSE;
END$$
DELIMITER ;

-- ==========================================================
-- PROCEDIMIENTOS ADICIONALES ÚTILES
-- ==========================================================

DELIMITER $$
CREATE PROCEDURE sp_login_usuario (
    IN p_correo VARCHAR(100)
)
BEGIN
    SELECT id_usuario, nombre_usuario, correo, contrasena, tipo_usuario_id, activo
    FROM usuarios 
    WHERE correo = p_correo AND activo = TRUE AND deleted = FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_actualizar_ultimo_ingreso (
    IN p_usuario_id INT
)
BEGIN
    UPDATE usuarios 
    SET ultimo_ingreso = CURRENT_TIMESTAMP
    WHERE id_usuario = p_usuario_id;
END$$
DELIMITER ;