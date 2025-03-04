--4. SCRIPT DE REPORTES  - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
Use Com1353G01; go;
--ATENCION: puede ejecutar directamente el codigo para crear los SP que generan los reportes, luego podra ejecutar cada uno de ellos con la sintaxis de abajo DE CADA REPORTE
--SI NO SE IMPORTAN LOS DATOS DEL SCPRIP 3 NO SE GENERARAN LOS REPORTES YA QUE NO HABRA DATOS DISPONIBLES
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


		/*----------EJECUTAR------------------------
		EXEC Rep.Reporte_FacturacionMensual_XML 03,2019
		------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

		/*------------------EJECUTAR-------------------------------------------
		EXEC Rep.ObtenerFacturacionPorTrimestreXML @Anio = 2019, @Trimestre = 1;
		--------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
        PRINT 'La fecha de fin debe ser más grande que la fecha de inicio';
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


	/*------------------------EJECUTAR-----------------------------------------------------
	EXEC Reporte_ProductosVendidos_XML '2019-01-01', '2020-01-01' 
	--ejemplo '2024-02-01'
	-----------------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	--validar que la fecha de inicio se mas cicas que la fecha de fin
	IF @FechaFin<@FechaInicio
	BEGIN
		PRINT 'la fecha de fin debe ser mas grande que la fecha de inicio'
		return;
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
	/*------------------------------EJECUTAR--------------------------------------------------------
	EXEC Rep.ObtenerVentasPorRangoFechasXML @FechaInicio = '2019-01-01', @FechaFin = '2019-02-28';
	--------------------------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

	/*------------------EJECUTAR----------------------------------
	EXEC Rep.ObtenerTopProductosPorSemanaXML @Mes = 3, @Anio = 2019;
	------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

	/*------------EJECUTAR-----------------------------------------
	EXEC ObtenerMenoresProductosDelMesXML  @Mes = 1,@Anio = 2019;
	-------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

	/*-------------------EJECUTAR----------------------------------------------------
	EXEC Rep.ObtenerVentasPorFechaYSucursalXML @Fecha = '2019-02-15', @SucursalID = 2;
	-------------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

	/*----------------EJECUTAR----------------------------------------
	EXEC Rep.Reporte_VendedorTopPorSucursal_XML @Mes = 2, @Anio = 2019;
	----------------------------------------------------------------*/



