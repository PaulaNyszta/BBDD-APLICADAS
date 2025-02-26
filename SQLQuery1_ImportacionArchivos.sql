Use Com1353G01
-----------------------------------------------------------------------------------------------------------------------
-- Procedimiento para importar Electronic accessories.xlsx
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_ElectronicAccessories') 
BEGIN
	 DROP PROCEDURE Importar_ElectronicAccessories;
	 PRINT 'SP Importar_ElectronicAccessories ya existe -- > se borro';
END;
go
CREATE PROCEDURE Importar_ElectronicAccessories
	@RutaArchivo NVARCHAR(255)
AS
BEGIN
	--creat tabla temporal para cargar los datos
	CREATE TABLE #Temp (
		id INT IDENTITY(1,1),
		precio_unitario DECIMAL(10,2),
		nombre_producto VARCHAR(100),
		moneda VARCHAR(7))
		

		-- Importar datos desde Excel a #temp
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL ='
	
	INSERT INTO #Temp (nombre_producto, precio_unitario, moneda)
	SELECT Product, [Precio Unitario en dolares], ''USD''
	FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
		''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
		''SELECT [Product], [Precio Unitario en dolares] FROM [Sheet1$]'')';
	EXEC sp_executesql @SQL; --consultas dinamicas

	--paso el contenido de 3temp como parametros para sp insertarproducto

	DECLARE @contador INT = 1, @totalFilas INT;
	SELECT @totalFilas = COUNT(*) FROM #Temp;

	WHILE @contador <= @totalFilas
	BEGIN
		DECLARE  @id INT, @nombre_producto VARCHAR(100), @precio_unitario DECIMAL(10,2), @moneda VARCHAR(7)
		SELECT
			@id = id, @nombre_producto = nombre_producto, @precio_unitario = precio_unitario, @moneda = moneda
		FROM #Temp WHERE id = @contador;

		EXEC ddbba.insertarProducto 
			@nombre_producto,
			@precio_unitario, --precio unitario
			'Electrodomestico', --linea
			0, --precio ref
			'', --unidad
			'', --cantxunidad
			@moneda, --moneda
			'' --fecha
		SET @contador = @contador + 1;
	END;

	DROP TABLE #Temp;
END;
go
PRINT 'SP Importar_ElectronicAccessories se creo exitosamente';
go
--ejecutar el Store procedure
EXEC Importar_ElectronicAccessories 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\Electronic accessories.xlsx';
go
----fijarse
--SELECT * FROM ddbba.Producto
SELECT * FROM #Temp
DROP TABLE #Temp
----borrar el SP
--DROP PROCEDURE Importar_ElectronicAccessories
--para solucionar error 7099, 7050 Win+R -->services.msc -->SQL Server (SQLEXPRESS)--> propiedades-->iniciar sesion-->cabiar a "Cuenta del sistema local", Marca la casilla "Permitir que el servicio interactúe con el escritorio".

------------------------------------------------------------------------------------
-- Procedimiento para importar Productos_importados.xlsx
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Productos_importados') 
BEGIN
	 DROP PROCEDURE Importar_Productos_importados;
	 PRINT 'SP Importar_Productos_importados ya existe -- > se borro';
END;
go
CREATE PROCEDURE Importar_Productos_importados
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    --crear tabla temporal para cargar los datos
	CREATE TABLE #Temp (
		id INT IDENTITY(1,1),
		precio_unitario DECIMAL(10,2),
		nombre_producto VARCHAR(100),
		moneda VARCHAR(7),
		linea VARCHAR(50),
		cantidadPorUnidad NVARCHAR(50),
		proveedor NVARCHAR(255))


    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL ='
    INSERT INTO #Temp (nombre_producto, linea, cantidadPorUnidad, precio_unitario,proveedor, moneda)
    SELECT [NombreProducto], [Categoría], [CantidadPorUnidad], [PrecioUnidad], [Proveedor],''ARS''
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [NombreProducto], [Categoría], [CantidadPorUnidad], [PrecioUnidad],[Proveedor] FROM [Listado de Productos$]'')';
    
    EXEC sp_executesql @SQL;

	--paso el contenido de #temp como parametros para sp insertarproducto

	DECLARE @contador INT = 1, @totalFilas INT;
	SELECT @totalFilas = COUNT(*) FROM #Temp;

	WHILE @contador <= @totalFilas
	BEGIN
		DECLARE  @id INT, @nombre_producto NVARCHAR(255), @precio_unitario DECIMAL(10,2), @moneda VARCHAR(7), @linea VARCHAR(100), @cantidadPorUnidad NVARCHAR(50), @proveedor NVARCHAR(255) 
		SELECT
			@id = id, @nombre_producto = nombre_producto, @precio_unitario = precio_unitario, @moneda = moneda, @linea = linea, @cantidadPorUnidad = cantidadPorUnidad, @proveedor = proveedor
		FROM #Temp WHERE id = @contador;

		
		EXEC ddbba.insertarProducto 
			@nombre_producto,
			@precio_unitario, --precio unitario
			@linea, --linea
			0, --precio ref
			'', --unidad
			@cantidadPorUnidad, --cantxunidad
			@moneda, --moneda
			'';--fecha
			
		--inserto tambien el proveedor en su tabla correspondiente
		EXEC ddbba.insertarProveedor
			@proveedor;

		--inserto tambien el proveedor y producto en su tabla correspondienTE
		DECLARE @id_proveedor int
		SELECT @id_proveedor = id_proveedor
		FROM ddbba.Proveedor
		WHERE @proveedor = nombre

		EXEC ddbba.insertarprovee
			@id_proveedor,
			@id --id de producto

		SET @contador = @contador + 1;
	END;

	DROP TABLE #Temp;
	
END;
go


--ejecutar el Store procedure
EXEC Importar_Productos_importados 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\Productos_importados.xlsx';
go
----fijarse
SELECT * FROM ddbba.Producto
select * from ddbba.Proveedor
select * from ddbba.Provee
----borrar el SP
--DROP PROCEDURE Importar_Productos_importados

EXEC Borrar



---------------------------------------------------------------------------------------------
-- Procedimiento para importar catalogo.csv
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Catalogo') 
BEGIN
	 DROP PROCEDURE Importar_Catalogo;
	 PRINT 'SP Importar_Catalogo ya existe -- > se borro';
END;
go
CREATE PROCEDURE Importar_Catalogo
    @RutaArchivo NVARCHAR(255), @RutaArchivoClasificacion NVARCHAR(255)
AS
BEGIN 
	DECLARE @SQL NVARCHAR(MAX);

    --crear tabla temporal para cargar los datos del catalogo
	CREATE TABLE #Temp (
				id int identity(1,1),
				linea VARCHAR(50),
				nombre_producto  VARCHAR(100),
				precio_unitario DECIMAL(10, 2),
				precio_referencia decimal (10,2),
				unidad varchar(10),
				fecha datetime
			)
	
		SET @SQL = ' 
		BULK INSERT #Temp
		FROM ''' + @RutaArchivo + '''
		WITH (
			FORMAT = ''CSV'',
			FIRSTROW = 2,
			FIELDTERMINATOR = '','',
			ROWTERMINATOR = ''0X0a'',
			CODEPAGE = ''65001'',
			TABLOCK
		);';
		
		EXEC sp_executesql @SQL;

	--crear tabla temporal para cargar los datos de la clasificacion de archivos
	CREATE TABLE #Temp_clasificacion (
				linea_clasificacion VARCHAR(50),
				tipo_producto VARCHAR(50)
			)
    
		SET @SQL =' 
    INSERT INTO #Temp_clasificacion (linea_clasificacion, tipo_producto)
    SELECT [Línea de producto],[Producto]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivoClasificacion + ';HDR=YES'',
        ''SELECT [Línea de producto],[Producto] FROM [Clasificacion productos$]'')';
		EXEC sp_executesql @SQL;

	--paso el contenido de #temp como parametros para sp insertarproducto
	DECLARE @contador INT = 1, @totalFilas INT;
	SELECT @totalFilas = COUNT(*) FROM #Temp;

	WHILE @contador <= @totalFilas
	BEGIN
		DECLARE  @id INT, @nombre_producto VARCHAR(100), @linea VARCHAR(50), @precio_unitario DECIMAL(10,2), @precio_referencia DECIMAL(10,2), @unidad VARCHAR(10), @fecha DATETIME, @moneda VARCHAR(7)
		SELECT
			@id = id, @nombre_producto = nombre_producto, @precio_unitario = precio_unitario, @precio_referencia = precio_referencia,@unidad = unidad,@fecha = fecha
		FROM #Temp WHERE id = @contador;

		--que la categoria del archivo coincida con la categorias de los productos
		SELECT TOP 1 @linea = linea_clasificacion
		FROM #Temp T inner join #Temp_clasificacion TC on T.linea=TC.tipo_producto
		WHERE id = @contador;

		EXEC ddbba.insertarProducto 
			@nombre_producto,
			@precio_unitario, --precio unitario
			@linea, --linea
			@precio_referencia, --precio ref
			@unidad, --unidad
			'', --cantxunidad
			'ARS', --moneda
			@fecha --fecha

		SET @contador = @contador + 1;
	END;

	DROP TABLE #Temp;

END;
go

--ejecutar el Store procedure
EXEC Importar_Catalogo 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\catalogo.csv', 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Informacion_complementaria.xlsx'
go
----fijarse
--SELECT * FROM ddbba.Producto



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Procedimiento para importar Informacion_complementaria.xlsx 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Informacion_complementaria') 
BEGIN
	 DROP PROCEDURE Importar_Informacion_complementaria;
	 PRINT 'SP Importar_Informacion_complementaria ya existe -- > se borro';
END;
go
CREATE PROCEDURE Importar_Informacion_complementaria
    @RutaArchivo NVARCHAR(255)
AS
BEGIN

	DECLARE @SQL NVARCHAR(MAX);
    
	--1. crear tabla temporal para cargar SUCURSALES--------------------------------------------------
	CREATE TABLE #Temp_sucursal (
		id INT IDENTITY(1,1),
		localidad VARCHAR(100),
		direccion VARCHAR(255),
		horario VARCHAR(50),
		telefono VARCHAR(20)
		)
		
    --ingreso de SUCURSALES
	SET @SQL =' 
    INSERT INTO #Temp_sucursal (localidad,direccion,horario,telefono)
    SELECT [Ciudad],[direccion],[Horario],[Telefono]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [Ciudad], [direccion], [Horario], [Telefono] FROM [sucursal$]'')';

    EXEC sp_executesql @SQL;
	--paso el contenido de #temp como parametros para sp insertarSucursal

	DECLARE @contador INT = 1, @totalFilas INT;
	SELECT @totalFilas = COUNT(*) FROM #Temp_sucursal;
	DECLARE  
		@localidad VARCHAR(100),
		@direccion VARCHAR(255),
		@horario VARCHAR(50),
		@telefono VARCHAR(20)
	WHILE @contador <= @totalFilas
	BEGIN

		SELECT 
				@localidad = localidad,
				@direccion = direccion,
				@horario = horario,
				@telefono = telefono
		FROM #Temp_sucursal WHERE id = @contador;
		--reemplazo las ciudades
		IF @localidad IN ('Yangon')
			SET @localidad='San Justo';
		IF @localidad IN ('Naypyitaw')
			SET @localidad='Ramos Mejia';
		IF @localidad IN ('Mandalay')
			SET @localidad='Lomas del Mirador';
		
		EXEC ddbba.insertarSucursal
			@localidad,
			@direccion,
			@horario,
			@telefono

		SET @contador = @contador + 1;
	END;
	DROP TABLE #Temp_sucursal;

	--2. crear tabla temporal para cargar EMPLEADOS --------------------------------------------------
	CREATE TABLE #Temp_empleado (
		id_emp INT IDENTITY(1,1),
		id_empleado int,
		nombre VARCHAR(100),
		apellido VARCHAR(100),
		dni INT,
		direccion VARCHAR(255),		
		email_personal VARCHAR(255),
		email_empresarial VARCHAR(255),
		turno VARCHAR(50),
		cargo VARCHAR(50),
		sucursal VARCHAR(20)
		)
		
    --ingreso de EMPLEADOS
	SET @SQL =' 
    INSERT INTO #Temp_empleado (id_empleado,nombre,apellido,dni,direccion,email_personal,email_empresarial,turno,cargo,sucursal)
    SELECT [Legajo/ID],[Nombre],[Apellido],[DNI],[Direccion],[email personal],[email empresa],[Turno],[Cargo],[Sucursal]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [Legajo/ID],[Nombre],[Apellido],[DNI],[Direccion],[email personal],[email empresa],[Turno],[Cargo],[Sucursal] FROM [Empleados$]'')';

    EXEC sp_executesql @SQL;
	--paso el contenido de #temp como parametros para sp insertarEmpleado

	SET @contador = 1;
	SELECT @totalFilas = COUNT(*) FROM #Temp_empleado;
	DECLARE 
		@id_empleado int,
		@nombre VARCHAR(100),
		@apellido VARCHAR(100),
		@dni INT,
		@direccion_emp VARCHAR(255),		
		@email_personal VARCHAR(255),
		@email_empresarial VARCHAR(255),
		@turno VARCHAR(50),
		@cargo VARCHAR(50),
		@sucursal VARCHAR(20),
		@id_sucursal_emp INT,
		@cuil VARCHAR(15)

	WHILE @contador <= @totalFilas
	BEGIN
		SELECT 
			@id_empleado = id_empleado,
			@nombre = nombre,
			@apellido = apellido,
			@dni = dni,
			@direccion_emp = direccion,
			@email_personal = email_personal,
			@email_empresarial = email_empresarial,
			@turno = turno,
			@cargo = cargo,
			@sucursal = sucursal
		FROM #Temp_empleado WHERE id_emp = @contador;
		--crear cuil
		
			    SET @cuil = CAST((FLOOR(RAND() * 8) + 20) AS VARCHAR) + '-' + CAST(@dni AS VARCHAR) + '-' + CAST((FLOOR(RAND() * 9) + 1) AS VARCHAR);

		--guardar id de sucursal
		SELECT @id_sucursal_emp = id_sucursal
		FROM ddbba.Sucursal
		WHERE localidad = @sucursal

		EXEC ddbba.insertarEmpleado
			@id_empleado,
			@cuil,
			@dni,
			@direccion_emp,
			@apellido,
			@nombre,
			@email_personal,
			@email_empresarial,
			@turno,
			@cargo,
			@id_sucursal_emp

		SET @contador = @contador + 1;
	END;
	DROP TABLE #Temp_empleado;

END; --fin SP

--ejecutar el Store procedure
EXEC Importar_Informacion_complementaria 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Informacion_complementaria.xlsx';
go
----fijarse
SELECT * FROM ddbba.Empleado
----borrar el SP
--DROP PROCEDURE Importar_Informacion_complementaria

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Procedimiento para crear los MEDIOS DE PAGO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Insertar_MediosDePago') 
BEGIN
	 DROP PROCEDURE Insertar_MediosDePago;
	 PRINT 'SP Insertar_MediosDePago ya existe -- > se borro';
END;
go
CREATE PROCEDURE Insertar_MediosDePago
AS
BEGIN
	EXEC ddbba.insertarMedioPago 'Credit card';
	EXEC ddbba.insertarMedioPago 'Cash';
	EXEC ddbba.insertarMedioPago 'Ewallet';
END;

--ejecutar el sp Insertar_MediosDePago
EXEC Insertar_MediosDePago;
--fijarse 
SELECT * FROM ddbba.MedioPago

-- Procedimiento para insertar los datos en PROVEE
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Insertar_Provee') 
BEGIN
	 DROP PROCEDURE Insertar_Provee;
	 PRINT 'SP Insertar_Provee ya existe -- > se borro';
END;
go
CREATE PROCEDURE Insertar_Provee
AS
BEGIN
	DECLARE 
	SELECT p.id_prod, p.id_prov
	FROM ddbba.Provee p
	INNER JOIN ddbba.Producto pd ON p.id_prod = pd.id_producto
	INNER JOIN ddbba.Proveedor prov ON p.id_prov = pd.id_pro
END;

--ejecutar el sp Insertar_MediosDePago
EXEC Insertar_MediosDePago;
--fijarse 
SELECT * FROM ddbba.MedioPago

-----------------------------------------------------------------------------------------------------------
-- Procedimiento para importar Ventas_registradas.csv
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Ventas_registradas') 
BEGIN
	 DROP PROCEDURE Importar_Ventas_registradas;
	 PRINT 'SP Importar_Ventas_registradas ya existe -- > se borro';
END;
go
CREATE PROCEDURE Importar_Ventas_registradas
    @RutaArchivo NVARCHAR(255)
AS
BEGIN 
	DECLARE @SQL NVARCHAR(MAX);

    --crear tabla temporal para cargar los datos de la venta
	CREATE TABLE #Temp (
				id int identity(1,1),
				id_factura VARCHAR(15),
				localidad VARCHAR(100),
				tipo VARCHAR(50), --tipo de cliente
				genero VARCHAR(10),
				nombre_producto  VARCHAR(100),
				precio_unitario DECIMAL(10, 2),
				cantidad INT,
				fecha DATE,
				hora TIME,
				tipo_mp VARCHAR(10), --tipo
				id_empleado INT,
				iden_pago VARCHAR(30)
			)
	
		SET @SQL =' 
    INSERT INTO #Temp (id_factura,localidad,tipo,genero,nombre_producto,precio_unitario,cantidad,fecha,hora,tipo_mp,id_empleado,iden_pago)
    SELECT [Legajo/ID],[Nombre],[Apellido],[DNI],[Direccion],[email personal],[email empresa],[Turno],[Cargo],[Sucursal]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [Legajo/ID],[Nombre],[Apellido],[DNI],[Direccion],[email personal],[email empresa],[Turno],[Cargo],[Sucursal] FROM [Empleados$]'')';

    EXEC sp_executesql @SQL;

	--crear tabla temporal para cargar los datos de la clasificacion de archivos
	CREATE TABLE #Temp_clasificacion (
				linea_clasificacion VARCHAR(50),
				tipo_producto VARCHAR(50)
			)
    
		SET @SQL =' 
    INSERT INTO #Temp_clasificacion (linea_clasificacion, tipo_producto)
    SELECT [Línea de producto],[Producto]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivoClasificacion + ';HDR=YES'',
        ''SELECT [Línea de producto],[Producto] FROM [Clasificacion productos$]'')';
		EXEC sp_executesql @SQL;

	--paso el contenido de #temp como parametros para sp insertarproducto
	DECLARE @contador INT = 1, @totalFilas INT;
	SELECT @totalFilas = COUNT(*) FROM #Temp;

	WHILE @contador <= @totalFilas
	BEGIN
		DECLARE  @id INT, @nombre_producto VARCHAR(100), @linea VARCHAR(50), @precio_unitario DECIMAL(10,2), @precio_referencia DECIMAL(10,2), @unidad VARCHAR(10), @fecha DATETIME, @moneda VARCHAR(7)
		SELECT
			@id = id, @nombre_producto = nombre_producto, @precio_unitario = precio_unitario, @precio_referencia = precio_referencia,@unidad = unidad,@fecha = fecha
		FROM #Temp WHERE id = @contador;

		--que la categoria del archivo coincida con la categorias de los productos
		SELECT TOP 1 @linea = linea_clasificacion
		FROM #Temp T inner join #Temp_clasificacion TC on T.linea=TC.tipo_producto
		WHERE id = @contador;

		EXEC ddbba.insertarProducto 
			@nombre_producto,
			@precio_unitario, --precio unitario
			@linea, --linea
			@precio_referencia, --precio ref
			@unidad, --unidad
			'', --cantxunidad
			'ARS', --moneda
			@fecha --fecha

		SET @contador = @contador + 1;
	END;

	DROP TABLE #Temp;

END;
go

--ejecutar el Store procedure
EXEC Importar_Catalogo '"C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Ventas_registradas.csv"'
go














SELECT * FROM ddbba.Producto
--borrar tablas
CREATE PROCEDURE Borrar
AS
BEGIN
	 DROP TABLE ddbba.Factura
	DROP TABLE ddbba.Tiene
	DROP TABLE ddbba.Venta
	DROP TABLE ddbba.Pedido
	DROP TABLE ddbba.MedioPago
	DROP TABLE ddbba.Cliente
	DROP TABLE ddbba.Provee
	DROP TABLE ddbba.Producto
	DROP TABLE ddbba.Proveedor
	DROP TABLE ddbba.Empleado
	DROP TABLE ddbba.Sucursal
END;	



