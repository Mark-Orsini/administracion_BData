CREATE USER 'app_ciberseg'@'localhost' IDENTIFIED BY 'Abuelita123';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON ciberseguridad_educacion.* TO 'app_ciberseg'@'localhost';
FLUSH PRIVILEGES;