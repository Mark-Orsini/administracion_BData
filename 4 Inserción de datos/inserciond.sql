create DATABASE sistema_ventas4E;

USE sistema_ventas4E;

CREATE TABLE tipo_usuarios(
id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único
nombre_tipo VARCHAR(50) NOT NULL, -- Tipo de usuario (Admin, Cliente)
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT, -- Usuario que crea
updated_by INT, -- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

-- Tabla para usuarios
CREATE TABLE usuarios(
id_usuario INT AUTO_INCREMENT PRIMARY KEY, -- Id único
nombre VARCHAR(100) NOT NULL, -- Nombre de usuario
correo VARCHAR(100) UNIQUE, -- Correo electrónico único
tipo_usuario_id INT, -- Relación a tipo_usuario
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE productos (
id_productos INT AUTO_INCREMENT PRIMARY KEY, -- Id único
nombre_productos VARCHAR(100) NOT NULL, 
precio INT, 
stock INT DEFAULT 0, 
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE ventas(
id_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único
vendedor_id INT, 
fecha_venta DATETIME,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);

CREATE TABLE detalle_ventas (
id_detalle_ventas INT AUTO_INCREMENT PRIMARY KEY, -- Id único
venta_id INT NOT NULL, 
producto_id INT NOT NULL,
cantidad_vendida INT,
precio_unitario INT,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha creación
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Fecha modificación
created_by INT,-- Usuario que crea
updated_by INT,-- Usuario que modifica
deleted BOOLEAN DEFAULT FALSE -- Borrado lógico
);
ALTER TABLE detalle_ventas
MODIFY COLUMN precio_unitario float NOT null;

ALTER TABLE tipo_usuarios
ADD descripcion_tipo varchar(200) AFTER nombre_tipo;

-- RELACION ENTRETABLE USUARIO Y TIPO USUARIO 
ALTER TABLE usuarios -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_tipo_usuario
-- Añade referencia(FK)
FOREIGN KEY (tipo_usuario_id) REFERENCES
tipo_usuarios(id_tipo_usuario);

ALTER TABLE usuarios
CHANGE COLUMN nombre nombre_usuario varchar(100) not null;

ALTER TABLE usuarios
ADD passwordd varchar(45) AFTER nombre_usuario;

ALTER TABLE productos
MODIFY COLUMN precio float NOT null;

-- crear relacion entre usuario y venta --
ALTER TABLE ventas -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_ventas5
-- Añade referencia(FK)
FOREIGN KEY (id_ventas) REFERENCES
usuarios(id_usuario);

ALTER TABLE ventas
CHANGE COLUMN vendedor_id usuario_id varchar(100) not null;


-- RELACION ENTRE detalle Y VENTA 
ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_usuario_ventas
-- Añade referencia(FK)
FOREIGN KEY (venta_id) REFERENCES
ventas(id_ventas);

-- RELACION ENTRE PRODUCTO Y detalle 
ALTER TABLE detalle_ventas  -- Modificar tabla
-- Agregar una restricción (FK)
ADD CONSTRAINT fk_producto_ventas
-- Añade referencia(FK)
FOREIGN KEY (producto_id) REFERENCES
productos(id_productos);

-- no se pero es importante --
INSERT INTO ventas(usuario_id, fecha_venta, created_by, updated_by)
VALUES(1, NOW(), 1, 1);

-- Siguiente --
INSERT INTO usuarios (
    nombre_usuario, passwordd, correo, tipo_usuario_id, created_by, updated_by
)
VALUES (
    'sistema',
    '4x4=16$',
    'sistema@plataforma.cl',
    NULL,
    NULL,
    NULL
);
INSERT INTO tipo_usuarios (
    nombre_tipo,
    descripcion_tipo,
    created_by,
    updated_by
)
VALUES (
    'Administrador',
    'Accede a todas las funciones del sistema, incluida la administración de usuarios.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
);

-- Crear tipo de usuarios --
INSERT INTO tipo_usuarios (
    nombre_tipo,
    descripcion_tipo,
    created_by,
    updated_by
)
VALUES (
    'Vendedor',
    'Registra ventas, aplica descuentos, genera facturas o tickets.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'Cliente',
    'Puede ver productos, relizar pedidos, realizar pagos y ver su historial de compras.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
),
(
    'Gerente',
    'Accede a reportes de ventas, rendimiento de vendedores, gestión de inventario y autoriza descuentos o devoluciones.',
    1, -- creado por el usuario inicial
    1  -- actualizado por el mismo
);


-- Insertar un nuevo usuario real --
INSERT INTO usuarios (
    nombre_usuario, passwordd, correo, tipo_usuario_id, created_by, updated_by
)
VALUES (
    'Mark',
    'MK03', 
    'markorsini@liceovvh.cl',
    1,  -- tipo: Administrador
	1, 1  -- creado por el usuario "sistema"
),
(
    'Marcell',
    'porotoVerde17', 
    'marcellfigueroa@liceovvh.cl',
    1,  -- tipo: Administrador
	1, 1  -- creado por el usuario "sistema"
),
(
    'Benjamin',
    'wuatonTeton',
    'benjaminrios@liceovvh.cl',
    3,  -- tipo: Cliente
	1, 1  -- creado por el usuario "sistema"
),
(
    'Vicente',
    'brawlStar', -- bcrypt hasheado
    'manuelulloa@liceovvh.cl',
    4,  -- tipo: Gerente
	1, 1  -- creado por el usuario "sistema"
);

--  Muestra los usuarios activos --
SELECT nombre_usuario
FROM usuarios
WHERE deleted = 'False';

-- Muestra los usuarios cuyo tipo de usuario sea "Administrador" --
SELECT nombre_usuario
FROM usuarios
WHERE tipo_usuario_id = 1;

-- Lista los nombres de usuario que comienzan con "Cualquier letra" --
SELECT nombre_usuario
FROM usuarios
WHERE nombre_usuario LIKE 'M%';

--  Muestra los registros de personas creadas entre dos fechas específicas. --
SELECT nombre_usuario
FROM usuarios
WHERE date(created_at) BETWEEN '2025-05-26' AND '2025-05-28';

select * from usuarios;

-- mis consultas --
select *
from usuarios
where correo like 'm%';

select *  
from usuarios
where nombre_usuario <> 'Benjamin';

select nombre_usuario
from usuarios
where passwordd like 'P%' or 'M%';

select *
from usuarios
where tipo_usuario_id = '1';

select *
from usuarios
where id_usuario between 2 and 4;
