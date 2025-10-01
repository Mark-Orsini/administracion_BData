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

CREATE TABLE tipo_comentario(
    id_tipo_comentario      INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo_comentario  VARCHAR(50) NOT NULL CHECK (nombre_tipo_comentario IN ('Ayuda','Opinion','Sugerencia','Problema')),
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
-- 3. SIMULACIÓN
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
        -- Datos del formulario de Registro
    nombre_falso VARCHAR(100),
    apellido_falso VARCHAR(100),
    correo_falso VARCHAR(255),
    clave_falso VARCHAR(255),
    fecha_nacimiento_falso DATE,
    genero_falso VARCHAR(20),
    numero_cuenta_falso VARCHAR(50),
    cvc_falso VARCHAR(5),
    fecha_vencimiento_tarjeta_falso VARCHAR(10),
    -- Datos del formulario de Recuperar Cuenta
    rut_falso VARCHAR(20),
    direccion_falso TEXT,
    correo_recuperacion_falso VARCHAR(255), 
    numero_telefono_falso VARCHAR(30),
    clave_anterior_falso VARCHAR(255),
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
    tipo_comentario_id   INT NOT NULL,
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
    CONSTRAINT fk_op_tipo     FOREIGN KEY (tipo_comentario_id)  REFERENCES tipo_comentario(id_tipo_comentario),
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
-- AÑADIR CLAVES FORÁNEAS DE AUDITORÍA (Para evitar referencias circulares)
-- ==========================================================
ALTER TABLE tipo_usuarios
    ADD CONSTRAINT fk_tipo_usu_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_tipo_usu_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE estados
    ADD CONSTRAINT fk_estado_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_estado_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE tipo_comentario
    ADD CONSTRAINT fk_tipo_com_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_tipo_com_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE usuarios
    ADD CONSTRAINT fk_usuario_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_usuario_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE simulaciones
    ADD CONSTRAINT fk_sim_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_sim_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE datos_simulacion
    ADD CONSTRAINT fk_datos_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_datos_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE opiniones_usuarios
    ADD CONSTRAINT fk_opinion_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_opinion_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;

ALTER TABLE estadisticas_usuario
    ADD CONSTRAINT fk_est_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    ADD CONSTRAINT fk_est_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario) ON DELETE SET NULL;


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

-- CORRECCIÓN: Se inserta en la tabla correcta con los nombres de columna correctos.
INSERT INTO tipo_comentario (nombre_tipo_comentario, descripcion_tipo) VALUES
('Ayuda',       'Solicitud de ayuda al usuario'),
('Opinion',     'Opinión general sobre el sistema'),
('Sugerencia',  'Sugerencia de mejora'),
('Problema',    'Reporte de error o problema');

-- Primer administrador
INSERT INTO usuarios (nombre_usuario, correo, contrasena, tipo_usuario_id) VALUES
('Admin', 'admin@ciberseguridad.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1);
