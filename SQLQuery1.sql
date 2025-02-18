-- coemntario - fecha de entrega - número de comisión, número de grupo, nombre de la materia, nombres y DNI de los alumnos.
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Com1353G01')
	BEGIN
		CREATE DATABASE Com1353G01;
		PRINT 'Base de datos creada exitosamente';
	END;
go
USE Com1353G01
go
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ddbba')
	BEGIN
		EXEC('CREATE SCHEMA ddbba');
		PRINT ' Schema creado exitosamente';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Sucursal') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Sucursal (
			id_sucursal INT PRIMARY KEY,
			localidad VARCHAR(100),
			direccion VARCHAR(255),
			horario VARCHAR(50),
			telefono VARCHAR(20)
		);
		PRINT 'Tabla Sucursal creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Sucursal ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Empleado') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Empleado (
			id_empleado INT PRIMARY KEY,
			fecha_alta DATE,
			cuil VARCHAR(11),
			domicilio VARCHAR(255),
			apellido VARCHAR(100),
			nombre VARCHAR(100),
			email_personal VARCHAR(255),
			email_empresarial VARCHAR(255),
			telefono VARCHAR(20),
			dni VARCHAR(20),
			turno VARCHAR(50),
			cargo VARCHAR(50),
			id_sucursal INT,
			CONSTRAINT FKEmpleado FOREIGN KEY (id_sucursal) REFERENCES ddbba.Sucursal(id_sucursal)
		);
		PRINT 'Tabla Empelado creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Empleado ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Proveedor') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba .Proveedor (
			id_proveedor INT PRIMARY KEY,
			nombre VARCHAR(255)
		);
		PRINT 'Tabla Proveedor creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Proveedor ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Producto') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Producto (
			id_producto INT PRIMARY KEY,
			precio_unitario DECIMAL(10, 2),
			linea VARCHAR(100),
			descripcion VARCHAR(255)
		);
		PRINT 'Tabla Producto creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Producto ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Provee') AND type = N'U')
	BEGIN 
		CREATE TABLE ddbba.Provee (
			id_proveedor INT,
			id_producto INT,
			CONSTRAINT PKProvee PRIMARY KEY (id_proveedor, id_producto),
			CONSTRAINT FKProvee1 FOREIGN KEY (id_proveedor) REFERENCES ddbba.Proveedor(id_proveedor),
			CONSTRAINT FKProvee2 FOREIGN KEY (id_producto) REFERENCES ddbba.Producto(id_producto)
		);
		PRINT 'Tabla Provee creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Provee ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Cliente') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Cliente (
			id_cliente INT PRIMARY KEY,
			genero VARCHAR(10),
			tipo VARCHAR(50),
			apellido VARCHAR(100),
			nombre VARCHAR(100),
			fecha_nac DATE
		);
		PRINT 'Tabla Cliente creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Cliente ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.MedioPago') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.MedioPago (
			id_mp INT PRIMARY KEY,
			tipo VARCHAR(50)
		);
		PRINT 'Tabla MedioPago creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla MedioPago ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Pedido') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Pedido (
			id_pedido INT PRIMARY KEY, 
			fecha_pedido DATE,
			hora_pedido DATETIME,
			id_cliente INT,
			id_mp INT,
			id_empleado INT,
			iden_pago VARCHAR(30), 
			CONSTRAINT FKCliente FOREIGN KEY (id_cliente) REFERENCES ddbba.Cliente(id_cliente),
			CONSTRAINT FKPedido1 FOREIGN KEY (id_mp) REFERENCES ddbba.MedioPago (id_mp),
			CONSTRAINT FKPedido2 FOREIGN KEY (id_empleado) REFERENCES ddbba.Empleado (id_empleado)
		); 
		PRINT 'Tabla Pedido creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Pedido ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Tiene') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Tiene (
			id_producto INT,
			id_pedido INT,
			cantidad INT,
			CONSTRAINT PKTiene PRIMARY KEY (id_producto, id_pedido),
			CONSTRAINT FKTiene1 FOREIGN KEY (id_producto) REFERENCES ddbba.Producto(id_producto),
			CONSTRAINT FKTiene2 FOREIGN KEY (id_pedido) REFERENCES ddbba.Pedido(id_pedido)
		);
		PRINT 'Tabla Tiene creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Tiene ya existe.';
	END;
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Factura') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Factura (
			id_factura VARCHAR(15),
			tipo_factura CHAR(3),
			id_pedido INT,
			fecha DATE,
			CONSTRAINT PKFactura PRIMARY KEY (id_factura, id_pedido),
			CONSTRAINT FKFactura FOREIGN KEY (id_pedido) REFERENCES ddbba.Pedido(id_pedido),
		);
		PRINT 'Tabla Factura creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Fcatura ya existe.';
	END;

