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

-- SP PARA CLIENTE


CREATE PROCEDURE ddbba.insertarCliente
    @id int,
    @gen VARCHAR(50),
    @tipo VARCHAR(50),
	@ap VARCHAR(50),
	@nom VARCHAR(50),
	@fnac DATE 
AS
BEGIN

IF @id <= 0
PRINT 'Error. Inserte un Id de Cliente mayor a 0';
RETURN;

IF @gen != 'MALE' AND @gen != 'FEMALE'
BEGIN 
	PRINT 'Error. Genero incorrecto.'
	RETURN;
END

IF @tipo !='Member' AND @tipo != 'Normal'
BEGIN	
	PRINT 'Error. Tipo de Cliente incorrecto.'
	RETURN;
END

END 
    INSERT INTO Cliente
    VALUES (@id,@gen,@tipo,@ap,@nom,@fnac);
   
   PRINT 'Cliente insertado correctamente';
END;



-- SP PARA TABLA PEDIDO

CREATE PROCEDURE ddbba.InsertarPedido (
    @id_pedido INT,
    @fecha_pedido DATE,
    @hora_pedido DATETIME,
    @id_cliente INT,
    @id_mp INT,
    @id_empleado INT,
    @iden_pago VARCHAR(30))
AS
BEGIN
    IF @id_pedido <= 0
    BEGIN
        PRINT 'Error: id_pedido debe ser mayor a 0';
        RETURN;
    END
    
    --IF @fecha_pedido < DATEADD(YEAR, -1, GETDATE())
    --BEGIN
        --PRINT 'Error: fecha_pedido no puede ser menor a un año';
        --RETURN;
    --END
    
    IF @id_cliente <= 0 OR @id_mp <= 0 OR @id_empleado <= 0
    BEGIN
        PRINT 'Error: id_cliente, id_mp e id_empleado deben ser mayores a 0';
        RETURN;
    END
    
    IF LEN(@iden_pago) = 0 OR LEN(@iden_pago) > 30
    BEGIN
        PRINT 'Error: El iden_pago debe tener entre 1 y 30 caracteres.';
        RETURN;
    END
    
    INSERT INTO ddbba.Pedido (id_pedido, fecha_pedido, hora_pedido, id_cliente, id_mp, id_empleado, iden_pago)
    VALUES (@id_pedido, @fecha_pedido, @hora_pedido, @id_cliente, @id_mp, @id_empleado, @iden_pago);

END;

--SP PARA FACTURA

CREATE PROCEDURE ddbba.insertarFactura(
		@id_factura VARCHAR(15),
		@tipo_factura CHAR(3),
		@id_pedido INT,
		@fecha DATE)
AS
BEGIN	
		IF LEN(@id_factura) <= 0
	BEGIN
		PRINT 'Error: La cantidad de caracteres de id_factura debe ser mayor a 0';
		RETURN;
	END

		IF LEN(@tipo_factura) != 1 
	BEGIN
		PRINT 'Error: tipo_factura debe ser 1 solo caracter.';
		RETURN;
	END
	
		IF id_pedido <= 0
	BEGIN	
		PRINT 'Error: id_pedido debe ser mayor que 0.';
		RETURN;
	END
	INSERT INTO Factura VALUES (@id_factura,@tipo_factura,@id_pedido,@fecha);
	PRINT 'Factura ingresada correctamente.';
END


--SP PARA MEDIO DE PAGO

CREATE PROCEDURE ddbba.insertarMedioPago(
		@id_mp INT,
		@tipo VARCHAR(50))
AS
BEGIN
	IF @id_mp <= 0
	BEGIN
		PRINT 'id_mp debe ser mayor que 0.';
		RETURN;
	END
		IF LEN(@tipo)<=0 OR LEN(@tipo)>50
	BEGIN
		PRINT 'tipo debe tener entre 1 y 50 caracteres.';
		RETURN;
	END
	INSERT INTO MedioPago VALUES (@id_mp,@tipo);
	PRINT 'Medio de Pago ingresado correctamente.';
END

<<<<<<< HEAD
DROP PROCEDURE ddbba.insertarMedioPago

SELECT name
FROM sys.procedures 

=======
--SP PARA PROVEEDOR
CREATE PROCEDURE InsertarProveedor
    @id_proveedor INT,
    @nombre VARCHAR(255)
AS
BEGIN
    -- Manejo de errores
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar que el nombre no sea nulo ni vacío
        IF (@nombre IS NULL OR LTRIM(RTRIM(@nombre)) = '')
        BEGIN
            PRINT 'El nombre del proveedor no puede ser nulo o vacío.'
            ROLLBACK TRANSACTION; -- Revierte cambios
            RETURN; -- Detiene la ejecucion
        END

        -- Validar que el id_proveedor no exista ya en la tabla
        IF EXISTS (SELECT 1 FROM Com1353G01.ddbba.Proveedor WHERE id_proveedor = @id_proveedor)
        BEGIN
            PRINT 'El id_proveedor ya existe en la tabla Proveedor.'
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar los datos en la tabla
        INSERT INTO Com1353G01.ddbba.Proveedor (id_proveedor, nombre)
        VALUES (@id_proveedor, @nombre);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Proveedor insertado correctamente.';
    END TRY
    BEGIN CATCH
        -- Manejar cualquier error que ocurra
        ROLLBACK TRANSACTION;
        PRINT 'Ocurrió un error al intentar insertar el proveedor.';
        THROW;
    END CATCH
END;
GO

--SP PARA PRODUCTO
CREATE PROCEDURE InsertarProducto
	@id_producto INT,
	@precio_unitario DECIMAL(10,2),
	@linea VARCHAR(100),
	@descripcion VARCHAR(255)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		IF EXISTS(SELECT 1 FROM Com1353G01.ddbba.Producto WHERE id_producto= @id_producto)
		BEGIN
			PRINT 'El codigo del producto ya existe en la tabla'
			ROLLBACK TRANSACTION
			RETURN
		END

		IF (@id_producto <= 0)
		BEGIN
			PRINT 'El codigo del producto debe ser mayor a cero'
			ROLLBACK TRANSACTION
			RETURN
		END

		IF (@precio_unitario <= 0)
		BEGIN
			PRINT 'El precio del producto debe ser mayor a cero'
			ROLLBACK TRANSACTION
			RETURN
		END

		IF (@linea IS NULL OR LTRIM(RTRIM(@linea)) = '')
		BEGIN
			PRINT 'La linea del producto no debe ser nula'
			ROLLBACK TRANSACTION
			RETURN
		END

		IF (@descripcion IS NULL OR LTRIM(RTRIM(@descripcion)) = '')
		BEGIN
			PRINT 'La descripcion del producto no debe ser nula'
			ROLLBACK TRANSACTION
			RETURN
		END

		 -- Insertar los datos en la tabla
        INSERT INTO Com1353G01.ddbba.Producto(id_producto, precio_unitario, linea, descripcion)
        VALUES (@id_producto, @precio_unitario, @linea, @descripcion );

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Producto insertado correctamente.';

	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
        PRINT 'Ocurrió un error al intentar insertar el producto.';
        THROW;
	END CATCH
END;
GO

--..
