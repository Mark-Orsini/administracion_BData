create database ejemplo_check;

use ejemplo_check;

create table tipo_usuarios (
	id_tipo int primary key auto_increment,
    nombre_tipo varchar(50) not null,
    check (nombre_tipo in ('Estudiante','Profesor','Administrador')),
    nivel_acceso tinyint check (nivel_acceso between 1 and 3),
    descripcion_tipo varchar(300) not null,
    create_at datetime default current_timestamp,
    update_at datetime default current_timestamp on update current_timestamp,
    create_by int,
    updated_by int,
    deleted boolean default false
);

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL CHECK (CHAR_LENGTH(nombre) >= 3 AND nombre REGEXP '^[A-Za-z ]+$'),
    passsword varchar(30) not null,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%@%.%'),
    fecha_registro DATE DEFAULT (current_date),
    activo BOOLEAN DEFAULT TRUE,
    edad TINYINT CHECK (edad BETWEEN 13 AND 100),
    id_tipo INT,
    FOREIGN KEY (id_tipo) REFERENCES tipo_usuarios(id_tipo)
);

CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL CHECK (CHAR_LENGTH(titulo) BETWEEN 5 AND 200),
    duracion_horas DECIMAL(4,2) CHECK (duracion_horas > 0 AND duracion_horas <= 100),
    nivel VARCHAR(20) CHECK (nivel IN ('Principiante', 'Intermedio', 'Avanzado')),
    precio DECIMAL(10,2) CHECK (precio >= 0),
    fecha_publicacion DATE CHECK (fecha_publicacion >= '2020-01-01'),
    CHECK (
        (nivel = 'Principiante' AND precio <= 50) OR
        (nivel IN ('Intermedio', 'Avanzado') AND precio <= 200)
	)
);

create table inscripciones (
	id_inscripcion int unique not null auto_increment key,
    id_curso int not null,
    id_usuario int not null,
    fecha_inscripcion datetime default current_timestamp,
    create_at datetime default current_timestamp,
    update_at datetime default current_timestamp on update current_timestamp,
    create_by int,
    updated_by int,
    deleted boolean default false
);

alter table inscripciones
add constraint fk_cursos_inscripciones
foreign key (id_curso) references cursos(id_curso);

alter table inscripciones
add constraint fk_usuarios_inscripciones
foreign key (id_usuario) references usuarios(id_usuario);