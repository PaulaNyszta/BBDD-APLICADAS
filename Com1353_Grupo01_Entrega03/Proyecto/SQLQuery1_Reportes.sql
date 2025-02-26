--4. SCRIPT DE REPORTES  - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].

--ATENCION: puede ejecutar directamente el codigo para crear los SP que generan los reportes, luego podra ejecutar cada uno de ellos con la sintaxis de abajo DE CADA REPORTE
--SI NO SE IMPORTAN LOS DATOS DEL SCPRIP 3 NO SE GENERARAN LOS REPORTES YA QUE NO HABRA DATOS DISPONIBLES

--REPORTE Mensual: ingresando un mes y a�o determinado mostrar el total facturado por d�as de la semana, incluyendo s�bado y domingo.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Reporte_FacturacionMensual_XML') 
BEGIN
	 DROP PROCEDURE Reporte_FacturacionMensual_XML;
	 PRINT 'SP Reporte_FacturacionMensual_XML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE Reporte_FacturacionMensual_XML
    @Mes INT,
    @Anio INT
AS
BEGIN
	--valida que se un mes valido 
	IF @Mes>12 or @Mes<1
	BEGIN
		print 'mes invalido';
		return;
	END;
	--valida que se un anio valido 
	IF @Anio>YEAR(GETDATE()) or @Anio<1800
	BEGIN
		print 'Anio invalido';
		return;
	END;
    SELECT 
        DATENAME(WEEKDAY, Ped.fecha_pedido) AS DiaSemana, --Obtiene el nombre del d�a de la semana
        SUM(T.cantidad*P.precio_unitario) AS TotalFacturado 
    FROM ddbba.Tiene T inner join ddbba.Producto P 
			on T.id_producto=P.id_producto
			inner join ddbba.Pedido Ped on Ped.id_pedido = T.id_pedido
    WHERE MONTH(Ped.fecha_pedido) = @Mes AND YEAR(Ped.fecha_pedido) = @Anio
    GROUP BY DATENAME(WEEKDAY, Ped.fecha_pedido) 
    FOR XML PATH('Dia'), ROOT('FacturacionMensual'); 
													
	
END;
go

		/*----------EJECUTAR------------------------
		EXEC Reporte_FacturacionMensual_XML 02,2019
		------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Trimestral: mostrar el total facturado por turnos de trabajo por mes.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerFacturacionPorTrimestreXML') 
BEGIN
	 DROP PROCEDURE ObtenerFacturacionPorTrimestreXML;
	 PRINT 'SP ObtenerFacturacionPorTrimestreXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE ObtenerFacturacionPorTrimestreXML
    @Anio INT,
    @Trimestre INT
AS
BEGIN
	--valida que se un anio valido 
	IF @Anio>YEAR(GETDATE()) or @Anio<1800
	BEGIN
		print 'Anio invalido';
		return;
	END;
	--valida que se un trimestre valido 
	IF @Trimestre>4 or @Trimestre<1
	BEGIN
		print 'Trimestre invalido';
		return;
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
    END

    -- Generar consulta en formato XML
    SELECT
        E.turno AS 'Turno',
        MONTH(F.fecha) AS 'Mes',
        SUM(T.cantidad * PR.precio_unitario) AS 'TotalFacturado'
    FROM
        ddbba.Factura F
    JOIN ddbba.Pedido PED ON F.id_pedido = PED.id_pedido
    JOIN ddbba.Venta V ON V.id_pedido = PED.id_pedido
    JOIN ddbba.Empleado E ON V.id_empleado = E.id_empleado
    JOIN ddbba.Tiene T ON T.id_pedido = PED.id_pedido
    JOIN ddbba.Producto PR ON T.id_producto = PR.id_producto
    WHERE
        YEAR(F.fecha) = @Anio
        AND MONTH(F.fecha) BETWEEN @MesInicio AND @MesFin
    GROUP BY
        E.turno, MONTH(F.fecha)
    ORDER BY
        E.turno, MONTH(F.fecha)
    FOR XML PATH('Factura'), ROOT('Facturas');
END;
go
		/*------------------EJECUTAR-------------------------------------------
		EXEC ObtenerFacturacionPorTrimestreXML @Anio = 2019, @Trimestre = 1;
		--------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango, ordenado de mayor a menor.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Reporte_ProductosVendidos_XML') 
BEGIN
	 DROP PROCEDURE Reporte_ProductosVendidos_XML;
	 PRINT 'SP ObtenerFacturacionPorTrimestreXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE Reporte_ProductosVendidos_XML
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
	--validar que la fecha de inicio se mas cicas que la fecha de fin
	IF @FechaFin<@FechaInicio
	BEGIN
		PRINT 'la fecha de fin debe ser mas grande que la fecha de inicio'
		return;
	END;
    SELECT 
        P.id_producto,
        P.nombre_producto,
        SUM(T.cantidad) AS CantidadVendida
    FROM ddbba.Tiene T
    INNER JOIN ddbba.Producto P ON T.id_producto = P.id_producto
    INNER JOIN ddbba.Pedido Ped ON T.id_pedido = Ped.id_pedido
    WHERE Ped.fecha_pedido BETWEEN @FechaInicio AND @FechaFin
    GROUP BY P.id_producto, P.nombre_producto
    ORDER BY CantidadVendida DESC
    FOR XML PATH('Producto'), ROOT('ReporteProductosVendidos');
END;
go
	/*------------------------EJECUTAR-----------------------------------------------------
	EXEC Reporte_ProductosVendidos_XML '2019-01-01', '2020-01-01' --ejemplo '2024-02-01'
	-----------------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango por sucursal, ordenado de mayor a menor.
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerVentasPorRangoFechasXML') 
BEGIN
	 DROP PROCEDURE ObtenerVentasPorRangoFechasXML;
	 PRINT 'SP ObtenerFacturacionPorTrimestreXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE ObtenerVentasPorRangoFechasXML
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
	--validar que la fecha de inicio se mas cicas que la fecha de fin
	IF @FechaFin<@FechaInicio
	BEGIN
		PRINT 'la fecha de fin debe ser mas grande que la fecha de inicio'
		return;
	END;
    SELECT 
        S.localidad AS Sucursal,
        SUM(T.cantidad) AS CantidadVendida
    FROM ddbba.Venta V
    INNER JOIN ddbba.Pedido Ped ON V.id_pedido = Ped.id_pedido
    INNER JOIN ddbba.Tiene T ON T.id_pedido = Ped.id_pedido
    INNER JOIN ddbba.Sucursal S ON V.id_sucursal = S.id_sucursal
    WHERE Ped.fecha_pedido BETWEEN @FechaInicio AND @FechaFin
    GROUP BY S.localidad
    ORDER BY CantidadVendida DESC
    FOR XML PATH('Venta'), ROOT('ReporteVentas');
END;
go
	/*------------------------------EJECUTAR--------------------------------------------------------
	EXEC ObtenerVentasPorRangoFechasXML @FechaInicio = '2019-01-01', @FechaFin = '2019-02-28';
	--------------------------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Mostrar los 5 productos m�s vendidos en un mes, por semana
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerTopProductosPorSemanaXML') 
BEGIN
	 DROP PROCEDURE ObtenerTopProductosPorSemanaXML;
	 PRINT 'SP ObtenerFacturacionPorTrimestreXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE ObtenerTopProductosPorSemanaXML
     @Mes INT ,
	 @Anio INT
  
AS
BEGIN
	--valida que se un mes valido 
	IF @Mes>12 or @Mes<1
	BEGIN
		print 'mes invalido';
		return;
	END;
	--valida que se un anio valido 
	IF @Anio>YEAR(GETDATE()) or @Anio<1800
	BEGIN
		print 'Anio invalido';
		return;
	END;

    WITH Semanas AS (
        SELECT 
            (DATEPART(WEEK, Ped.fecha_pedido) - DATEPART(WEEK, DATEFROMPARTS(@Anio, @Mes, 1)) + 1) AS Semana,
            P.id_producto,
            P.nombre_producto,
            SUM(T.cantidad) AS CantidadVendida
        FROM ddbba.Tiene T
        INNER JOIN ddbba.Producto P ON T.id_producto = P.id_producto
        INNER JOIN ddbba.Pedido Ped ON T.id_pedido = Ped.id_pedido
        WHERE YEAR(Ped.fecha_pedido) = @Anio
          AND MONTH(Ped.fecha_pedido) = @Mes
        GROUP BY DATEPART(WEEK, Ped.fecha_pedido), P.id_producto, P.nombre_producto
    )
    SELECT 
        S.Semana,
        S.id_producto,
        S.nombre_producto,
        S.CantidadVendida
    FROM Semanas S
    WHERE (SELECT COUNT(*) FROM Semanas S2 
           WHERE S2.Semana = S.Semana 
           AND S2.CantidadVendida >= S.CantidadVendida) <= 5
    ORDER BY S.Semana, S.CantidadVendida DESC
    FOR XML PATH('Producto'), ROOT('TopProductos');
END;
go
	/*------------------EJECUTAR----------------------------------
	EXEC ObtenerTopProductosPorSemanaXML @Mes = 3, @Anio = 2019;
	------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Mostrar los 5 productos menos vendidos en el mes. 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerMenoresProductosDelMesXML') 
BEGIN
	 DROP PROCEDURE ObtenerMenoresProductosDelMesXML;
	 PRINT 'SP ObtenerMenoresProductosDelMesXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE ObtenerMenoresProductosDelMesXML
    @Mes INT,
	@Anio INT
    
AS
BEGIN
	--valida que se un mes valido 
	IF @Mes>12 or @Mes<1
	BEGIN
		print 'mes invalido';
		return;
	END;
	--valida que se un anio valido 
	IF @Anio>YEAR(GETDATE()) or @Anio<1800
	BEGIN
		print 'Anio invalido';
		return;
	END;

    WITH VentasMes AS (
        SELECT 
            P.id_producto,
            P.nombre_producto,
            SUM(T.cantidad) AS CantidadVendida
        FROM ddbba.Tiene T
        INNER JOIN ddbba.Producto P ON T.id_producto = P.id_producto
        INNER JOIN ddbba.Pedido Ped ON T.id_pedido = Ped.id_pedido
        WHERE YEAR(Ped.fecha_pedido) = @Anio
          AND MONTH(Ped.fecha_pedido) = @Mes
        GROUP BY P.id_producto, P.nombre_producto
    )
    SELECT TOP 5 -- Solo tomamos los 5 productos con menor cantidad vendida
        V.id_producto,
        V.nombre_producto,
        V.CantidadVendida
    FROM VentasMes V
    ORDER BY V.CantidadVendida ASC -- Orden ascendente para los menos vendidos
    FOR XML PATH('Producto'), ROOT('BottomProductos');
END;
GO
	/*------------EJECUTAR-----------------------------------------
	EXEC ObtenerMenoresProductosDelMesXML  @Mes = 1,@Anio = 2019;
	-------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Mostrar total acumulado de ventas (o sea tambi�n mostrar el detalle) para una fecha y sucursal particulares 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ObtenerVentasPorFechaYSucursalXML') 
BEGIN
	 DROP PROCEDURE ObtenerVentasPorFechaYSucursalXML;
	 PRINT 'SP ObtenerVentasPorFechaYSucursalXML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE ObtenerVentasPorFechaYSucursalXML
    @Fecha DATE,
    @SucursalID INT
AS
BEGIN
	--validar que el id de la sucursal exista
	IF NOT EXISTS (SELECT 1 FROM ddbba.Sucursal WHERE @SucursalID=id_sucursal)
	BEGIN
		print 'sucursal no xiste';
		return;
	END;


    -- C�lculo del detalle de ventas y total acumulado en un solo bloque
    WITH VentasDetalle AS (
        SELECT 
            P.id_producto,
            P.nombre_producto,
            SUM(T.cantidad) AS CantidadVendida,
            SUM(T.cantidad * P.precio_unitario) AS TotalVenta
        FROM ddbba.Tiene T
        INNER JOIN ddbba.Producto P ON T.id_producto = P.id_producto
        INNER JOIN ddbba.Pedido Ped ON T.id_pedido = Ped.id_pedido
        INNER JOIN ddbba.Venta V ON Ped.id_pedido = V.id_pedido
        WHERE Ped.fecha_pedido = @Fecha
          AND V.id_sucursal = @SucursalID
        GROUP BY P.id_producto, P.nombre_producto
    )

    -- Generaci�n del XML para los detalles de ventas y el total acumulado en un solo SELECT
    SELECT 
        V.id_producto,
        V.nombre_producto,
        V.CantidadVendida,
        V.TotalVenta
    FROM VentasDetalle V
    UNION ALL
    SELECT 
        NULL AS id_producto,
        'Total Acumulado' AS nombre_producto,
        SUM(V.CantidadVendida) AS CantidadVendida,
        SUM(V.TotalVenta) AS TotalVenta
    FROM VentasDetalle V
    FOR XML PATH('Producto'), ROOT('ReporteVentas');
END;
GO
	/*-------------------EJECUTAR----------------------------------------------------
	EXEC ObtenerVentasPorFechaYSucursalXML @Fecha = '2019-02-15', @SucursalID = 2;
	-------------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPORTE Mensual: ingresando un mes y a�o determinado mostrar el vendedor de mayor monto facturado por sucursal. 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Reporte_VendedorTopPorSucursal_XML') 
BEGIN
	 DROP PROCEDURE Reporte_VendedorTopPorSucursal_XML;
	 PRINT 'SP Reporte_VendedorTopPorSucursal_XML ya existe -- > se creara nuevamente';
END;
go
CREATE PROCEDURE Reporte_VendedorTopPorSucursal_XML
    @Mes INT,
    @Anio INT
AS
BEGIN
	--valida que se un mes valido 
	IF @Mes>12 or @Mes<1
	BEGIN
		print 'mes invalido';
		return;
	END;
	--valida que se un anio valido 
	IF @Anio>YEAR(GETDATE()) or @Anio<1800
	BEGIN
		print 'Anio invalido';
		return;
	END;
    SET NOCOUNT ON;

    WITH FacturacionPorVendedor AS (
        SELECT 
            E.id_empleado,
            E.nombre AS NombreVendedor,
            S.id_sucursal,
            S.localidad AS LocalidadSucursal,
            SUM(T.cantidad * P.precio_unitario) AS TotalFacturado
        FROM ddbba.Pedido Ped
        INNER JOIN ddbba.Venta V ON Ped.id_pedido = V.id_pedido
        INNER JOIN ddbba.Tiene T ON Ped.id_pedido = T.id_pedido
        INNER JOIN ddbba.Producto P ON T.id_producto = P.id_producto
        INNER JOIN ddbba.Empleado E ON V.id_empleado = E.id_empleado
        INNER JOIN ddbba.Sucursal S ON V.id_sucursal = S.id_sucursal
       WHERE MONTH(Ped.fecha_pedido) = @Mes AND YEAR(Ped.fecha_pedido) = @Anio
        GROUP BY E.id_empleado, E.nombre, S.id_sucursal, S.localidad
    ),
    MaxFacturacionPorSucursal AS (
        SELECT 
            id_sucursal, 
            MAX(TotalFacturado) AS MaxFacturado
        FROM FacturacionPorVendedor
        GROUP BY id_sucursal
    )
    SELECT 
        FV.id_sucursal as Id_sucursal,
        FV.LocalidadSucursal AS localidad,
        FV.id_empleado AS Id_empleado,
        FV.NombreVendedor AS Vendedor,
        FV.TotalFacturado AS Total_facturado
    FROM FacturacionPorVendedor FV
    INNER JOIN MaxFacturacionPorSucursal MF 
        ON FV.id_sucursal = MF.id_sucursal 
        AND FV.TotalFacturado = MF.MaxFacturado
    FOR XML PATH('Reporte'), ROOT('FacturacionMensual');
END;
go
	/*----------------EJECUTAR----------------------------------------
	EXEC Reporte_VendedorTopPorSucursal_XML @Mes = 2, @Anio = 2019;
	----------------------------------------------------------------*/
