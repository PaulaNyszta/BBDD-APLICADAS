-- Script de pruebas
Use Com1353G01
-- prueba para SP insertarSucursal, Ejecute los siguientes juegos de prueba y luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarSucursal
	90000,'Ramos','Av Rivadavia 2343','L 00:00','0000000000'; --debe dar error en la localidad
EXEC ddbba.insertarSucursal
	90000,'Ramos Mejia','Av Rivadavia 2343','L 00:00','0000000000'; --debe dar error en el telefono
EXEC ddbba.insertarSucursal
	90000,'Ramos Mejia','Av Rivadavia 2343','L 00:00','000000000'; --debe insertar la sucursal correctamente
EXEC ddbba.insertarSucursal
	90000,'Ramos Mejia','Av Rivadavia 2343','L 00:00','000000000'; --debe dar error en el id
SELECT * FROM ddbba.Sucursal WHERE id_sucursal = 90000; --observe que la sucursal fue agregado exitosamente


--prueba para SP insertarEmpleado, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarEmpleado
    11111,'11-11111111-','Av','Gomez','Pedro','GP@','GP@','T','Sup',1; --debe dar error el id
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-','Av','Gomez','Pedro','GP@','GP@','T','Sup',1; --debe dar error en el cuil
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','Av','Gomez','Pedro','GP@','GP@','T','Sup',1; --debe dar error en el turno
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','Av','Gomez','Pedro','GP@','GP@','TT','Sup',1; --debe dar error en el id_sucu
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','Av','Gomez','Pedro','GP@','GP@','TT','Sup',90000; --debe insertarse el empleado correctamente
EXEC ddbba.insertarEmpleado
    900000,'11-11111111-1','Av','Gomez','Pedro','GP@','GP@','TT','Sup',90000; --debe dar error en id
SELECT * FROM ddbba.Empleado WHERE id_empleado = 900000; --observe que el empleado fue agregado exitosamente

--prueba para SP insertarProveedor, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarProveedor
	90000,''; --debe dar error el nombre
EXEC ddbba.insertarProveedor
	90000,'Jose'; --se debe agregar el proveedor
EXEC ddbba.insertarProveedor
	90000,'Jose'; --debe dar error el id
SELECT * FROM ddbba.Proveedor WHERE id_proveedor = 90000; --observe que el proveedor fue agregado exitosamente

--prueba para SP insertarProducto, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarProducto
	0,-1,'','descrip',-1,kg,'2030-09-01' --debe dar error el id
EXEC ddbba.insertarProducto
	90000,-1,'','descrip',-1,kg,'2030-09-01'--debe dar error el precio
EXEC ddbba.insertarProducto
	90000,1,'','descrip',-1,kg,'2030-09-01'--debe dar error la linea
EXEC ddbba.insertarProducto
	90000,1,'bebida','descrip',-1,kg,'2030-09-01' --debe dar error el precio de referencia
EXEC ddbba.insertarProducto
	90000,1,'bebida','descrip',1,kg,'2030-09-01' --debe dar error la fecha
EXEC ddbba.insertarProducto
	90000,1,'bebida','descrip',1,kg,'2020-09-01' --debe insertarse correctamnete los datos
EXEC ddbba.insertarProducto
	90000,1,'bebida','descrip',1,kg,'2020-09-01' --debe encontrar el producto con el mismo id, lo actualizara
SELECT * FROM ddbba.Producto WHERE id_producto = 90000 --observe que el producto fue agregado exitosamente
EXEC ddbba.insertarProducto
	90000,1000,'bebida','descrip',1000,kg,'2020-09-01' --actualicemos sus precios
SELECT * FROM ddbba.Producto WHERE id_producto = 90000 --observe que el precio se actualizo

-- prueba para SP insertarProvee, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarProvee
	10,10 --debe dar error el proveedor
EXEC ddbba.insertarProvee
	90000,10 --debe dar error el producuto
EXEC ddbba.insertarProvee
	90000,90000 --debe insertarse los datos correctamente
SELECT * FROM ddbba.Provee WHERE id_producto = 90000 AND id_proveedor = 90000; --observe que los datos fueron agregado exitosamente


--prueba para SP insertarCliente, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarCliente
    -1,'Mal','Norma','Gomez','Pedro','2030-11-12'; --debe dar error el id
EXEC ddbba.insertarCliente
    90000,'Mal','Norma','Gomez','Pedro','2030-11-12'; -- debe dar error el genero
EXEC ddbba.insertarCliente
    90000,'Male','Norma','Gomez','Pedro','2030-11-12'; -- debe dar erro el tipo de cliente
EXEC ddbba.insertarCliente
    90000,'Male','Normal','Gomez','Pedro','2030-11-12'; -- debe dar error la fecha
EXEC ddbba.insertarCliente
    90000,'Male','Normal','Gomez','Pedro','2019-11-12'; --de insertar correctamente el cliente
EXEC ddbba.insertarCliente
    90000,'Male','Normal','Gomez','Pedro','2019-11-12'; --debe decir que el id ya existe
SELECT * FROM ddbba.Cliente WHERE id_cliente = 90000 --observe que el cliente fue agregado exitosamente

-- prueba para SP insertarMedioPago, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.InsertarMedioPago
	-1,'' ;--debe dar error el id
EXEC ddbba.InsertarMedioPago
	90000,'' ;--debe dar error el tipo
EXEC ddbba.InsertarMedioPago
	90000,'tarjeta' ;--debe insertarse el medio de pago correctamente
EXEC ddbba.InsertarMedioPago
	90000,'' ;--debe dar un id ya existente
SELECT * FROM ddbba.MedioPago WHERE id_mp = 90000 --observe que el medio de pago fue agregado exitosamente

-- prueba para SP insertarPedido, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.InsertarPedido
	-1,'2030-01-02','00:00',90000,90000,''; --debe dar error en el id
EXEC ddbba.InsertarPedido
	90000,'2030-01-02','00:00',90000,90000,''; --debe dar error la fecha
EXEC ddbba.InsertarPedido
	90000,'2020-01-02','00:00',90000,90000,''; --debe dar error el identificador de pago
EXEC ddbba.InsertarPedido
	90000,'2020-01-02','00:00',90000,90000,'111111111'; --debe ingresarse los datos exitosamente
SELECT * FROM ddbba.Pedido WHERE id_pedido = 90000 --observe que el pedido fue agregado exitosamente

-- prueba para SP insertarVenta, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarVenta
	10,10,10; --debe dar error el id de pedido
EXEC ddbba.insertarVenta
	90000,10,0; --debe dar error el id de sucursal
EXEC ddbba.insertarVenta
	90000,90000,0; --debe dar error el empleado
EXEC ddbba.insertarVenta
	90000,90000,900000; --debe insertarse correctamente los datos
SELECT * FROM ddbba.Venta WHERE id_pedido = 90000 AND id_sucursal = 90000 AND id_empleado = 900000; --observe que la venta fue agregado exitosamente


-- prueba para SP insertarTiene, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarTiene
	10,10,0; --debe dar error el id de producto
EXEC ddbba.insertarTiene
	90000,10,0; --debe dar error el id de pedido
EXEC ddbba.insertarTiene
	90000,90000,0; --debe dar error la cantidad
EXEC ddbba.insertarTiene
	90000,90000,10; --debe insertarse correctamente los datos
SELECT * FROM ddbba.Tiene WHERE id_pedido = 90000 AND id_producto = 90000 ;--observe que los datos fueron agregado exitosamente


-- prueba para SP insertarFactura, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos
EXEC ddbba.insertarFactura
	'1','Z',10,'2030-01-01'; --debe dar error en el id
EXEC ddbba.insertarFactura
	'900-00-0000','Z',10,'2030-01-01'; --debe dar error tipo
EXEC ddbba.insertarFactura
	'900-00-0000','A',10,'2030-01-01'; --debe dar error en el pedido
EXEC ddbba.insertarFactura
	'900-00-0000','A',90000,'2030-01-01'; --debe dar error la fecha
EXEC ddbba.insertarFactura
	'900-00-0000','A',90000,'2020-01-01'; --debe insertarse la factura correctamente
EXEC ddbba.insertarFactura
	'900-00-0000','A',90000,'2020-01-01'; --debe dar error el id
SELECT * FROM ddbba.Factura WHERE id_factura = '900-00-0000' --observe que la factura fue agregado exitosamente



--Luego de ejecutar los SP, emilinar los datos de prueba de las tablas
DELETE FROM ddbba.Sucursal WHERE id_sucursal = 90000;
DELETE FROM ddbba.Empleado WHERE id_empleado = 900000;
DELETE FROM ddbba.Proveedor WHERE id_proveedor = 90000;
DELETE FROM ddbba.Producto WHERE id_producto = 90000;
DELETE FROM ddbba.Provee WHERE id_producto = 90000 AND id_proveedor = 90000;
DELETE FROM ddbba.Cliente WHERE id_cliente = 90000;
DELETE FROM ddbba.Pedido WHERE id_pedido= 90000;
DELETE FROM ddbba.MedioPago WHERE id_mp= 90000;
DELETE FROM ddbba.Venta WHERE id_pedido = 90000 AND id_sucursal = 90000 AND id_empleado = 900000 --observe que el cliente fue agregado exitosamente
DELETE FROM ddbba.Tiene WHERE id_pedido= 90000 AND id_producto = 90000;
DELETE FROM ddbba.Factura WHERE id_factura= '900-00-0000' ;

--ENTREGA N4
-- prueba para SP Electronic accessories.xlsx,
--observe que si ponemos una ruta invalida, no dejara cargar los datos
EXEC Importar_ElectronicAccessories 'Electronic accessories.xlsx';
--agregamos una ruta valida y ejecutamos
EXEC Importar_ElectronicAccessories 'C:\Users\paula\OneDrive\Escritorio\UNLaM\BASE DE DATOS APLICADA\TP BBDD APLICADAS\TP_integrador_Archivos_1\Productos\Electronic accessories.xlsx';
--si el archivo ya fue agregado anteriormente y queremos volver a cargar los mismo productos no se modificara (0 rows affected) ya que no permite ingresar productos con el mismo nombre

