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

		-- Importar datos desde Excel
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL ='
	INSERT INTO ddbba.Producto (descripcion, precio_unitario, moneda)
	SELECT Product, [Precio Unitario en dolares], ''dolar''
	FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
		''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
		''SELECT [Product], [Precio Unitario en dolares] FROM [Sheet1$]'')
		WHERE [Product] NOT IN (SELECT descripcion FROM ddbba.Producto)';
	EXEC sp_executesql @SQL; --consultas dinamicas
END;
go
PRINT 'SP Importar_ElectronicAccessories se creo exitosamente';
go
--ejecutar el Store procedure
EXEC Importar_ElectronicAccessories 'C:\Users\luciano\Desktop\UNLAM\2025\BBDD-APLICADAS\TP_integrador_Archivos_1\Productos\Electronic accessories.xlsx';
go
----fijarse
--SELECT * FROM ddbba.Producto
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
    
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL ='
    INSERT INTO ddbba.Producto (descripcion, proveedor, linea, cantidadPorUnidad, precio_unitario, moneda)
    SELECT [NombreProducto], [Proveedor], [Categoría], [CantidadPorUnidad], [PrecioUnidad], ''pesos''
    FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
        ''Excel 12.0;Database=' + @RutaArchivo + ';HDR=YES'',
        ''SELECT [NombreProducto], [Proveedor], [Categoría], [CantidadPorUnidad], [PrecioUnidad] FROM [Listado de Productos$]'')
    WHERE [NombreProducto] NOT IN (SELECT descripcion FROM ddbba.Producto)';
    
    EXEC sp_executesql @SQL;
END;
go
PRINT 'SP Importar_Productos_importados se creo exitosamente';
go

--ejecutar el Store procedure
EXEC Importar_Productos_importados 'C:\Users\luciano\Desktop\UNLAM\2025\BBDD-APLICADAS\TP_integrador_Archivos_1\Productos\Productos_importados.xlsx';
go
----fijarse
--SELECT * FROM ddbba.Producto
----borrar el SP
--DROP PROCEDURE Importar_Productos_importados

---------------------------------------------------------------------------------------------
-- Procedimiento para importar catalogo.csv
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Importar_Catalogo') 
BEGIN
	 DROP PROCEDURE Importar_Catalogo;
	 PRINT 'SP Importar_Catalogo ya existe -- > se borro';
END;
go
CREATE PROCEDURE Importar_Catalogo
    @RutaArchivo NVARCHAR(255)
AS
BEGIN

	 DECLARE @SQL NVARCHAR(MAX);
		SET @SQL = '
		CREATE TABLE #Temp_Catalogo (
			id int,
			categoria VARCHAR(100),
			nombre  NVARCHAR(255),
			precio DECIMAL(10, 2),
			precio_referencia decimal (10,2),
			unidad varchar(10),
			fecha datetime
		);
    
		BULK INSERT #Temp_Catalogo
		FROM ''' + @RutaArchivo + '''
		WITH (
			FORMAT = ''CSV'',
			FIRSTROW = 2,
			FIELDTERMINATOR = '','',
			ROWTERMINATOR = ''0X0a'',
			CODEPAGE = ''65001'',
			TABLOCK
		);
    
		INSERT INTO ddbba.Producto (linea, descripcion, precio_unitario, precio_referencia, unidad, fecha, moneda)
		SELECT categoria, nombre, precio, precio_referencia, unidad, fecha, ''pesos''
		FROM #Temp_Catalogo
		WHERE nombre NOT IN (SELECT descripcion FROM ddbba.Producto)
    
		DROP TABLE #Temp_Catalogo';
		
		EXEC sp_executesql @SQL;
END;
go
PRINT 'SP Importar_Catalogo se creo exitosamente';
go

--ejecutar el Store procedure
EXEC Importar_Catalogo 'C:\Users\luciano\Desktop\UNLAM\2025\BBDD-APLICADAS\TP_integrador_Archivos_1\Productos\catalogo.csv';
go
----fijarse
--SELECT * FROM ddbba.Producto
----borrar el SP
--DROP PROCEDURE Importar_Catalogo






/*
SELECT * FROM ddbba.Producto
--borrar tablas
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
	DROP TABLE ddbba.Sucursal*/

	EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1;
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1;
