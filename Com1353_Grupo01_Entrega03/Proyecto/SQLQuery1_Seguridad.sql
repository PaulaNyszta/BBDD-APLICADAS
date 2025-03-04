-- 5. SEGURIDAD - 28/02/2025 - Com 1353 - Grupo 01 - Base de Datos Aplicadas, BARRIONUEVO LUCIANO [45429539], NYSZTA PAULA [45129511].
USE Com1353G01
--ATENCIO: se podra ejecutar como bloque todo el codigo para crear los objetos, pero se debera ejecutar uno por uno
--debajo de cada consigna de seguridad se detalla su forma de ejecucion

--Crear notas de Credito para devoluciones de Clientes------------------------------------------------------------------
--SP PARA GENERAR NOTA CREDITO


	/*--------EJECUTAR-------------------------------
	EXEC Procedimientos.insertarNotaCredito 257026,'102-06-2002', 1,'No me gusto' 	([id_empleado],[id_factura],[cantidadADevolver],[motivo])
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

--DROP TRIGGER IF EXISTS trg_Empleado_Encrypt ;


-------VER LA TABLA ENCRIPTADA-----
SELECT * FROM DDBBA.Empleado


--DESENCRIPTAR Y VER LA TABLA ENTERA
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



