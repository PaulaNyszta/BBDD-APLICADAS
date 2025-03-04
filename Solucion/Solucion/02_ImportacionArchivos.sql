-- 3. SCRIPT DE IMPORTACION DE DATOS - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
--ATENCION: puede ejecutar el archivo como bloque para crear los SP  y luego ir ejecutandolos de a uno para ver la insercion

Use Com1353G01
-----------------------------------------------------------------------------------------------------------------------
--Crear el Schema de impotacion
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'imp')
	BEGIN
		EXEC('CREATE SCHEMA imp');
		PRINT ' Schema creado exitosamente';
	END;
go

-- 1. Procedimiento Almacenado para importar Electronic accessories.xlsx
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_ElectronicAccessories') 
BEGIN
    DROP PROCEDURE imp.Importar_ElectronicAccessories;
    PRINT 'SP Importar_ElectronicAccessories ya existe --> se borr�';
END;
GO
CREATE PROCEDURE imp.Importar_ElectronicAccessories
    @RutaArchivo NVARCHAR(255),
	@cotizacion decimal(10,2)
AS
BEGIN
    SET NOCOUNT ON;

		IF @cotizacion<=0
		BEGIN
			PRINT 'La cotizacion no puede ser negativa ni cero';
			RETURN;
		END;
    -- Crear tabla temporal para cargar los datos(Para que sea accesible en toda la ejecuci�n del procedimiento, usa una tabla temporal global (##Temp))
CREATE TABLE ##Temp (
    nombre_producto VARCHAR(100),
    precio_unitario DECIMAL(10,2),
    moneda VARCHAR(7),
    fecha DATE DEFAULT GETDATE() --fecha del dia que se importan los datos
);

DECLARE @SQL NVARCHAR(MAX);
SET @SQL = '
INSERT INTO ##Temp (nombre_producto, precio_unitario, moneda)
SELECT Product, [Precio Unitario en dolares], ''USD''
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
    ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
    ''SELECT [Product], [Precio Unitario en dolares] FROM [Sheet1$]'')';

EXEC sp_executesql @SQL;

	--eliminamos los duplicados
	;WITH CTE AS (
	 SELECT *, 
			 ROW_NUMBER() OVER (PARTITION BY LTRIM(RTRIM(LOWER(nombre_producto))) ORDER BY fecha DESC) AS rn
	 FROM ##Temp
	)
	DELETE FROM CTE WHERE rn > 1;


	--modificaremos los precios que dicen USD con la cotizacion actual
	UPDATE t
	SET moneda='ARS',
		precio_unitario = precio_unitario*@cotizacion
	FROM ##Temp t
	WHERE moneda = 'USD';



-- Ahora la tabla ya es accesible en toda la ejecuci�n del procedimiento
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
	FROM ##Temp tmp
	WHERE NOT EXISTS (SELECT 1 FROM ddbba.Producto Pr WHERE tmp.nombre_producto=Pr.nombre_producto)
	-- Eliminar la tabla temporal global despu�s de usarla
	DROP TABLE ##Temp;

END;
GO


	/*--FIJARSE
	SELECT * FROM ddbba.Producto

	-----EJECUTAR EL STORE PROCEDURE--------------debe colocar la ruta a sus archivos---------------------------------------------------------------------------
	EXEC imp.Importar_ElectronicAccessories 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Productos\Electronic accessories.xlsx', 1063.75
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Procedimiento para importar Productos_importados.xlsx
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Productos_importados') 
BEGIN
    DROP PROCEDURE imp.Importar_Productos_importados;
    PRINT 'SP Importar_Productos_importados ya existe --> se borr�';
END;
GO
CREATE PROCEDURE imp.Importar_Productos_importados
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Crear tabla temporal global (##Temp)
    IF OBJECT_ID('tempdb..##Temp') IS NOT NULL
        DROP TABLE ##Temp;

    CREATE TABLE ##Temp (
        nombre_producto NVARCHAR(255),
        precio_unitario DECIMAL(10,2),
        moneda VARCHAR(7),
        linea VARCHAR(100),
        cantidadPorUnidad NVARCHAR(50),
        proveedor NVARCHAR(255),
        fecha DATETIME DEFAULT GETDATE()
    );

    -- Importar datos desde Excel a ##Temp
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = '
    INSERT INTO ##Temp (nombre_producto, proveedor, linea, cantidadPorUnidad, precio_unitario, moneda)
    SELECT [NombreProducto], [Proveedor], [Categor�a], [CantidadPorUnidad], [PrecioUnidad], ''ARS''
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [NombreProducto], [Proveedor], [Categor�a], [CantidadPorUnidad], [PrecioUnidad] FROM [Listado de Productos$]'')';

    EXEC sp_executesql @SQL;
    PRINT 'Datos cargados en ##Temp.';

    -- Eliminar duplicados dentro de ##Temp
    ;WITH CTE AS (
        SELECT *, 
               ROW_NUMBER() OVER (
                   PARTITION BY LTRIM(RTRIM(LOWER(nombre_producto)))
                   ORDER BY fecha DESC) AS rn
        FROM ##Temp
    )
    DELETE FROM CTE WHERE rn > 1;

    PRINT 'Duplicados eliminados en ##Temp.';

    -- Insertar proveedores �nicos en ddbba.Proveedor
    INSERT INTO ddbba.Proveedor (nombre)
    SELECT DISTINCT proveedor
    FROM ##Temp
    WHERE proveedor IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM ddbba.Proveedor p WHERE p.nombre = ##Temp.proveedor
    );

    PRINT 'Proveedores insertados correctamente.';

    -- Insertar productos en ddbba.Producto (evitando duplicados)
    INSERT INTO ddbba.Producto (nombre_producto, precio_unitario, linea, precio_referencia, unidad, cantidadPorUnidad, moneda, fecha)
    SELECT 
        nombre_producto, 
        precio_unitario, 
        linea, 
        0,  -- Precio de referencia por defecto
        '', -- Unidad vac�a
        cantidadPorUnidad, 
        moneda, 
        fecha
    FROM ##Temp tmp
	  WHERE NOT EXISTS (SELECT 1 FROM ddbba.Producto Pr WHERE tmp.nombre_producto=Pr.nombre_producto)

    PRINT 'Productos insertados correctamente.';

    -- Insertar en ProveedorProvee (evitando duplicados)
    INSERT INTO ddbba.ProveedorProvee (id_proveedor, id_producto)
    SELECT  
        p.id_proveedor, 
        pr.id_producto
    FROM ddbba.Proveedor p 
	INNER JOIN ##Temp tmp ON tmp.proveedor=p.nombre
	INNER JOIN ddbba.Producto Pr ON Pr.nombre_producto=tmp.nombre_producto

	WHERE NOT EXISTS (SELECT 1 FROM ddbba.ProveedorProvee PP WHERE PP.id_proveedor=(SELECT TOP 1 p.id_proveedor FROM ddbba.Proveedor p INNER JOIN ##Temp tmp ON tmp.proveedor=p.nombre)
	and PP.id_producto=(SELECT TOP 1 Pr.id_producto FROM ddbba.Producto Pr INNER JOIN ##Temp tmp ON Pr.nombre_producto=tmp.nombre_producto));

    PRINT 'Relaci�n Proveedor-Producto insertada correctamente.';

    -- Eliminar la tabla temporal global despu�s de la ejecuci�n
    DROP TABLE ##Temp;
    PRINT '##Temp eliminada.';

    PRINT 'Importaci�n completada correctamente.';
END;
GO


	/*--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos---------------------------------------------------------------------------
	EXEC imp.Importar_Productos_importados 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Productos\Productos_importados.xlsx';
	go
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Producto
	select * from ddbba.Proveedor
	select * from ddbba.ProveedorProvee
	*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Procedimiento para importar catalogo.csv
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Catalogo') 
BEGIN
     DROP PROCEDURE imp.Importar_Catalogo;
     PRINT 'SP Importar_Catalogo ya existe --> se borr�';
END;
GO

CREATE PROCEDURE imp.Importar_Catalogo
    @RutaArchivo NVARCHAR(255), @RutaArchivoClasificacion NVARCHAR(255)
AS
BEGIN 
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);

    -- Crear tabla temporal global para el cat�logo
    IF OBJECT_ID('tempdb..##Temp_Catalogo') IS NOT NULL
        DROP TABLE ##Temp_Catalogo;


    CREATE TABLE ##Temp_Catalogo (
        id INT IDENTITY(1,1),
        linea VARCHAR(50),
        nombre_producto  VARCHAR(100),
        precio_unitario DECIMAL(10,2),
        precio_referencia DECIMAL(10,2),
        unidad VARCHAR(10),
        fecha DATETIME DEFAULT GETDATE()
    );
    
    -- Importar datos desde CSV a ##Temp_Catalogo
    SET @SQL = ' 
    BULK INSERT ##Temp_Catalogo
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
    PRINT 'Datos cargados en ##Temp_Catalogo.';

    -- Crear tabla temporal global para la clasificaci�n
    IF OBJECT_ID('tempdb..##Temp_Clasificacion') IS NOT NULL
        DROP TABLE ##Temp_Clasificacion;

    CREATE TABLE ##Temp_Clasificacion (
        linea_clasificacion VARCHAR(50),
        tipo_producto VARCHAR(50)
    );

    -- Importar datos de clasificaci�n desde Excel
    SET @SQL =' 
    INSERT INTO ##Temp_Clasificacion (linea_clasificacion, tipo_producto)
    SELECT [L�nea de producto], [Producto]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivoClasificacion + ';HDR=YES'',
        ''SELECT [L�nea de producto], [Producto] FROM [Clasificacion productos$]'')';
    
    EXEC sp_executesql @SQL;
    PRINT 'Datos cargados en ##Temp_Clasificacion.';

    -- Normalizar datos eliminando duplicados
    ;WITH CTE AS (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY LTRIM(RTRIM(LOWER(nombre_producto))) 
                   ORDER BY fecha DESC) AS rn
        FROM ##Temp_Catalogo
    )
    DELETE FROM CTE WHERE rn > 1;
    PRINT 'Duplicados eliminados en ##Temp_Catalogo.';

    -- Insertar productos en ddbba.Producto evitando duplicados
    INSERT INTO ddbba.Producto (nombre_producto, precio_unitario, linea, precio_referencia, unidad, cantidadPorUnidad, moneda, fecha)
    SELECT 
        c.nombre_producto,
        c.precio_unitario,
        cl.linea_clasificacion,
        c.precio_referencia,
        c.unidad,
        '', -- cantidadPorUnidad
        'ARS', -- moneda
        c.fecha
    FROM ##Temp_Catalogo c
    LEFT JOIN ##Temp_Clasificacion cl ON c.linea = cl.tipo_producto
	WHERE NOT EXISTS (SELECT 1 FROM ddbba.Producto Pr WHERE c.nombre_producto=Pr.nombre_producto)
  
    PRINT 'Productos insertados correctamente en ddbba.Producto.';

    -- Eliminar tablas temporales globales
    DROP TABLE ##Temp_Catalogo;
    DROP TABLE ##Temp_Clasificacion;
    PRINT 'Tablas temporales eliminadas.';

    PRINT 'Importaci�n completada correctamente.';
END;
GO



	/*--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos-------------------------ARCHIVO CATALOGO.CSV----------------------------------------------------ARCHIVO INFROMSCION_COMPLEMENTARIA.XLSX-------------------------
	EXEC imp.Importar_Catalogo 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Productos\catalogo.csv', 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Informacion_complementaria.xlsx';
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Producto 
	*/
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
	
	/*--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos------------------------------------------------------------------
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
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    -- Crear tabla temporal para cargar EMPLEADOS
    CREATE TABLE #Temp_empleado (
        id_empleado INT,
        nombre VARCHAR(100),
        apellido VARCHAR(100),
        dni INT,
        direccion VARCHAR(255),
        email_personal VARCHAR(255),
        email_empresarial VARCHAR(255),
        turno VARCHAR(50),
        cargo VARCHAR(50),
        sucursal VARCHAR(100)
    );

    -- Ingreso de EMPLEADOS
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = '
    INSERT INTO #Temp_empleado (id_empleado, nombre, apellido, dni, direccion, email_personal, email_empresarial, turno, cargo, sucursal)
    SELECT [Legajo/ID], [Nombre], [Apellido], [DNI], [Direccion], [email personal], [email empresa], [Turno], [Cargo], [Sucursal]
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [Legajo/ID], [Nombre], [Apellido], [DNI], [Direccion], [email personal], [email empresa], [Turno], [Cargo], [Sucursal] FROM [Empleados$]'')
    ';
    
    EXEC sp_executesql @SQL;

    -- Insertar datos en la tabla final sin encriptaci�n
    INSERT INTO ddbba.Empleado (id_empleado, cuil, dni, direccion, apellido, nombre, email_personal, email_empresarial, turno, cargo, id_sucursal)
    SELECT
        id_empleado,
        CAST((FLOOR(RAND() * 8) + 20) AS VARCHAR) + '-' + CAST(dni AS VARCHAR) + '-' + CAST((FLOOR(RAND() * 9) + 1) AS VARCHAR) as Cuil,
        dni as DNI,
        direccion as Direccion,
        apellido as Apellido,
        nombre as Nombre,
        email_personal as Email_personal,
        email_empresarial as Email_empresarial,
        turno,
        cargo,
        (SELECT id_sucursal FROM ddbba.Sucursal S WHERE tmpe.sucursal = S.localidad) as Id_Sucursal
    FROM #Temp_empleado tmpe
    WHERE id_empleado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE id_empleado = tmpe.id_empleado);

    DROP TABLE #Temp_empleado;

END; -- Fin SP
go


	/*--EJECUTAR EL STORE PROCEDURE----------------------------------------------------debe colocar la ruta a sus archivos------------------------------------------------------------------
	EXEC imp.Importar_Informacion_complementaria_empleado 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Informacion_complementaria.xlsx';
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.Empleado
	*/


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

	/*-EJECUTAR EL STORE PROCEDURE
	EXEC imp.Insertar_MediosDePago;
	----------------------------*/
	/*OBSERVAR INSERCION
	SELECT * FROM ddbba.MedioPago
	*/
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6.Procedimiento para importar Ventas_registradas.csv
--CLIENTES
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Ventas_registradas_cliente_pedido_productosolicitado') 
BEGIN
	 DROP PROCEDURE imp.Importar_Ventas_registradas_cliente_pedido_productosolicitado;
	 PRINT 'SP Importar_Ventas_registradas_cliente_pedido_productosolicitado ya existe -- > se borro';
END;
go
CREATE PROCEDURE imp.Importar_Ventas_registradas_cliente_pedido_productosolicitado
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

		--cargar datos a PEDIDO
		ALTER TABLE #Temp
		ADD estado VARCHAR(10),
		dni_cliente char(8),
		id_mp int,
		id_sucursal int;
		

		UPDATE #Temp
		SET estado = CASE WHEN CAST(NEWID() AS BINARY(1)) % 2 = 0 THEN 'Pagado' ELSE 'NoPagado' END,
		dni_cliente = RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 90000000 + 10000000 AS VARCHAR(8)), 8), --COLOCAR API
		localidad = CASE
		WHEN localidad = 'Yangon' THEN 'San Justo'
		WHEN localidad = 'Naypyitaw' THEN 'Ramos Mejia'
		WHEN localidad = 'Mandalay' THEN 'Lomas del Mirador'
					END,
		tipo_mp = CASE
		WHEN tipo_mp = 'Credit card' THEN 'Tarjeta de credito'
		WHEN tipo_mp = 'Ewallet' THEN 'Billetera Electronica'
		WHEN tipo_mp = 'Cash' THEN 'Efectivo'
					END;

		UPDATE t
		SET
		t.id_mp = mp.id_mp,
        t.id_sucursal = s.id_sucursal
		FROM #Temp t
		INNER JOIN ddbba.MedioPago mp ON mp.tipo = t.tipo_mp
		INNER JOIN ddbba.Sucursal s ON s.localidad = t.localidad;

		--modificacmos la tabla para ingresar nuevos datos
		ALTER TABLE #Temp
		ADD nombre VARCHAR(50),
		 apellido varchar(50),
		 fnac DATE;

		--cargar datos a CLIENTE
		--generacion  de nombres aleatorios para cliente
		DECLARE @nombres TABLE (nombre VARCHAR(50));
		DECLARE @apellidos TABLE (apellido VARCHAR(50));
		DECLARE @nombre VARCHAR(50), @apellido VARCHAR(50)
		 -- Insertamos algunos nombres y apellidos en las tablas temporales
		INSERT INTO @nombres VALUES ('Juan'), ('Mar�a'), ('Carlos'), ('Ana'), ('Pedro'), ('Laura'), ('Luis'), ('Sof�a');
		INSERT INTO @apellidos VALUES ('Gomez'), ('Perez'), ('Lopez'), ('Fernandez'), ('Martinez'), ('Rodriguez'), ('Sanchez'), ('Diaz');

		UPDATE #Temp
		SET 
			nombre = (SELECT TOP 1 nombre FROM @nombres ORDER BY NEWID()),
			apellido = (SELECT TOP 1 apellido FROM @apellidos ORDER BY NEWID()),
			fnac = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 18250), GETDATE()); -- 50 a�os aleatorios

		UPDATE #Temp SET	nombre_producto = REPLACE (nombre_producto, 'é', '�');
		UPDATE #Temp SET	nombre_producto = REPLACE (nombre_producto, 'ñ', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'ó', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'á', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'ú', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'º', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'Ñ', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'í', '�'); 
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, '単', '�');
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'Ã�', 'ú'); 
		UPDATE #Temp SET 	nombre_producto = REPLACE (nombre_producto, 'Á', '�');


		ALTER TABLE #Temp
		ADD id_producto int;

		UPDATE t
		SET
		t.id_producto=P.id_producto
		FROM #temp t
		INNER JOIN ddbba.Producto P ON P.nombre_producto=t.nombre_producto 

------------------------------------------------------------------------------------------------			

		--insertamos los datos en CLIENTE
		INSERT INTO ddbba.Cliente (dni_cliente,genero,tipo,apellido,nombre,fecha_nac)
		SELECT
			dni_cliente,
			genero,
			tipo,
			apellido,
			nombre,
			fnac
		FROM #Temp tmp
		WHERE NOT EXISTS (SELECT 1 FROM ddbba.Pedido Ped WHERE Ped.id_factura=tmp.id_factura)
		
		--insertamos datos en PEDIDO
		INSERT INTO ddbba.Pedido (id_factura, fecha_pedido, hora_pedido, dni_cliente, id_mp, iden_pago, id_empleado, id_sucursal, tipo_factura, estado_factura)
		SELECT 
			t.id_factura,
			t.fecha,
			t.hora,
			t.dni_cliente,
			t.id_mp,
			t.iden_pago,
			t.id_empleado,
			t.id_sucursal,
			t.tipo_factura,
			t.estado
		FROM #Temp t
		WHERE NOT EXISTS (SELECT 1 FROM ddbba.Pedido P WHERE P.id_factura=t.id_factura);
		
		--insertar los datos en la tabla correspondiente PRODUCTOSOLICITADO	
		INSERT INTO ddbba.ProductoSolicitado (id_factura, id_producto, cantidad)
		SELECT
			id_factura,
			id_producto,
			cantidad
		FROM #Temp t
		WHERE NOT EXISTS 
			(SELECT 1 FROM ddbba.ProductoSolicitado  PS WHERE PS.id_factura=t.id_factura and PS.id_producto=t.id_producto);
	DROP TABLE #Temp;
END;
go

	/*--EJECUTAR EL STORE PROCEDURE--------------------------------------------------------------------------------------------------------------------------
	EXEC imp.Importar_Ventas_registradas_cliente_pedido_productosolicitado 'C:\Users\paula\Downloads\TP_integrador_Archivos_1 (1)\TP_integrador_Archivos\Ventas_registradas.csv';
	------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	/*OBSERVAR INSERCION
	SELECT  * FROM ddbba.Cliente
	SELECT * FROM ddbba.Pedido
	SELECT * FROM ddbba.ProductoSolicitado
	*/


	



/*--DESENCRIPTAR Y VER LA TABLA ENTERA
	SELECT id_empleado, 
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', nombre)) AS Nombre,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', apellido)) AS Apellido,
       CONVERT(NVARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', dni)) AS dni,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', direccion)) AS Direccion,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', cuil)) AS Cuil,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', email_personal)) AS Email_personal,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Contrasenia', email_empresarial)) AS Email_empresarial,
       turno,
       cargo,
       id_sucursal
FROM ddbba.Empleado;
select 
*/

