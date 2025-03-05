-- 2. CRIPT DE PRUEBAS - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].

--ATENCION: Estas pruebas se ejecutaran paso por paso siguiendo las instruccion en el orden dado :)
--SI ANTES SE REALIZAZON IMPORTACIONES, LO MEJOR ES ELIMINAR EL CONTENIDO DE LAS TABLAS (codigo se cuentra mas abajo en medio) 
--PARA QUE NO HAYA ERRORES A LA HORA DE CARGAR LOS DATOS DE PRUEBA

-- usar la base de datos
Use Com1353G01
DISABLE TRIGGER ddbba.trg_Empleado_Encrypt ON ddbba.Empleado; --desabilotar el trigger para hacer las pruebas

--PRUEBA 1 TABLA SUCURSAL
--1.1. Insercion
-- 1.1.1: Insertar una sucursal válida
EXEC Procedimientos.insertarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234', 
    @horario = '09:00-18:00', 
    @telefono = '123456789';

-- 1.1.2: Intentar insertar una sucursal con la misma localidad y dirección (ya existente)
EXEC Procedimientos.insertarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234', 
    @horario = '10:00-19:00', 
    @telefono = '987654321';

-- 1.1.3: Intentar insertar una sucursal sin dirección (valor nulo)
EXEC Procedimientos.insertarSucursal 
    @localidad = 'San Justo', 
    @direccion = NULL, 
    @horario = '08:00-16:00', 
    @telefono = '123456789';

-- 1.1.4: Insertar una sucursal en una localidad no permitida
EXEC Procedimientos.insertarSucursal 
    @localidad = 'Buenos Aires', 
    @direccion = 'Calle Falsa 123', 
    @horario = '10:00-20:00', 
    @telefono = '123456789';

-- 1.1.5: Insertar una sucursal con un teléfono de menos de 9 caracteres
EXEC Procedimientos.insertarSucursal 
    @localidad = 'Lomas del Mirador', 
    @direccion = 'Calle Real 456', 
    @horario = '07:00-15:00', 
    @telefono = '12345678';

-- 1.1.6: Insertar una sucursal con un teléfono de más de 9 caracteres
EXEC Procedimientos.insertarSucursal 
    @localidad = 'San Justo', 
    @direccion = 'Av. Libertador 789', 
    @horario = '12:00-21:00', 
    @telefono = '1234567890';

-- 1.1.7: Insertar una sucursal sin localidad (valor nulo)
EXEC Procedimientos.insertarSucursal 
    @localidad = NULL, 
    @direccion = 'Calle Nueva 321', 
    @horario = '09:00-17:00', 
    @telefono = '123456789';

--1.1.8 Verificar los cambios
select * from ddbba.Sucursal 


--1.2. Modificacion
-- 1.2.1: Modificar el horario y teléfono de una sucursal existente
EXEC Procedimientos.modificarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234', 
    @nuevo_horario = '10:00-20:00', 
    @nuevo_telefono = '987654321';

-- 1.2.2: Intentar modificar una sucursal que no existe
EXEC Procedimientos.modificarSucursal 
    @localidad = 'Buenos Aires', 
    @direccion = 'Calle Falsa 123', 
    @nuevo_horario = '09:00-18:00', 
    @nuevo_telefono = '123456789';

-- 1.2.3: Intentar modificar con un teléfono de menos de 9 caracteres
EXEC Procedimientos.modificarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234', 
    @nuevo_telefono = '12345678';

-- 1.2.4: Intentar modificar con un teléfono de más de 9 caracteres
EXEC Procedimientos.modificarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234', 
    @nuevo_telefono = '1234567890';

-- 1.2.5: No modificar nada (solo verifica que no falle si no se pasan nuevos valores)
EXEC Procedimientos.modificarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234'


--1.3. Eliminacion
-- 1.3.1: Eliminar una sucursal existente
EXEC Procedimientos.eliminarSucursal 
    @localidad = 'Ramos Mejia', 
    @direccion = 'Av. Rivadavia 1234';

-- 1.3.2: Intentar eliminar una sucursal que no existe
EXEC Procedimientos.eliminarSucursal 
    @localidad = 'Buenos Aires', 
    @direccion = 'Calle Falsa 123';

-- 1.3.3: Intentar eliminar una sucursal sin proporcionar la localidad (NULL)
EXEC Procedimientos.eliminarSucursal 
    @localidad = NULL, 
    @direccion = 'Calle Nueva 321';

-- 1.3.4: Intentar eliminar una sucursal sin proporcionar la dirección (NULL)
EXEC Procedimientos.eliminarSucursal 
    @localidad = 'San Justo', 
    @direccion = NULL;

--1.3.5 observar cambios
select * from ddbba.Sucursal

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 2 TABLA EMPLEADO
--2.1 insertar

-- Suponemos que tenemos una tabla `Sucursal` para hacer pruebas con id_sucursal
-- 2.1.1. Crear una sucursal de prueba para usarla en las inserciones
SET IDENTITY_INSERT ddbba.Sucursal ON;

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

-- 2.1.9. Prueba con apellido nulo (debe dar error)
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



--2.2. Modificar
-- 2.2.1. Prueba de Modificación Exitosa( cambiar dirección, turno y email empresarial)
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
SELECT * FROM ddbba.Empleado 


--2.3. Eliminacion
-- 2.3.1. Crear empleados de prueba para hacer las pruebas de eliminación
INSERT INTO ddbba.Empleado (id_empleado, cuil, dni, direccion, apellido, nombre, email_personal, email_empresarial, turno, cargo, id_sucursal)
VALUES 
(2, '20-23456789-0', 23456789, 'Calle Ejemplo 456', 'Gómez', 'Carlos', 'carlos.gomez@gmail.com', 'carlos.gomez@empresa.com', 'TM', 'Analista', 1),
(3, '20-34567890-1', 34567890, 'Calle Ejemplo 789', 'Martínez', 'Ana', 'ana.martinez@gmail.com', 'ana.martinez@empresa.com', 'Jornada completa', 'Jefe de Proyecto', 1);

-- 2.3.2. Prueba de Eliminación Exitosa(eliminar un empleado que existe)
EXEC Procedimientos.eliminarEmpleado @id_empleado = 1;

-- 2.3.3. Prueba de Eliminación con `id_empleado` Inexistente (debe dar error)
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
INSERT INTO ddbba.Cliente (dni_cliente,genero,tipo,apellido,nombre,fecha_nac )
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

-- 3.1.3. Caso con fecha de pedido futura
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

-- 3.1.4. Caso con cliente nulo
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

-- 3.1.5. Caso con id_mp no existente
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

-- 3.1.6. Caso con identificador de pago con más de 30 caracteres
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

-- 3.1.7. Caso con empleado no existente
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

-- 3.1.8. Caso con sucursal no existente
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

-- 3.1.9. Caso con tipo_factura inválido
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

-- 3.1.10. Caso con estado_factura inválido
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

-- 3.1.11. Caso válido: Datos correctos
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
    @estado_factura = 'NoPagado';

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

--3.2.11 visualizacion de tabla
select * from ddbba.Pedido


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

--4.1.9 visualizar
select * from ddbba.Producto 

--4.2. Modificacion
-- 4.2.1 Modificación válida (cambiar precio y moneda)
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @precio_unitario = 160.00,
    @moneda = 'EUR';

--  4.2.2: Producto no existente
EXEC Procedimientos.modificarProducto
	@id_producto = 999,
    @nombre_producto = 'Café Inexistente',
    @precio_unitario = 150.00;

--  4.2.3: Precio unitario negativo
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @nombre_producto = 'Café Premium',
    @precio_unitario = -100.00;

-- 4.2.4: Precio de referencia negativo
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @nombre_producto = 'Café Premium',
    @precio_referencia = -50.00;

-- 4.2.5: Fecha futura
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @nombre_producto = 'Café Premium ',
    @fecha = '2026-03-02';

-- 4.2.6: Moneda no permitida
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @nombre_producto = 'Café Premium',
    @moneda = 'GBP';

-- 4.2.7: Modificación sin cambios (debe mantener los valores actuales)
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @nombre_producto = 'Café Premium';

-- 4.2.8: Cambio de unidad y cantidad por unidad
EXEC Procedimientos.modificarProducto
	@id_producto =1,
    @unidad = 'Litro',
    @cantidadPorUnidad = '2';

-- 4.2.9: Intentar poner moneda en NULL (debe mantener la anterior)
EXEC Procedimientos.modificarProducto
    @id_producto =1,
    @nombre_producto = 'Café Premium',
    @moneda = NULL;

--4.2.11 visualizar las modificaciones
SELECT * FROM ddbba.Producto;


--4.3. Eliminacion
-- 4.3.1: Eliminación exitosa de un producto existente
EXEC Procedimientos.eliminarProducto
    @id_producto =1;

-- 4.3.2: Intentar eliminar un producto que no existe
EXEC Procedimientos.eliminarProducto
    @id_producto =1;

-- 4.3.3: Observar eliminacion
SELECT * FROM ddbba.Producto;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 5 TABLA PROVEEDORPROVEE
--5.1. 
--insertaremos datos de prueba en la tabla 'Producto' y ;Proveedor'
SET IDENTITY_INSERT ddbba.Producto ON;

INSERT INTO ddbba.Producto (id_producto,nombre_producto,precio_unitario,linea,precio_referencia,unidad,cantidadPorUnidad,moneda,fecha)
 VALUES (2,'Café', 150.00, 'Bebidas', 130.00,'Kg',1,  'USD',  '2020-03-02'),
		(1,'Café Premium', 150.00, 'Bebidas', 130.00,'Kg',1,  'USD',  '2020-03-02');

SET IDENTITY_INSERT ddbba.Producto OFF;

SET IDENTITY_INSERT ddbba.Proveedor ON;

 INSERT INTO ddbba.Proveedor (id_proveedor,nombre)
 VALUES	(2,'Georgalo'),
		(1,'Nestle');

 SET IDENTITY_INSERT ddbba.Proveedor OFF;

-- 5.1.1: Insertar un proveedor y producto válidos
EXEC Procedimientos.insertarProveedorProvee 
@id_proveedor = 1, 
@id_producto = 1;

-- 5.1.2: Intentar insertar un proveedor que no existe
EXEC Procedimientos.insertarProveedorProvee 
@id_proveedor = 999, 
@id_producto = 10;

-- 5.1.3: Intentar insertar un producto que no existe
EXEC Procedimientos.insertarProveedorProvee 
@id_proveedor = 1, 
@id_producto = 999;

-- 5.1.4: Intentar insertar un proveedor con un producto que ya existe en la tabla ProveedorProvee
EXEC Procedimientos.insertarProveedorProvee 
@id_proveedor = 1, 
@id_producto = 1;

-- 5.1.5: Insertar otro proveedor con el mismo producto (para verificar que no haya restricciones indebidas)
EXEC Procedimientos.insertarProveedorProvee 
@id_proveedor = 2, 
@id_producto = 1;

-- 5.1.6: Insertar el mismo proveedor con otro producto (para verificar que un proveedor pueda proveer varios productos)
EXEC Procedimientos.insertarProveedorProvee 
@id_proveedor = 1, 
@id_producto = 2;

--5.1.7 visualizar
select * from ddbba.ProveedorProvee


--5.2. Modificacion
-- 5.2.1 Modificar proveedor y producto existentes con nuevos valores válidos
EXEC Procedimientos.modificarProveedorProvee 
    @id_proveedor = 2, @id_producto = 1, 
    @nuevo_id_proveedor = 2, @nuevo_id_producto = 2;

-- 5.2.2: Intentar modificar una relación que no existe
EXEC Procedimientos.modificarProveedorProvee 
    @id_proveedor = 999, @id_producto = 999, 
    @nuevo_id_proveedor = 2, @nuevo_id_producto = 11;

-- 5.2.3: Modificar solo el proveedor que no existe
EXEC Procedimientos.modificarProveedorProvee 
    @id_proveedor = 1, @id_producto = 1, 
    @nuevo_id_proveedor = 3;

-- 5.2.4: Modificar solo el producto que no existe
EXEC Procedimientos.modificarProveedorProvee 
    @id_proveedor = 1, @id_producto = 1, 
    @nuevo_id_producto = 12;

--5.2.5 visualizar cambios
select * from ddbba.Proveedorprovee


--5.3. Eliminacion
-- 5.3.1: Eliminar una relación proveedor-producto existente
EXEC Procedimientos.eliminarProveedorProvee 
    @id_proveedor = 1, @id_producto = 1;

-- 5.3.2: Intentar eliminar una relación que no existe
EXEC Procedimientos.eliminarProveedorProvee 
    @id_proveedor = 999, @id_producto = 999;

-- 5.3.3: Intentar eliminar un proveedor con un producto inexistente
EXEC Procedimientos.eliminarProveedorProvee 
    @id_proveedor = 1, @id_producto = 999;

-- 5.3.4: Intentar eliminar un producto con un proveedor inexistente
EXEC Procedimientos.eliminarProveedorProvee 
    @id_proveedor = 999, @id_producto = 10;

-- 5.3.5: Intentar eliminar la misma relación dos veces 
EXEC Procedimientos.eliminarProveedorProvee 
    @id_proveedor = 1, @id_producto = 1;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 6 TABLA CLIENTE
--borrar cliente antes generado

--6.1. Insertar un cliente válido
EXEC Procedimientos.insertarCliente 
	@dni = '12345679',
	@genero = 'Male',
	@tipo = 'Normal',
	@apellido = 'Gomez',
	@Nombre = 'Pedro',
	@Fnac = '1990-01-01';

-- 6.1.1: Prueba con campos nulos: Debe devolver un mensaje de error indicando que ninguno de los campos puede ser nulo.
EXEC Procedimientos.insertarCliente 
@dni = NULL, @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

EXEC Procedimientos.insertarCliente 
@DNI = '12345678', @Genero = NULL, @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

-- 6.1.2: Prueba de cliente ya existente: Debe devolver un mensaje indicando que el cliente ya existe.
EXEC Procedimientos.insertarCliente 
@DNI = '12345679', @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

-- 6.1.3: Prueba con DNI incorrecto (menos de 8 dígitos): Debe devolver un mensaje indicando que el DNI debe tener 8 dígitos.
EXEC Procedimientos.insertarCliente 
@DNI = '12345', @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

-- 6.1.4: Prueba con DNI incorrecto (más de 8 dígitos): Debe devolver un mensaje indicando que el DNI debe tener 8 dígitos.
EXEC Procedimientos.insertarCliente 
@DNI = '1234566666689', @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

-- 6.1.5: Prueba con género inválido: Debe devolver un mensaje indicando que el género debe ser "Female" o "Male".
EXEC Procedimientos.insertarCliente 
@DNI = '12345578', @Genero = 'Other', @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

-- 6.1.6: Prueba con tipo de cliente inválido: Debe devolver un mensaje indicando que el tipo de cliente debe ser "Normal" o "Member".
EXEC Procedimientos.insertarCliente 
@DNI = '12345778', @Genero = 'Male', @Tipo = 'VIP', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '1990-01-01';

-- 6.1.7: Prueba con fecha de nacimiento futura: Debe devolver un mensaje indicando que la fecha de nacimiento no puede ser futura.
EXEC Procedimientos.insertarCliente 
@DNI = '12345688', @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Gomez', @Nombre = 'Pedro', @Fnac = '2050-01-01';

--6.1.8 visualizar
SELECT * FROM ddbba.Cliente;

--6.2. Modificacion
--6.2.1 Modificar un cliente válido
EXEC Procedimientos.modificarCliente 
@DNI = '12345679',
@Genero = 'Female',
@Tipo = 'Member',
@Apellido = 'Perez',
@Nombre = 'Ana',
@Fnac = '1985-05-15';

-- 6.2.2: Prueba con cliente inexistente
EXEC Procedimientos.modificarCliente 
@DNI = '99999999', @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Lopez', @Nombre = 'Carlos', @Fnac = '1992-07-10';

-- 6.2.3: Prueba con campos nulos
EXEC Procedimientos.modificarCliente 
@DNI = '12345679', @Genero = NULL, @Tipo = 'Normal', @Apellido = 'Perez', @Nombre = 'Ana', @Fnac = '1985-05-15';

-- 6.2.5: Prueba con género inválido
EXEC Procedimientos.modificarCliente 
@DNI = '12345679', @Genero = 'Other', @Tipo = 'Normal', @Apellido = 'Perez', @Nombre = 'Ana', @Fnac = '1985-05-15';

-- 6.2.6: Prueba con tipo de cliente inválido
EXEC Procedimientos.modificarCliente 
@DNI = '12345679', @Genero = 'Male', @Tipo = 'VIP', @Apellido = 'Perez', @Nombre = 'Ana', @Fnac= '1985-05-15';

-- 6.2.7: Prueba con fecha de nacimiento futura
EXEC Procedimientos.modificarCliente 
@DNI = '12345679', @Genero = 'Male', @Tipo = 'Normal', @Apellido = 'Perez', @Nombre = 'Ana', @Fnac = '2050-01-01';

--6.2.8 visualizar
SELECT * FROM ddbba.Cliente;

--PRUEBA 6.3 ELIMINACION
--6.3.1 Eliminar un cliente válido
EXEC Procedimientos.eliminarCliente 
@DNI = '12345679';

--6.3.2 Intentar eliminar un cliente que no existe
EXEC Procedimientos.eliminarCliente 
@DNI = '99999999'; -- Debe devolver 'Error: Cliente no encontrado'

--6.3.3 Intentar eliminar con DNI NULL
EXEC Procedimientos.eliminarCliente 
@DNI = NULL; -- Debe devolver 'Error: El DNI no puede ser NULL'

--6.3.4 Intentar eliminar con DNI incorrecto (menos de 8 dígitos)
EXEC Procedimientos.eliminarCliente 
@DNI = '12345'; -- Debe devolver 'Error: El DNI debe tener 8 dígitos'

--6.3.5 Intentar eliminar con DNI incorrecto (más de 8 dígitos)
EXEC Procedimientos.eliminarCliente 
@DNI = '123456789012'; -- Debe devolver 'Error: El DNI debe tener 8 dígitos'

--6.3.6 visualizar
select * from ddbba.cliente
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 7 NOTA DE CRÉDITO
--creamos un pedido
INSERT INTO ddbba.Pedido (id_factura,fecha_pedido,hora_pedido,dni_cliente,id_mp,iden_pago,id_empleado,id_sucursal,tipo_factura,estado_factura)
VALUES ('001-01-0002','2020-01-01','00:00',87654321,1,'--',100,1,'A','NoPagado'),
('001-01-0001','2020-01-01','00:00',87654321,1,'--',100,1,'A','Pagado');
INSERT INTO ddbba.ProductoSolicitado (id_factura,id_producto,cantidad)
VALUES ('001-01-0001',1,5);
INSERT INTO ddbba.Empleado (id_empleado,nombre,apellido,dni,direccion,cuil,email_personal,email_empresarial,turno,cargo,id_sucursal)
VALUES (102,'paula','nyszta',45129129,'en mi casa','24-45129129-0','P@','P@','TT','Supervisor',1)


--7.1.1 Insertar una nota de crédito válida
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 1,
	@motivo = 'No me gusto';

--7.1.2 Insertar una nota de credito con factura no pagada
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0002', --factura no pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 1,
	@motivo = 'No me gusto';


--7.1.3 Insertar una nota de crédito con empleado no supervisor 
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 100, --no supervisor
	@cantidadADevolver = 1,
	@motivo = 'No me gusto';

--7.1.4 Intentar insertar con factura inexistente
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0009', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 1,
	@motivo = 'No me gusto';


--7.1.5 Intentar insertar con cantidad a devolver negativa
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = -1,
	@motivo = 'No me gusto';

--7.1.6 Intentar insertar con cantidad mayor a la pagada
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 100,
	@motivo = 'No me gusto';

--7.1.7 Intentar insertar con motivo nulo
EXEC Procedimientos.insertarNotaCredito 
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 1,
	@motivo = NULL;

--7.1.8 visualizar
SELECT * FROM ddbba.NotaCredito;

--7.2 Modificar
--7.2.1 Modificar una nota de crédito válida
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 2,
	@motivo = 'no me gusto';

--7.2.3 Intentar modificar factura no pagada
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0002', --factura no pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 2,
	@motivo = 'no me gusto';

--7.2.4 Intentar modificar sin ser supervisor
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 100, --no supervisor
	@cantidadADevolver = 2,
	@motivo = 'no me gusto';


--7.2.5 Intentar insertar con factura inexistente
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0009', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 1,
	@motivo = 'No me gusto';


--7.1.5 Intentar insertar con cantidad a devolver negativa
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = -1,
	@motivo = 'No me gusto';

--7.1.6 Intentar insertar con cantidad mayor a la pagada
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 100,
	@motivo = 'No me gusto';

--7.1.7 Intentar insertar con motivo nulo
EXEC Procedimientos.modificarNotaCredito 
	@id_nota_credito = 1,
	@id_factura = '001-01-0001', --factura pagada
	@id_empleado = 102, --supervisor
	@cantidadADevolver = 1,
	@motivo = NULL;




--7.3 Eliminar
--7.3.1 Eliminar una nota de crédito existente
EXEC Procedimientos.eliminarNotaCredito 
	@id_nota_credito = 1; -- Debe eliminar correctamente.

--7.3.2 Intentar eliminar una nota de crédito inexistente
EXEC Procedimientos.eliminarNotaCredito 
	@id_nota_credito = 9999; -- Debe devolver 'Error: No existe la Nota de Crédito con ese ID.'

--7.3.3 Intentar eliminar sin especificar ID
EXEC Procedimientos.eliminarNotaCredito 
	@id_nota_credito = NULL; -- Debe devolver 'Error: El ID de la Nota de Crédito no puede ser nulo.'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 8 MEDIO DE PAGO
--8.1 Insertar un medio de pago válido
EXEC Procedimientos.insertarMedioPago 
	@tipo = 'Credit card'; -- Debe insertar correctamente como 'Tarjeta de credito'.

--8.1.2 Intentar insertar un medio de pago con tipo nulo
EXEC Procedimientos.insertarMedioPago 
	@tipo = NULL; -- Debe devolver 'Error: El tipo de medio de pago no puede ser nulo.'

--8.1.3 Intentar insertar un medio de pago con tipo inválido
EXEC Procedimientos.insertarMedioPago 
	@tipo = 'Cheque'; -- Debe devolver 'Error: El medio de pago debe ser Credit card, Cash o Ewallet.'

--8.1.4 Intentar insertar un medio de pago que ya existe
EXEC Procedimientos.insertarMedioPago 
	@tipo = 'Credit card'; -- Debe devolver 'Error: El medio de pago ya existe.' si ya existe en la base de datos.



--8.2 Modificacion
--8.2.1 Modificar un medio de pago existente con tipo válido
EXEC Procedimientos.modificarMedioPago 
	@id_mp = 1, 
	@nuevo_tipo = 'Cash'; -- Debe modificar correctamente a 'Efectivo'.

--8.2.3 Intentar modificar un medio de pago con ID nulo
EXEC Procedimientos.modificarMedioPago 
	@id_mp = NULL, 
	@nuevo_tipo = 'Credit card'; -- Debe devolver 'Error: El ID del medio de pago no puede ser nulo.'

--8.2.4 Intentar modificar un medio de pago con tipo nulo
EXEC Procedimientos.modificarMedioPago 
	@id_mp = 1, 
	@nuevo_tipo = NULL; -- Debe devolver 'Error: El tipo de medio de pago no puede ser nulo.'

--8.2.5 Intentar modificar un medio de pago con un ID que no existe
EXEC Procedimientos.modificarMedioPago 
	@id_mp = 9999, 
	@nuevo_tipo = 'Ewallet'; -- Debe devolver 'Error: No existe un medio de pago con ese ID.'

--8.2.6 Intentar modificar un medio de pago con un tipo inválido
EXEC Procedimientos.modificarMedioPago 
	@id_mp = 1, 
	@nuevo_tipo = 'Cheque'; -- Debe devolver 'Error: El medio de pago debe ser Credit card, Cash o Ewallet.'


--8.3 Eliminacion
--8.3.1 Eliminar un medio de pago existente por ID
EXEC Procedimientos.eliminarMedioPago 
	@id_medio_pago = 2; -- Debe eliminar correctamente el medio de pago con el ID especificado.

--8.3.2 Intentar eliminar un medio de pago con un ID que no existe
EXEC Procedimientos.eliminarMedioPago 
	@id_medio_pago = 9999; -- Debe devolver 'Error: No existe un medio de pago con ese ID.'

--8.3.3 Intentar eliminar un medio de pago sin especificar ni ID ni nombre
EXEC Procedimientos.eliminarMedioPago 
	@id_medio_pago = NULL, 
	@nombre_medio_pago = NULL; -- Debe devolver 'Error: Debe especificar un ID o un nombre del medio de pago.'

--8.3.4 Eliminar un medio de pago existente por nombre
EXEC Procedimientos.eliminarMedioPago 
	@nombre_medio_pago = 'Tarjeta de credito'; -- Debe eliminar correctamente el medio de pago con el nombre especificado.

--8.3.5 Intentar eliminar un medio de pago con un nombre que no existe
EXEC Procedimientos.eliminarMedioPago 
	@nombre_medio_pago = 'Cheque'; -- Debe devolver 'Error: No existe un medio de pago con ese nombre.'


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 9 PROVEEDOR
--9.1.1 Insertar un proveedor válido
EXEC Procedimientos.insertarProveedor 
	@nombre = 'Proveedor A'; -- Debe insertar correctamente el proveedor.

--9.1.2 Intentar insertar un proveedor con nombre nulo
EXEC Procedimientos.insertarProveedor 
	@nombre = NULL; -- Debe devolver 'El nombre del proveedor no puede ser nulo.'

--9.1.3 Intentar insertar un proveedor que ya existe
EXEC Procedimientos.insertarProveedor 
	@nombre = 'Proveedor A'; -- Debe devolver 'El proveedor ya existe en la tabla Proveedor.' si ya existe.

--9.1.4 Insertar un proveedor válido que no existe
EXEC Procedimientos.insertarProveedor 
	@nombre = 'Proveedor B'; -- Debe insertar correctamente el proveedor si no existe en la tabla.

--9.1.5 Intentar insertar un proveedor con un nombre vacío
EXEC Procedimientos.insertarProveedor 
	@nombre = ''; -- Debe devolver 'El nombre del proveedor no puede ser nulo.' o un mensaje adecuado para el caso de cadena vacía, dependiendo de la implementación.


--9.2 Modificar
--9.2.1 Modificar un proveedor existente con nombre válido
EXEC Procedimientos.modificarProveedor 
	@id_proveedor = 1, 
	@nuevo_nombre = 'Proveedor Actualizado'; -- Debe modificar correctamente el nombre del proveedor.

--9.2.2 Intentar modificar un proveedor con nombre nulo
EXEC Procedimientos.modificarProveedor 
	@id_proveedor = 1, 
	@nuevo_nombre = NULL; -- Debe devolver 'El nombre del proveedor no puede ser nulo.'

--9.2.3 Intentar modificar un proveedor que no existe
EXEC Procedimientos.modificarProveedor 
	@id_proveedor = 9999, 
	@nuevo_nombre = 'Nuevo Proveedor'; -- Debe devolver 'El proveedor no existe en la base de datos.'

--9.2.4 Modificar un proveedor con un nuevo nombre válido que no existe en la base de datos
EXEC Procedimientos.modificarProveedor 
	@id_proveedor = 1, 
	@nuevo_nombre = 'Proveedor B'; -- Debe modificar correctamente el proveedor si no existe otro proveedor con ese nombre.


--9.3 Eliminacion
--9.3.1 Eliminar un proveedor existente
EXEC Procedimientos.eliminarProveedor 
	@id_proveedor = 4; -- Debe eliminar correctamente el proveedor con el ID especificado.

--9.3.2 Intentar eliminar un proveedor que no existe
EXEC Procedimientos.eliminarProveedor 
	@id_proveedor = 9999; -- Debe devolver 'El proveedor no existe en la base de datos.'

--9.3.3 Intentar eliminar un proveedor proporcionando un ID nulo
EXEC Procedimientos.eliminarProveedor 
	@id_proveedor = NULL; -- Debe devolver 'El proveedor no existe en la base de datos.' o un mensaje adecuado para el caso de ID nulo.

--9.3.4 visualizar
select * from ddbba.Proveedor
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PRUEBA 10 PRODUCTO_SOLICITADO
--DATOS DE PRUEBA

-- Inserción en la tabla Sucursal
INSERT INTO ddbba.Sucursal (localidad, direccion, horario, telefono)
VALUES ('Centro', 'Av. Libertador 1000', '9:00 - 18:00', '555-1234');

-- Inserción en la tabla Empleado
INSERT INTO ddbba.Empleado (id_empleado, nombre, apellido, dni, direccion, cuil, email_personal, email_empresarial, turno, cargo, id_sucursal)
VALUES (1, 'Juan', 'Perez', 12345678, 'Av. Siempre Viva 123', '20-12345678-9', 'juan.perez@mail.com', 'juan.perez@empresa.com', 'Mañana', 'Vendedor', 1);


-- Inserción en la tabla Producto
INSERT INTO ddbba.Producto (nombre_producto, linea, precio_unitario, precio_referencia, unidad, cantidadPorUnidad, moneda, fecha)
VALUES ('Laptop', 'Electrónica', 1200.00, 1300.00, 'Unidad', '1', 'USD', '2025-03-01');

-- Inserción en la tabla ProveedorProvee
INSERT INTO ddbba.ProveedorProvee (id_proveedor, id_producto)
VALUES (1, 1);

-- Inserción en la tabla Cliente
INSERT INTO ddbba.Cliente (dni_cliente, genero, tipo, apellido, nombre, fecha_nac)
VALUES ('12345670', 'Masculino', 'Particular', 'Lopez', 'Carlos', '1990-05-10');

-- Inserción en la tabla Pedido
INSERT INTO ddbba.Pedido (id_factura, fecha_pedido, hora_pedido, dni_cliente, id_mp, iden_pago, id_empleado, id_sucursal, tipo_factura, estado_factura)
VALUES ('123-45-6789', '2025-03-04', '10:30', '12345678', 1, 'Transferencia', 1, 1, 'A', 'Pagado');

-- Inserción en la tabla NotaCredito
INSERT INTO ddbba.NotaCredito (fecha_emision, dni_cliente, id_factura, nombre_producto, precio_unitario, cantidad, monto, cantidadADevolver, motivo)
VALUES ('2025-03-05', '12345678', '123-45-6789', 'Laptop', 1200.00, 1, 1200.00, 1, 'Devolución parcial');

--10.1.1 Insertar un producto solicitado con datos válidos
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = '123-45-6789', 
	@id_producto = 1, 
	@cantidad = 10; -- Debe insertar correctamente el producto solicitado.

--10.1.2 Intentar insertar un producto solicitado con id_factura nulo
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = NULL, 
	@id_producto = 1, 
	@cantidad = 10; -- Debe devolver 'El id_factura no puede ser nulo.'

--10.1.3 Intentar insertar un producto solicitado con id_producto nulo
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = 'F12345678901', 
	@id_producto = NULL, 
	@cantidad = 10; -- Debe devolver 'El id_producto no puede ser nulo.'

--10.1.4 Intentar insertar un producto solicitado con cantidad nula
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = 'F12345678901', 
	@id_producto = 1, 
	@cantidad = NULL; -- Debe devolver 'La cantidad no puede ser nula.'

--10.1.5 Intentar insertar un producto solicitado con datos duplicados
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = '123-45-6789', 
	@id_producto = 1, 
	@cantidad = 10; -- Debe devolver 'El pedido ya tiene esos datos' si ya existe una entrada con los mismos valores.

--10.1.6 Intentar insertar un producto solicitado con un producto que no existe
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = 'F12345678901', 
	@id_producto = 9999, 
	@cantidad = 10; -- Debe devolver 'El producto no existe.'

--10.1.7 Intentar insertar un producto solicitado con un pedido que no existe
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = 'F99999999999', 
	@id_producto = 1, 
	@cantidad = 10; -- Debe devolver 'El pedido no existe.'

--10.1.8 Intentar insertar un producto solicitado con cantidad menor o igual a cero
EXEC Procedimientos.insertarProductoSolicitado 
	@id_factura = '123-45-6789', 
	@id_producto = 1, 
	@cantidad = -1; -- Debe devolver 'La cantidad debe ser mayor a cero.'



--10.2 Modificacion
-- 10.2.1: Prueba de modificación válida
EXEC Procedimientos.modificarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 1, 
    @cantidad = 3;
-- Esperado: "Valores modificados correctamente"

-- 10.2.2: Prueba de cantidad inválida (menor a cero)
EXEC Procedimientos.modificarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 1, 
    @cantidad = -1;
-- Esperado: "La cantidad debe ser mayor a cero"

-- 10.2.3: Prueba de producto no existente en la factura
EXEC Procedimientos.modificarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 999,  -- Producto que no existe
    @cantidad = 3;
-- Esperado: "El producto solicitado no existe en la factura"

-- 10.2.4: Prueba de factura no existente
EXEC Procedimientos.modificarProductoSolicitado 
    @id_factura = '999-99-9999',  -- Factura que no existe
    @id_producto = 1, 
    @cantidad = 3;
-- Esperado: "El pedido no existe"

-- 10.2.5: Prueba de producto no existente
EXEC Procedimientos.modificarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 999,  -- Producto que no existe
    @cantidad = 3;
-- Esperado: "El producto no existe"


--10.3 Eliminacion
-- 10.3.1: Prueba de eliminación válida
EXEC Procedimientos.eliminarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 1;
-- Esperado: "Producto solicitado eliminado correctamente"

-- 10.3.2: Prueba de producto no existente en la factura
EXEC Procedimientos.eliminarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 999;  -- Producto que no existe en la factura
-- Esperado: "El producto solicitado no existe en la factura"

-- 10.3.3: Prueba de factura no existente
EXEC Procedimientos.eliminarProductoSolicitado 
    @id_factura = '999-99-9999',  -- Factura que no existe
    @id_producto = 1;
-- Esperado: "El pedido no existe"

-- 10.3.4: Prueba de producto no existente
EXEC Procedimientos.eliminarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = 999;  -- Producto que no existe
-- Esperado: "El producto no existe"

-- 10.3.5: Prueba de id_factura nulo
EXEC Procedimientos.eliminarProductoSolicitado 
    @id_factura = NULL, 
    @id_producto = 1;
-- Esperado: "El id_factura no puede ser nulo"

-- 10.3.6: Prueba de id_producto nulo
EXEC Procedimientos.eliminarProductoSolicitado 
    @id_factura = '123-45-6789', 
    @id_producto = NULL;
-- Esperado: "El id_producto no puede ser nulo"







	--Por ultimo DEBEMOS VACIAR TODAS LAS TABLAS, como hay FK involucradas, directamente eliminamos las tablas
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

										--IMPORTANTE, VOLVER AL SCRIPT 1 DAR A >EXECUTE
										--habilitar el trigger
										ENABLE TRIGGER ddbba.trg_Empleado_Encrypt ON ddbba.Empleado;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--PRUEBA DE REPORTES
--REPORTE Mensual: ingresando un mes y año determinado mostrar el total facturado por días de la semana, incluyendo sábado y domingo.

-- Prueba 1: Consultar facturación para el mes 00 y año 2019 (debe dar error en el mes)
	EXEC Rep.Reporte_FacturacionMensual_XML 00, 2019;
-- Prueba 2: Consultar facturación para el mes 01 y año 2026 (debe dar error en el año)
	EXEC Rep.Reporte_FacturacionMensual_XML 01, 2026;
-- Prueba 3: Consultar facturación para el mes 01 y año 2019 (debe hacer un reporte correcto)
	EXEC Rep.Reporte_FacturacionMensual_XML 01, 2019;


--REPORTE Trimestral: mostrar el total facturado por turnos de trabajo por mes.

-- Prueba 1: Consultar facturación para el año 2026 y trimestre 0 (debe dar error en el año)
	EXEC Rep.ObtenerFacturacionPorTrimestreXML 2026, 1;
-- Prueba 2: Consultar facturación para el año 2025 y trimestre 5 (debe dar error en el trimestre)
	EXEC Rep.ObtenerFacturacionPorTrimestreXML 2025, 5;
-- Prueba 3: Consultar facturación para el año 2020 y trimestre 3 (debe dar un reporte correcto para el tercer trimestre de 2020)
	EXEC Rep.ObtenerFacturacionPorTrimestreXML 2020, 3;


--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango, ordenado de mayor a menor.

-- Prueba 1: Consultar reporte con fecha de fin antes de la fecha de inicio (debe dar error)
	EXEC Rep.Reporte_ProductosVendidos_XML '2025-03-01', '2025-02-01';
-- Prueba 2: Consultar reporte con fechas en el futuro (debe dar error)
	EXEC Rep.Reporte_ProductosVendidos_XML '2026-01-01', '2030-03-01';
-- Prueba 3: Consultar reporte con fechas en el futuro (debe dar error)
	EXEC Rep.Reporte_ProductosVendidos_XML '2016-01-01', '2026-03-01';
-- Prueba 4: Consultar reporte con fechas validas (debe devolver un reporte vacío si no hay ventas en ese rango de fechas)
	EXEC Rep.Reporte_ProductosVendidos_XML '2016-01-01', '2020-03-01';


--REPORTE Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar la cantidad de productos vendidos en ese rango por sucursal, ordenado de mayor a menor.

-- Prueba 1: Consultar reporte con fecha de fin antes de la fecha de inicio (debe dar error)
	EXEC Rep.ObtenerVentasPorRangoFechasXML '2025-03-01', '2025-02-01';
-- Prueba 2: Consultar reporte con fechas en el futuro (debe dar error)
	EXEC Rep.ObtenerVentasPorRangoFechasXML '2026-01-01', '2026-03-01';
-- Prueba 2: Consultar reporte con fechas en el futuro (debe dar error)
	EXEC Rep.ObtenerVentasPorRangoFechasXML '2020-01-01', '2026-03-01';
-- Prueba 4: Consultar reporte con fechas válidas (debe devolver un reporte vacío si no hay ventas en ese rango de fechas)
	EXEC Rep.ObtenerVentasPorRangoFechasXML '2025-01-01', '2025-03-01';



--REPORTE Mostrar los 5 productos más vendidos en un mes, por semana

-- Prueba 1: Consultar reporte con un mes inválido (debe dar error por mes inválido)
	EXEC Rep.ObtenerTopProductosPorSemanaXML 13, 2025;
-- Prueba 2: Consultar reporte con un año inválido (debe dar error por año inválido)
	EXEC Rep.ObtenerTopProductosPorSemanaXML 5, 2100;
-- Prueba 3: Consultar reporte con un mes y año válidos (debe devolver un reporte vacío si no hay ventas en ese rango de fechas)
	EXEC Rep.ObtenerTopProductosPorSemanaXML 3, 2025;


--REPORTE Mostrar los 5 productos menos vendidos en el mes. 

-- Prueba 1: Consultar reporte con un mes inválido (debe dar error por mes inválido)
	EXEC Rep.ObtenerMenoresProductosDelMesXML 13, 2025;
-- Prueba 2: Consultar reporte con un año inválido (debe dar error por año inválido)
	EXEC Rep.ObtenerMenoresProductosDelMesXML 5, 2100;
-- Prueba 3: Consultar reporte con un mes y año válidos (debe devolver un reporte vacío si no hay ventas en ese rango de fechas)
	EXEC Rep.ObtenerMenoresProductosDelMesXML 3, 2025;


--REPORTE Mostrar total acumulado de ventas (o sea también mostrar el detalle) para una fecha y sucursal particulares 

-- Prueba 1: Consultar reporte con una fecha y sucursal válidas (debe devolver el detalle y el total acumulado de ventas)
	EXEC Rep.ObtenerVentasPorFechaYSucursalXML '2025-03-01', 1;
-- Prueba 2: Consultar reporte con una sucursal que no existe (debe devolver "Sucursal no existe")
	EXEC Rep.ObtenerVentasPorFechaYSucursalXML '2025-03-01', 9999;



--REPORTE Mensual: ingresando un mes y año determinado mostrar el vendedor de mayor monto facturado por sucursal. 

-- Prueba 1: Consultar reporte con un mes y año válidos (debe devolver un reporte vacío si no hay ventas en ese rango de fechas)
	EXEC Rep.Reporte_VendedorTopPorSucursal_XML 01, 2025;
-- Prueba 2: Consultar reporte con un mes inválido (debe devolver "Mes inválido")
	EXEC Rep.Reporte_VendedorTopPorSucursal_XML 13, 2025;
-- Prueba 3: Consultar reporte con un año inválido (debe devolver "Año inválido")
	EXEC Rep.Reporte_VendedorTopPorSucursal_XML 01, 1799;





