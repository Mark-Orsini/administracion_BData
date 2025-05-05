create database sistema_ventas_4E;

use sistema_ventas_4E;

create table tipo_usuarios (
id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY,
nombre_tipo VARCHAR(50) NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

create table usuarios (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre_tipo VARCHAR(100) NOT NULL,
correo VARCHAR(100) UNIQUE,
tipo_usuario_id INT,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

alter table usuarios ADD CONSTRAINT fk_usuario_tipo_usuario FOREIGN KEY (tipo_usuario_id) REFERENCES
tipo_usuarios(id_tipo_usuario);

create table Tabla_productos (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre varchar(40) not null,
precio float not null,
stock int default 0 not null,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

create table tabla_ventas (
id INT AUTO_INCREMENT PRIMARY KEY,
usuario_id int,
Fecha datetime,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);

create table Tabla_detalle_ventas (
id INT AUTO_INCREMENT PRIMARY KEY,
venta_id int,
producto_id int,
cantidad int,
precio_unitario float,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
created_by INT,
updated_by INT,
deleted BOOLEAN DEFAULT FALSE
);