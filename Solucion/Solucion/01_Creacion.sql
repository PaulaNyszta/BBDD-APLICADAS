-- 1. SCRIPT DE CREACION - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
--En este Script se incluiran todos los Store Procedures y Tablas que deben crearse para la ultilizacion posterior


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
--Creacion de las tablas 
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
		CREATE TABLE ddbba.Proveedor (
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.ProveedorProvee') AND type = N'U')
	BEGIN 
		CREATE TABLE ddbba.ProveedorProvee(
			id_proveedor INT,
			id_producto INT,
			CONSTRAINT PKProvee PRIMARY KEY (id_proveedor, id_producto),
			CONSTRAINT FKProvee1 FOREIGN KEY (id_proveedor) REFERENCES ddbba.Proveedor(id_proveedor),
			CONSTRAINT FKProvee2 FOREIGN KEY (id_producto) REFERENCES ddbba.Producto(id_producto)
		);
		PRINT 'Tabla ProveedorProvee creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla ProveedorProvee ya existe.';
	END;
go
--TABLA CLIENTE
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.Cliente') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.Cliente (
			dni_cliente char(8) PRIMARY KEY CHECK (LEN(dni_cliente) = 8 ),
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
			dni_cliente char(8) ,
			id_mp INT,
			iden_pago VARCHAR(50),
			id_empleado INT,
			id_sucursal INT,
            tipo_factura CHAR(1) CHECK (tipo_factura IN ('A', 'B', 'C')),
			estado_factura VARCHAR(10) CHECK (estado_factura IN ('Pagado', 'NoPagado')),
			CONSTRAINT FKPedido1 FOREIGN KEY (dni_cliente) REFERENCES ddbba.Cliente(dni_cliente),
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

--TABLA ProductoSolicitado
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Com1353G01.ddbba.ProductoSolicitado') AND type = N'U')
	BEGIN
		CREATE TABLE ddbba.ProductoSolicitado (
			id_factura char(12),
			id_producto INT ,
			cantidad INT,
			CONSTRAINT PKTiene PRIMARY KEY (id_producto, id_factura),
			CONSTRAINT FKTiene1 FOREIGN KEY (id_producto) REFERENCES ddbba.Producto(id_producto),
			CONSTRAINT FKTiene2 FOREIGN KEY (id_factura) REFERENCES ddbba.Pedido(id_factura)
		);
		PRINT 'Tabla ProductoSolicitado creada correctamente.';
	END
ELSE
	BEGIN
		PRINT 'La tabla ProductoSolicitado ya existe.';
	END;
go
-- TABLA NOTA CREDITO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ddbba.NotaCredito') AND type = N'U')
BEGIN
    CREATE TABLE ddbba.NotaCredito (
        id_nota_credito INT IDENTITY(1,1)PRIMARY KEY,
		fecha_emision DATETIME ,
		dni_cliente char(8),
		id_factura CHAR(12),
		nombre_producto VARCHAR(100),
	    precio_unitario DECIMAL(10,2),
		cantidad INT, --cantidad del pedido
		monto DECIMAL (10,2),
		cantidadADevolver int, --cantidad de devolucion
		motivo Varchar(255)
	    CONSTRAINT FKNotaCredito2 FOREIGN KEY (id_factura) REFERENCES ddbba.Pedido(id_factura),
	    CONSTRAINT FKNotaCredito3 FOREIGN KEY (dni_cliente) REFERENCES ddbba.Cliente(dni_cliente)
    );
    PRINT 'Tabla NotaCredito creada correctamente.';
END;
GO

---------------------------------------------SP--------------------------------------------------------------------
--Crear el Schema nuevo para unicamente los SP
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Procedimientos')
	BEGIN
		EXEC('CREATE SCHEMA Procedimientos');
		PRINT ' Schema Procedimientos creado exitosamente';
	END;
go


-- SP PARA INSERTAR CLIENTE-------------------------------------------------------
--creacion de los Store Procedure DE INSERCION de los datos a las tablas anteriores
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarCliente')
BEGIN
    DROP PROCEDURE Procedimientos.insertarCliente;
END;
GO
CREATE PROCEDURE Procedimientos.insertarCliente
    @dni CHAR(9),
    @genero VARCHAR(50),
    @tipo VARCHAR(10),
    @apellido VARCHAR(50),
    @nombre VARCHAR(50),
    @fnac DATE
AS
BEGIN
    -- Validación de que ningún campo sea NULL
    IF @dni IS NULL OR @genero IS NULL OR @tipo IS NULL OR 
       @apellido IS NULL OR @nombre IS NULL OR @fnac IS NULL
    BEGIN
        PRINT 'Error: Ningún campo puede ser NULL';
        RETURN;
    END;

    -- Validación de que el cliente no se haya insertado
    IF EXISTS (SELECT 1 FROM ddbba.Cliente WHERE dni_cliente = @dni)
    BEGIN
        PRINT 'Cliente ya existente';
        RETURN;
    END;

    -- Validación de que el DNI tenga 8 dígitos
    IF LEN(@dni) < 8 or LEN(@dni) > 8
    BEGIN
        PRINT 'Error: El DNI debe ser de 8 dígitos';
        RETURN;
    END
	ELSE
	BEGIN
		SET @dni = CAST(@dni AS CHAR(8));
	END;

    -- Validación de género
    IF @genero NOT IN ('Female', 'Male')
    BEGIN
        PRINT 'Error: El género debe ser "Female" o "Male"';
        RETURN;
    END;

    -- Validación del tipo de cliente
    IF @tipo NOT IN ('Normal', 'Member')
    BEGIN
        PRINT 'Error: El tipo de cliente debe ser "Normal" o "Member"';
        RETURN;
    END;

    -- Validación de que la fecha de nacimiento no sea futura
    IF @fnac > GETDATE()
    BEGIN
        PRINT 'Error: La fecha de nacimiento no puede ser futura';
        RETURN;
    END;

    -- Insertar el cliente
    INSERT INTO ddbba.Cliente (dni_cliente, genero, tipo, apellido, nombre, fecha_nac)
    VALUES (@dni, @genero, @tipo, @apellido, @nombre, @fnac);
    
    PRINT 'Cliente insertado correctamente';
END;
GO

-- SP PARA MODIFICAR CLIENTE
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarCliente')
BEGIN
    DROP PROCEDURE Procedimientos.modificarCliente;
END;
GO
CREATE PROCEDURE Procedimientos.modificarCliente
    @dni CHAR(9),
    @genero VARCHAR(50),
    @tipo VARCHAR(10),
    @apellido VARCHAR(50),
    @nombre VARCHAR(50),
    @fnac DATE
AS
BEGIN
    -- Validación de que ningún campo sea NULL
    IF @dni IS NULL OR @genero IS NULL OR @tipo IS NULL OR 
       @apellido IS NULL OR @nombre IS NULL OR @fnac IS NULL
    BEGIN
        PRINT 'Error: Ningún campo puede ser NULL';
        RETURN;
    END;

    -- Verificar si el cliente existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Cliente WHERE dni_cliente = @dni)
    BEGIN
        PRINT 'Error: Cliente no encontrado';
        RETURN;
    END;

    -- Validación de que el DNI tenga 8 dígitos
    IF LEN(@dni) <> 8 
    BEGIN
        PRINT 'Error: El DNI debe ser de 8 dígitos';
        RETURN;
    END
	ELSE
	BEGIN
		SET @dni = cast(@dni as char(8));
	END;

    -- Validación de género
    IF @genero NOT IN ('Female', 'Male')
    BEGIN
        PRINT 'Error: El género debe ser "Female" o "Male"';
        RETURN;
    END;

    -- Validación del tipo de cliente
    IF @tipo NOT IN ('Normal', 'Member')
    BEGIN
        PRINT 'Error: El tipo de cliente debe ser "Normal" o "Member"';
        RETURN;
    END;

    -- Validación de que la fecha de nacimiento no sea futura
    IF @fnac > GETDATE()
    BEGIN
        PRINT 'Error: La fecha de nacimiento no puede ser futura';
        RETURN;
    END;

    -- Modificar el cliente
    UPDATE ddbba.Cliente
    SET genero = @genero,
        tipo = @tipo,
        apellido = @apellido,
        nombre = @nombre,
        fecha_nac = @fnac
    WHERE dni_cliente = @dni;

    PRINT 'Cliente modificado correctamente';
END;
GO
-- SP PARA ELIMINAR CLIENTE
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarCliente')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarCliente;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarCliente
    @dni CHAR(9)
AS
BEGIN
    -- Validación de que el DNI no sea NULL
    IF @dni IS NULL
    BEGIN
        PRINT 'Error: El DNI no puede ser NULL';
        RETURN;
    END;

    -- Validación de que el DNI tenga 8 dígitos
    IF LEN(@dni) <> 8
    BEGIN
        PRINT 'Error: El DNI debe tener 8 dígitos';
        RETURN;
    END
	BEGIN
		SET	@dni = cast(@dni as char(8));
	END;

    -- Verificar si el cliente existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Cliente WHERE dni_cliente = @dni)
    BEGIN
        PRINT 'Error: Cliente no encontrado';
        RETURN;
    END;

    -- Eliminar el cliente
    DELETE FROM ddbba.Cliente WHERE dni_cliente = @dni;
    
    PRINT 'Cliente eliminado correctamente';
END;
GO


-- SP PARA EMPLEADO------------------------------------------------------------------
--insercion
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarEmpleado')
BEGIN
	DROP PROCEDURE Procedimientos.insertarEmpleado ;
END;
go
CREATE PROCEDURE Procedimientos.insertarEmpleado
	@id_empleado INT,
	@cuil VARCHAR(200),
	@dni INT,
	@direccion VARCHAR(255),
	@apellido VARCHAR(100),
	@nombre VARCHAR(100),
	@email_personal VARCHAR(255),
	@email_empresarial VARCHAR(255),
	@turno VARCHAR(50),
	@cargo VARCHAR(50),
	@id_sucursal INT
AS
BEGIN

	-- Validación de id del empleado sea unico
	IF EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = @id_empleado)
	BEGIN
		PRINT 'Error. Empleado ya existente';
		RETURN;
	END;
	-- Validación de id del empleado no puede ser null
	IF @id_empleado IS NULL
	BEGIN
		PRINT 'Error. El id_empleado no puede ser nulo';
		RETURN;
	END;

	-- Validación de que el cuil tenga forma XX-XXXXXXXX-X
	 IF @cuil NOT LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    BEGIN
        PRINT 'Error: El número de CUIL debe tener forma XX-XXXXXXXX-X';
        RETURN;
    END;
	-- Validación de que el dni sean 8 numeros y no nulo
	 IF @dni NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'  or @dni IS NULL 
    BEGIN
        PRINT 'Error: El número de DNI debe tener forma XXXXXXXX (8 numeros) y no debe ser nulo';
        RETURN;
    END;
	-- Validación de que el turno sea TM, TT o jornada completa y no nulo
	IF @turno IS NULL OR @turno NOT IN ('TT','TM','Jornada completa')
	BEGIN
		PRINT'El turno debe ser TT, TM, o Jornada completa';
		RETURN;
	END;
	-- Validación de que el nombre y apellido no sea nulo
	IF @nombre IS NULL OR @apellido IS NULL
	BEGIN
		PRINT'El Nombre y Apellido no deben ser nulos';
		RETURN;
	END;
		-- Validación de que el cargo no sea nulo
	IF @cargo IS NULL 
	BEGIN
		PRINT'El Cargo no debe ser nulo';
		RETURN;
	END;

    -- Validación de que el id_sucursal exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal	WHERE @id_sucursal = id_sucursal)
	BEGIN
		PRINT'El id_sucursal debe existir';
		RETURN;
	END;
	INSERT INTO ddbba.Empleado (id_empleado,cuil,dni,direccion,apellido,nombre,email_personal, email_empresarial,turno,cargo,id_sucursal)
	VALUES (@id_empleado,@cuil,@dni,@direccion,@apellido,@nombre,@email_personal,@email_empresarial,@turno,@cargo,@id_sucursal);
	PRINT 'Empleado insertado correctamente';
END;
go
--modificacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarEmpleado')
BEGIN
    DROP PROCEDURE Procedimientos.modificarEmpleado;
END;
GO
CREATE PROCEDURE Procedimientos.modificarEmpleado
    @id_empleado INT,
    @cuil VARCHAR(200) = NULL,
    @dni INT = NULL,
    @direccion VARCHAR(255) = NULL,
    @apellido VARCHAR(100) = NULL,
    @nombre VARCHAR(100) = NULL,
    @email_personal VARCHAR(255) = NULL,
    @email_empresarial VARCHAR(255) = NULL,
    @turno VARCHAR(50) = NULL,
    @cargo VARCHAR(50) = NULL,
    @id_sucursal INT = NULL
AS
BEGIN
    -- Validación: Verificar si el empleado existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = @id_empleado)
    BEGIN
        PRINT 'Error: Empleado no encontrado';
        RETURN;
    END;

    -- Validación: Si se cambia el CUIL, verificar el formato
    IF @cuil NOT LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    BEGIN
        PRINT 'Error: El número de CUIL debe tener la forma XX-XXXXXXXX-X';
        RETURN;
    END;

    -- Validación: Si se cambia el DNI, verificar que tenga 8 números
    IF @dni NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT 'Error: El DNI debe tener 8 números';
        RETURN;
    END;

    -- Validación: Si se cambia el turno, verificar que sea válido
    IF  @turno NOT IN ('TT', 'TM', 'Jornada completa')
    BEGIN
        PRINT 'Error: El turno debe ser TT, TM o Jornada completa';
        RETURN;
    END;

    -- Validación: Si se cambia la sucursal, verificar que exista
    IF @id_sucursal IS NOT NULL
    BEGIN
		IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE id_sucursal = @id_sucursal)
		BEGIN
        PRINT 'Error: El id_sucursal no existe';
        RETURN;
		END;
    END;

    -- Actualización del empleado
    UPDATE ddbba.Empleado
    SET 
        cuil = ISNULL(@cuil, cuil),
        dni = ISNULL(@dni, dni),
        direccion = ISNULL(@direccion, direccion),
        apellido = ISNULL(@apellido, apellido),
        nombre = ISNULL(@nombre, nombre),
        email_personal = ISNULL(@email_personal, email_personal),
        email_empresarial = ISNULL(@email_empresarial, email_empresarial),
        turno = ISNULL(@turno, turno),
        cargo = ISNULL(@cargo, cargo),
        id_sucursal = ISNULL(@id_sucursal, id_sucursal)
    WHERE id_empleado = @id_empleado;

    PRINT 'Empleado modificado correctamente';
END;
GO
--eliminacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarEmpleado')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarEmpleado;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarEmpleado 
    @id_empleado INT
AS
BEGIN
    -- Validación: Verificar si el empleado existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = @id_empleado)
    BEGIN
        PRINT 'Error: Empleado no encontrado';
        RETURN;
    END;

    -- Eliminación del empleado
    DELETE FROM ddbba.Empleado WHERE id_empleado = @id_empleado;

    PRINT 'Empleado eliminado correctamente';
END;
GO

-- SP PARA  PEDIDO----------------------------------------------------------------
--insercion
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarPedido')
BEGIN
	DROP PROCEDURE Procedimientos.insertarPedido ;
END;
go
CREATE PROCEDURE Procedimientos.InsertarPedido (
	@id_factura CHAR(12),
    @fecha_pedido DATE,
    @hora_pedido TIME,
    @dni_cliente char(8),
    @id_mp INT,
    @iden_pago VARCHAR(50),
	@id_empleado INT,
	@id_sucursal int,
	@tipo_factura CHAR(1),
	@estado_factura VARCHAR(10))
AS
BEGIN
	-- Validación del que el id no sea Null
	IF (@id_factura IS NULL)
	BEGIN
		PRINT 'Error. El id no puede ser Nulo.';
		RETURN;
	END;
			-- Validación de id de la factura cumpla con la forma XXX-XX-XXXX
		IF @id_factura NOT LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
		BEGIN
			PRINT 'Error. La el id de la factura no cumple con la forma XXX-XX-XXXX';
			RETURN;
		END;
		-- Validación de id de la factura sea un numero unico 
		IF EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_factura = @id_factura) 
		BEGIN
			PRINT'El Pedido ya existe';
			RETURN;
		END;    
	-- Validación del que la fecha no sea Null
	IF (@fecha_pedido IS NULL)
	BEGIN
		PRINT 'Error. La fecha de pedido no puede ser Nula.';
		RETURN;
	END;
	    --validadcion de la fecha del pedido no sea futura
    IF (@fecha_pedido > GETDATE())
    BEGIN
        PRINT 'Error: fecha del pedido no puede ser futura';
        RETURN;
    END;
 	-- Validación del que el cliente  no sea Null
	IF (@dni_cliente IS NULL)
	BEGIN
		PRINT 'Error. El cliente no puede ser Nulo.';
		RETURN;
	END;   

	-- Validación de que el medio de pago exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE @id_mp=id_mp) 
	BEGIN
		PRINT'El Medio de pago no existe';
		RETURN;
	END; 
	 --validadcion de que el identificador de pago tenga entre 0 y 30 caracteres
    IF (LEN(@iden_pago) = 0 OR LEN(@iden_pago) > 30)
    BEGIN
        PRINT 'Error: El iden_pago debe tener entre 1 y 30 caracteres.';
        RETURN;
    END;

	-- Validación de que el empleado exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE @id_empleado=id_empleado) 
	BEGIN
		PRINT'El Empleado no existe';
		RETURN;
	END; 

	-- Validación de que la sucursal exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE @id_sucursal=id_sucursal) 
	BEGIN
		PRINT'La sucursal no existe';
		RETURN;
	END; 
 
		--verificacion de que el tipo de factura se A, B o C
		IF @tipo_factura IS NULL OR @tipo_factura NOT IN ('A','B','C')
			BEGIN
				PRINT 'Error: tipo_factura debe ser A, B o C.';
				RETURN;
			END;   

		--validadcion de que el estado sea 'Pagado' o 'NoPagado'
		IF @estado_factura IS NULL OR @estado_factura NOT IN ('Pagado', 'NoPagado')
		BEGIN
			PRINT 'Error: el estado debe ser Pagado o NoPagado';
			RETURN;
		END;
	
    INSERT INTO ddbba.Pedido (id_factura,fecha_pedido,hora_pedido,dni_cliente,id_mp,iden_pago,id_empleado,id_sucursal,tipo_factura,estado_factura)
    VALUES (@id_factura,@fecha_pedido,@hora_pedido,@dni_cliente,@id_mp,@iden_pago,@id_empleado,@id_sucursal,@tipo_factura,@estado_factura);
END;
go
--modificacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarPedido')
BEGIN
    DROP PROCEDURE Procedimientos.modificarPedido;
END;
GO
CREATE PROCEDURE Procedimientos.modificarPedido
    @id_factura CHAR(12),
    @fecha_pedido DATE = NULL,
    @hora_pedido TIME = NULL,
    @dni_cliente CHAR(8) = NULL,
    @id_mp INT = NULL,
    @iden_pago VARCHAR(50) = NULL,
    @id_empleado INT = NULL,
    @id_sucursal INT = NULL,
    @tipo_factura CHAR(1) = NULL,
    @estado_factura VARCHAR(10) = NULL
AS
BEGIN
    -- Validación: Verificar si el pedido existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'Error: El pedido no existe';
        RETURN;
    END;

    -- Validación de la fecha del pedido (si se cambia)
    IF @fecha_pedido IS NOT NULL AND @fecha_pedido > GETDATE()
    BEGIN
        PRINT 'Error: La fecha del pedido no puede ser futura';
        RETURN;
    END;

    -- Validación de que el medio de pago exista (si se cambia)
    IF @id_mp IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE id_mp = @id_mp)
    BEGIN
        PRINT 'Error: El Medio de pago no existe';
        RETURN;
    END;

    -- Validación de que el empleado exista (si se cambia)
    IF @id_empleado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = @id_empleado)
    BEGIN
        PRINT 'Error: El Empleado no existe';
        RETURN;
    END;

    -- Validación de que la sucursal exista (si se cambia)
    IF @id_sucursal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE id_sucursal = @id_sucursal)
    BEGIN
        PRINT 'Error: La Sucursal no existe';
        RETURN;
    END;

    -- Validación del tipo de factura (si se cambia)
    IF @tipo_factura IS NOT NULL AND @tipo_factura NOT IN ('A', 'B', 'C')
    BEGIN
        PRINT 'Error: El tipo_factura debe ser A, B o C';
        RETURN;
    END;

    -- Validación del estado de la factura (si se cambia)
    IF @estado_factura IS NOT NULL AND @estado_factura NOT IN ('Pagado', 'NoPagado')
    BEGIN
        PRINT 'Error: El estado_factura debe ser "Pagado" o "NoPagado"';
        RETURN;
    END;

    -- Actualización del pedido
    UPDATE ddbba.Pedido
    SET 
        fecha_pedido = ISNULL(@fecha_pedido, fecha_pedido),
        hora_pedido = ISNULL(@hora_pedido, hora_pedido),
        dni_cliente = ISNULL(@dni_cliente, dni_cliente),
        id_mp = ISNULL(@id_mp, id_mp),
        iden_pago = ISNULL(@iden_pago, iden_pago),
        id_empleado = ISNULL(@id_empleado, id_empleado),
        id_sucursal = ISNULL(@id_sucursal, id_sucursal),
        tipo_factura = ISNULL(@tipo_factura, tipo_factura),
        estado_factura = ISNULL(@estado_factura, estado_factura)
    WHERE id_factura = @id_factura;

    PRINT 'Pedido modificado correctamente';
END;
GO
--eliminacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarPedido')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarPedido;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarPedido
    @id_factura CHAR(12)
AS
BEGIN
    -- Validación: Verificar si el pedido existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'Error: El pedido no existe';
        RETURN;
    END;

    -- Eliminación del pedido
    DELETE FROM ddbba.Pedido WHERE id_factura = @id_factura;

    PRINT 'Pedido eliminado correctamente';
END;
GO

--SP PARA PRODUCTO---------------------------------------------------------------------------
--insercion
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProducto')
BEGIN
	DROP PROCEDURE Procedimientos.insertarProducto ;
END;
go
CREATE PROCEDURE Procedimientos.insertarProducto
	@nombre_producto VARCHAR(100),
	@precio_unitario DECIMAL(10,2),
	@linea VARCHAR(50),
	@precio_referencia  decimal (10,2),
	@unidad varchar(10),
	@cantidadPorUnidad NVARCHAR(50),
	@moneda VARCHAR(7),
	@fecha datetime
AS
BEGIN
		--validar que el producto no exista
		 IF EXISTS (SELECT 1 FROM ddbba.Producto WHERE @nombre_producto=nombre_producto)
        BEGIN
            PRINT 'El producto ya existe en la tabla.'
            RETURN;
        END;
		--validar que el precio no sea nulo ni negativo
		IF @precio_unitario <= 0 or @precio_unitario IS NULL
		BEGIN
			PRINT 'El precio del producto debe ser mayor a cero'
			RETURN;
		END;

		--validar que el precio de referencia no sea negativo
		IF (@precio_referencia < 0)
		BEGIN
			PRINT 'El precio de referencia debe ser mayor a cero'
			RETURN;
		END;
		--validar que la fecha no sea futura
		IF @fecha > GETDATE()
		BEGIN
			PRINT 'La fecha del producto no debe ser futura';
			RETURN;
		END;
		--validar que la moneda sea USD, ARS o EUR
		IF @moneda NOT IN ('USD', 'EUR', 'ARS') or @moneda is null
		BEGIN
			PRINT 'La moneda debe ser de tipo USD, EUR o ARS';
			RETURN;
		END;

		 -- Insertar los datos en la tabla
        INSERT INTO ddbba.Producto( nombre_producto,precio_unitario, linea,precio_referencia,unidad,cantidadPorUnidad,moneda,fecha)
        VALUES (@nombre_producto,@precio_unitario, @linea,@precio_referencia,@unidad,@cantidadPorUnidad,@moneda,@fecha );
		PRINT 'Producto insertado correctamente'
END;
go
--modificacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarProducto')
BEGIN
    DROP PROCEDURE Procedimientos.modificarProducto;
END;
GO
CREATE PROCEDURE Procedimientos.modificarProducto
	@id_producto int,
    @nombre_producto VARCHAR(100) = NULL,
    @precio_unitario DECIMAL(10,2) = NULL,
    @linea VARCHAR(50) = NULL,
    @precio_referencia DECIMAL(10,2) = NULL,
    @unidad VARCHAR(10) = NULL,
    @cantidadPorUnidad NVARCHAR(50) = NULL,
    @moneda VARCHAR(7) = NULL,
    @fecha DATETIME = NULL
AS
BEGIN
    -- Validación: Verificar si el producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto)
    BEGIN
        PRINT 'Error: El producto no existe';
        RETURN;
    END;

    -- Validación de que el precio no sea negativo o nulo (si se cambia)
    IF @precio_unitario IS NOT NULL AND (@precio_unitario <= 0)
    BEGIN
        PRINT 'Error: El precio del producto debe ser mayor a cero';
        RETURN;
    END;

    -- Validación de que el precio de referencia no sea negativo (si se cambia)
    IF @precio_referencia IS NOT NULL AND (@precio_referencia < 0)
    BEGIN
        PRINT 'Error: El precio de referencia debe ser mayor a cero';
        RETURN;
    END;

    -- Validación de que la fecha no sea futura (si se cambia)
    IF @fecha IS NOT NULL AND @fecha > GETDATE()
    BEGIN
        PRINT 'Error: La fecha del producto no debe ser futura';
        RETURN;
    END;

    -- Validación de que la moneda sea válida (si se cambia)
    IF @moneda IS NOT NULL AND @moneda NOT IN ('USD', 'EUR', 'ARS')
    BEGIN
        PRINT 'Error: La moneda debe ser de tipo USD, EUR o ARS';
        RETURN;
    END;

    -- Actualización del producto
    UPDATE ddbba.Producto
    SET 
		nombre_producto = ISNULL(@nombre_producto,nombre_producto),
        precio_unitario = ISNULL(@precio_unitario, precio_unitario),
        linea = ISNULL(@linea, linea),
        precio_referencia = ISNULL(@precio_referencia, precio_referencia),
        unidad = ISNULL(@unidad, unidad),
        cantidadPorUnidad = ISNULL(@cantidadPorUnidad, cantidadPorUnidad),
        moneda = ISNULL(@moneda, moneda),
        fecha = ISNULL(@fecha, fecha)
    WHERE id_producto = @id_producto;

    PRINT 'Producto modificado correctamente';
END;
GO
--eliminacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarProducto')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarProducto;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarProducto
    @id_producto int
AS
BEGIN
    -- Validación: Verificar si el producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto)
    BEGIN
        PRINT 'Error: El producto no existe';
        RETURN;
    END;

    -- Eliminación del producto
    DELETE FROM ddbba.Producto WHERE id_producto = @id_producto;

    PRINT 'Producto eliminado correctamente';
END;
GO

--SP PARA PROVEEDOR_PROVEE--------------------------------------------------------------------
--insercion-
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProveedorProvee')
BEGIN
	DROP PROCEDURE Procedimientos.insertarProveedorProvee;
END;
go
CREATE PROCEDURE Procedimientos.insertarProveedorProvee(
	@id_proveedor INT,
	@id_producto INT)
AS
BEGIN
	--verificar que el proveedor exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE id_proveedor = @id_proveedor)
	BEGIN	
		PRINT 'El proveedor no existe.';
		RETURN;
	END;
	--verificar que el producto exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto)
	BEGIN	
		PRINT 'El producto no existe.';
		RETURN;
	END;
	--verificar que ya se haya agregado el proveedor con su producto
	IF EXISTS (SELECT 1 FROM ddbba.ProveedorProvee WHERE id_producto = @id_producto and id_proveedor=@id_proveedor)
	BEGIN	
		PRINT 'ya existe ese proveedor con el producto';
		RETURN;
	END;

INSERT INTO ddbba.ProveedorProvee(id_proveedor,id_producto) VALUES (@id_proveedor,@id_producto);
PRINT 'Valores insertados correctamente'
END;
go
--modificacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarProveedorProvee')

BEGIN
    DROP PROCEDURE Procedimientos.modificarProveedorProvee;
END;
GO
CREATE PROCEDURE Procedimientos.modificarProveedorProvee
    @id_proveedor INT,
    @id_producto INT,
    @nuevo_id_proveedor INT = NULL,
    @nuevo_id_producto INT = NULL
AS
BEGIN
    -- Validación: Verificar si la relación proveedor-producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.ProveedorProvee WHERE id_proveedor = @id_proveedor AND id_producto = @id_producto)
    BEGIN
        PRINT 'Error: La relación proveedor-producto no existe.';
        RETURN;
    END;

    -- Verificar que el nuevo proveedor (si se proporciona) exista
    IF @nuevo_id_proveedor IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE id_proveedor = @nuevo_id_proveedor)
    BEGIN
        PRINT 'Error: El nuevo proveedor no existe.';
        RETURN;
    END;

    -- Verificar que el nuevo producto (si se proporciona) exista
    IF @nuevo_id_producto IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @nuevo_id_producto)
    BEGIN
        PRINT 'Error: El nuevo producto no existe.';
        RETURN;
    END;

    -- Actualizar la relación proveedor-producto con los nuevos valores (si se proporcionan)
    UPDATE ddbba.ProveedorProvee
    SET 
        id_proveedor = ISNULL(@nuevo_id_proveedor, id_proveedor),
        id_producto = ISNULL(@nuevo_id_producto, id_producto)
    WHERE id_proveedor = @id_proveedor AND id_producto = @id_producto;

    PRINT 'Relación proveedor-producto modificada correctamente';
END;
GO
--eliminacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarProveedorProvee')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarProveedorProvee;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarProveedorProvee
    @id_proveedor INT,
    @id_producto INT
AS
BEGIN
    -- Validación: Verificar si la relación proveedor-producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.ProveedorProvee WHERE id_proveedor = @id_proveedor AND id_producto = @id_producto)
    BEGIN
        PRINT 'Error: La relación proveedor-producto no existe.';
        RETURN;
    END;

    -- Eliminar la relación proveedor-producto
    DELETE FROM ddbba.ProveedorProvee WHERE id_proveedor = @id_proveedor AND id_producto = @id_producto;

    PRINT 'Relación proveedor-producto eliminada correctamente';
END;
GO

--SP PARA INSERTAR NOTA CREDITO--------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarNotaCredito')
BEGIN
    DROP PROCEDURE Procedimientos.insertarNotaCredito;
END;
GO
CREATE PROCEDURE Procedimientos.insertarNotaCredito(
	@id_empleado INT,
	@id_factura CHAR(12),
	@cantidadADevolver int, --cantidad de unidades a devolver
	@motivo VARCHAR(255) --descripcion de porque se va a realizar la devolucion

)
AS
BEGIN
	
	--verificar que existe el id_factura
		IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE @id_factura=id_factura)
		BEGIN
			PRINT 'NO EXISTE LA FACTURA INGRESADA';
			RETURN;
		END;
		--verificar que existe el id_empleado
		IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE @id_empleado=id_empleado)
		BEGIN
			PRINT 'NO EXISTE EL EMPLEADO INGRESADO';
			RETURN;
		END;

	DECLARE @estado_factura VARCHAR(10);
	DECLARE @cargo VARCHAR(50);

	-- Verificar si la factura está pagada
	SELECT @estado_factura = estado_factura
	FROM ddbba.Pedido
	WHERE id_factura = @id_factura;

	IF @estado_factura <> 'Pagado' 
	BEGIN
		PRINT 'Error: La nota de crédito solo puede generarse para facturas pagadas.';
		RETURN;
	END;

	-- Verificar si el empleado es un Supervisor
	SELECT @cargo = cargo 
	FROM ddbba.Empleado
	WHERE id_empleado = @id_empleado;

	IF @cargo <> 'Supervisor'
	BEGIN
		PRINT 'Error: Solo los supervisores pueden generar notas de crédito.';
		RETURN;
	END;

		--generar fecha actual
		DECLARE @fecha_emision DATETIME;
		SET @fecha_emision = GETDATE();

		--busco dni_cliente
		DECLARE @dni_cliente INT;
		SELECT @dni_cliente=dni_cliente FROM ddbba.Pedido Ped WHERE Ped.id_factura=@id_factura;

		--nombre del producto
		DECLARE @nombre_producto VARCHAR(100);
		SELECT  @nombre_producto=nombre_producto
		FROM ddbba.Producto P
		INNER JOIN ddbba.ProductoSolicitado PS ON P.id_producto=PS.id_producto
		WHERE @id_factura=PS.id_factura;

		--precio del producto
		DECLARE @precio_unitario DECIMAL(10,2);
		SELECT  @precio_unitario=precio_unitario
		FROM ddbba.Producto P
		INNER JOIN ddbba.ProductoSolicitado PS ON P.id_producto=PS.id_producto
		WHERE @id_factura=PS.id_factura;

		--cantidad
		DECLARE @cantidad INT;
		SELECT  @cantidad=cantidad
		FROM ddbba.ProductoSolicitado PS
		WHERE @id_factura=PS.id_factura;

			--verificacion que la cantidad a devolver no sea mayor a la pagada
			IF @cantidadADevolver > @cantidad
			BEGIN
			PRINT 'La cantidad no puede mayor a la pagada';
			
			RETURN;
			END;
			--verificacion que la cantidad a devolver no sea negativa nula
			IF @cantidadADevolver <=0
				BEGIN
			PRINT 'La cantidad no puede ser negativa o nula';
			RETURN;
				END;
			--verificar que motivo no sea nulo
			IF @motivo IS NULL
			BEGIN
				PRINT 'El motivo no puede ser nulo';
				return;
			END;
		--monto
		DECLARE @monto DECIMAL(10,2);
		SET  @monto = (@cantidad*@precio_unitario);

INSERT INTO ddbba.NotaCredito(fecha_emision,dni_cliente,id_factura,nombre_producto,precio_unitario, cantidad,monto,cantidadADevolver,motivo)
VALUES (@fecha_emision,@dni_cliente,@id_factura,@nombre_producto,@precio_unitario, @cantidad,@monto,@cantidadADevolver,@motivo);
PRINT 'Valores insertados correctamente';
END;
go
-- SP PARA MODIFICAR NOTA CREDITO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarNotaCredito')
BEGIN
	DROP PROCEDURE Procedimientos.modificarNotaCredito;
END;
GO
CREATE PROCEDURE Procedimientos.modificarNotaCredito(
		@id_nota_credito int,
		@id_empleado INT,
		@id_factura CHAR(12),
		@cantidadADevolver int, --cantidad de unidades a devolver
		@motivo VARCHAR(255) --descripcion de porque se va a realizar la devolucion

)
AS
BEGIN
	
	IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE @id_factura=id_factura)
		BEGIN
			PRINT 'NO EXISTE LA FACTURA INGRESADA';
			RETURN;
		END;
		--verificar que existe el id_empleado
		IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE @id_empleado=id_empleado)
		BEGIN
			PRINT 'NO EXISTE EL EMPLEADO INGRESADO';
			RETURN;
		END;

	DECLARE @estado_factura VARCHAR(10);
	DECLARE @cargo VARCHAR(50);

	-- Verificar si la factura está pagada
	SELECT @estado_factura = estado_factura
	FROM ddbba.Pedido
	WHERE id_factura = @id_factura;

	IF @estado_factura <> 'Pagado' 
	BEGIN
		PRINT 'Error: La nota de crédito solo puede modificarse para facturas pagadas.';
		RETURN;
	END;
	--verificacion que la cantidad a devolver no sea negativa nula
			IF @cantidadADevolver <=0
				BEGIN
			PRINT 'La cantidad no puede ser negativa o nula';
			RETURN;
				END;
			--verificar que motivo no sea nulo
			IF @motivo IS NULL
			BEGIN
				PRINT 'El motivo no puede ser nulo';
				return;
			END;
	-- Verificar si el empleado es un Supervisor
	SELECT @cargo = cargo 
	FROM ddbba.Empleado
	WHERE id_empleado = @id_empleado;

	IF @cargo <> 'Supervisor'
	BEGIN
		PRINT 'Error: Solo los supervisores pueden generar notas de crédito.';
		RETURN;
	END;

		

		--cantidad
		DECLARE @cantidad INT;
		SELECT  @cantidad=cantidad
		FROM ddbba.ProductoSolicitado PS
		WHERE @id_factura=PS.id_factura;

			--verificacion que la cantidad a devolver no sea mayor a la pagada
			IF @cantidadADevolver > @cantidad
				BEGIN
			PRINT 'La cantidad no puede mayor a la pagada';
			RETURN;
				END;

	-- Modificación de los datos
	UPDATE ddbba.NotaCredito
	SET 
		cantidadADevolver = @cantidadADevolver,
		motivo = @motivo
	WHERE id_nota_credito = @id_nota_credito;

	PRINT 'Nota de Crédito modificada correctamente.';
END;
GO

-- SP PARA ELIMINAR NOTA DE CRÉDITO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarNotaCredito')
BEGIN
	DROP PROCEDURE Procedimientos.eliminarNotaCredito;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarNotaCredito(
	@id_nota_credito INT -- ID de la Nota de Crédito a eliminar
)
AS
BEGIN
	-- Validación de NULL
	IF @id_nota_credito IS NULL
	BEGIN
		PRINT 'Error: El ID de la Nota de Crédito no puede ser nulo.';
		RETURN;
	END;

	-- Verificación de existencia de la Nota de Crédito
	IF NOT EXISTS (SELECT 1 FROM ddbba.NotaCredito WHERE id_nota_credito = @id_nota_credito)
	BEGIN
		PRINT 'Error: No existe la Nota de Crédito con ese ID.';
		RETURN;
	END;

	-- Eliminación de la Nota de Crédito
	DELETE FROM ddbba.NotaCredito WHERE id_nota_credito = @id_nota_credito;

	PRINT 'Nota de Crédito eliminada correctamente.';
END;
GO


-- SP PARA INSERTAR MEDIO DE PAGO---------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarMedioPago')
BEGIN
	DROP PROCEDURE Procedimientos.insertarMedioPago;
END;
GO
CREATE PROCEDURE Procedimientos.insertarMedioPago
	@tipo VARCHAR(50)
AS
BEGIN
	-- Validar que el parámetro no sea NULL
	IF @tipo IS NULL
	BEGIN
		PRINT 'Error: El tipo de medio de pago no puede ser nulo.';
		RETURN;
	END;

	-- Validar que el medio de pago sea Credit card, Cash o Ewallet
	IF @tipo NOT IN ('Credit card', 'Cash', 'Ewallet')
	BEGIN
		PRINT 'Error: El medio de pago debe ser Credit card, Cash o Ewallet.';
		RETURN;
	END;

	-- Convertir a español
	IF @tipo = 'Credit card' SET @tipo = 'Tarjeta de credito';
	IF @tipo = 'Cash' SET @tipo = 'Efectivo';
	IF @tipo = 'Ewallet' SET @tipo = 'Billetera Electronica';

	-- Validar que el medio de pago no exista
	IF EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE tipo = @tipo)
	BEGIN
		PRINT 'Error: El medio de pago ya existe.';
		RETURN;
	END;

	-- Insertar el medio de pago
	INSERT INTO ddbba.MedioPago (tipo) VALUES (@tipo);
	PRINT 'Medio de Pago ingresado correctamente.';

END;
GO

-- SP PARA MODIFICAR MEDIO DE PAGO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarMedioPago')
BEGIN
	DROP PROCEDURE Procedimientos.modificarMedioPago;
END;
GO
CREATE PROCEDURE Procedimientos.modificarMedioPago
	@id_mp INT,
	@nuevo_tipo VARCHAR(50)
AS
BEGIN
	-- Validar que el ID del medio de pago no sea NULL
	IF @id_mp IS NULL
	BEGIN
		PRINT 'Error: El ID del medio de pago no puede ser nulo.';
		RETURN;
	END;

	-- Validar que el nuevo tipo de pago no sea NULL
	IF @nuevo_tipo IS NULL
	BEGIN
		PRINT 'Error: El tipo de medio de pago no puede ser nulo.';
		RETURN;
	END;

	-- Validar que el medio de pago exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE id_mp = @id_mp)
	BEGIN
		PRINT 'Error: No existe un medio de pago con ese ID.';
		RETURN;
	END;

	-- Validar que el nuevo medio de pago sea Credit card, Cash o Ewallet
	IF @nuevo_tipo NOT IN ('Credit card', 'Cash', 'Ewallet')
	BEGIN
		PRINT 'Error: El medio de pago debe ser Credit card, Cash o Ewallet.';
		RETURN;
	END;

	-- Convertir a español
	IF @nuevo_tipo = 'Credit card' SET @nuevo_tipo = 'Tarjeta de credito';
	IF @nuevo_tipo = 'Cash' SET @nuevo_tipo = 'Efectivo';
	IF @nuevo_tipo = 'Ewallet' SET @nuevo_tipo = 'Billetera Electronica';

	-- Validar que el nuevo medio de pago no exista ya en la tabla
	IF EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE tipo = @nuevo_tipo)
	BEGIN
		PRINT 'Error: Ya existe un medio de pago con ese tipo.';
		RETURN;
	END;

	-- Actualizar el medio de pago
	UPDATE ddbba.MedioPago
	SET tipo = @nuevo_tipo
	WHERE id_mp = @id_mp;

	PRINT 'Medio de Pago modificado correctamente.';
END;
GO

-- SP PARA ELIMINAR MEDIO DE PAGO POR ID O NOMBRE
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarMedioPago')
BEGIN
	DROP PROCEDURE Procedimientos.eliminarMedioPago;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarMedioPago
	@id_medio_pago INT = NULL,
	@nombre_medio_pago VARCHAR(50) = NULL
AS
BEGIN
	-- Validar que al menos uno de los parámetros no sea NULL
	IF @id_medio_pago IS NULL AND @nombre_medio_pago IS NULL
	BEGIN
		PRINT 'Error: Debe especificar un ID o un nombre del medio de pago.';
		RETURN;
	END;

	-- Si se proporcionó el ID, validar que exista
	IF @id_medio_pago IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE id_mp = @id_medio_pago)
		BEGIN
			PRINT 'Error: No existe un medio de pago con ese ID.';
			RETURN;
		END;
		-- Eliminar el medio de pago por ID
		DELETE FROM ddbba.MedioPago WHERE id_mp = @id_medio_pago;
		PRINT 'Medio de Pago con ID ' + CAST(@id_medio_pago AS VARCHAR) + ' eliminado correctamente.';
		RETURN;
	END;

	-- Si se proporcionó el nombre, validar que exista
	IF @nombre_medio_pago IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM ddbba.MedioPago WHERE tipo = @nombre_medio_pago)
		BEGIN
			PRINT 'Error: No existe un medio de pago con ese nombre.';
			RETURN;
		END;
		-- Eliminar el medio de pago por nombre
		DELETE FROM ddbba.MedioPago WHERE tipo = @nombre_medio_pago;
		PRINT 'Medio de Pago con nombre ' + @nombre_medio_pago + ' eliminado correctamente.';
		RETURN;
	END;

END;
GO


--SP PARA SUCURSAL----------------------------------------------------------------------------
--insercion
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarSucursal')
BEGIN
	DROP PROCEDURE Procedimientos.insertarSucursal ;
END;
go
CREATE PROCEDURE Procedimientos.insertarSucursal 
	@localidad VARCHAR(100),
	@direccion VARCHAR(255),
	@horario VARCHAR(50),
	@telefono VARCHAR(20)
AS
BEGIN

	-- Validación de id_sucursal sea unico 
	IF EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE @localidad=localidad and @direccion=direccion) 
	BEGIN
		PRINT 'id sucursal ya existente';
        RETURN;
    END
	-- Validación de id_sucursal sea unico 
	IF @direccion IS NULL
	BEGIN
		PRINT 'La direccion no debe ser nula';
        RETURN;
    END
    --validacion de que la localidad se Ramos Mejia, Lomas del Mirador o San Justo
	IF @localidad NOT IN ('Ramos Mejia','Lomas del Mirador','San Justo') or @localidad IS NULL
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
    
    INSERT INTO ddbba.Sucursal (localidad,direccion,horario,telefono)
    VALUES (@localidad,@direccion,@horario,@telefono);
    
    PRINT 'Sucursal insertada correctamente';
END;
go
--modificacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarSucursal')
BEGIN
    DROP PROCEDURE Procedimientos.modificarSucursal;
END;
GO
CREATE PROCEDURE Procedimientos.modificarSucursal
    @localidad VARCHAR(100),
    @direccion VARCHAR(255),
    @nuevo_horario VARCHAR(50) = NULL,
    @nuevo_telefono VARCHAR(20) = NULL
AS
BEGIN
    -- Validación: Verificar si la sucursal existe con la localidad y dirección proporcionadas
    IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE localidad = @localidad AND direccion = @direccion)
    BEGIN
        PRINT 'Error: La sucursal no existe con la localidad y dirección proporcionadas.';
        RETURN;
    END;

    -- Validación: Verificar que el teléfono (si se proporciona) tenga 9 caracteres
    IF @nuevo_telefono IS NOT NULL AND LEN(@nuevo_telefono) != 9
    BEGIN
        PRINT 'Error: El teléfono debe tener 9 caracteres.';
        RETURN;
    END;

    -- Verificar que la localidad se encuentre en la lista válida
    IF @localidad NOT IN ('Ramos Mejia', 'Lomas del Mirador', 'San Justo')
    BEGIN
        PRINT 'Error: La localidad debe ser Ramos Mejia, Lomas del Mirador o San Justo.';
        RETURN;
    END;

    -- Actualizar los datos de la sucursal con los nuevos valores proporcionados
    UPDATE ddbba.Sucursal
    SET 
        horario = ISNULL(@nuevo_horario, horario),
        telefono = ISNULL(@nuevo_telefono, telefono)
    WHERE localidad = @localidad AND direccion = @direccion;

    PRINT 'Sucursal modificada correctamente';
END;
GO
--eliminacion
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarSucursal')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarSucursal;
END;
GO
CREATE PROCEDURE Procedimientos.eliminarSucursal
    @localidad VARCHAR(100),
    @direccion VARCHAR(255)
AS
BEGIN
    -- Validación: Verificar si la sucursal existe con la localidad y dirección proporcionadas
    IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE localidad = @localidad AND direccion = @direccion)
    BEGIN
        PRINT 'Error: La sucursal no existe con la localidad y dirección proporcionadas.';
        RETURN;
    END;

    -- Eliminar la sucursal
    DELETE FROM ddbba.Sucursal WHERE localidad = @localidad AND direccion = @direccion;

    PRINT 'Sucursal eliminada correctamente';
END;
GO


--SP PARA INSERTAR PROVEEDOR---------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProveedor')
BEGIN
	DROP PROCEDURE Procedimientos.insertarProveedor ;
END;
go
CREATE PROCEDURE Procedimientos.insertarProveedor
    @nombre NVARCHAR(255)
AS
BEGIN
        -- Validar que el nombre no sea nulo 
        IF (@nombre IS NULL OR @nombre = ' ')
        BEGIN
            PRINT 'El nombre del proveedor no puede ser nulo.'
            RETURN; 
        END;

        -- Validar que el proveedor no exista ya en la tabla
        IF EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE nombre = @nombre)
        BEGIN
            PRINT 'El proveedor ya existe en la tabla Proveedor.'
            RETURN;
        END

        -- Insertar los datos en la tabla
        INSERT INTO ddbba.Proveedor (nombre)
        VALUES (@nombre)
        PRINT 'Proveedor insertado correctamente.';
 
END;
go
-- SP PARA MODIFICAR PROVEEDOR
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarProveedor')
BEGIN
    DROP PROCEDURE Procedimientos.modificarProveedor;
END;
go
CREATE PROCEDURE Procedimientos.modificarProveedor
    @id_proveedor INT,
    @nuevo_nombre NVARCHAR(255)
AS
BEGIN
    -- Validar que el nombre no sea nulo
    IF (@nuevo_nombre IS NULL)
    BEGIN
        PRINT 'El nombre del proveedor no puede ser nulo.';
        RETURN;
    END;

    -- Validar que el proveedor exista
    IF NOT EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        PRINT 'El proveedor no existe en la base de datos.';
        RETURN;
    END;

    -- Validar que el nuevo nombre no exista ya para otro proveedor
    IF EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE nombre = @nuevo_nombre AND id_proveedor != @id_proveedor)
    BEGIN
        PRINT 'Ya existe otro proveedor con el mismo nombre.';
        RETURN;
    END;

    -- Actualizar el nombre del proveedor
    UPDATE ddbba.Proveedor
    SET nombre = @nuevo_nombre
    WHERE id_proveedor = @id_proveedor;

    PRINT 'Proveedor actualizado correctamente.';
END;
go
-- SP PARA ELIMINAR PROVEEDOR
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarProveedor')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarProveedor;
END;
go
CREATE PROCEDURE Procedimientos.eliminarProveedor
    @id_proveedor INT
AS
BEGIN
    -- Validar que el proveedor exista
    IF NOT EXISTS (SELECT 1 FROM ddbba.Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        PRINT 'El proveedor no existe en la base de datos.';
        RETURN;
    END;

    -- Eliminar el proveedor
    DELETE FROM ddbba.Proveedor WHERE id_proveedor = @id_proveedor;

    PRINT 'Proveedor eliminado correctamente.';
END;
go

--SP PARA INSERTAR ProductoSolicitado------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'insertarProductoSolicitado')
BEGIN
    DROP PROCEDURE Procedimientos.insertarProductoSolicitado;
END;
go
CREATE PROCEDURE Procedimientos.insertarProductoSolicitado
    @id_factura CHAR(12),
    @id_producto INT,
    @cantidad INT
AS
BEGIN
    -- Validar que los parámetros no sean nulos
    IF (@id_factura IS NULL)
    BEGIN
        PRINT 'El id_factura no puede ser nulo';
        RETURN;
    END;

    IF (@id_producto IS NULL)
    BEGIN
        PRINT 'El id_producto no puede ser nulo';
        RETURN;
    END;

    IF (@cantidad IS NULL)
    BEGIN
        PRINT 'La cantidad no puede ser nula';
        RETURN;
    END;
	    -- Verificar que la cantidad pedida sea mayor a cero
    IF (@cantidad <= 0)
    BEGIN
        PRINT 'La cantidad debe ser mayor a cero';
        RETURN;
    END;

    -- Verificar que no se inserten datos duplicados
    IF EXISTS (SELECT 1 FROM ddbba.ProductoSolicitado WHERE id_producto = @id_producto AND @id_factura = id_factura)
    BEGIN
        PRINT 'El pedido ya tiene esos datos';
        RETURN;
    END;

    -- Verificar si el producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto)
    BEGIN
        PRINT 'El producto no existe';
        RETURN;
    END;

    -- Verificar que el pedido exista
    IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE @id_factura = id_factura)
    BEGIN
        PRINT 'El pedido no existe';
        RETURN;
    END;



    -- Insertar los datos en la tabla
    INSERT INTO ddbba.ProductoSolicitado(id_producto, id_factura, cantidad)
    VALUES (@id_producto, @id_factura, @cantidad);

    PRINT 'Valores insertados correctamente';
END;
go

-- SP PARA MODIFICAR Producto_Solicitado
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'modificarProductoSolicitado')
BEGIN
    DROP PROCEDURE Procedimientos.modificarProductoSolicitado;
END;
go
CREATE PROCEDURE Procedimientos.modificarProductoSolicitado
    @id_factura CHAR(12),
    @id_producto INT,
    @cantidad INT
AS
BEGIN
    -- Validar que los parámetros no sean nulos
    IF (@id_factura IS NULL)
    BEGIN
        PRINT 'El id_factura no puede ser nulo';
        RETURN;
    END;

    IF (@id_producto IS NULL)
    BEGIN
        PRINT 'El id_producto no puede ser nulo';
        RETURN;
    END;

    IF (@cantidad IS NULL)
    BEGIN
        PRINT 'La cantidad no puede ser nula';
        RETURN;
    END;

    -- Verificar si el producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto)
    BEGIN
        PRINT 'El producto no existe';
        RETURN;
    END;

    -- Verificar que el pedido exista
    IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE @id_factura = id_factura)
    BEGIN
        PRINT 'El pedido no existe';
        RETURN;
    END;

    -- Verificar si el registro ya existe en ProductoSolicitado
    IF NOT EXISTS (SELECT 1 FROM ddbba.ProductoSolicitado WHERE id_producto = @id_producto AND id_factura = @id_factura)
    BEGIN
        PRINT 'El producto solicitado no existe en la factura';
        RETURN;
    END;

    -- Verificar que la cantidad pedida sea mayor a cero
    IF (@cantidad <= 0)
    BEGIN
        PRINT 'La cantidad debe ser mayor a cero';
        RETURN;
    END;

    -- Modificar los datos en la tabla ProductoSolicitado
    UPDATE ddbba.ProductoSolicitado
    SET cantidad = @cantidad
    WHERE id_producto = @id_producto AND id_factura = @id_factura;

    PRINT 'Valores modificados correctamente';
END;
go

-- SP PARA ELIMINAR Producto_Solicitado
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'eliminarProductoSolicitado')
BEGIN
    DROP PROCEDURE Procedimientos.eliminarProductoSolicitado;
END;
go
CREATE PROCEDURE Procedimientos.eliminarProductoSolicitado
    @id_factura CHAR(12),
    @id_producto INT
AS
BEGIN
    -- Validar que los parámetros no sean nulos
    IF (@id_factura IS NULL)
    BEGIN
        PRINT 'El id_factura no puede ser nulo';
        RETURN;
    END;

    IF (@id_producto IS NULL)
    BEGIN
        PRINT 'El id_producto no puede ser nulo';
        RETURN;
    END;

    -- Verificar que el producto existe
    IF NOT EXISTS (SELECT 1 FROM ddbba.Producto WHERE id_producto = @id_producto)
    BEGIN
        PRINT 'El producto no existe';
        RETURN;
    END;

    -- Verificar que el pedido exista
    IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE @id_factura = id_factura)
    BEGIN
        PRINT 'El pedido no existe';
        RETURN;
    END;

    -- Verificar que el producto solicitado exista en la factura
    IF NOT EXISTS (SELECT 1 FROM ddbba.ProductoSolicitado WHERE id_producto = @id_producto AND id_factura = @id_factura)
    BEGIN
        PRINT 'El producto solicitado no existe en la factura';
        RETURN;
    END;

    -- Eliminar el producto solicitado de la tabla
    DELETE FROM ddbba.ProductoSolicitado
    WHERE id_producto = @id_producto AND id_factura = @id_factura;

    PRINT 'Producto solicitado eliminado correctamente';
END;
go




--REPORTES
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

--Crear el Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Rep')
	BEGIN
		EXEC('CREATE SCHEMA Rep');
		PRINT ' Schema creado exitosamente';
	END;
go


--REPORTE Mensual: ingresando un mes y año determinado mostrar el total facturado por días de la semana, incluyendo sábado y domingo.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Reporte_FacturacionMensual_XML') 
BEGIN
    DROP PROCEDURE Rep.Reporte_FacturacionMensual_XML;
    PRINT 'SP Reporte_FacturacionMensual_XML ya existe -- > se creara nuevamente';
END;
GO
CREATE PROCEDURE Rep.Reporte_FacturacionMensual_XML
    @Mes INT,
    @Anio INT
AS
BEGIN
    -- Valida que se un mes válido
    IF @Mes > 12 OR @Mes < 1
    BEGIN
        PRINT 'Mes inválido';
        RETURN;
    END;

    -- Valida que sea un año válido
    IF @Anio > YEAR(GETDATE()) OR @Anio < 1800
    BEGIN
        PRINT 'Año inválido';
        RETURN;
    END;
    -- Consulta para obtener el total facturado por día de la semana 
	WITH VentasDelMes as (
	SELECT ped.fecha_pedido, precio_unitario,cantidad
	FROM ddbba.Pedido ped
	INNER JOIN ddbba.ProductoSolicitado ps ON ps.id_factura=ped.id_factura
	INNER JOIN ddbba.Producto p ON p.id_producto = ps.id_producto
	WHERE MONTH(ped.fecha_pedido) = @Mes and YEAR(ped.fecha_pedido) = @Anio
	)

	SELECT DATENAME(WEEKDAY, fecha_pedido) AS DiaSemana, 
			SUM(precio_unitario*cantidad) as TotalFacturado
	FROM VentasDelMes
	GROUP BY DATENAME(WEEKDAY, fecha_pedido)
    FOR XML PATH('Dia'), ROOT('FacturacionMensual');
END;
GO


--Trimestral: mostrar el total facturado por turnos de trabajo por mes.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerFacturacionPorTrimestreXML') 
BEGIN
    DROP PROCEDURE Rep.ObtenerFacturacionPorTrimestreXML;
    PRINT 'SP ObtenerFacturacionPorTrimestreXML ya existe -- > se creara nuevamente';
END;
GO
CREATE PROCEDURE Rep.ObtenerFacturacionPorTrimestreXML
    @Anio INT,
    @Trimestre INT
AS
BEGIN
    -- Valida que se un año válido
    IF @Anio > YEAR(GETDATE()) OR @Anio < 1800
    BEGIN
        PRINT 'Año inválido';
        RETURN;
    END;

    -- Valida que se un trimestre válido
    IF @Trimestre > 4 OR @Trimestre < 1
    BEGIN
        PRINT 'Trimestre inválido';
        RETURN;
    END;

    DECLARE @MesInicio INT, @MesFin INT;

    -- Determinar los meses del trimestre
    IF @Trimestre = 1
    BEGIN
        SET @MesInicio = 1;
        SET @MesFin = 3;
    END
    ELSE IF @Trimestre = 2
    BEGIN
        SET @MesInicio = 4;
        SET @MesFin = 6;
    END
    ELSE IF @Trimestre = 3
    BEGIN
        SET @MesInicio = 7;
        SET @MesFin = 9;
    END
    ELSE IF @Trimestre = 4
    BEGIN
        SET @MesInicio = 10;
        SET @MesFin = 12;
    END;


    SELECT
        E.turno AS 'Turno',
        MONTH(Ped.fecha_pedido) AS 'Mes',
        SUM(PS.cantidad * Pr.precio_unitario) OVER (PARTITION BY E.turno, MONTH(Ped.fecha_pedido)) AS 'TotalFacturado'
    FROM
        ddbba.ProductoSolicitado PS
    INNER JOIN ddbba.Pedido Ped ON PS.id_factura = Ped.id_factura
	INNER JOIN ddbba.Empleado E ON E.id_empleado=Ped.id_empleado
	INNER JOIN ddbba.Producto Pr ON Pr.id_producto=PS.id_producto
	WHERE YEAR(Ped.fecha_pedido) = @Anio
        AND MONTH(Ped.fecha_pedido) BETWEEN @MesInicio AND @MesFin
    ORDER BY
        E.turno, MONTH(Ped.fecha_pedido) 
    FOR XML PATH('Factura'), ROOT('Facturas');
END;
GO

--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango, ordenado de mayor a menor.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Reporte_ProductosVendidos_XML') 
BEGIN
    DROP PROCEDURE Rep.Reporte_ProductosVendidos_XML;
    PRINT 'SP Reporte_ProductosVendidos_XML ya existe -- > se creara nuevamente';
END;
GO
CREATE PROCEDURE Rep.Reporte_ProductosVendidos_XML
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    --validar que la fecha de inicio sea más chica que la fecha de fin
    IF @FechaFin < @FechaInicio
    BEGIN
        PRINT 'La fecha de fin debe ser más grande que la fecha de inicio!';
        RETURN;
    END;
  --validar que la fecha ingresada
    IF @FechaInicio > GETDATE()
    BEGIN
        PRINT 'La fecha de inicio no debe ser futura';
        RETURN;
    END;
    --validar que la fecha ingresada
    IF @FechaFin > GETDATE()
    BEGIN
        PRINT 'La fecha de fin no debe ser futura';
        RETURN;
    END;
 
    ;WITH ProductoVentas AS (
        SELECT 
            P.id_producto,
            P.nombre_producto,
            SUM(PS.cantidad) AS CantidadVendida,
            RANK() OVER (ORDER BY SUM(PS.cantidad) DESC) AS Ranking
        FROM ddbba.ProductoSolicitado PS
        INNER JOIN ddbba.Producto P ON PS.id_producto = P.id_producto
        INNER JOIN ddbba.Pedido Ped ON PS.id_factura = Ped.id_factura
        WHERE Ped.fecha_pedido BETWEEN @FechaInicio AND @FechaFin
        GROUP BY P.id_producto, P.nombre_producto
    )
    SELECT 
        id_producto,
        nombre_producto,
        CantidadVendida,
        Ranking
    FROM ProductoVentas
    ORDER BY Ranking 
    FOR XML PATH('Producto'), ROOT('ReporteProductosVendidos');
END;
GO


--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango por sucursal, ordenado de mayor a menor.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerVentasPorRangoFechasXML') 
BEGIN
	 DROP PROCEDURE Rep.ObtenerVentasPorRangoFechasXML;
	 PRINT 'SP ObtenerFacturacionPorTrimestreXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE Rep.ObtenerVentasPorRangoFechasXML
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
	--validar que la fecha de inicio sea más chica que la fecha de fin
    IF @FechaFin < @FechaInicio
    BEGIN
        PRINT 'La fecha de fin debe ser más grande que la fecha de inicio!';
        RETURN;
    END;
  --validar que la fecha ingresada
    IF @FechaInicio > GETDATE()
    BEGIN
        PRINT 'La fecha de inicio no debe ser futura';
        RETURN;
    END;
    --validar que la fecha ingresada
    IF @FechaFin > GETDATE()
    BEGIN
        PRINT 'La fecha de fin no debe ser futura';
        RETURN;
    END;
    SELECT 
        S.localidad AS Sucursal,
        SUM(PS.cantidad) AS CantidadVendida
    FROM ddbba.ProductoSolicitado PS
    INNER JOIN ddbba.Pedido Ped ON PS.id_factura = Ped.id_factura
    INNER JOIN ddbba.Sucursal S ON Ped.id_sucursal = S.id_sucursal

    WHERE Ped.fecha_pedido BETWEEN @FechaInicio AND @FechaFin
    GROUP BY S.localidad
    ORDER BY CantidadVendida DESC
    FOR XML PATH('Venta'), ROOT('ReporteVentas');
END;
go


--REPORTE Mostrar los 5 productos más vendidos en un mes, por semana 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerTopProductosPorSemanaXML') 
BEGIN
    DROP PROCEDURE Rep.ObtenerTopProductosPorSemanaXML;
    PRINT 'SP ObtenerTopProductosPorSemanaXML ya existe -- > se creara nuevamente';
END;
GO
CREATE PROCEDURE Rep.ObtenerTopProductosPorSemanaXML
     @Mes INT,
     @Anio INT
AS
BEGIN
    -- Validación del mes
    IF @Mes > 12 OR @Mes < 1
    BEGIN
        PRINT 'Mes inválido';
        RETURN;
    END;

    -- Validación del año
    IF @Anio > YEAR(GETDATE()) OR @Anio < 1800
    BEGIN
        PRINT 'Año inválido';
        RETURN;
    END;

    WITH Semanas AS (
        SELECT 
            DATEPART(WEEK, Ped.fecha_pedido) - DATEPART(WEEK, DATEFROMPARTS(@Anio, @Mes, 1)) + 1 AS Semana, --muestra la semana del mes y no del anio
            P.id_producto,
            P.nombre_producto,
            SUM(PS.cantidad) AS CantidadVendida,
            RANK() OVER (PARTITION BY DATEPART(WEEK, Ped.fecha_pedido) ORDER BY SUM(PS.cantidad) DESC) AS Ranking
        FROM ddbba.ProductoSolicitado PS
        INNER JOIN ddbba.Producto P ON PS.id_producto = P.id_producto
        INNER JOIN ddbba.Pedido Ped ON PS.id_factura = Ped.id_factura
        WHERE YEAR(Ped.fecha_pedido) = @Anio
          AND MONTH(Ped.fecha_pedido) = @Mes
        GROUP BY DATEPART(WEEK, Ped.fecha_pedido), P.id_producto, P.nombre_producto
    )
    SELECT 
        Semana,
        id_producto,
        nombre_producto,
        CantidadVendida
    FROM Semanas
    WHERE Ranking <= 5
    ORDER BY Semana, Ranking
    FOR XML PATH('Producto'), ROOT('TopProductos');
END;
GO


--REPORTE Mostrar los 5 productos menos vendidos en el mes. 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerMenoresProductosDelMesXML') 
BEGIN
	 DROP PROCEDURE Rep.ObtenerMenoresProductosDelMesXML;
	 PRINT 'SP ObtenerMenoresProductosDelMesXML ya existe --> se creará nuevamente';
END;
GO
CREATE PROCEDURE Rep.ObtenerMenoresProductosDelMesXML
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación del mes
    IF @Mes > 12 OR @Mes < 1
    BEGIN
        PRINT 'Mes inválido';
        RETURN;
    END;

    -- Validación del año
    IF @Anio > YEAR(GETDATE()) OR @Anio < 1800
    BEGIN
        PRINT 'Año inválido';
        RETURN;
    END;


    WITH VentasMes AS (
        SELECT 
            P.id_producto,
            P.nombre_producto,
            SUM(PS.cantidad) AS CantidadVendida,
            RANK() OVER (ORDER BY SUM(PS.cantidad) ASC) AS RangoVentas
        FROM ddbba.ProductoSolicitado PS
        INNER JOIN ddbba.Producto P ON PS.id_producto = P.id_producto
        INNER JOIN ddbba.Pedido Ped ON PS.id_factura = Ped.id_factura
        WHERE YEAR(Ped.fecha_pedido) = @Anio
          AND MONTH(Ped.fecha_pedido) = @Mes
        GROUP BY P.id_producto, P.nombre_producto
    )
    SELECT 
        V.id_producto,
        V.nombre_producto,
        V.CantidadVendida
    FROM VentasMes V
    WHERE V.RangoVentas <= 5 -- Filtra los 5 productos menos vendidos
    ORDER BY V.CantidadVendida ASC 
    FOR XML PATH('Producto'), ROOT('BottomProductos');
END;
GO


--REPORTE Mostrar total acumulado de ventas (o sea también mostrar el detalle) para una fecha y sucursal particulares 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerVentasPorFechaYSucursalXML') 
BEGIN
	 DROP PROCEDURE Rep.ObtenerVentasPorFechaYSucursalXML;
	 PRINT 'SP ObtenerVentasPorFechaYSucursalXML ya existe --> se creará nuevamente';
END;
GO
CREATE PROCEDURE Rep.ObtenerVentasPorFechaYSucursalXML
    @Fecha DATE,
    @SucursalID INT
AS
BEGIN
    SET NOCOUNT ON; 

    -- Validar que la sucursal exista
    IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE id_sucursal = @SucursalID)
    BEGIN
        PRINT 'Sucursal no existe';
        RETURN;
    END;

    -- Obtener detalle de ventas con total acumulado usando Window Functions
    WITH VentasDetalle AS (
        SELECT 
            P.id_producto,
            P.nombre_producto,
            SUM(PS.cantidad) AS CantidadVendida,
            SUM(PS.cantidad * P.precio_unitario) AS TotalVenta,
            SUM(SUM(PS.cantidad * P.precio_unitario)) OVER()   AS TotalAcumulado -- Total acumulado de la venta
        FROM ddbba.ProductoSolicitado PS
        INNER JOIN ddbba.Producto P ON PS.id_producto = P.id_producto
       INNER JOIN ddbba.Pedido Ped ON PS.id_factura = Ped.id_factura
        WHERE Ped.fecha_pedido = @Fecha
          AND Ped.id_sucursal = @SucursalID
        GROUP BY P.id_producto, P.nombre_producto
    )
    
    SELECT 
        V.id_producto,
        V.nombre_producto,
        V.CantidadVendida,
        V.TotalVenta,
        NULL AS TotalAcumulado -- Para diferenciar productos del total acumulado
    FROM VentasDetalle V

    UNION ALL 

    SELECT 
        NULL AS id_producto,
        'Total Acumulado' AS nombre_producto,
        NULL AS CantidadVendida,
        NULL AS TotalVenta,
        MAX(V.TotalAcumulado) AS TotalAcumulado -- Total acumulado en una sola fila
    FROM VentasDetalle V

   FOR XML PATH('Producto'), ROOT('ReporteVentas');
END;
GO


--REPORTE Mensual: ingresando un mes y año determinado mostrar el vendedor de mayor monto facturado por sucursal. 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Reporte_VendedorTopPorSucursal_XML') 
BEGIN
	 DROP PROCEDURE Rep.Reporte_VendedorTopPorSucursal_XML;
	 PRINT 'SP Reporte_VendedorTopPorSucursal_XML ya existe --> se creará nuevamente';
END;
GO
CREATE PROCEDURE Rep.Reporte_VendedorTopPorSucursal_XML
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON; 

    -- Validar mes y año
    IF @Mes < 1 OR @Mes > 12
    BEGIN
        PRINT 'Mes inválido';
        RETURN;
    END;
    
    IF @Anio < 1800 OR @Anio > YEAR(GETDATE())
    BEGIN
        PRINT 'Año inválido';
        RETURN;
    END;

    -- Obtener facturación por vendedor y determinar el top 1 por sucursal usando RANK()
    WITH FacturacionPorVendedor AS (
        SELECT 
            E.id_empleado,
            S.id_sucursal,
            S.localidad AS LocalidadSucursal,
            SUM(PS.cantidad * P.precio_unitario) AS TotalFacturado,
            RANK() OVER (PARTITION BY S.id_sucursal ORDER BY SUM(PS.cantidad * P.precio_unitario) DESC) AS Rnk -- Ordena de mayor a menor dentro de cada sucursal
        FROM ddbba.Pedido Ped
		INNER JOIN ddbba.Empleado E ON Ped.id_empleado = E.id_empleado
		INNER JOIN ddbba.Sucursal S ON Ped.id_sucursal = S.id_sucursal
        INNER JOIN ddbba.ProductoSolicitado PS ON Ped.id_factura = PS.id_factura
        INNER JOIN ddbba.Producto P ON PS.id_producto = P.id_producto
        
       
        WHERE MONTH(Ped.fecha_pedido) = @Mes 
          AND YEAR(Ped.fecha_pedido) = @Anio
        GROUP BY E.id_empleado, S.id_sucursal, S.localidad
    )

    -- Seleccionar solo los mejores vendedores (RANK = 1) por sucursal
    SELECT 
        FV.id_sucursal AS Id_sucursal,
        FV.LocalidadSucursal AS Localidad,
        FV.id_empleado AS LegajoEmpleado,
        FV.TotalFacturado AS Total_facturado
    FROM FacturacionPorVendedor FV
    WHERE FV.Rnk = 1 -- Solo los vendedores top por sucursal
    FOR XML PATH('Reporte'), ROOT('FacturacionMensual');
END;
GO

--TRIGGER DE ENCRIPTACION
------------------------------------------------------------------------------------------------------------------------------------------------
--AGREGAR CAMPOS PARA ENCRIPTAR

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'nombre_enc')
    ALTER TABLE ddbba.Empleado ADD nombre_enc VARBINARY(MAX);
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'apellido_enc')
    ALTER TABLE ddbba.Empleado ADD apellido_enc VARBINARY(MAX);
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'dni_enc')
    ALTER TABLE ddbba.Empleado ADD dni_enc VARBINARY(MAX);
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'direccion_enc')
    ALTER TABLE ddbba.Empleado ADD direccion_enc VARBINARY(MAX);
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'cuil_enc')
    ALTER TABLE ddbba.Empleado ADD cuil_enc VARBINARY(MAX);
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'email_personal_enc')
    ALTER TABLE ddbba.Empleado ADD email_personal_enc VARBINARY(MAX);
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'ddbba' AND TABLE_NAME = 'Empleado' AND COLUMN_NAME = 'email_empresarial_enc')
    ALTER TABLE ddbba.Empleado ADD email_empresarial_enc VARBINARY(MAX);
GO

--TRIGGER PARA QUE CADA VEZ QUE SE INGRESA UN REGISTRO A LA TABLA, LOS DATOS SENSIBLES SON ENCRIPTADOS (SE ENCUENTRA DESACTIVADO)
IF EXISTS (SELECT 1 FROM sys.triggers WHERE name='trg_Empleado_Encrypt')
    DROP TRIGGER ddbba.trg_Empleado_Encrypt;
GO
CREATE TRIGGER ddbba.trg_Empleado_Encrypt
ON ddbba.Empleado
AFTER INSERT
AS
BEGIN
		-- Encriptar y actualizar las columnas encriptadas
		UPDATE e
		SET 
			e.nombre_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', i.nombre),
			e.apellido_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', i.apellido),
			e.dni_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', CAST(i.dni AS VARCHAR)),
			e.direccion_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', i.direccion),
			e.cuil_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', i.cuil),
			e.email_personal_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', i.email_personal),
			e.email_empresarial_enc = ENCRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', i.email_empresarial)
		FROM ddbba.Empleado e
		INNER JOIN inserted i ON e.id_empleado = i.id_empleado;

		-- Opcional: Eliminar los datos visibles o ponerlos en NULL (si no se van a necesitar)
		UPDATE e
		SET 
			e.nombre = NULL,
			e.apellido = NULL,
			e.dni = NULL,
			e.direccion = NULL,
			e.cuil = NULL,
			e.email_personal = NULL,
			e.email_empresarial = NULL
		FROM ddbba.Empleado e
		INNER JOIN inserted i ON e.id_empleado = i.id_empleado;
END;
PRINT 'TRIGGER CREADO CORRECTAMENTE';
GO