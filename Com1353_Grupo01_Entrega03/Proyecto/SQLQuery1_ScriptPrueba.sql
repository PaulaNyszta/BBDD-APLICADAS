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

--PRUEBA 2 TABLA EMPLEADO
--2.1 insertar

-- Asegurarnos de que los datos existen antes de la prueba
-- Suponemos que tenemos una tabla `Sucursal` para hacer pruebas con id_sucursal
-- 2.1.1. Crear una sucursal de prueba para usarla en las inserciones
SET IDENTITY_INSERT ddbba.Sucursal ON; --para que deje agregar manualmente el id
INSERT INTO ddbba.Sucursal (id_sucursal, localidad, direccion, horario, telefono)
VALUES (1, 'Ramos Mejía', 'Calle Ficticia 123', '09:00 - 18:00', '123456789');
SET IDENTITY_INSERT ddbba.Sucursal OFF;
-- 2.1.2 Insertar un empleado con datos válidos
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 1, 
    @cuil = '20-12345678-9', 
    @dni = 12345678, 
    @direccion = 'Calle Ejemplo 456', 
    @apellido = 'Pérez', 
    @nombre = 'Juan', 
    @email_personal = 'juan.perez@gmail.com', 
    @email_empresarial = 'juan.perez@empresa.com', 
    @turno = 'TT', 
    @cargo = 'Desarrollador', 
    @id_sucursal = 1; -- Sucursal existente
	
-- 2.1.3. Prueba de Inserción con `id_empleado` ya existente (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 1, -- Mismo id_empleado que el anterior
    @cuil = '20-23456789-0', 
    @dni = 23456789, 
    @direccion = 'Otra dirección', 
    @apellido = 'Gómez', 
    @nombre = 'Carlos', 
    @email_personal = 'carlos.gomez@gmail.com', 
    @email_empresarial = 'carlos.gomez@empresa.com', 
    @turno = 'TM', 
    @cargo = 'Analista', 
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.4. Prueba con `id_empleado` Nulo (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = NULL, 
    @cuil = '20-23456789-0', 
    @dni = 23456789, 
    @direccion = 'Dirección Válida', 
    @apellido = 'Gómez', 
    @nombre = 'Carlos', 
    @email_personal = 'carlos.gomez@gmail.com', 
    @email_empresarial = 'carlos.gomez@empresa.com', 
    @turno = 'TT', 
    @cargo = 'Analista', 
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.5. Prueba con CUIL Incorrecto (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 2, 
    @cuil = '201234567890', -- CUIL inválido (error esperado)
    @dni = 34567890, 
    @direccion = 'Dirección Válida', 
    @apellido = 'Gómez', 
    @nombre = 'Carlos', 
    @email_personal = 'carlos.gomez@gmail.com', 
    @email_empresarial = 'carlos.gomez@empresa.com', 
    @turno = 'TT', 
    @cargo = 'Analista', 
    @id_sucursal = 1; -- Sucursal existente

--2.1.6. Prueba con DNI Incorrecto (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 3, 
    @cuil = '20-34567890-1', 
    @dni = 3456789, -- DNI inválido (error esperado)
    @direccion = 'Dirección Válida', 
    @apellido = 'Martínez', 
    @nombre = 'Ana', 
    @email_personal = 'ana.martinez@gmail.com', 
    @email_empresarial = 'ana.martinez@empresa.com', 
    @turno = 'TT', 
    @cargo = 'Jefe de Proyecto', 
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.7. Prueba con Turno Incorrecto (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 4, 
    @cuil = '20-45678901-2', 
    @dni = 45678901, 
    @direccion = 'Dirección Válida', 
    @apellido = 'Sánchez', 
    @nombre = 'Pedro', 
    @email_personal = 'pedro.sanchez@gmail.com', 
    @email_empresarial = 'pedro.sanchez@empresa.com', 
    @turno = 'Mañana', -- Turno inválido (error esperado)
    @cargo = 'Consultor', 
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.8. Prueba con nombre nulo (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 5, 
    @cuil = '20-56789012-3', 
    @dni = 56789012, 
    @direccion = 'Dirección Válida', 
    @apellido = 'Fernández', 
    @nombre = NULL, --Nombre Invalido
    @email_personal = 'lucia.fernandez@gmail.com', 
    @email_empresarial = 'lucia.fernandez@empresa.com', 
    @turno = 'TM', 
    @cargo = 'Líder de Equipo', 
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.9. Prueba con apwllido nulo (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 5, 
    @cuil = '20-56789012-3', 
    @dni = 56789012, 
    @direccion = 'Dirección Válida', 
    @apellido = NULL, --apellido Invalido
    @nombre = 'Pedro', 
    @email_personal = 'lucia.fernandez@gmail.com', 
    @email_empresarial = 'lucia.fernandez@empresa.com', 
    @turno = 'TM', 
    @cargo = 'Líder de Equipo', 
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.10. Prueba con cargo nulo (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 5, 
    @cuil = '20-56789012-3', 
    @dni = 56789012, 
    @direccion = 'Dirección Válida', 
    @apellido = 'Fernández', 
    @nombre = 'Pedro',
    @email_personal = 'lucia.fernandez@gmail.com', 
    @email_empresarial = 'lucia.fernandez@empresa.com', 
    @turno = 'TM', 
    @cargo = NULL, --Cargo invalido
    @id_sucursal = 1; -- Sucursal existente

-- 2.1.11. Prueba con Sucursal Inexistente (debe dar error)
EXEC Procedimientos.insertarEmpleado
    @id_empleado = 5, 
    @cuil = '20-56789012-3', 
    @dni = 56789012, 
    @direccion = 'Dirección Válida', 
    @apellido = 'Fernández', 
    @nombre = 'Lucía', 
    @email_personal = 'lucia.fernandez@gmail.com', 
    @email_empresarial = 'lucia.fernandez@empresa.com', 
    @turno = 'TM', 
    @cargo = 'Líder de Equipo', 
    @id_sucursal = 999; -- Sucursal inexistente (error esperado)

-- 2.1.12. Verificación Final: Mostrar los empleados insertados
SELECT * FROM ddbba.Empleado; -- Verificar que los empleados se hayan insertado correctamente

--2.2 Modificar
-- Asegurarnos de que los datos existen antes de la prueba
-- Suponemos que tenemos una tabla `Empleado` con datos de prueba

--2.2. Modificar
-- 2.2.1. Prueba de Modificación Exitosa
-- Cambiar dirección, turno y email empresarial
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 1, 
    @direccion = 'Nueva Dirección 456', 
    @turno = 'TM', 
    @email_empresarial = 'juan.nuevo@empresa.com';

-- 2.2.2. Prueba de Modificación con CUIL Incorrecto (debe dar error)
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 1, 
    @cuil = '20-12345678-99'; -- CUIL inválido (error esperado)

-- 2.2.3. Prueba de Modificación con DNI Incorrecto (debe dar error)
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 1, 
    @dni = 123456789; -- DNI inválido (error esperado)

-- 2.2.4. Prueba de Modificación con Turno Incorrecto (debe dar error)
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 1, 
    @turno = 'Mañana'; -- Turno inválido (error esperado)

-- 2.2.5. Prueba de Modificación con Sucursal Inexistente (debe dar error)
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 1, 
    @id_sucursal = 999; -- Sucursal inexistente (error esperado)

-- 2.2.6. Prueba de Modificación con Empleado Inexistente (debe dar error)
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 9999; -- Empleado inexistente (error esperado)

-- 2.2.7. Prueba de Modificación con Todos los Campos Nulos (debe modificar sólo lo que se especifique)
EXEC Procedimientos.modificarEmpleado
    @id_empleado = 1, 
    @nombre = 'Carlos'; -- Sólo se cambia el nombre

-- 2.2.8. Verificar si la modificación de datos fue exitosa
SELECT * FROM ddbba.Empleado WHERE id_empleado = 1; -- Mostrar datos del empleado después de la modificación

--2.3. Eliminacion
-- Asegurarnos de que los datos existen antes de la prueba
-- Primero, insertamos algunos empleados de prueba

-- 2.3.1. Crear empleados de prueba para hacer las pruebas de eliminación
INSERT INTO ddbba.Empleado (id_empleado, cuil, dni, direccion, apellido, nombre, email_personal, email_empresarial, turno, cargo, id_sucursal)
VALUES 
(2, '20-23456789-0', 23456789, 'Calle Ejemplo 456', 'Gómez', 'Carlos', 'carlos.gomez@gmail.com', 'carlos.gomez@empresa.com', 'TM', 'Analista', 1),
(3, '20-34567890-1', 34567890, 'Calle Ejemplo 789', 'Martínez', 'Ana', 'ana.martinez@gmail.com', 'ana.martinez@empresa.com', 'Jornada completa', 'Jefe de Proyecto', 1);

-- 2.3.2. Prueba de Eliminación Exitosa
-- Eliminar un empleado que existe
EXEC Procedimientos.eliminarEmpleado @id_empleado = 1;

-- 2.3.3. Prueba de Eliminación con `id_empleado` Inexistente (debe dar error)
-- Intentamos eliminar un empleado que no existe
EXEC Procedimientos.eliminarEmpleado @id_empleado = 999; -- ID no existente (error esperado)

-- 2.3.4. Verificación Final: Mostrar los empleados restantes
SELECT * FROM ddbba.Empleado; -- Verificar que solo queda el empleado con id_empleado = 2 y 3 (eliminado el de id_empleado = 1)
-- 2.3.5 Eliminar el resto de los empleados que existe
EXEC Procedimientos.eliminarEmpleado @id_empleado = 2;
EXEC Procedimientos.eliminarEmpleado @id_empleado = 3;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--PRUEBA 3 TABLA PEDIDO
--3.1. insertar
--generamos datos validos para poder inserta pedido
INSERT INTO ddbba.Cliente (dni,genero,tipo,apellido,nombre,fecha_nac )
VALUES ('12345678','Female','Member','Perez','Jazmin','2019-11-12'),
		('87654321','Female','Member','Perez','Lola','2019-11-12')
SET IDENTITY_INSERT ddbba.Mediopago ON;
INSERT INTO ddbba.Mediopago (id_mp,tipo)
VALUES (1,'Cash'),
		(2,'Ewallet')
SET IDENTITY_INSERT ddbba.Mediopago OFF;
SET IDENTITY_INSERT ddbba.Sucursal ON;
INSERT INTO ddbba.Sucursal (id_sucursal,localidad,horario,telefono)
VALUES (2,'Ramos Mejia','nose','444-4444'),
		(3,'Lomas del Mirador','nose','444-4444')
SET IDENTITY_INSERT ddbba.Sucursal OFF;
INSERT INTO ddbba.Empleado (id_empleado, cuil, dni, direccion, apellido, nombre, email_personal, email_empresarial, turno, cargo, id_sucursal)
VALUES (100, '20-23456789-0', 23456789, 'Calle Ejemplo 456', 'Gómez', 'Carlos', 'carlos.gomez@gmail.com', 'carlos.gomez@empresa.com', 'TM', 'Analista', 2),
		(101, '20-23456780-0', 23456780, 'Calle Ejemplo 456', 'Gómez', 'Carlos', 'carlos.gomez@gmail.com', 'carlos.gomez@empresa.com', 'TM', 'Analista', 2)


-- 3.1.1. Caso con id_factura nulo
EXEC Procedimientos.InsertarPedido 
    @id_factura = NULL,
    @fecha_pedido = '2025-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.2. Caso con id_factura en formato incorrecto
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-678',
    @fecha_pedido = '2025-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.4. Caso con fecha de pedido futura
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2035-01-01',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.5. Caso con cliente nulo
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = NULL,
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.6. Caso con id_mp no existente
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 9999,  -- ID de medio de pago no válido
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.7. Caso con identificador de pago con más de 30 caracteres
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO_QUE_SUPERA_LOS_30_CARACTERES',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.8. Caso con empleado no existente
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 9999,  -- ID de empleado no válido
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.9. Caso con sucursal no existente
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 9999,  -- ID de sucursal no válido
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';

-- 3.1.10. Caso con tipo_factura inválido
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'D',  -- Tipo de factura inválido
    @estado_factura = 'Pagado';

-- 3.1.11. Caso con estado_factura inválido
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pendiente';  -- Estado de factura inválido

-- 3.1.12. Caso válido: Datos correctos
EXEC Procedimientos.InsertarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-05',
    @hora_pedido = '14:30:00',
    @dni_cliente = '12345678',
    @id_mp = 1,
    @iden_pago = 'PAGO001',
    @id_empleado = 100,
    @id_sucursal = 2,
    @tipo_factura = 'A',
    @estado_factura = 'Pagado';
-- 3.1.12. Verificación Final: Mostrar Pedido insertado
SELECT * FROM ddbba.Pedido; -- Verificar que los pedidos se hayan insertado correctamente


--3.2. Modificacion
-- 3.2.1. Caso válido: Modificación de un pedido existente con todos los campos
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-03-06',
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 1,
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 3,
    @tipo_factura = 'B',
    @estado_factura = 'NOPagado';

-- 3.2.2. Caso con pedido no existente
EXEC Procedimientos.modificarPedido 
    @id_factura = '999-99-9999',  -- ID de factura que no existe
    @fecha_pedido = '2025-03-06',
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 2,
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 3,
    @tipo_factura = 'B',
    @estado_factura = 'Pagado';

-- 3.2.3. Caso con fecha de pedido futura
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2025-12-31',  -- Fecha futura
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 2,
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 3,
    @tipo_factura = 'B',
    @estado_factura = 'Pagado';

-- 3.2.4. Caso con id_mp no existente
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-12-31',  
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 9999,  -- ID de medio de pago no válido
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 3,
    @tipo_factura = 'B',
    @estado_factura = 'Pagado';

-- 3.2.5. Caso con id_empleado no existente
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-12-31',  
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 2,
    @iden_pago = 'PAGO002',
    @id_empleado = 9999,  -- ID de empleado no válido
    @id_sucursal = 3,
    @tipo_factura = 'B',
    @estado_factura = 'Pagado';

-- 3.2.6. Caso con id_sucursal no existente
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-12-31',  
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 2,
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 9999,  -- ID de sucursal no válido
    @tipo_factura = 'B',
    @estado_factura = 'Pagado';

-- 3.2.7. Caso con tipo_factura inválido
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-12-31',  
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 2,
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 3,
    @tipo_factura = 'D',  -- Tipo de factura inválido
    @estado_factura = 'Pagado';

-- 3.2.8. Caso con estado_factura inválido
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = '2020-12-31',  
    @hora_pedido = '15:30:00',
    @dni_cliente = '87654321',
    @id_mp = 2,
    @iden_pago = 'PAGO002',
    @id_empleado = 101,
    @id_sucursal = 3,
    @tipo_factura = 'B',
    @estado_factura = 'Pendiente';  -- Estado de factura inválido

-- 3.2.9. Caso con campos opcionales nulos
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = NULL,
    @hora_pedido = NULL,
    @dni_cliente = NULL,
    @id_mp = NULL,
    @iden_pago = NULL,
    @id_empleado = NULL,
    @id_sucursal = NULL,
    @tipo_factura = NULL,
    @estado_factura = NULL;  -- Ningún cambio, solo la validación del ID de factura

-- 3.2.10. Caso con un solo cambio en el estado_factura
EXEC Procedimientos.modificarPedido 
    @id_factura = '123-45-6789',
    @fecha_pedido = NULL,
    @hora_pedido = NULL,
    @dni_cliente = NULL,
    @id_mp = NULL,
    @iden_pago = NULL,
    @id_empleado = NULL,
    @id_sucursal = NULL,
    @tipo_factura = NULL,
    @estado_factura = 'NoPagado';  -- Solo cambio de estado de factura



--3.3. Eliminacion
-- 3.3.1. Caso válido: Eliminación de un pedido existente
EXEC Procedimientos.eliminarPedido 
    @id_factura = '123-45-6789';  -- ID de factura que existe

-- 3.3.2. Caso con pedido no existente
EXEC Procedimientos.eliminarPedido 
    @id_factura = '999-99-9999';  -- ID de factura que no existe

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--PRUEBAS 4 TABLA PRODUCTO
--4.1. insercion
-- 4.1.1: Inserción válida
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Premium',
    @precio_unitario = 150.00,
    @linea = 'Bebidas',
    @precio_referencia = 130.00,
    @unidad = 'Kg',
    @cantidadPorUnidad = '1',
    @moneda = 'USD',
    @fecha = '2025-03-02';

-- 4.1.2: Producto ya existente
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Premium',
    @precio_unitario = 160.00,
    @linea = 'Bebidas',
    @precio_referencia = 140.00,
    @unidad = 'Kg',
    @cantidadPorUnidad = '1',
    @moneda = 'USD',
    @fecha = '2025-03-02';

-- 4.1.3: Precio unitario negativo
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Standard',
    @precio_unitario = -100.00,
    @linea = 'Bebidas',
    @precio_referencia = 100.00,
    @unidad = 'Kg',
    @cantidadPorUnidad = '1',
    @moneda = 'USD',
    @fecha = '2025-03-02';

-- 4.1.4: Precio de referencia negativo
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Té Verde',
    @precio_unitario = 120.00,
    @linea = 'Bebidas',
    @precio_referencia = -50.00,
    @unidad = 'Bolsa',
    @cantidadPorUnidad = '20',
    @moneda = 'EUR',
    @fecha = '2025-03-02';

-- 4.1.5: Fecha futura
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Gourmet',
    @precio_unitario = 250.00,
    @linea = 'Bebidas',
    @precio_referencia = 220.00,
    @unidad = 'Kg',
    @cantidadPorUnidad = '1',
    @moneda = 'USD',
    @fecha = '2026-03-02';

-- 4.1.6: Moneda no permitida
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Exótico',
    @precio_unitario = 200.00,
    @linea = 'Bebidas',
    @precio_referencia = 180.00,
    @unidad = 'Kg',
    @cantidadPorUnidad = '1',
    @moneda = 'GBP',
    @fecha = '2025-03-02';

-- 4.1.7: Moneda nula
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Colombiano',
    @precio_unitario = 180.00,
    @linea = 'Bebidas',
    @precio_referencia = 160.00,
    @unidad = 'Kg',
    @cantidadPorUnidad = '1',
    @moneda = NULL,
    @fecha = '2025-03-02';

-- 4.1.8: Precio unitario NULL
EXEC Procedimientos.insertarProducto
    @nombre_producto = 'Café Expreso',
    @precio_unitario = NULL,
    @linea = 'Bebidas',
    @precio_referencia = 100.00,
    @unidad = 'Taza',
    @cantidadPorUnidad = '1',
    @moneda = 'USD',
    @fecha = '2025-03-02';

--4.2. Modificacion

-- 4.2.1 Modificación válida (cambiar precio y moneda)
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @precio_unitario = 160.00,
    @moneda = 'EUR';

--  4.2.2: Producto no existente
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Inexistente',
    @precio_unitario = 150.00;

--  4.2.3: Precio unitario negativo
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @precio_unitario = -100.00;

-- 4.2.4: Precio de referencia negativo
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @precio_referencia = -50.00;

-- 4.2.5: Fecha futura
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium ',
    @fecha = '2026-03-02';

-- 4.2.6: Moneda no permitida
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @moneda = 'GBP';

-- 4.2.7: Modificación sin cambios (debe mantener los valores actuales)
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium';

-- 4.2.8: Cambio de unidad y cantidad por unidad
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @unidad = 'Litro',
    @cantidadPorUnidad = '2';

-- 4.2.9: Modificar varios campos a la vez
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @precio_unitario = 170.00,
    @linea = 'Bebidas Especiales',
    @moneda = 'USD',
    @fecha = '2025-03-02';

-- 4.2.10: Intentar poner moneda en NULL (debe mantener la anterior)
EXEC Procedimientos.modificarProducto
    @nombre_producto = 'Café Premium',
    @moneda = NULL;
--4.2.11 visualizar las modificaciones
SELECT * FROM ddbba.Producto;


--4.3. Eliminacion
-- 4.3.1: Eliminación exitosa de un producto existente
EXEC Procedimientos.eliminarProducto
    @nombre_producto = 'Café Premium';

-- 4.3.2: Intentar eliminar un producto que no existe
EXEC Procedimientos.eliminarProducto
    @nombre_producto = 'Café Inexistente';

-- 4.3.3: Intentar eliminar con un nombre en NULL (debería fallar)
EXEC Procedimientos.eliminarProducto
    @nombre_producto = NULL;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--prueba para SP insertarProveedor, Ejecute los siguientes juegos de prueba y  luego el SELECT para ver los resultados
-- datos invalidos

EXEC ddbba.insertarProveedor
	'peperino'; --se debe agregar el proveedor
EXEC ddbba.insertarProveedor
	'peperino'; --debe dar error de existencia
SELECT * FROM ddbba.Proveedor WHERE nombre = 'Peperino'; --observe que el proveedor fue agregado exitosamente




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


