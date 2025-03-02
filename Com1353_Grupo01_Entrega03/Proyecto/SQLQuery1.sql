-- 1. SCRIPT DE CREACION - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
--En este Script se incluiran todos los Store Procedures, Triggers y Tablas que deben crearse para la ultilizacion posterior

--Crea la Base de datos
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Com1353G01')
	BEGIN
		CREATE DATABASE Com1353G01;
		PRINT 'Base de datos creada exitosamente';
	END;
go
USE Com1353G01
go
--Crear el Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ddbba')
	BEGIN
		EXEC('CREATE SCHEMA ddbba');
		PRINT ' Schema creado exitosamente';
	END;
go

--Creacion e las tablas 
--TABLA SUCURSAL
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Sucursal') AND type = N'U') -- 'U' tabla creada por el usuario 'N' es q sea unicode
	BEGIN
		CREATE TABLE ddbba.Sucursal (
			id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
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
--TABLA EMPLEADO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Empleado') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Empleado (
			id_empleado INT PRIMARY KEY,
			nombre VARCHAR(100),
			apellido VARCHAR(100),
			dni INT,
			direccion VARCHAR(255),
			cuil VARCHAR(200),
			email_personal VARCHAR(255),
			email_empresarial VARCHAR(255),
			turno VARCHAR(50),
			cargo VARCHAR(50),
			id_sucursal INT,
			CONSTRAINT FKEmpleado FOREIGN KEY (id_sucursal) REFERENCES ddbba.Sucursal(id_sucursal), 
		);
		PRINT 'Tabla Empelado creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Empleado ya existe.';
	END;
go
--TABLA PROVEEDOR
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Proveedor') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba .Proveedor (
			id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
			nombre NVARCHAR(255)
		);
		PRINT 'Tabla Proveedor creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Proveedor ya existe.';
	END;
go
--TABLA PRODUCTO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Producto') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Producto (
			id_producto INT IDENTITY(1,1) PRIMARY KEY,
			nombre_producto VARCHAR(100), --marca
			linea VARCHAR(50),
			precio_unitario DECIMAL(10, 2),
			precio_referencia  decimal (10,2),
			unidad varchar(10), --kg, ml, dolar
			cantidadPorUnidad NVARCHAR(50),
			moneda VARCHAR(7),
			fecha datetime,
		);
		PRINT 'Tabla Producto creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Producto ya existe.';
	END;
go
--TABLA PROVEEDOR_PROVEE
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Proveedor_provee') AND type = N'U')
	BEGIN 
		CREATE TABLE ddbba.Proveedor_provee(
			id_proveedor INT,
			id_producto INT,
			CONSTRAINT PKProvee PRIMARY KEY (id_proveedor, id_producto),
			CONSTRAINT FKProvee1 FOREIGN KEY (id_proveedor) REFERENCES ddbba.Proveedor(id_proveedor),
			CONSTRAINT FKProvee2 FOREIGN KEY (id_producto) REFERENCES ddbba.Producto(id_producto)
		);
		PRINT 'Tabla Proveedor_provee creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Proveedor_provee ya existe.';
	END;
go
--TABLA CLIENTE
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Cliente') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Cliente (
			id_cliente INT PRIMARY KEY,
			genero VARCHAR(10),
			tipo VARCHAR(10),
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
--TABLA MEDIO DE PAGO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.MedioPago') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.MedioPago (
			id_mp INT IDENTITY (1,1) PRIMARY KEY,
			tipo VARCHAR(50)
		);
		PRINT 'Tabla MedioPago creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla MedioPago ya existe.';
	END;
go
--TABLA PEDIDO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Pedido') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Pedido (
			id_factura CHAR(12)  CHECK (id_factura LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]') PRIMARY KEY,
			fecha_pedido DATE,
			hora_pedido TIME,
			id_cliente INT ,
			id_mp INT,
			iden_pago VARCHAR(50),
			id_empleado INT,
			id_sucursal INT,
            tipo_factura CHAR(1) CHECK (tipo_factura IN ('A', 'B', 'C')),
			fecha_factura DATE,
			estado_factura VARCHAR(10) CHECK (estado_factura IN ('Pagada', 'NoPagada')),
			CONSTRAINT FKPedido1 FOREIGN KEY (id_cliente) REFERENCES ddbba.Cliente(id_cliente),
			CONSTRAINT FKPedido2 FOREIGN KEY (id_mp) REFERENCES ddbba.MedioPago (id_mp),
			CONSTRAINT FKPedido3 FOREIGN KEY (id_empleado) REFERENCES ddbba.Empleado (id_empleado),
			CONSTRAINT FKPedido4 FOREIGN KEY (id_sucursal) REFERENCES ddbba.Sucursal (id_sucursal)
		); 
		PRINT 'Tabla Pedido creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Pedido ya existe.';
	END;
go

--TABLA Productos_Solicitados
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Productos_Solicitados') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Productos_Solicitados (
			id_factura char(12),
			id_producto INT ,
			cantidad INT,
			CONSTRAINT PKTiene PRIMARY KEY (id_producto, id_factura),
			CONSTRAINT FKTiene1 FOREIGN KEY (id_producto) REFERENCES ddbba.Producto(id_producto),
			CONSTRAINT FKTiene2 FOREIGN KEY (id_factura) REFERENCES ddbba.Pedido(id_factura)
		);
		PRINT 'Tabla Productos_Solicitados creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Productos_Solicitados ya existe.';
	END;
go

-- TABLA NOTA CREDITO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ddbba.NotaCredito') AND type = N'U')
BEGIN
    CREATE TABLE ddbba.NotaCredito (
        id_nota_credito INT IDENTITY(1,1)PRIMARY KEY,
		fecha_emision DATETIME ,
		id_cliente INT,
		id_factura CHAR(12),
		nombre_producto VARCHAR(100),
	    precio_unitario DECIMAL(10,2),
		cantidad INT,
		monto DECIMAL (10,2),
	    CONSTRAINT FKNotaCredito2 FOREIGN KEY (id_factura) REFERENCES ddbba.Pedido(id_factura),
	    CONSTRAINT FKNotaCredito3 FOREIGN KEY (id_cliente) REFERENCES ddbba.Cliente(id_cliente)
    );
    PRINT 'Tabla NotaCredito creada correctamente.';
END;
GO

---------------------------------------------SP--------------------------------------------------------------------
--creacion de los Store Procedure que validan la insercion de los datos a las tablas anteriores

--Crear el Schema nuevo para unicamente los SP
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Procedimientos')
	BEGIN
		EXEC('CREATE SCHEMA Procedimientos');
		PRINT ' Schema Procedimientos creado exitosamente';
	END;
go




