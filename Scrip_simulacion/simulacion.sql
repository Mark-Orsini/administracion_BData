-- ==========================================================
-- SISTEMA DE EDUCACIÓN EN CIBERSEGURIDAD – SCRIPT MÍNIMO
-- Tablas ELIMINADAS: niveles_dificultad, tipo_simulaciones
-- ==========================================================

CREATE DATABASE IF NOT EXISTS ciberseguridad_educacion;
USE ciberseguridad_educacion;

-- ==========================================================
-- 1. CATÁLOGOS BÁSICOS
-- ==========================================================

CREATE TABLE tipo_usuarios(
    id_tipo_usuario      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_usuario  VARCHAR(50) NOT NULL CHECK (nombre_tipo_usuario IN ('Administrador','Usuario')),
    descripcion_tipo     VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(descripcion_tipo) >= 3),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE
);

CREATE TABLE estados(
    id_estado        INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado    VARCHAR(20) NOT NULL UNIQUE,
    descripcion_estado VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(descripcion_estado) >= 5),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE
);

CREATE TABLE tipo_opiniones(
    id_tipo_opinion      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_opinion  VARCHAR(50) NOT NULL CHECK (nombre_tipo_opinion IN ('Simulacion','Sistema General','Sugerencia','Problema')),
    descripcion_tipo     VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(descripcion_tipo) >= 3),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE
);

-- ==========================================================
-- 2. USUARIOS
-- ==========================================================

CREATE TABLE usuarios(
    id_usuario      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario  VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre_usuario) >= 3 AND nombre_usuario REGEXP '^[A-Za-zÀ-ÿ ]+$'),
    correo          VARCHAR(100) NOT NULL UNIQUE CHECK (correo LIKE '%@%.%'),
    contrasena      VARCHAR(255) NOT NULL,
    tipo_usuario_id INT NOT NULL,
    activo          BOOLEAN DEFAULT TRUE,
    ultimo_ingreso  DATETIME NULL,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_usuario_tipo FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuarios(id_tipo_usuario)
);

-- ==========================================================
-- 3. SIMULACIÓN (sin tipo, sin nivel)
-- ==========================================================

CREATE TABLE simulaciones(
    id_simulacion    INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id       INT NOT NULL,
    estado_id        INT NOT NULL DEFAULT 1,
    fecha_inicio     DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin        DATETIME NULL,
    duracion_segundos INT NULL,
    puntaje          DECIMAL(5,2) NULL CHECK (puntaje BETWEEN 0 AND 100),
    fue_enganado     BOOLEAN NULL,
    ip_usuario       VARCHAR(45),
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_sim_usuario  FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_sim_estado   FOREIGN KEY (estado_id)  REFERENCES estados(id_estado)
);

-- ==========================================================
-- 4. DATOS FALSOS CAPTURADOS
-- ==========================================================

CREATE TABLE datos_simulacion(
    id_datos          INT AUTO_INCREMENT PRIMARY KEY,
    simulacion_id     INT NOT NULL,
    telefono_falso    VARCHAR(20),
    correo_falso      VARCHAR(150) CHECK (correo_falso LIKE '%@%.%'),
    usuario_falso     VARCHAR(50),
    contrasena_falsa  VARCHAR(255),
    tipo_dato         VARCHAR(30) DEFAULT 'Login' CHECK (tipo_dato IN ('Login','Personal','Financiero','Otro')),
    datos_adicionales TEXT,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_datos_sim FOREIGN KEY (simulacion_id) REFERENCES simulaciones(id_simulacion)
);

-- ==========================================================
-- 5. OPINIONES
-- ==========================================================

CREATE TABLE opiniones_usuarios(
    id_opinion        INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id        INT NOT NULL,
    simulacion_id     INT NULL,
    tipo_opinion_id   INT NOT NULL,
    calificacion      INT CHECK (calificacion BETWEEN 1 AND 5),
    comentario        TEXT CHECK (CHAR_LENGTH(comentario) >= 5),
    es_anonima        BOOLEAN DEFAULT FALSE,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_op_usuario  FOREIGN KEY (usuario_id)       REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_op_tipo     FOREIGN KEY (tipo_opinion_id)  REFERENCES tipo_opiniones(id_tipo_opinion),
    CONSTRAINT fk_op_sim      FOREIGN KEY (simulacion_id)    REFERENCES simulaciones(id_simulacion)
);

-- ==========================================================
-- 6. ESTADÍSTICAS (RESUMEN POR USUARIO)
-- ==========================================================

CREATE TABLE estadisticas_usuario(
    id_estadistica          INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id              INT NOT NULL UNIQUE,
    total_simulaciones      INT DEFAULT 0 CHECK (total_simulaciones >= 0),
    simulaciones_completadas INT DEFAULT 0 CHECK (simulaciones_completadas >= 0),
    duracion_promedio       DECIMAL(8,2) DEFAULT 0 CHECK (duracion_promedio >= 0),
    puntaje_promedio        DECIMAL(5,2) DEFAULT 0 CHECK (puntaje_promedio BETWEEN 0 AND 100),
    veces_enganado          INT DEFAULT 0 CHECK (veces_enganado >= 0),
    veces_detectado         INT DEFAULT 0 CHECK (veces_detectado >= 0),
    primera_simulacion      DATETIME NULL,
    ultima_simulacion       DATETIME NULL,
    /* auditoría */
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by  INT,
    updated_by  INT,
    deleted     BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_est_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);

-- ==========================================================
-- 7. LOGS DE AUDITORÍA (OPCIONAL – PUEDE BORRARSE)
-- ==========================================================

CREATE TABLE logs_sistema(
    id_log     INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    accion     VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(accion) >= 3),
    descripcion TEXT,
    ip_direccion VARCHAR(45),
    nivel_log  VARCHAR(20) DEFAULT 'INFO' CHECK (nivel_log IN ('INFO','WARNING','ERROR','CRITICAL')),
    /* auditoría */
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    deleted    BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_log_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);

-- ==========================================================
-- DATOS INICIALES MÍNIMOS
-- ==========================================================

INSERT INTO tipo_usuarios (nombre_tipo_usuario, descripcion_tipo, created_by) VALUES
('Administrador', 'Acceso total', 1),
('Usuario',       'Realiza simulaciones', 1);

INSERT INTO estados (nombre_estado, descripcion_estado, created_by) VALUES
('En Progreso', 'Simulación en curso', 1),
('Completada',  'Simulación finalizada', 1),
('Abandonada',  'No completada', 1);

INSERT INTO tipo_opiniones (nombre_tipo_opinion, descripcion_tipo, created_by) VALUES
('Simulacion',     'Opinión sobre una simulación', 1),
('Sistema General','Opinión general', 1),
('Sugerencia',     'Sugerencia de mejora', 1),
('Problema',       'Reporte de error', 1);

-- Primer administrador
INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id, created_by) VALUES
('Admin', 'admin@ciberseguridad.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1);

-- ==========================================================
-- PROCEDIMIENTO: ACTUALIZAR ESTADÍSTICAS
-- ==========================================================

DELIMITER //
CREATE PROCEDURE actualizar_estadisticas_usuario(IN p_usuario_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT IGNORE INTO estadisticas_usuario (usuario_id, created_by)
    VALUES (p_usuario_id, p_usuario_id);

    UPDATE estadisticas_usuario e
    JOIN (
        SELECT
            COUNT(*)                                            AS total_simulaciones,
            SUM(estado_id = 2)                                  AS simulaciones_completadas,
            COALESCE(AVG(duracion_segundos),0)                  AS duracion_promedio,
            COALESCE(AVG(puntaje),0)                            AS puntaje_promedio,
            SUM(fue_enganado = 1)                               AS veces_enganado,
            SUM(fue_enganado = 0)                               AS veces_detectado,
            MIN(fecha_inicio)                                   AS primera_simulacion,
            MAX(fecha_inicio)                                   AS ultima_simulacion
        FROM simulaciones
        WHERE usuario_id = p_usuario_id AND deleted = FALSE
    ) x ON e.usuario_id = p_usuario_id
    SET
        e.total_simulaciones      = x.total_simulaciones,
        e.simulaciones_completadas= x.simulaciones_completadas,
        e.duracion_promedio       = x.duracion_promedio,
        e.puntaje_promedio        = x.puntaje_promedio,
        e.veces_enganado          = x.veces_enganado,
        e.veces_detectado         = x.veces_detectado,
        e.primera_simulacion      = x.primera_simulacion,
        e.ultima_simulacion       = x.ultima_simulacion,
        e.updated_by              = p_usuario_id;

    COMMIT;
END//
DELIMITER ;

-- ==========================================================
-- TRIGGER: AUTO-ESTADÍSTICAS AL COMPLETAR
-- ==========================================================

DELIMITER //
CREATE TRIGGER trg_after_sim_completa
AFTER UPDATE ON simulaciones
FOR EACH ROW
BEGIN
    IF NEW.estado_id = 2 AND OLD.estado_id <> 2 THEN
        CALL actualizar_estadisticas_usuario(NEW.usuario_id);
    END IF;
END//
DELIMITER ;

-- ==========================================================
-- VISTAS MÍNIMAS
-- ==========================================================

CREATE OR REPLACE VIEW vista_usuarios_estadisticas AS
SELECT u.id_usuario,
        u.nombre_usuario,
        u.correo,
        tu.nombre_tipo_usuario,
        u.activo,
        u.ultimo_ingreso,
        u.created_at                                       AS fecha_registro,
        COALESCE(e.total_simulaciones,0)                   AS total_simulaciones,
        COALESCE(e.simulaciones_completadas,0)             AS simulaciones_completadas,
        COALESCE(e.puntaje_promedio,0)                     AS puntaje_promedio,
        COALESCE(e.veces_enganado,0)                       AS veces_enganado,
        COALESCE(e.veces_detectado,0)                      AS veces_detectado
FROM usuarios u
LEFT JOIN tipo_usuarios tu ON u.tipo_usuario_id = tu.id_tipo_usuario
LEFT JOIN estadisticas_usuario e ON u.id_usuario = e.usuario_id
WHERE u.deleted = FALSE;

SELECT 'BD mínima funcional lista' AS mensaje;