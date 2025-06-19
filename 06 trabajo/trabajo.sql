create database LinguaMax;
use LinguaMax;

create table roles (
id_rol int primary key auto_increment,
rol VARCHAR(30) check (rol IN ('Administrador', 'Profesor', 'Estudiante')),
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table usuarios (
id_usuario int primary key auto_increment,
id_rol int not null,
id_matricula int not null,
id_historial int not null,
id_nota int not null,
nombre varchar(50) not null ,
apellido varchar(50) not null,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table cursos_usuarios (
id_curso_usuario int primary key auto_increment,
id_usuario int not null,
id_curso int not null,
nota_final float,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table cursos (
id_curso int primary key auto_increment,
idioma varchar(50) not null,
nivel varchar(10) check (nivel IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
profesor varchar(50) not null,
fecha datetime not null ,
sala varchar(10) not null,
cupo int not null,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table matriculas (
id_matricula int primary key auto_increment,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table notas (
id_nota int primary key auto_increment,
calificacion float not null,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table cursos_evaluaciones (
id_cursos_evaluaciones int primary key auto_increment,
id_curso int not null,
id_evaluacion int not null,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table evaluaciones (
id_evaluacion int primary key auto_increment,
id_nota int not null,
tipo varchar(10)  check (tipo IN ('trabajo', 'prueba')),
fecha datetime not null,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

create table historiales_academicos (
id_historial int primary key auto_increment,
id_nota int not null,
create_at datetime default current_timestamp,
update_at datetime default current_timestamp on update current_timestamp,
created_by int,
updated_by int,
deleted boolean default false
);

alter table usuarios
add constraint fk_usuario
foreign key (id_rol) references roles(id_rol);

alter table usuarios
add constraint fk_matricula
foreign key (id_matricula) references matriculas(id_matricula);

alter table cursos_usuarios
add constraint fk_usuario2
foreign key (id_usuario) references usuarios(id_usuario);

alter table cursos_usuarios
add constraint fk_curso3
foreign key (id_curso) references cursos(id_curso);

alter table usuarios
add constraint fk_historial2
foreign key (id_historial) references historiales_academicos(id_historial);

alter table cursos_evaluaciones
add constraint fk_curso4
foreign key (id_curso) references cursos(id_curso);

alter table cursos_evaluaciones
add constraint fk_evaluacion2
foreign key (id_evaluacion) references evaluaciones(id_evaluacion);

alter table usuarios
add constraint fk_nota
foreign key (id_nota) references notas(id_nota);

alter table evaluaciones
add constraint fk_nota2
foreign key (id_nota) references notas(id_nota);