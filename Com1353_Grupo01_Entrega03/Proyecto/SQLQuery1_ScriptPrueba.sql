-- 2. CRIPT DE PRUEBAS - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
--ATENCION: Estas pruebas se ejecutaran paso por paso
Use Com1353G01
-- prueba para SP insertarSucursal, Ejecute los siguientes juegos de prueba y luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarSucursal
	'Ramos','Av Rivadavia 2343','L 00:00','0000000000'; --debe dar error en la localidad
EXEC ddbba.insertarSucursal
	'Ramos Mejia','Av Rivadavia 2343','L 00:00','0000000000'; --debe dar error en el telefono
EXEC ddbba.insertarSucursal
	'Ramos Mejia','Av Rivadavia 2343','L 00:00','000000000'; --debe insertar la sucursal correctamente
EXEC ddbba.insertarSucursal
	'Ramos Mejia','Av Rivadavia 2343','L 00:00','000000000'; --debe dacer que la sucursal ya es existente
SELECT * FROM ddbba.Sucursal WHERE localidad='Ramos Mejia' and direccion='Av Rivadavia 2343'; --observe que la sucursal fue agregado exitosamente


--prueba para SP insertarEmpleado, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-','1','Av','Gomez','Pedro','GP@','GP@','T','Sup',1; --debe dar error en el cuil
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','1','Av','Gomez','Pedro','GP@','GP@','T','Sup',1; --debe dar error en el dni
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','11111111','Av','Gomez','Pedro','GP@','GP@','T','Sup',1; --debe dar error en el turno
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','11111111','Av','Gomez','Pedro','GP@','GP@','TT','Sup',40; --debe dar error en el id_sucu
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','11111111','Av','Gomez','Pedro','GP@','GP@','TT','Sup',1; --debe insertarse el empleado correctamente
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','11111111','Av','Gomez','Pedro','GP@','GP@','TT','Sup',1; --debe dar error en id
SELECT * FROM ddbba.Empleado WHERE id_empleado = 900000; --observe que el empleado fue agregado exitosamente

--prueba para SP insertarProveedor, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos

EXEC ddbba.insertarProveedor
	'peperino'; --se debe agregar el proveedor
EXEC ddbba.insertarProveedor
	'peperino'; --debe dar error de existencia
SELECT * FROM ddbba.Proveedor WHERE nombre = 'Peperino'; --observe que el proveedor fue agregado exitosamente

--prueba para SP insertarProducto, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarProducto
	'Perro',-1,'animal',-1,kg,'3x12','AR','2030-09-01'--debe dar error el precio
EXEC ddbba.insertarProducto
	'Perro',1,'animal',-1,kg,'3x12','AR','2030-09-01' --debe dar error el precio de referencia
EXEC ddbba.insertarProducto
	'Perro',1,'animal',1,kg,'3x12','AR','2030-09-01' --debe dar error la fecha
EXEC ddbba.insertarProducto
	'Perro',1,'animal',1,kg,'3x12','AR','2020-09-01' --debe dar error la moneda
EXEC ddbba.insertarProducto
	'Perro',1,'animal',1,kg,'3x12','ARS','2020-09-01' --debe insertar el proveedor correctamente
EXEC ddbba.insertarProducto
	'Perro',1,'animal',1,kg,'3x12','ARS','2020-09-01' --debe decir que el producto ya existe
SELECT * FROM ddbba.Producto WHERE nombre_producto = 'perro' --observe que el precio se actualizo

-- prueba para SP insertarProvee, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarProvee
	90000,90000 --debe dar error el proveedor
EXEC ddbba.insertarProvee
	1,90000 --debe dar error el producuto
EXEC ddbba.insertarProvee
	1,1 --debe insertarse los datos correctamente
EXEC ddbba.insertarProvee
	1,1 --debe decir que los datos ya existen
SELECT * FROM ddbba.Provee WHERE id_producto = 1 AND id_proveedor = 1; --observe que los datos fueron agregado exitosamente


--prueba para SP insertarCliente, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarCliente
    90000,'Mal','Norma','Gomez','Pedro','2030-11-12'; -- debe dar error el genero
EXEC ddbba.insertarCliente
    90000,'Male','Norma','Gomez','Pedro','2030-11-12'; -- debe dar erro el tipo de cliente
EXEC ddbba.insertarCliente
    90000,'Male','Normal','Gomez','Pedro','2030-11-12'; -- debe dar error la fecha
EXEC ddbba.insertarCliente
    90000,'Male','Normal','Gomez','Pedro','2019-11-12'; --de insertar correctamente el cliente
EXEC ddbba.insertarCliente
    90000,'Male','Normal','Gomez','Pedro','2019-11-12'; --debe decir que el id ya existe (error del sistema)
SELECT * FROM ddbba.Cliente WHERE id_cliente = 90000 --observe que el cliente fue agregado exitosamente

-- prueba para SP insertarMedioPago, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.InsertarMedioPago
	'' ;--debe dar error el tipo
EXEC ddbba.InsertarMedioPago
	'Cash' ;--debe insertarse el medio de pago correctamente
EXEC ddbba.InsertarMedioPago
	'Cash' ;--debe decir que ya existe
SELECT * FROM ddbba.MedioPago WHERE tipo = 'Efectivo' --observe que el medio de pago fue agregado exitosamente

-- prueba para SP insertarPedido, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.InsertarPedido
	'2030-01-02','00:00',90000,90000,''; --debe dar error la fecha
EXEC ddbba.InsertarPedido
	'2020-01-02','00:00',90000,90000,''; --debe dar error el identificador de pago
EXEC ddbba.InsertarPedido
	'2020-01-02','00:00',90000,2,'111111111'; --debe dar error el Medio de pago
EXEC ddbba.InsertarPedido
	'2020-01-02','00:00',90000,1,'111111111'; --debe insertar correctamente
EXEC ddbba.InsertarPedido
	'2020-01-02','00:00',90000,1,'111111111'; --debe dar error de existencia
SELECT * FROM ddbba.Pedido WHERE fecha_pedido = '2020-01-02' and hora_pedido='00:00' and id_cliente=90000 and id_mp=1--observe que el pedido fue agregado exitosamente

-- prueba para SP insertarVenta, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarVenta
	100000,10000,10000; --debe dar error el id de pedido
EXEC ddbba.insertarVenta
	1,100000,1111110; --debe dar error el id de sucursal
EXEC ddbba.insertarVenta
	1,1,0; --debe dar error el empleado
EXEC ddbba.insertarVenta
	1,1,900000; --debe insertarse correctamente los datos
SELECT * FROM ddbba.Venta WHERE id_pedido = 1 AND id_sucursal = 1 AND id_empleado = 900000; --observe que la venta fue agregado exitosamente


-- prueba para SP insertarTiene, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarTiene
	0,0,0; --debe dar error el id de producto
EXEC ddbba.insertarTiene
	0,1,0; --debe dar error el id de pedido
EXEC ddbba.insertarTiene
	1,1,0; --debe dar error la cantidad
EXEC ddbba.insertarTiene
	1,1,10; --debe insertarse correctamente los datos
SELECT * FROM ddbba.Tiene WHERE id_pedido = 1 AND id_producto = 1 ;--observe que los datos fueron agregado exitosamente


-- prueba para SP insertarFactura, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarFactura
	'1','Z',10,'2030-01-01',''; --debe dar error en el id
EXEC ddbba.insertarFactura
	'900-00-0000','Z',10,'2030-01-01',''; --debe dar error tipo
EXEC ddbba.insertarFactura
	'900-00-0000','A',10,'2030-01-01',''; --debe dar error en el pedido
EXEC ddbba.insertarFactura
	'900-00-0000','A',1,'2030-01-01',''; --debe dar error la fecha
EXEC ddbba.insertarFactura
	'900-00-0000','A',1,'2030-01-01',''; --debe dar error el estado
EXEC ddbba.insertarFactura
	'900-00-0000','A',1,'2020-01-01','Pagado'; --debe insertarse la factura correctamente
EXEC ddbba.insertarFactura
	'900-00-0000','A',1,'2020-01-01','Pagado'; --debe dar error de existencia
SELECT * FROM ddbba.Factura WHERE id_factura = '900-00-0000' --observe que la factura fue agregado exitosamente


--Luego de ejecutar los SP, emilinar los datos de prueba de las tablas DE ABAJO HACIA ARRIBA
DELETE FROM ddbba.Factura WHERE id_factura= '900-00-0000' ;
DELETE FROM ddbba.Tiene WHERE id_pedido = 1 AND id_producto = 1;
DELETE FROM ddbba.Venta WHERE id_pedido = 1 AND id_sucursal = 1 AND id_empleado = 900000; --observe que el cliente fue agregado exitosamente
DELETE FROM ddbba.Pedido WHERE fecha_pedido = '2020-01-02' and hora_pedido='00:00' and id_cliente=90000 and id_mp=1;
DELETE FROM ddbba.MedioPago WHERE tipo = 'Efectivo' 
DELETE FROM ddbba.Cliente WHERE id_cliente = 90000;
DELETE FROM ddbba.Provee WHERE id_producto = 1 AND id_proveedor = 1;
DELETE FROM ddbba.Producto WHERE nombre_producto = 'perro';
DELETE FROM ddbba.Proveedor WHERE nombre = 'Peperino';
DELETE FROM ddbba.Empleado WHERE id_empleado = 900000;
DELETE FROM ddbba.Sucursal WHERE localidad='Ramos Mejia' and direccion='Av Rivadavia 2343';




--REPORTES
--REPORTE Mensual: ingresando un mes y año determinado mostrar el total facturado por días de la semana, incluyendo sábado y domingo.
EXEC Reporte_FacturacionMensual_XML 00,2019 --debe dar error en el mes
EXEC Reporte_FacturacionMensual_XML 01,2026 --debe dar error en el anio
EXEC Reporte_FacturacionMensual_XML 01,2019 --debe hacer un reporte correcto

--REPORTE Trimestral: mostrar el total facturado por turnos de trabajo por mes.
EXEC ObtenerFacturacionPorTrimestreXML @Anio = 2029, @Trimestre = 1; --debe dar error el anio
EXEC ObtenerFacturacionPorTrimestreXML @Anio = 2019, @Trimestre = 0; --debe dar error el trimestre
EXEC ObtenerFacturacionPorTrimestreXML @Anio = 2019, @Trimestre = 1; --debe hacer un reporte correcto

--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango, ordenado de mayor a menor.
EXEC Reporte_ProductosVendidos_XML '2019-01-01', '2010-01-01' --debe dar error en las fechas de inicio/fin
EXEC Reporte_ProductosVendidos_XML '2019-01-01', '2020-01-01'  --debe hacer un reporte correcto

--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango por sucursal, ordenado de mayor a menor.
EXEC ObtenerVentasPorRangoFechasXML @FechaInicio = '2019-01-01', @FechaFin = '2009-02-28';--debe dar error en las fechas de inicio/fin
EXEC ObtenerVentasPorRangoFechasXML @FechaInicio = '2019-01-01', @FechaFin = '2019-02-28';--debe hacer un reporte correcto

--REPORTE Mostrar los 5 productos más vendidos en un mes, por semana
EXEC ObtenerTopProductosPorSemanaXML 00,2019 --debe dar error en el mes
EXEC ObtenerTopProductosPorSemanaXML 01,2026 --debe dar error en el anio
EXEC ObtenerTopProductosPorSemanaXML 01,2019 --debe hacer un reporte correcto

--REPORTE Mostrar los 5 productos menos vendidos en el mes. 
EXEC ObtenerMenoresProductosDelMesXML 00,2019 --debe dar error en el mes
EXEC ObtenerMenoresProductosDelMesXML 01,2026 --debe dar error en el anio
EXEC ObtenerMenoresProductosDelMesXML 01,2019 --debe hacer un reporte correcto

--REPORTE Mostrar total acumulado de ventas (o sea también mostrar el detalle) para una fecha y sucursal particulares 
EXEC ObtenerVentasPorFechaYSucursalXML @Fecha = '2019-02-15', @SucursalID = 500; --debe dar error la sucursal
EXEC ObtenerVentasPorFechaYSucursalXML @Fecha = '2019-02-15', @SucursalID = 2;

--REPORTE Mensual: ingresando un mes y año determinado mostrar el vendedor de mayor monto facturado por sucursal. 
EXEC Reporte_VendedorTopPorSucursal_XML 00,2019 --debe dar error en el mes
EXEC Reporte_VendedorTopPorSucursal_XML 01,2026 --debe dar error en el anio
EXEC Reporte_VendedorTopPorSucursal_XML 01,2019 --debe hacer un reporte correcto

--ENTREGA N5
--prueba para el SP GenerarNotaCredito
EXEC GenerarNotaCredito '102-06-200', 257026 	--debe dar error el id_factura
EXEC GenerarNotaCredito '102-06-2002', 25702	--debe dar error el id_empleado
--buscar una factura no pagada y luego insertar su id en la ejecucion de abajo
SELECT * FROM ddbba.Factura
EXEC GenerarNotaCredito '', 257026	--debe decir que la factura debe estar pagada
--buscar un empelado que no sea supervisor y luego insertar su id en la ejecucion de abajo
SELECT * FROM ddbba.Empleado
EXEC GenerarNotaCredito '', insertaraqui	--debe decir que la factura debe estar pagada
--buscar un empelado que  sea supervisor y una factura que este pagada  y luego insertar los id aqui abajo
EXEC GenerarNotaCredito '', insertaraqui 	--debe generar una nota de credito valida


