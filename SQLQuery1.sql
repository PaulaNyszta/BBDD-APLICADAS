-- Script de creacion - fecha de entrega - Com 1353 - Grupo 01 - Base de Datos Aplicadas, nombres y DNI de los alumnos.
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
 --CREACION DE TABLAS-----------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Sucursal') AND type = N'U') -- 'U' tabla creada por el usuario 'N' es q sea unicode
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
			cuil VARCHAR(15),
			domicilio VARCHAR(255),
			apellido VARCHAR(100),
			nombre VARCHAR(100),
			email_personal VARCHAR(255),
			email_empresarial VARCHAR(255),
			turno VARCHAR(50),
			cargo VARCHAR(50),
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
			id_pedido INT  PRIMARY KEY, 
			fecha_pedido DATE,
			hora_pedido DATETIME,
			id_cliente INT,
			id_mp INT,
			iden_pago VARCHAR(30), 
			CONSTRAINT FKCliente FOREIGN KEY (id_cliente) REFERENCES ddbba.Cliente(id_cliente),
			CONSTRAINT FKPedido1 FOREIGN KEY (id_mp) REFERENCES ddbba.MedioPago (id_mp),
		); 
		PRINT 'Tabla Pedido creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Pedido ya existe.';
	END;
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Venta') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Venta (
			id_pedido INT, 
			id_sucursal INT,
			id_empleado INT,
			CONSTRAINT PKVenta PRIMARY KEY (id_sucursal, id_pedido),
			CONSTRAINT FKVenta1 FOREIGN KEY (id_sucursal) REFERENCES ddbba.Sucursal (id_sucursal),
			CONSTRAINT FKVenta2 FOREIGN KEY (id_pedido) REFERENCES ddbba.Pedido (id_pedido),
			CONSTRAINT FKVenta3 FOREIGN KEY (id_empleado) REFERENCES ddbba.Empleado (id_empleado),
		); 
		PRINT 'Tabla Venta creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla Venta ya existe.';
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
			id_factura VARCHAR(15) CHECK (id_factura LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'),
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
		PRINT 'La tabla Factura ya existe.';
	END;
go

---------------------------------------------SP---------------------------------------------------
-- SP PARA CLIENTE
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarCliente')
BEGIN
	DROP PROCEDURE ddbba.insertarCliente ;
END;
go
CREATE PROCEDURE ddbba.insertarCliente
	@id_cliente int,
	@genero VARCHAR(50),
	@tipo VARCHAR(50),
	@apellido VARCHAR(50),
	@nombre VARCHAR(50),
	@fnac DATE 
AS
BEGIN

	-- Validación de id del cliente sea un numero positivo 
	IF (@id_cliente <= 0)
	BEGIN
		PRINT 'Error. Inserte un Id de Cliente mayor a 0';
		RETURN;
	END;
	-- Validación de id del cliente sea un numero unico 
	IF EXISTS (SELECT 1 FROM ddbba.Cliente WHERE id_cliente = @id_cliente) 
	BEGIN
		PRINT'El Id del cliente ya existe';
		RETURN;
	END;
	-- Validación del que el genero sea female o male
	IF (@genero NOT IN ('Female', 'Male'))
	BEGIN
		PRINT 'Error. El género debe ser "Female" o "Male".';
		RETURN;
	END;
	-- Validación del que el tipo de cliente sea Normal o Member
	IF (@tipo NOT IN ('Normal', 'Member'))
	BEGIN
		PRINT 'Error. El tipo de cliente debe ser "Normal" o "Member".';
		RETURN
	END;
	-- Validación de que la fecha de nacimiento no sea futura
	IF (@fnac > GETDATE())
	BEGIN
		PRINT 'La fecha de alta no puede ser futura';
		RETURN;
	END;
    
	INSERT INTO ddbba.Cliente (id_cliente, genero, tipo, apellido,nombre,fecha_nac)
	VALUES (@id_cliente,@genero,@tipo,@apellido,@nombre,@fnac);
	PRINT 'Cliente insertado correctamente';
END;
go

-- SP PARA EMPLEADO
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarEmpleado')
BEGIN
	DROP PROCEDURE ddbba.insertarEmpleado ;
END;
go
CREATE PROCEDURE ddbba.insertarEmpleado
	@id_empleado INT,
	@fecha_alta DATE,
	@cuil VARCHAR(15),
	@domicilio VARCHAR(255),
	@apellido VARCHAR(100),
	@nombre VARCHAR(100),
	@email_personal VARCHAR(255),
	@email_empresarial VARCHAR(255),
	@turno VARCHAR(50),
	@cargo VARCHAR(50)
AS
BEGIN

	-- Validación de id del empleado sea unico
	IF EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = @id_empleado)
	BEGIN
		PRINT 'Error. Id ya existente';
		RETURN;
	END;
	-- Validación de id del empleado tenga 6 caracteres
	IF LEN(@id_empleado) < 6
	BEGIN
		PRINT 'Error. Inserte un Id de Empleado con al menos 6 caracteres';
		RETURN;
	END;
	-- Validación de que la fecha de alta no sea futura
	IF (@fecha_alta > GETDATE())
	BEGIN
		PRINT 'La fecha de alta no puede ser futura';
		RETURN;
	END;
	-- Validación de que el cuil tenga forma XX-XXXXXXXX-X
	 IF @cuil NOT LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    BEGIN
        PRINT 'Error: El número de CUIL debe tener forma XX-XXXXXXXX-X';
        RETURN;
    END;
	-- Validación de que el turno sea TM, TT o jornada completa
	IF @turno NOT IN ('TT','TM','Jornada completa')
	BEGIN
		PRINT'El turno debe ser TT, TM, o Jornada completa';
		RETURN;
	END;
    
	INSERT INTO ddbba.Empleado (id_empleado,fecha_alta,cuil,domicilio,apellido,nombre,email_personal, email_empresarial,turno,cargo)
	VALUES (@id_empleado,@fecha_alta,@cuil,@domicilio,@apellido,@nombre,@email_personal,@email_empresarial,@turno,@cargo);
	PRINT 'Empleado insertado correctamente';
END;
go
-- SP PARA  PEDIDO
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarPedido')
BEGIN
	DROP PROCEDURE ddbba.insertarPedido ;
END;
go
CREATE PROCEDURE ddbba.InsertarPedido (
    @id_pedido INT,
    @fecha_pedido DATE,
    @hora_pedido DATETIME,
    @id_cliente INT,
    @id_mp INT,
    @iden_pago VARCHAR(30))
AS
BEGIN
	-- Validación de id del pedido sea un numero positivo 
	IF (@id_pedido <= 0)
	BEGIN
		PRINT 'Error. Inserte un Id de pedido mayor a 0';
		RETURN;
	END;
	-- Validación de id del pedido sea un numero unico 
	IF EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_pedido = @id_pedido) 
	BEGIN
		PRINT'El Id del pedido ya existe';
	END;    
    --validadcion de la fecha del pedido no sea futura
    IF (@fecha_pedido > GETDATE())
    BEGIN
        PRINT 'Error: fecha del pedido no puede ser futura';
        RETURN;
    END;
	 --validadcion de que el identificador de pago tenga entre 1 y 30 caracteres
    IF (LEN(@iden_pago) = 0 OR LEN(@iden_pago) > 30)
    BEGIN
        PRINT 'Error: El iden_pago debe tener entre 1 y 30 caracteres.';
        RETURN;
    END;
    
    INSERT INTO ddbba.Pedido (id_pedido, fecha_pedido, hora_pedido, id_cliente, id_mp, iden_pago)
    VALUES (@id_pedido, @fecha_pedido, @hora_pedido, @id_cliente, @id_mp, @iden_pago);
END;
go

--SP PARA FACTURA
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarFactura')
BEGIN
	DROP PROCEDURE ddbba.insertarFactura ;
END;
go
CREATE PROCEDURE ddbba.insertarFactura
		@id_factura VARCHAR(15),
		@tipo_factura CHAR(3),
		@id_pedido INT,
		@fecha DATE
AS
BEGIN	
		-- Validación de id de la factura cumpla con la forma XXX-XX-XXXX
		IF (@id_factura  NOT LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]')
		BEGIN
			PRINT 'Error. La el id de la factura no cumple con la forma XXX-XX-XXXX';
			RETURN;
		END;
		-- Validación de id de la factura sea un numero unico 
		IF EXISTS (SELECT 1 FROM ddbba.Factura WHERE id_factura = @id_factura) 
		BEGIN
			PRINT'El Id de la Factura ya existe';
		END;    
		--verificacion de que el tipo de factura se A, B o C
		IF (@tipo_factura NOT IN ('A','B','C'))
			BEGIN
				PRINT 'Error: tipo_factura debe ser A, B o C.';
				RETURN;
			END;
		--validadcion de que el id pedido exista
		IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_pedido = @id_pedido)
		BEGIN
			PRINT 'Error: no existe el pedido';
			RETURN;
		END;	
		--validadcion de que la fecha no sea futura
		IF @fecha > GETDATE()
		BEGIN
			PRINT 'Error: la fecha no puede ser futura';
			RETURN;
		END;	
	
	INSERT INTO Factura VALUES (@id_factura,@tipo_factura,@id_pedido,@fecha);
	PRINT 'Factura ingresada correctamente.';
END;
go

--SP PARA MEDIO DE PAGO
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarMedioPago')
BEGIN
	DROP PROCEDURE ddbba.insertarMedioPago ;
END;
go
CREATE PROCEDURE ddbba.insertarMedioPago
		@id_mp INT,
		@tipo VARCHAR(50)
AS
BEGIN
	--validar que el id de medio de pago sea positivo
	IF @id_mp <= 0
	BEGIN
		PRINT 'id_mp debe ser mayor que 0.';
		RETURN;
	END;
	--validar que el id de medio de pago no exisya
	IF  EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE id_mp = @id_mp)
	BEGIN
		PRINT 'id_mp ya existe';
		RETURN;
	END;
	--validar que el tipo tenga entre 1 y 50 caracteres
	IF LEN(@tipo)<=0 OR LEN(@tipo)>50
	BEGIN
		PRINT 'tipo debe tener entre 1 y 50 caracteres.';
		RETURN;
	END;
	INSERT INTO MedioPago VALUES (@id_mp,@tipo);
	PRINT 'Medio de Pago ingresado correctamente.';

END;
go
--SP PARA SUCURSAL
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarSucursal')
BEGIN
	DROP PROCEDURE ddbba.insertarSucursal ;
END;
go
CREATE PROCEDURE ddbba.insertarSucursal 
    @id_sucursal INT,
	@localidad VARCHAR(100),
	@direccion VARCHAR(255),
	@horario VARCHAR(50),
	@telefono VARCHAR(20)
AS
BEGIN

	-- Validación de id_sucursal sea un numero unico 
	IF EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE id_sucursal = @id_sucursal) 
	BEGIN
		PRINT 'id sucursal ya existente';
        RETURN;
    END
    --validacion de que la localidad se Ramos Mejia, Lomas del Mirador o San Justo
	IF (@localidad NOT IN ('Ramos Mejia','Lomas del Mirador','San Justo'))
	BEGIN
		PRINT 'la localidad debe ser Ramos Mejia,Lomas del Mirador o San Justo';
		RETURN;
	END;
	--validar que el telefono tenga 9 caracteres
	IF LEN(@telefono)!=9 
	BEGIN
		PRINT 'el telefono debe tener entre 9 caracteres.';
		RETURN;
	END;
    
    INSERT INTO ddbba.Sucursal (id_sucursal,localidad,direccion,horario,telefono)
    VALUES (@id_sucursal,@localidad,@direccion,@horario,@telefono);
    
    PRINT 'Sucursal insertada correctamente';
END;
go
--SP PARA PROVEEDOR
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProveedor')
BEGIN
	DROP PROCEDURE ddbba.insertarProveedor ;
END;
go
CREATE PROCEDURE ddbba.insertarProveedor
    @id_proveedor INT,
    @nombre VARCHAR(255)
AS
BEGIN
        -- Validar que el nombre no sea nulo ni vacío
        IF (@nombre IS NULL OR LTRIM(RTRIM(@nombre)) = '')
        BEGIN
            PRINT 'El nombre del proveedor no puede ser nulo o vacío.'
            RETURN; -- Detiene la ejecucion
        END;

        -- Validar que el id_proveedor no exista ya en la tabla
        IF EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE id_proveedor = @id_proveedor)
        BEGIN
            PRINT 'El id_proveedor ya existe en la tabla Proveedor.'
            RETURN;
        END

        -- Insertar los datos en la tabla
        INSERT INTO ddbba.Proveedor (id_proveedor, nombre)
        VALUES (@id_proveedor, @nombre)
        PRINT 'Proveedor insertado correctamente.';
 
END;
go

--SP PARA PRODUCTO
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProducto')
BEGIN
	DROP PROCEDURE ddbba.insertarProducto ;
END;
go
CREATE PROCEDURE ddbba.InsertarProducto
	@id_producto INT,
	@precio_unitario DECIMAL(10,2),
	@linea VARCHAR(100),
	@descripcion VARCHAR(255)
AS
BEGIN

		IF EXISTS(SELECT 1 FROM ddbba.Producto WHERE id_producto= @id_producto)
		BEGIN
			PRINT 'El codigo del producto ya existe en la tabla'
			RETURN
		END

		IF (@id_producto <= 0)
		BEGIN
			PRINT 'El codigo del producto debe ser mayor a cero'
			RETURN
		END

		IF (@precio_unitario <= 0)
		BEGIN
			PRINT 'El precio del producto debe ser mayor a cero'
			RETURN
		END

		IF (@linea IS NULL OR LTRIM(RTRIM(@linea)) = '')
		BEGIN
			PRINT 'La linea del producto no debe ser nula'
			RETURN
		END

		IF (@descripcion IS NULL OR LTRIM(RTRIM(@descripcion)) = '')
		BEGIN
			PRINT 'La descripcion del producto no debe ser nula'
			RETURN
		END

		 -- Insertar los datos en la tabla
        INSERT INTO ddbba.Producto(id_producto, precio_unitario, linea, descripcion)
        VALUES (@id_producto, @precio_unitario, @linea, @descripcion );
		PRINT 'Producto insertado correctamente'
END;
go
--SP PARA VENTA
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarVenta')
BEGIN
	DROP PROCEDURE ddbba.insertarVenta;
END;
go
CREATE PROCEDURE ddbba.insertarVenta
	@id_pedido INT, 
	@id_sucursal INT,
	@id_empleado INT
AS
BEGIN
	--verificar que el pedido exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_pedido = @id_pedido)
	BEGIN	
		PRINT 'El Pedido no existe.';
		RETURN;
	END;
	--verificar que la sucursal exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE id_sucursal = @id_sucursal)
	BEGIN	
		PRINT 'La Sucursal no existe.';
		RETURN;
	END;
	--verificar que el empleado exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = @id_empleado)
	BEGIN	
		PRINT 'El empleado no existe.';
		RETURN;
	END;

INSERT INTO ddbba.Venta (id_pedido,id_sucursal,id_empleado) VALUES (@id_pedido,@id_sucursal,@id_empleado);
PRINT 'Valores insertados correctamente'
END;
go
--SP PARA TIENE
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'InsertarTiene')
BEGIN
	DROP PROCEDURE ddbba.insertarTiene;
END;
go
CREATE PROCEDURE ddbba.InsertarTiene
	@id_producto INT,
	@id_pedido INT,
	@cantidad INT
AS

BEGIN
	--verificar si el producto existe
	if NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto )
	BEGIN
		PRINT 'El producto no existe'
		RETURN;
	END;
	--verificar que el pedido existe
	if NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_pedido = @id_pedido )
	BEGIN
		PRINT 'El pedido no existe'
		RETURN;
	END;
	--verificar que la cantidad pedida es mayor a cero
	if(@cantidad <= 0)
	BEGIN 
		PRINT 'La cantidad debe ser mayor a cero'
		RETURN;
	END;

	INSERT INTO ddbba.Tiene(id_producto, id_pedido, cantidad)
    VALUES (@id_producto, @id_pedido, @cantidad);
	PRINT 'Valores insertados correctamente'
END;
go
--SP PARA PROVEE
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProvee')
BEGIN
	DROP PROCEDURE ddbba.insertarProvee;
END;
go
CREATE PROCEDURE ddbba.insertarProvee(
	@id_prov INT,
	@id_prod INT)
AS
BEGIN
	--verificar que el proveedor exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE id_proveedor = @id_prov)
	BEGIN	
		PRINT 'El proveedor no existe.';
		RETURN;
	END;
	--verificar que el producto exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_prod)
	BEGIN	
		PRINT 'El producto no existe.';
		RETURN;
	END;

INSERT INTO ddbba.Provee (id_proveedor,id_producto) VALUES (@id_prov,@id_prod);
PRINT 'Valores insertados correctamente'
END;
go





