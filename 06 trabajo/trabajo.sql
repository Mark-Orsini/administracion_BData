-- Crear la base de datos LinguaMax
CREATE DATABASE LinguaMax;

-- Usar la base de datos LinguaMax
USE LinguaMax;

-- Tabla de Roles
-- Un rol define el tipo de usuario (Administrador, Profesor, Estudiante)
CREATE TABLE roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    rol VARCHAR(30) CHECK (rol IN ('Administrador', 'Profesor', 'Estudiante')) NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT, -- ID del usuario que creó el registro
    updated_by INT, -- ID del usuario que actualizó el registro por última vez
    deleted BOOLEAN DEFAULT FALSE -- Para soft-delete
);

-- Tabla de Usuarios
-- Contiene información general de todos los usuarios, incluyendo su rol.
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_rol INT NOT NULL, -- Clave foránea a la tabla roles
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%@%.%'), -- Correo electrónico único con formato válido
    contrasena VARCHAR(255) NOT NULL, -- Contraseña (se recomienda almacenar hashes, no texto plano)
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Matrículas
-- Representa una matrícula general de un usuario en el sistema (no necesariamente en un curso específico).
-- Define el tipo de matrícula (ej. 'oficial', 'libre') para un usuario.
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    tipo_matricula VARCHAR(30), -- Tipo de matrícula del usuario
    fecha_matricula DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Cursos
-- Información de los cursos ofrecidos, enlazando al profesor que lo imparte.
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    idioma VARCHAR(50) NOT NULL,
    nivel VARCHAR(10) CHECK (nivel IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')) NOT NULL, -- Nivel del curso según el Marco Común Europeo de Referencia para las Lenguas
    id_profesor INT NOT NULL, -- Clave foránea a la tabla usuarios (rol: Profesor)
    fecha_inicio DATETIME NOT NULL,
    sala VARCHAR(10) NOT NULL,
    cupo INT NOT NULL CHECK (cupo > 0), -- Asegura que el cupo sea un número positivo
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Registros de Asistencia
-- Registra la asistencia individual de un estudiante a una sesión específica de un curso.
CREATE TABLE registros_asistencia (
    id_registro_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL, -- El estudiante
    id_curso INT NOT NULL, -- El curso al que asiste
    fecha_sesion DATE NOT NULL, -- La fecha de la sesión
    asistencia tinyint NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_usuario, id_curso, fecha_sesion) -- Un estudiante solo tiene un registro de asistencia por curso y fecha de sesión
);

-- Tabla de Notas (Valores de Calificación)
-- Guarda los valores de las calificaciones y su estado general.
CREATE TABLE estado_calificacion (
    id_nota INT PRIMARY KEY AUTO_INCREMENT,
    estado_nota VARCHAR(30) CHECK (estado_nota IN ('Aprobado', 'Reprobado', 'Pendiente')) NOT NULL, -- Estado de la calificación
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Evaluaciones
-- Define las evaluaciones disponibles (tipo, fecha), sin calificaciones directas.
CREATE TABLE evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    nombre_evaluacion VARCHAR(100) NOT NULL, -- Nombre descriptivo de la evaluación (Ej: "Examen Final", "Tarea 1")
    tipo VARCHAR(20) CHECK (tipo IN ('trabajo', 'prueba', 'examen_oral', 'participacion')) NOT NULL, -- Tipos de evaluación
    fecha DATETIME NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Historiales Académicos
-- Registra anotaciones o eventos importantes en el historial académico de un usuario.
CREATE TABLE historiales_academicos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL, -- Enlaza directamente al usuario
    observaciones varchar(100),
    tipo_anotacion VARCHAR(20) CHECK (tipo_anotacion IN ('Positiva', 'Negativa', 'Advertencia', 'Reconocimiento')) NOT NULL, -- Tipo de anotación en el historial
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Unión: Cursos_Usuarios (Inscripciones de Cursos y Nota Final)
-- Relaciona usuarios con cursos y almacena la nota final de ese curso para ese usuario.
CREATE TABLE inscripcion_cursos (
    id_inscripcion_curso INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_curso INT NOT NULL,
    nota_final FLOAT CHECK (nota_final >= 0.0 AND nota_final <= 7.0), -- Nota final del estudiante en el curso (puede ser NULL si aún no se ha calificado)
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_usuario, id_curso) -- Asegura que un usuario solo se inscribe una vez en un curso
);

-- Tabla de Unión: Cursos_Evaluaciones
-- Relaciona qué evaluaciones están asociadas a qué curso.
CREATE TABLE cursos_evaluaciones (
    id_curso_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_curso INT NOT NULL,
    id_evaluacion INT NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_curso, id_evaluacion) -- Una evaluación solo puede estar asociada una vez por curso
);

-- Tabla de Unión: Calificaciones_Evaluaciones
-- Esta tabla enlaza a un estudiante (usuario) con una evaluación específica
-- y la nota obtenida por ese estudiante en esa evaluación.
CREATE TABLE calificaciones (
    id_calificacion_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_evaluacion INT NOT NULL, -- La evaluación realizada
    id_usuario INT NOT NULL,    -- El estudiante que realizó la evaluación
    id_nota INT NOT NULL,       -- La calificación obtenida (referencia a la tabla notas)
    calificacion FLOAT NOT NULL CHECK (calificacion >= 0.0 AND calificacion <= 7.0), -- Calificación en una escala de 0.0 a 7.0
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_evaluacion, id_usuario) -- Un estudiante solo tiene una nota por evaluación
);

CREATE TABLE tipo_matricula (
	id_tipo_matricula INT PRIMARY KEY AUTO_INCREMENT,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE tipo_anotacion (
	id_tipo_anotacion INT PRIMARY KEY AUTO_INCREMENT,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE estado_notas (
	id_estado_notas INT PRIMARY KEY AUTO_INCREMENT,
	create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- --- CONEXIONES (CLAVES FORÁNEAS) ---

-- Claves Foráneas para la tabla 'usuarios'
ALTER TABLE usuarios
ADD CONSTRAINT fk_rol_usuario
FOREIGN KEY (id_rol) REFERENCES roles(id_rol);

-- Claves Foráneas para la tabla 'matriculas'
ALTER TABLE matriculas
ADD CONSTRAINT fk_usuario_matricula
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

-- Claves Foráneas para la tabla 'cursos'
ALTER TABLE cursos
ADD CONSTRAINT fk_profesor_curso
FOREIGN KEY (id_profesor) REFERENCES usuarios(id_usuario); -- El profesor es un usuario

-- Claves Foráneas para la tabla 'registros_asistencia'
ALTER TABLE registros_asistencia
ADD CONSTRAINT fk_usuario_asistencia
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

ALTER TABLE registros_asistencia
ADD CONSTRAINT fk_curso_asistencia
FOREIGN KEY (id_curso) REFERENCES cursos(id_curso);

-- Claves Foráneas para la tabla 'historiales_academicos'
ALTER TABLE historiales_academicos
ADD CONSTRAINT fk_usuario_historial
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

-- Claves Foráneas para la tabla 'cursos_usuarios'
ALTER TABLE cursos_usuarios
ADD CONSTRAINT fk_usuario_curso_union
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

ALTER TABLE cursos_usuarios
ADD CONSTRAINT fk_curso_usuario_union
FOREIGN KEY (id_curso) REFERENCES cursos(id_curso);

-- Claves Foráneas para la tabla 'cursos_evaluaciones'
ALTER TABLE cursos_evaluaciones
ADD CONSTRAINT fk_curso_evaluacion_union
FOREIGN KEY (id_curso) REFERENCES cursos(id_curso);

ALTER TABLE cursos_evaluaciones
ADD CONSTRAINT fk_evaluacion_curso_union
FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion);

-- Claves Foráneas para la tabla 'calificaciones_evaluaciones'
ALTER TABLE calificaciones_evaluaciones
ADD CONSTRAINT fk_evaluacion_calificacion
FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion);

ALTER TABLE calificaciones_evaluaciones
ADD CONSTRAINT fk_usuario_calificacion
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

ALTER TABLE calificaciones_evaluaciones
ADD CONSTRAINT fk_nota_calificacion
FOREIGN KEY (id_nota) REFERENCES notas(id_nota);