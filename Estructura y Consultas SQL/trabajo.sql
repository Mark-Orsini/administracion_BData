CREATE DATABASE ejemploSelect;
USE ejemploSelect;

-- Tabla: tipo_usuarios
CREATE TABLE tipo_usuarios (
    id_tipo INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    nombre_tipo VARCHAR(50) NOT NULL
    CHECK (nombre_tipo IN ('Administrador', 'Cliente', 'Moderador')),
    descripcion_tipo VARCHAR(200) NOT NULL,
    
    -- Campos de auditoría

	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- Tabla: usuarios (se añade campo created_at con valor por defecto)
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE 
    CHECK (CHAR_LENGTH(username) >= 3 AND username REGEXP '^[A-Za-z ]+$'),
    password VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_tipo_usuario INT,
    CONSTRAINT fk_usuarios_tipo_usuarios FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuarios(id_tipo),
    
    -- Campos de auditoría

	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- Tabla: ciudad (nueva)
CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL
    CHECK (CHAR_LENGTH(nombre_ciudad) >= 3 AND nombre_ciudad REGEXP '^[A-Za-z ]+$'),
    region VARCHAR(100)
    CHECK (CHAR_LENGTH(region) >= 3 AND region REGEXP '^[A-Za-z ]+$'),
    
    -- Campos de auditoría

	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- Tabla: personas (relacionada con usuarios y ciudad)
CREATE TABLE personas (
    rut VARCHAR(13) NOT NULL UNIQUE,
    nombre_completo VARCHAR(100) NOT NULL
    CHECK (CHAR_LENGTH(nombre_completo) >= 3 AND nombre_completo REGEXP '^[A-Za-z ]+$'),
    fecha_nac DATE,
    id_usuario INT,
    id_ciudad INT,
    CONSTRAINT fk_personas_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_personas_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad),
    -- Campos de auditoría

	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
	created_by INT, -- Usuario que crea
	updated_by INT, -- Usuario que modifica
	deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
    
);

-- Poblar tabla tipo_usuarios
INSERT INTO tipo_usuarios (nombre_tipo, descripcion_tipo) VALUES
('Administrador', 'Acceso completo al sistema'),
('Cliente', 'Usuario con acceso restringido'),
('Moderador', 'Puede revisar y aprobar contenido');

-- Poblar tabla usuarios
INSERT INTO usuarios (username, password, email, id_tipo_usuario) VALUES
('admin', 'pass1234', 'admin01@mail.com', 1),
('jvaldes', 'abc123', 'jvaldes@mail.com', 2),
('cmorales', '123456', 'cmorales@mail.com', 3),
('anavarro', 'pass4321', 'anavarro@mail.com', 2),
('rquezada', 'clave2023', 'rquezada@mail.com', 1),
('pgodoy', 'segura123', 'pgodoy@mail.com', 2),
('mdiaz', 'token456', 'mdiaz@mail.com', 3),
('scarvajal', 'azul789', 'scarvajal@mail.com', 2),
('ltapia', 'ltapia123', 'ltapia@mail.com', 3),
('afarias', 'afpass', 'afarias@mail.com', 2);

-- Poblar tabla ciudad
INSERT INTO ciudad (nombre_ciudad, region) VALUES
('Santiago', 'Region Metropolitana'),
('Valparaiso', 'Region de Valparaiso'),
('Concepcion', 'Region del Biobio'),
('La Serena', 'Region de Coquimbo'),
('Puerto Montt', 'Region de Los Lagos');

-- Poblar tabla personas (relacionadas con usuarios y ciudades)
INSERT INTO personas (rut, nombre_completo, fecha_nac, id_usuario, id_ciudad) VALUES
('11.111.111-1', 'Juan Valdes', '1990-04-12', 2, 1),
('22.222.222-2', 'Camila Morales', '1985-09-25', 3, 2),
('33.333.333-3', 'Andrea Navarro', '1992-11-03', 4, 3),
('44.444.444-4', 'Rodrigo Quezada', '1980-06-17', 5, 1),
('55.555.555-5', 'Patricio Godoy', '1998-12-01', 6, 4),
('66.666.666-6', 'Maria Diaz', '1987-07-14', 7, 5),
('77.777.777-7', 'Sebastian Carvajal', '1993-03-22', 8, 2),
('88.888.888-8', 'Lorena Tapia', '2000-10-10', 9, 3),
('99.999.999-9', 'Ana Fariuas', '1995-01-28', 10, 4),
('10.101.010-0', 'Carlos Soto', '1991-08-08', 1, 1); -- admin01

-- 1.- Complementar el Script SQL Base:
-- A partir del script adjunto, debes completar la estructura de la base de datos incorporando los siguientes elementos en cada tabla:
SELECT

    u.username,
    u.email,
    tu.nombre_tipo
FROM
    usuarios AS u
JOIN
    tipo_usuarios AS tu ON u.id_tipo_usuario = tu.id_tipo
WHERE
    tu.nombre_tipo = 'Cliente';

-- 2.- Mostrar Personas nacidas despues del año 1990
-- Seleccionar Nombre, fecha de nacimiento y username.
SELECT
    p.nombre_completo,
    p.fecha_nac,
    u.username
FROM
    personas AS p
JOIN
    usuarios AS u ON p.id_usuario = u.id_usuario
WHERE
    YEAR(p.fecha_nac) > 1990;

-- 3.- Seleccionar nombres de personas que comiencen con la
-- letra A - Seleccionar nombre y correo la persona.
SELECT
    p.nombre_completo,
    u.email
FROM
    personas AS p
JOIN
    usuarios AS u ON p.id_usuario = u.id_usuario
WHERE
    p.nombre_completo LIKE 'A%';

-- 4.- Mostrar usuarios cuyos dominios de correo sean mail.com
SELECT
    username,
    email
FROM
    usuarios
WHERE
    email LIKE '%@mail.com';

-- 5.- Mostrar todas las personas que no viven en
-- Valparaíso y su usuario + ciudad.
SELECT
    p.nombre_completo,
    u.username,
    c.nombre_ciudad
FROM
    personas AS p
JOIN
    usuarios AS u ON p.id_usuario = u.id_usuario
JOIN
    ciudad AS c ON p.id_ciudad = c.id_ciudad
WHERE
    c.nombre_ciudad <> 'Valparaíso';

-- 6.- Mostrar usuarios que contengan más de 7
-- carácteres de longitud.
SELECT
    username
FROM
    usuarios
WHERE
    LENGTH(username) > 7;

-- 7.- Mostrar username de personas nacidas entre
-- 1990 y 1995
SELECT
    u.username,
    p.nombre_completo,
    p.fecha_nac
FROM
    personas AS p
JOIN
    usuarios AS u ON p.id_usuario = u.id_usuario
WHERE
    YEAR(p.fecha_nac) BETWEEN 1990 AND 1995;