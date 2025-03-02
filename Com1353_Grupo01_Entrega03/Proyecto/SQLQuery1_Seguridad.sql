-- 5. SEGURIDAD - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
USE Com1353G01
--ATENCIO: se podra ejecutar como bloque todo el codigo para crear los objetos, pero se debera ejecutar uno por uno
--debajo de cada consigna de seguridad se detalla su forma de ejecucion

--Crear notas de Credito para devoluciones de Clientes------------------------------------------------------------------
--SP PARA GENERAR NOTA CREDITO
IF  EXISTS (SELECT * FROM sys.procedures WHERE name = 'GenerarNotaCredito')
BEGIN
	DROP PROCEDURE Procedimientos.GenerarNotaCredito;
END;
go
CREATE PROCEDURE Procedimientos.GenerarNotaCredito
	@id_factura CHAR(12),
	@id_empleado INT

AS
BEGIN
		--verificar que existe el id_factura
		IF NOT EXISTS (SELECT 1 FROM ddbba.Pedido WHERE @id_factura=id_factura)
		BEGIN
			PRINT 'NO EXISTE LA FACTURA INGRESADA';
			RETURN;
		END;
		--verificar que existe el id_empleado
		IF NOT EXISTS (SELECT 1 FROM ddbba.Empleado WHERE @id_empleado=id_empleado)
		BEGIN
			PRINT 'NO EXISTE EL EMPLEADO INGRESADO';
			RETURN;
		END;
	
			
	DECLARE @estado_factura VARCHAR(10);
	DECLARE @cargo VARCHAR(50);

	-- Verificar si la factura está pagada
	SELECT @estado_factura = estado_factura
	FROM ddbba.Pedido
	WHERE id_factura = @id_factura;

	IF @estado_factura <> 'Pagado' 
	BEGIN
		PRINT 'Error: La nota de crédito solo puede generarse para facturas pagadas.';
		RETURN;
	END;

	-- Verificar si el empleado es un Supervisor
	SELECT @cargo = cargo 
	FROM ddbba.Empleado
	WHERE id_empleado = @id_empleado;

	IF @cargo <> 'Supervisor'
	BEGIN
		PRINT 'Error: Solo los supervisores pueden generar notas de crédito.';
		RETURN;
	END;

		--generar fecha actual
		DECLARE @fecha_emision DATETIME;
		SET @fecha_emision = GETDATE();

		--busco id_cliente
		DECLARE @id_cliente INT;
		SELECT @id_cliente=id_cliente FROM ddbba.Pedido Ped WHERE Ped.id_factura=@id_factura;

		--nombre del producto
		DECLARE @nombre_producto VARCHAR(100);
		SELECT  @nombre_producto=nombre_producto
		FROM ddbba.Producto P
		INNER JOIN ddbba.ProductoSolicitado PS ON P.id_producto=PS.id_producto
		WHERE @id_factura=PS.id_factura;

		--precio del producto
		DECLARE @precio_unitario DECIMAL(10,2);
		SELECT  @precio_unitario=precio_unitario
		FROM ddbba.Producto P
		INNER JOIN ddbba.ProductoSolicitado PS ON P.id_producto=PS.id_producto
		WHERE @id_factura=PS.id_factura;

		--cantidad
		DECLARE @cantidad INT;
		SELECT  @cantidad=cantidad
		FROM ddbba.ProductoSolicitado PS
		WHERE @id_factura=PS.id_factura;

		--monto
		DECLARE @monto DECIMAL(10,2);
		SET  @monto = (@cantidad*@precio_unitario);

	-- Insertar la nota de crédito
	 EXEC Procedimientos.insertarNotaCredito @fecha_emision,@id_cliente,@id_factura,@nombre_producto,@precio_unitario,@cantidad,@monto;
    
	PRINT 'Nota de crédito generada exitosamente.';
END;
go

	/*--------EJECUTAR-------------------------------
	EXEC Procedimientos.GenerarNotaCredito '102-06-2002', 257026 	([id_factura],[id_empleado])
	------------------------------------------------*/
	/*--VISUALIZAR-----------------
	SELECT * FROM ddbba.NotaCredito

	*/


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--Encriptacion de los datos de los Empleados

--AGREGAR CAMPOS PARA ENCRIPTAR
ALTER TABLE ddbba.Empleado
	ADD nombre_enc VARBINARY(MAX),
    apellido_enc VARBINARY(MAX),
    dni_enc VARBINARY(MAX),
    direccion_enc VARBINARY(MAX),
    cuil_enc VARBINARY(MAX),
    email_personal_enc VARBINARY(MAX),
    email_empresarial_enc VARBINARY(MAX);
GO
	select * from ddbba.Empleado
--TRIGGER PARA QUE CADA VEZ QUE SE INGRESA UN REGISTRO A LA TABLA, LOS DATOS SENSIBLES SON ENCRIPTADOS
IF  EXISTS (SELECT 1 FROM sys.triggers WHERE name='trg_Empleado_Encrypt')
BEGIN
	print 'trigger ya existente';
	
END
ELSE
BEGIN
	EXEC('
			CREATE TRIGGER trg_Empleado_Encrypt
		ON ddbba.Empleado
		AFTER INSERT
		AS
		BEGIN
			-- Encriptar y actualizar las columnas encriptadas
			UPDATE e
			SET 
				e.nombre_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', i.nombre),
				e.apellido_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', i.apellido),
				e.dni_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', CAST(i.dni AS VARCHAR)),
				e.direccion_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', i.direccion),
				e.cuil_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', i.cuil),
				e.email_personal_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', i.email_personal),
				e.email_empresarial_enc = ENCRYPTBYPASSPHRASE(''Xg7#pV@1zK$9mTqW'', i.email_empresarial)
			FROM ddbba.Empleado e
			INNER JOIN inserted i ON e.id_empleado = i.id_empleado;

			-- Opcional: Eliminar los datos visibles o ponerlos en NULL (si no se van a necesitar)
			UPDATE e
			SET 
				e.nombre = NULL,
				e.apellido = NULL,
				e.dni = NULL,
				e.direccion = NULL,
				e.cuil = NULL,
				e.email_personal = NULL,
				e.email_empresarial = NULL
			FROM ddbba.Empleado e
			INNER JOIN inserted i ON e.id_empleado = i.id_empleado;
		END;
		PRINT ''TRIGGER CREADO CORRECTAMENTE'';
		')
END;

GO

DROP TRIGGER IF EXISTS trg_Empleado_Encrypt ;
/*--INSERCION DE DATOS-----------------------------
INSERT INTO ddbba.Empleado (id_empleado, nombre, apellido, dni, direccion, cuil, email_personal, email_empresarial, turno, cargo, id_sucursal)
VALUES (500, 'Carlos', 'Gómez', 32456789, 'Av. Siempre Viva 123, Buenos Aires', '20-32456789-3', 'carlos.gomez@email.com', 'cgomez@empresa.com', 'Mañana', 'Analista de Datos', 3),
(501, 'Mariana', 'López', 29876543, 'Calle Falsa 456, Córdoba', '27-29876543-5', 'mariana.lopez@email.com', 'mlopez@empresa.com', 'Tarde', 'Desarrolladora', 2);
*/


	/*-------VER LA TABLA ENCRIPTADA-----
	SELECT * FROM DDBBA.Empleado
	---------------------------------*/

/*--DESENCRIPTAR Y VER LA TABLA ENTERA
SELECT id_empleado, 
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', nombre_enc)) AS nombre,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', apellido_enc)) AS apellido,
       CONVERT(INT, CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', dni_enc))) AS dni,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', direccion_enc)) AS direccion,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', cuil_enc)) AS cuil,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', email_personal_enc)) AS email_personal,
       CONVERT(VARCHAR, DECRYPTBYPASSPHRASE('Xg7#pV@1zK$9mTqW', email_empresarial_enc)) AS email_empresarial,
	   turno,
	   cargo,
	   id_sucursal
FROM ddbba.Empleado;
*/
	/*-------VER LA TABLA DESENCRIPTADA-----
	SELECT * FROM DDBBA.Empleado
	---------------------------------*/

