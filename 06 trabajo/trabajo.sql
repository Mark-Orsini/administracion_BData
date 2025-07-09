-- Se elimina la base de datos si existe para empezar desde cero.
DROP DATABASE IF EXISTS LinguaMax;

-- Crear la base de datos LinguaMax
CREATE DATABASE LinguaMax;

-- Usar la base de datos LinguaMax
USE LinguaMax;

-- --- TABLAS DE CATÁLOGO Y TIPOS ---
-- Estas tablas almacenan valores fijos para ser usados en otras tablas.

-- Tabla de Roles
-- Define los tipos de usuario en el sistema (Administrador, Profesor, Estudiante).
CREATE TABLE roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    rol VARCHAR(30) UNIQUE NOT NULL CHECK (rol IN ('Administrador', 'Profesor', 'Estudiante')),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL, -- Se permite NULL si el creador no es un usuario registrado o se desconoce.
    updated_by INT NULL, -- Se permite NULL si el actualizador no es un usuario registrado o se desconoce.
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Tipos de Matrícula
-- Define si una matrícula es 'Oficial', 'Libre', etc.
CREATE TABLE tipos_matricula (
    id_tipo_matricula INT PRIMARY KEY AUTO_INCREMENT,
    tipo_matricula VARCHAR(50) UNIQUE NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Tipos de Anotación
-- Define los tipos de anotaciones para el historial académico (ej. 'Advertencia', 'Reconocimiento').
CREATE TABLE tipos_anotacion (
    id_tipo_anotacion INT PRIMARY KEY AUTO_INCREMENT,
    tipo_anotacion VARCHAR(50) UNIQUE NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Estados de Calificación
-- Define si una calificación está 'Aprobada', 'Reprobada' o 'Pendiente'.
CREATE TABLE estados_calificacion (
    id_estado_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(30) UNIQUE NOT NULL CHECK (estado IN ('Aprobado', 'Reprobado', 'Pendiente')),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE
);


-- --- TABLAS PRINCIPALES ---

-- Tabla de Personas
-- Contiene la información personal básica de individuos (nombre, apellido, RUT, teléfono).
-- Esta tabla se crea antes que 'usuarios' porque 'usuarios' la referencia.
CREATE TABLE personas (
    id_persona INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rut VARCHAR(11) UNIQUE NOT NULL, -- RUT debe ser único
    telefono VARCHAR(20) NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Usuarios
-- Contiene la información de autenticación y rol de todos los usuarios del sistema.
-- Referencia a la tabla 'roles' y 'personas'.
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_rol INT NOT NULL,
    id_persona INT UNIQUE NOT NULL, -- Un usuario está asociado a una única persona
    username VARCHAR(50) UNIQUE NOT NULL, -- El nombre de usuario debe ser único
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%@%.%'),
    contrasena VARCHAR(255) NOT NULL, -- Se recomienda almacenar un hash de la contraseña.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol),
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
    -- Las FK para created_by y updated_by se añadirán después de crear la tabla 'usuarios'
    -- para evitar referencias circulares durante la definición inicial.
);

-- Añadir claves foráneas para created_by y updated_by en la tabla 'personas'
ALTER TABLE personas
ADD CONSTRAINT fk_personas_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
ADD CONSTRAINT fk_personas_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario);

-- Añadir claves foráneas para created_by y updated_by en la tabla 'roles'
ALTER TABLE roles
ADD CONSTRAINT fk_roles_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
ADD CONSTRAINT fk_roles_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario);

-- Añadir claves foráneas para created_by y updated_by en la tabla 'tipos_matricula'
ALTER TABLE tipos_matricula
ADD CONSTRAINT fk_tiposmatricula_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
ADD CONSTRAINT fk_tiposmatricula_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario);

-- Añadir claves foráneas para created_by y updated_by en la tabla 'tipos_anotacion'
ALTER TABLE tipos_anotacion
ADD CONSTRAINT fk_tiposanotacion_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
ADD CONSTRAINT fk_tiposanotacion_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario);

-- Añadir claves foráneas para created_by y updated_by en la tabla 'estados_calificacion'
ALTER TABLE estados_calificacion
ADD CONSTRAINT fk_estadoscalificacion_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
ADD CONSTRAINT fk_estadoscalificacion_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario);

-- Añadir claves foráneas para created_by y updated_by en la tabla 'usuarios' (auto-referencia)
ALTER TABLE usuarios
ADD CONSTRAINT fk_usuarios_created_by FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
ADD CONSTRAINT fk_usuarios_updated_by FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario);


-- Tabla de Cursos
-- Contiene la información de los cursos ofrecidos, incluyendo el profesor asignado.
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    idioma VARCHAR(50) NOT NULL,
    nivel VARCHAR(10) NOT NULL CHECK (nivel IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
    id_profesor INT NOT NULL, -- Clave foránea al usuario que es profesor
    fecha_inicio DATETIME NOT NULL,
    sala VARCHAR(10) NOT NULL,
    cupo INT NOT NULL CHECK (cupo > 0),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_profesor) REFERENCES usuarios(id_usuario) -- Se asume que la lógica de negocio valida que el usuario sea profesor.
);

-- Tabla de Matrículas
-- Registra la matrícula general de un usuario en el sistema, asociada a un tipo de matrícula.
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_tipo_matricula INT NOT NULL, -- Clave foránea a la tabla tipos_matricula.
    fecha_matricula DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tipo_matricula) REFERENCES tipos_matricula(id_tipo_matricula)
);

-- Tabla de Evaluaciones
-- Define los tipos de evaluaciones que pueden existir en el sistema (trabajo, prueba, examen, etc.).
CREATE TABLE evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    nombre_evaluacion VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('trabajo', 'prueba', 'examen_oral', 'participacion')),
    fecha DATETIME NOT NULL, -- Fecha en que la evaluación está programada o fue realizada.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Historiales Académicos
-- Registra eventos o anotaciones importantes para un usuario (estudiante o profesor).
CREATE TABLE historiales_academicos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_tipo_anotacion INT NOT NULL, -- Clave foránea a la tabla tipos_anotacion.
    observaciones VARCHAR(255),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tipo_anotacion) REFERENCES tipos_anotacion(id_tipo_anotacion)
);


-- --- TABLAS DE UNIÓN (RELACIONES MUCHOS A MUCHOS) ---

-- Tabla de Inscripciones a Cursos
-- Relaciona a los usuarios (estudiantes) con los cursos en los que se inscriben.
-- Un estudiante puede inscribirse en múltiples cursos, y un curso puede tener múltiples estudiantes.
CREATE TABLE inscripciones_cursos (
    id_inscripcion_curso INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL, -- El estudiante
    id_curso INT NOT NULL,
    nota_final FLOAT CHECK (nota_final >= 1.0 AND nota_final <= 7.0), -- Rango de notas común en Chile.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_usuario, id_curso), -- Un usuario solo puede inscribirse una vez en el mismo curso.
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

-- Tabla de Registros de Asistencia
-- Registra la asistencia de un estudiante a una sesión específica de un curso.
-- Se vincula a la inscripción específica del estudiante en el curso.
CREATE TABLE registros_asistencia (
    id_registro_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion_curso INT NOT NULL, -- Se vincula a la inscripción específica del estudiante en el curso.
    fecha_sesion DATE NOT NULL,
    asistio BOOLEAN NOT NULL, -- TRUE si asistió, FALSE si no.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_inscripcion_curso, fecha_sesion), -- Un estudiante solo tiene un registro por sesión para un curso.
    FOREIGN KEY (id_inscripcion_curso) REFERENCES inscripciones_cursos(id_inscripcion_curso)
);

-- Tabla de Cursos_Evaluaciones
-- Asocia las evaluaciones que pertenecen a cada curso.
-- Un curso puede tener múltiples evaluaciones, y una evaluación puede aplicarse a múltiples cursos.
CREATE TABLE cursos_evaluaciones (
    id_curso_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_curso INT NOT NULL,
    id_evaluacion INT NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_curso, id_evaluacion), -- Una evaluación solo se asocia una vez a un curso específico.
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion)
);

-- Tabla de Calificaciones
-- Almacena la nota que un estudiante obtiene en una evaluación específica de un curso.
-- Se vincula a la inscripción del estudiante y a la evaluación específica del curso.
CREATE TABLE calificaciones (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion_curso INT NOT NULL, -- El estudiante inscrito en el curso.
    id_curso_evaluacion INT NOT NULL, -- La evaluación asociada a ese curso.
    id_estado_calificacion INT NOT NULL, -- El estado de la nota (Aprobado, Reprobado, Pendiente).
    calificacion FLOAT NOT NULL CHECK (calificacion >= 1.0 AND calificacion <= 7.0),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_by INT NULL,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_inscripcion_curso, id_curso_evaluacion), -- Un estudiante solo tiene una calificación por evaluación de un curso.
    FOREIGN KEY (id_inscripcion_curso) REFERENCES inscripciones_cursos(id_inscripcion_curso),
    FOREIGN KEY (id_curso_evaluacion) REFERENCES cursos_evaluaciones(id_curso_evaluacion),
    FOREIGN KEY (id_estado_calificacion) REFERENCES estados_calificacion(id_estado_calificacion)
);
