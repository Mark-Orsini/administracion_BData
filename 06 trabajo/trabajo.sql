-- Se elimina la base de datos si existe para empezar desde cero.
DROP DATABASE IF EXISTS LinguaMax;

-- Crear la base de datos LinguaMax
CREATE DATABASE LinguaMax;

-- Usar la base de datos LinguaMax
USE LinguaMax;

-- --- TABLAS DE CATÁLOGO Y TIPOS ---
-- Estas tablas almacenan valores fijos para ser usados en otras tablas.

-- Tabla de Roles
-- Define los tipos de usuario en el sistema.
CREATE TABLE roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    rol VARCHAR(30) UNIQUE NOT NULL CHECK (rol IN ('Administrador', 'Profesor', 'Estudiante')),
	create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Tipos de Matrícula
-- Define si una matrícula es 'Oficial', 'Libre', etc.
CREATE TABLE tipos_matricula (
    id_tipo_matricula INT PRIMARY KEY AUTO_INCREMENT,
    tipo_matricula VARCHAR(50) UNIQUE NOT NULL,
	create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Tipos de Anotación
-- Define los tipos de anotaciones para el historial académico.
CREATE TABLE tipos_anotacion (
    id_tipo_anotacion INT PRIMARY KEY AUTO_INCREMENT,
    tipo_anotacion VARCHAR(50) UNIQUE NOT NULL,
	create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Estados de Calificación
-- Define si una calificación está 'Aprobada', 'Reprobada' o 'Pendiente'.
CREATE TABLE estados_calificacion (
    id_estado_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(30) UNIQUE NOT NULL CHECK (estado IN ('Aprobado', 'Reprobado', 'Pendiente')),
	create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);


-- --- TABLAS PRINCIPALES ---

-- Tabla de Usuarios
-- Contiene la información general de todos los usuarios.
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_rol INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%@%.%'),
    contrasena VARCHAR(255) NOT NULL, -- Se recomienda almacenar un hash de la contraseña.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
    -- Se podría añadir una FK para created_by y updated_by si se requiere trazabilidad.
    -- FOREIGN KEY (created_by) REFERENCES usuarios(id_usuario),
    -- FOREIGN KEY (updated_by) REFERENCES usuarios(id_usuario)
);

-- Tabla de Cursos
-- Contiene la información de los cursos ofrecidos.
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    idioma VARCHAR(50) NOT NULL,
    nivel VARCHAR(10) NOT NULL CHECK (nivel IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
    id_profesor INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    sala VARCHAR(10) NOT NULL,
    cupo INT NOT NULL CHECK (cupo > 0),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_profesor) REFERENCES usuarios(id_usuario) -- Se asume que la lógica de negocio valida que el usuario sea profesor.
);

-- Tabla de Matrículas
-- Asocia un usuario con un tipo de matrícula general en el sistema.
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_tipo_matricula INT NOT NULL, -- Clave foránea a la tabla tipos_matricula.
    fecha_matricula DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tipo_matricula) REFERENCES tipos_matricula(id_tipo_matricula)
);

-- Tabla de Evaluaciones
-- Define las evaluaciones que pueden existir en el sistema.
CREATE TABLE evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    nombre_evaluacion VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('trabajo', 'prueba', 'examen_oral', 'participacion')),
    fecha DATETIME NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE
);

-- Tabla de Historiales Académicos
-- Registra eventos o anotaciones importantes para un usuario.
CREATE TABLE historiales_academicos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_tipo_anotacion INT NOT NULL, -- Clave foránea a la tabla tipos_anotacion.
    observaciones VARCHAR(255),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_tipo_anotacion) REFERENCES tipos_anotacion(id_tipo_anotacion)
);


-- --- TABLAS DE UNIÓN (RELACIONES MUCHOS A MUCHOS) ---

-- Tabla de Inscripciones a Cursos
-- Relaciona a los usuarios (estudiantes) con los cursos en los que se inscriben.
CREATE TABLE inscripciones_cursos (
    id_inscripcion_curso INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_curso INT NOT NULL,
    nota_final FLOAT CHECK (nota_final >= 1.0 AND nota_final <= 7.0), -- Rango de notas común en Chile.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_usuario, id_curso), -- Un usuario solo puede inscribirse una vez en el mismo curso.
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

-- Tabla de Registros de Asistencia
-- Registra la asistencia de un estudiante a una sesión de un curso.
CREATE TABLE registros_asistencia (
    id_registro_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion_curso INT NOT NULL, -- Se vincula a la inscripción específica.
    fecha_sesion DATE NOT NULL,
    asistio BOOLEAN NOT NULL, -- Más claro que un tinyint.
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_inscripcion_curso, fecha_sesion), -- Un estudiante solo tiene un registro por sesión.
    FOREIGN KEY (id_inscripcion_curso) REFERENCES inscripciones_cursos(id_inscripcion_curso)
);

-- Tabla de Cursos_Evaluaciones
-- Asocia las evaluaciones que pertenecen a cada curso.
CREATE TABLE cursos_evaluaciones (
    id_curso_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_curso INT NOT NULL,
    id_evaluacion INT NOT NULL,
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_curso, id_evaluacion), -- Una evaluación solo se asocia una vez a un curso.
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_evaluacion) REFERENCES evaluaciones(id_evaluacion)
);

-- Tabla de Calificaciones
-- Almacena la nota que un estudiante obtiene en una evaluación específica.
CREATE TABLE calificaciones (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion_curso INT NOT NULL, -- El estudiante inscrito en el curso.
    id_curso_evaluacion INT NOT NULL, -- La evaluación asociada a ese curso.
    id_estado_calificacion INT NOT NULL, -- El estado de la nota (Aprobado, Reprobado, etc.).
    calificacion FLOAT NOT NULL CHECK (calificacion >= 1.0 AND calificacion <= 7.0),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    deleted BOOLEAN DEFAULT FALSE,
    UNIQUE (id_inscripcion_curso, id_curso_evaluacion), -- Un estudiante solo tiene una calificación por evaluación de un curso.
    FOREIGN KEY (id_inscripcion_curso) REFERENCES inscripciones_cursos(id_inscripcion_curso),
    FOREIGN KEY (id_curso_evaluacion) REFERENCES cursos_evaluaciones(id_curso_evaluacion),
    FOREIGN KEY (id_estado_calificacion) REFERENCES estados_calificacion(id_estado_calificacion)
);
