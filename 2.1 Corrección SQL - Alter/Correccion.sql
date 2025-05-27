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
nombre_tipo VARCHAR(100) NOT NULL, -- Nombre de usuario
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
vendedor_id INT NOT NULL, 
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
CHANGE COLUMN nombre_tipo nombre_usuario varchar(100) not null;

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