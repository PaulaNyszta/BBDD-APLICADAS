-- 3. SCRIPT DE IMPORTACION DE DATOS - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
--ATENCION: puede ejecutar el archivo como bloque para crear los SP  y luego ir ejecutandolos de a uno para ver la insercion
--o puede ejecutar todo juntos abajo
Use Com1353G01
-----------------------------------------------------------------------------------------------------------------------
-- 1. Procedimiento Almacenado para importar Electronic accessories.xlsx
--Crear el Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'imp')
	BEGIN
		EXEC('CREATE SCHEMA imp');
		PRINT ' Schema creado exitosamente';
	END;
go

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_ElectronicAccessories') 
BEGIN
    DROP PROCEDURE imp.Importar_ElectronicAccessories;
    PRINT 'SP Importar_ElectronicAccessories ya existe --> se borró';
END;
GO
CREATE PROCEDURE imp.Importar_ElectronicAccessories
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Crear tabla temporal para cargar los datos
    CREATE TABLE #Temp (
        nombre_producto VARCHAR(100),
        precio_unitario DECIMAL(10,2),
        moneda VARCHAR(7),
        fecha DATETIME DEFAULT GETDATE()
    );


    -- Importar datos desde Excel a #Temp
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = '
    INSERT INTO #Temp (nombre_producto, precio_unitario, moneda)
    SELECT Product, [Precio Unitario en dolares], ''USD''
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [Product], [Precio Unitario en dolares] FROM [Sheet1$]'')';

    EXEC sp_executesql @SQL;

  
  -- Insertar productos válidos en ddbba.Producto
    INSERT INTO ddbba.Producto (nombre_producto, precio_unitario, linea, precio_referencia, unidad, cantidadPorunidad, moneda, fecha)
    SELECT 
        nombre_producto, 
        precio_unitario, 
        'Electrodomestico', 
        0,  
        '', 
        '', 
        moneda, 
        fecha
    FROM #Temp 
	
    -- Eliminar tablas temporales
    DROP TABLE #Temp;
END;
GO

	--FIJARSE
	SELECT * FROM ddbba.Producto

	-----EJECUTAR EL STORE PROCEDURE--------------debe colocar la ruta a sus archivos---------------------------------------------------------------------------
	EXEC imp.Importar_ElectronicAccessories 'C:\Users\luciano\Desktop\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';
	EXEC imp.Importar_ElectronicAccessories 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--para solucionar error 7099, 7050 Win+R -->services.msc -->SQL Server (SQLEXPRESS)--> propiedades-->iniciar sesion-->cabiar a "Cuenta del sistema local", Marca la casilla "Permitir que el servicio interactúe con el escritorio".


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Procedimiento para importar Productos_importados.xlsx
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Productos_importados') 
BEGIN
    DROP PROCEDURE imp.Importar_Productos_importados;
    PRINT 'SP Importar_ElectronicAccessories ya existe --> se borró';
END;
GO
CREATE PROCEDURE imp.Importar_Productos_importados
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Crear tabla temporal para cargar los datos
    CREATE TABLE #Temp (
        nombre_producto NVARCHAR(255),
        precio_unitario DECIMAL(10,2),
        moneda VARCHAR(7),
        linea VARCHAR(100),
        cantidadPorUnidad NVARCHAR(50),
        proveedor NVARCHAR(255)
    );


    -- Importar datos desde Excel a #Temp
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = '
    INSERT INTO #Temp (nombre_producto, linea, cantidadPorUnidad, precio_unitario, proveedor, moneda)
    SELECT [NombreProducto], [Categoría], [CantidadPorUnidad], [PrecioUnidad], [Proveedor], ''ARS''
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [NombreProducto], [Categoría], [CantidadPorUnidad], [PrecioUnidad], [Proveedor] FROM [Listado de Productos$]'')';
    
    EXEC sp_executesql @SQL;

 

    -- Insertar productos
    INSERT INTO ddbba.Producto (nombre_producto, precio_unitario, linea, precio_referencia, unidad, cantidadPorUnidad, moneda, fecha)
    SELECT 
        nombre_producto, 
        precio_unitario, 
        linea, 
        0,  -- precio de referencia por defecto
        '', -- unidad
        cantidadPorUnidad, 
        moneda, 
        ''  -- fecha (debe revisarse si es necesario manejarla de otra forma)
    FROM #Temp;

    -- Insertar relaciones en Provee
    INSERT INTO ddbba.ProveedorProvee (id_proveedor, id_producto)
    SELECT p.id_proveedor, pi.id_producto
    FROM #ProductosInsertados pi
    JOIN ddbba.Proveedor p ON pi.nombre_producto = p.nombre;

    -- Eliminar la tabla temporal
    DROP TABLE #Temp;
    DROP TABLE #ProductosInsertados;

    PRINT 'Importación completada correctamente.';
END;
GO


--ejecutar el Store procedure
EXEC Importar_Productos_importados 'C:\Users\luciano\Desktop\TP_integrador_Archivos\Productos\Productos_importados.xlsx';
go



----fijarse
SELECT * FROM ddbba.Producto
select * from ddbba.Proveedor

----borrar el SP
--DROP PROCEDURE Importar_Productos_importados

	--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos---------------------------------------------------------------------------
	EXEC imp.Importar_Productos_importados 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Productos\Productos_importados.xlsx';
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Producto
	select * from ddbba.Proveedor
	select * from ddbba.Provee
	*/

go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Procedimiento para importar catalogo.csv
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Catalogo') 
BEGIN
	 DROP PROCEDURE imp.Importar_Catalogo;
	 PRINT 'SP Importar_Catalogo ya existe -- > se borro';
END;
go
CREATE PROCEDURE imp.Importar_Catalogo
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

		--que la categoria del archivo coincida con la categorias de los productos
		DECLARE @linea VARCHAR(50);
		SELECT @linea=linea_clasificacion
		FROM #Temp_clasificacion tmpc INNER JOIN #Temp tmp ON tmp.linea=tmpc.tipo_producto
		

		INSERT INTO ddbba.Producto (nombre_producto, precio_unitario, linea, precio_referencia, unidad, cantidadPorunidad, moneda, fecha)
		SELECT 
			nombre_producto,
			precio_unitario, --precio unitario
			(SELECT linea_clasificacion FROM #Temp_clasificacion WHERE tipo_producto=linea),
			precio_referencia, --precio ref
			unidad, --unidad
			'', --cantxunidad
			'ARS', --moneda
			fecha --fecha
		FROM #temp;

	DROP TABLE #Temp;

END;
go


	--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos-------------------------ARCHIVO CATALOGO.CSV----------------------------------------------------ARCHIVO INFROMSCION_COMPLEMENTARIA.XLSX-------------------------
	EXEC imp.Importar_Catalogo 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Productos\catalogo.csv', 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Informacion_complementaria.xlsx';
	EXEC imp.Importar_Catalogo 'C:\Users\luciano\Desktop\UNLAM\2025\BBDD-APLICADAS\TP_integrador_Archivos_1\Productos\catalogo.csv', 'C:\Users\luciano\Desktop\UNLAM\2025\BBDD-APLICADAS\TP_integrador_Archivos_1\Informacion_complementaria.xlsx'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Producto
	*/

go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Procedimiento para importar Informacion_complementaria.xlsx 
--SUCURSAL
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Informacion_complementaria_sucursal') 
BEGIN
	 DROP PROCEDURE imp.Importar_Informacion_complementaria_sucursal;
	 PRINT 'SP Importar_Informacion_complementaria_sucursal ya existe -- > se borro';
END;
go
CREATE PROCEDURE imp.Importar_Informacion_complementaria_sucursal
    @RutaArchivo NVARCHAR(255)
AS
BEGIN

	DECLARE @SQL NVARCHAR(MAX);
    
	--crear tabla temporal para cargar SUCURSALES
	CREATE TABLE #Temp_sucursal (
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

	--reemplazo las ciudades
	UPDATE #Temp_sucursal
	SET localidad = CASE
		WHEN localidad = 'Yangon' THEN 'San Justo'
		WHEN localidad = 'Naypyitaw' THEN 'Ramos Mejia'
		WHEN localidad = 'Mandalay' THEN 'Lomas del Mirador'
		END;

	INSERT INTO ddbba.Sucursal (localidad,direccion,horario,telefono)
	SELECT
		localidad,
		direccion,
		horario,
		telefono
	FROM #Temp_sucursal tmps
	WHERE localidad IS NOT NULL AND direccion IS NOT NULL and NOT EXISTS (SELECT 1 FROM ddbba.Sucursal S WHERE S.localidad=tmps.localidad and S.direccion=tmps.direccion) --fijarse que no haya duplicados

	DROP TABLE #Temp_sucursal;
END;
go
	
	--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos------------------------------------------------------------------
	EXEC imp.Importar_Informacion_complementaria_sucursal 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Informacion_complementaria.xlsx';
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Sucursal
	*/


--EMPLEADO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Informacion_complementaria_empleado') 
BEGIN
	 DROP PROCEDURE imp.Importar_Informacion_complementaria_empleado;
	 PRINT 'SP Importar_Informacion_complementaria_empleado ya existe -- > se borro';
END;
go
CREATE PROCEDURE imp.Importar_Informacion_complementaria_empleado
    @RutaArchivo NVARCHAR(255), @Clave NVARCHAR(255)
AS
BEGIN
	--crear tabla temporal para cargar EMPLEADOS 
		CREATE TABLE #Temp_empleado (
			id_empleado int,
			nombre VARCHAR(100),
			apellido VARCHAR(100),
			dni INT,
			direccion VARCHAR(255),		
			email_personal VARCHAR(255),
			email_empresarial VARCHAR(255),
			turno VARCHAR(50),
			cargo VARCHAR(50),
			sucursal VARCHAR(100)
			)
		
    --ingreso de EMPLEADOS
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL =' 
    INSERT INTO #Temp_empleado (id_empleado,nombre,apellido,dni,direccion,email_personal,email_empresarial,turno,cargo,sucursal)
    SELECT [Legajo/ID],[Nombre],[Apellido],[DNI],[Direccion],[email personal],[email empresa],[Turno],[Cargo],[Sucursal]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [Legajo/ID],[Nombre],[Apellido],[DNI],[Direccion],[email personal],[email empresa],[Turno],[Cargo],[Sucursal] FROM [Empleados$]'')';

    EXEC sp_executesql @SQL;
	

	INSERT INTO ddbba.Empleado (id_empleado,cuil,dni,direccion,apellido,nombre,email_personal, email_empresarial,turno,cargo,id_sucursal)
	SELECT
		id_empleado,
		ENCRYPTBYPASSPHRASE(@Clave,CAST((FLOOR(RAND() * 8) + 20) AS VARCHAR) + '-' + CAST(dni AS VARCHAR) + '-' + CAST((FLOOR(RAND() * 9) + 1) AS VARCHAR)) as Cuil,
		ENCRYPTBYPASSPHRASE(@Clave,CAST(dni AS VARCHAR)) as DNI,
		ENCRYPTBYPASSPHRASE(@Clave,direccion) as Direccion,
		ENCRYPTBYPASSPHRASE(@Clave,apellido) as Apellido,
		ENCRYPTBYPASSPHRASE(@Clave,nombre) as Nombre,
		ENCRYPTBYPASSPHRASE(@Clave,email_personal) as Email_personal,
		ENCRYPTBYPASSPHRASE(@Clave,email_empresarial) as Email_empresarial,
		turno,
		cargo,
		(SELECT id_sucursal FROM ddbba.Sucursal S WHERE tmpe.sucursal=S.localidad)
	FROM #Temp_empleado tmpe
	WHERE id_empleado IS NOT NULL and NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado=tmpe.id_empleado);


	DROP TABLE #Temp_empleado;

END; --fin SP
go

	--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos------------------------------------------------------------------
	EXEC imp.Importar_Informacion_complementaria_empleado 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Informacion_complementaria.xlsx', 'Contrasenia';
	EXEC imp.Importar_Informacion_complementaria_empleado 'C:\Users\luciano\Desktop\UNLAM\2025\BBDD-APLICADAS\TP_integrador_Archivos_1\Informacion_complementaria.xlsx';
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Empleado
	*/

	/*--DESENCRIPTAR Y VER LA TABLA ENTERA
	SELECT id_empleado, 
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', nombre)) AS Nombre,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', apellido)) AS Apellido,
       CONVERT(INT, CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', CAST(dni AS VARCHAR)))) AS DNI,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', direccion)) AS Direccion,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', cuil)) AS Cuil,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', email_personal)) AS Email_personal,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', email_empresarial)) AS Email_empresarial,
	   turno,
	   cargo,
	   id_sucursal
	FROM ddbba.Empleado;
*/

go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Procedimiento para crear los MEDIOS DE PAGO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Insertar_MediosDePago') 
BEGIN
	 DROP PROCEDURE imp.Insertar_MediosDePago;
	 PRINT 'SP Insertar_MediosDePago ya existe -- > se borro';
END;
go
CREATE PROCEDURE imp.Insertar_MediosDePago
AS
BEGIN
	EXEC Procedimientos.insertarMedioPago 'Credit card';
	EXEC Procedimientos.insertarMedioPago 'Cash';
	EXEC Procedimientos.insertarMedioPago 'Ewallet';
END;
go

	--EJECUTAR EL STORE PROCEDURE
	EXEC imp.Insertar_MediosDePago;
	----------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.MedioPago
	*/


go
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6.Procedimiento para importar Ventas_registradas.csv
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Ventas_registradas') 
BEGIN
	 DROP PROCEDURE imp.Importar_Ventas_registradas;
	 PRINT 'SP Importar_Ventas_registradas ya existe -- > se borro';
END;
go
CREATE PROCEDURE imp.Importar_Ventas_registradas
    @RutaArchivo NVARCHAR(255)
AS
BEGIN 
	DECLARE @SQL NVARCHAR(MAX);

    --crear tabla temporal para cargar los datos de la venta
	CREATE TABLE #Temp (
				id_factura CHAR(12),
				tipo_factura CHAR(1),
				localidad VARCHAR(100),
				tipo VARCHAR(50), --tipo de cliente
				genero VARCHAR(10),
				nombre_producto  NVARCHAR(100),
				precio_unitario DECIMAL(10, 2),
				cantidad INT,
				fecha DATE,
				hora TIME,
				tipo_mp VARCHAR(50), --tipo
				id_empleado INT,
				iden_pago VARCHAR(50),
			)
	
		SET @SQL = ' 
		BULK INSERT #Temp
		FROM ''' + @RutaArchivo + '''
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '';'',
			ROWTERMINATOR = ''0X0a'',
			CODEPAGE = ''65001'',
			TABLOCK
		);';
		    EXEC sp_executesql @SQL;


		--cargar datos a CLIENTE
		--generacion  de nombres aleatorios para cliente
		DECLARE @nombres TABLE (nombre VARCHAR(50));
		DECLARE @apellidos TABLE (apellido VARCHAR(50));
		DECLARE @nombre VARCHAR(50), @apellido VARCHAR(50)
		 -- Insertamos algunos nombres y apellidos en las tablas temporales
		INSERT INTO @nombres VALUES ('Juan'), ('María'), ('Carlos'), ('Ana'), ('Pedro'), ('Laura'), ('Luis'), ('Sofía');
		INSERT INTO @apellidos VALUES ('Gomez'), ('Perez'), ('Lopez'), ('Fernandez'), ('Martinez'), ('Rodriguez'), ('Sanchez'), ('Diaz');

		--modificacmos la tabla para ingresar nuevos datos
		ALTER TABLE #Temp
		ADD nombre VARCHAR(50),
		 apellido varchar(50),
		 tipo_cliente varchar(10),
		 fnac DATE;

		UPDATE #Temp
		SET 
			nombre = (SELECT TOP 1 nombre FROM @nombres ORDER BY NEWID()),
			apellido = (SELECT TOP 1 apellido FROM @apellidos ORDER BY NEWID()),
			fnac = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 18250), GETDATE()) -- 50 años aleatorios
		
		
		
		--insertamos los datos en CLIENTE
		INSERT INTO ddbba.Cliente (genero,tipo,apellido,nombre,fecha_nac)
		SELECT
			genero,
			tipo,
			apellido,
			nombre,
			fnac
		FROM #Temp
		---------------------------------------------------------------------
		--cargar datos a PEDIDO
		ALTER TABLE #Temp
		ADD estado VARCHAR(10);
		UPDATE #Temp
		SET estado = CASE WHEN CAST(NEWID() AS BINARY(1)) % 2 = 0 THEN 'Pagado' ELSE 'NoPagado' END;


	INSERT INTO ddbba.Pedido (id_factura, fecha_pedido, hora_pedido, id_cliente, id_mp, iden_pago,id_empleado,id_sucursal,tipo_factura, estado_factura)
	SELECT 
		id_factura,
		fecha,
		hora,
		(SELECT id_cliente FROM ddbba.Cliente),
		(SELECT id_mp FROM ddbba.MedioPago MP WHERE tipo_mp=MP.tipo),
		iden_pago,
		id_empleado,
		(SELECT id_sucursal FROM ddbba.Sucursal S WHERE S.localidad=localidad),
		tipo_factura,
		estado
	FROM #Temp ;

	-------------------------------------------------------------

		--insertar los datos en la tabla correspondiente PRODUCTOSOLICITADO	
		INSERT INTO ddbba.ProductoSolicitado (id_factura, id_producto, cantidad)
		SELECT
			id_factura,
			(SELECT id_producto FROM ddbba.Producto P WHERE P.nombre_producto=tmp.nombre_producto),
			cantidad
		FROM #Temp tmp;

	DROP TABLE #Temp;

END;
go



	--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos------------------------------------------------------------------
	EXEC imp.Importar_Ventas_registradas 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Ventas_registradas.csv';
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Pedido
	SELECT  * FROM ddbba.Cliente
	SELECT * FROM ddbba.ProductoSolicitado

	*/

go




--CODIGO COMPLEMENTARIO PARA PODER EJECUTAR TODO JUNTO
/*
--EJECUTAR
EXEC Importar_ElectronicAccessories 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\Electronic accessories.xlsx';
GO
EXEC Importar_Productos_importados 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\Productos_importados.xlsx';
GO
EXEC Importar_Catalogo 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\catalogo.csv', 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Informacion_complementaria.xlsx'
GO
EXEC Importar_Informacion_complementaria 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Informacion_complementaria.xlsx';
GO
EXEC Insertar_MediosDePago;
GO
EXEC Importar_Ventas_registradas 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Ventas_registradas.csv'
=======
>>>>>>> c917d293e55f04979b72a0a0cd6e9eadd110c714


/*
CREATE PROCEDURE Borrar
AS
BEGIN
	DROP TABLE ddbba.NotaCredito 
	DROP TABLE ddbba.ProductoSolicitado
	DROP TABLE ddbba.Pedido
	DROP TABLE ddbba.MedioPago
	DROP TABLE ddbba.Cliente
	DROP TABLE ddbba.ProveedorProvee
	DROP TABLE ddbba.Producto
	DROP TABLE ddbba.Proveedor
	DROP TABLE ddbba.Empleado
	DROP TABLE ddbba.Sucursal
END;	
*/

