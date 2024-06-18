-- = LISTAR USUARIOS DISPONIBLES
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_LIST_1 () 
BEGIN
  SELECT 
    US.ID_USUARIO,
    US.ID_PERSONA,
    PE.NOMBRES,
    PE.APPATERNO,
    PE.APMATERNO,
    PE.DOCUMENTO,
    PE.CODIGO,
    US.ID_PRIVILEGIO,
    PR.NOM_PRIVILEGIO AS NOMBRE_PRIVILEGIO,
    US.ESTADO
  FROM
    USUARIO US 
    INNER JOIN PERSONA PE 
      ON PE.ID_PERSONA = US.ID_PERSONA 
    INNER JOIN PRIVILEGIO PR 
      ON PR.ID_PRIVILEGIO = US.ID_PRIVILEGIO
  WHERE
    US.ESTADO = '1'
  ORDER BY
    US.ID_USUARIO ASC; -- ASC para ordenar de menor a mayor

END $$

DELIMITER ;


-- = LISTAR USUARIOS ELIMINADOS
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_LIST_0 () 
BEGIN
  SELECT 
    US.ID_USUARIO,
    US.ID_PERSONA,
    PE.NOMBRES,
    PE.APPATERNO,
    PE.APMATERNO,
    PE.DOCUMENTO,
    PE.CODIGO,
    US.ID_PRIVILEGIO,
    PR.NOM_PRIVILEGIO AS NOMBRE_PRIVILEGIO,
    US.ESTADO
  FROM
    USUARIO US 
    INNER JOIN PERSONA PE 
      ON PE.ID_PERSONA = US.ID_PERSONA 
    INNER JOIN PRIVILEGIO PR 
      ON PR.ID_PRIVILEGIO = US.ID_PRIVILEGIO
  WHERE
    US.ESTADO = '0'
  ORDER BY
    US.ID_USUARIO ASC; -- ASC para ordenar de menor a mayor

END $$

DELIMITER ;



-- = LOGIN 
DELIMITER $$
CREATE PROCEDURE PROC_USUARIO_LOGIN (
  _DOCUMENTO VARCHAR(20),
  _CONTRASENIA VARCHAR(16)
) BEGIN
  SELECT 
    US.ID_USUARIO,
    PE.NOMBRES,
    PE.APPATERNO,
    PE.APMATERNO,
    PE.DOCUMENTO,
    PE.CODIGO,
    US.ID_PRIVILEGIO,
    PR.NOM_PRIVILEGIO AS 'NOMBRE_PRIVILEGIO'
  FROM USUARIO US
  INNER JOIN PERSONA PE 
    ON PE.ID_PERSONA = US.ID_PERSONA 
  INNER JOIN PRIVILEGIO PR
  ON PR.ID_PRIVILEGIO = US.ID_PRIVILEGIO
  WHERE 
    PE.DOCUMENTO = _DOCUMENTO
    AND US.CONTRASENIA = SHA2(_CONTRASENIA, 256)
    AND US.ESTADO <> 0;
END $$
DELIMITER ;



-- CREAR Y ACTUALIZAR USUARIO NATURAL
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_REGISTER(
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CODIGO VARCHAR(9),
    IN _ID_CATEGORIA INT,
    IN _ID_TIPO_VEHICULO INT,
    IN _PLACA VARCHAR(6),
    IN _CONTRASENIA LONGTEXT
)
BEGIN
    DECLARE documento_existente INT;
    DECLARE codigo_existente INT;
    DECLARE placa_existente INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);

    -- Verificar si el documento ya está en uso
    SELECT COUNT(*) INTO documento_existente FROM persona WHERE DOCUMENTO = _DOCUMENTO;

    IF documento_existente > 0 THEN
        -- Documento ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Verificar si el código ya está en uso
        SELECT COUNT(*) INTO codigo_existente FROM persona WHERE CODIGO = _CODIGO;

        IF codigo_existente > 0 THEN
            -- Código ya en uso
            SET __ICON = 'warning';
            SET __MESSAGE_TEXT = '¡El código ya está en uso!';
            SET __STATUS_CODE = '200';
        ELSE
            -- Verificar si la placa ya está en uso
            SELECT COUNT(*) INTO placa_existente FROM cuerpo_educativo WHERE PLACA = _PLACA;

            IF placa_existente > 0 THEN
                -- Placa ya en uso
                SET __ICON = 'warning';
                SET __MESSAGE_TEXT = '¡La placa ya está en uso!';
                SET __STATUS_CODE = '200';
            ELSE
                -- Insertar nueva persona
                INSERT INTO persona (NOMBRES, APPATERNO, APMATERNO, DOCUMENTO, CODIGO, ESTADO)
                VALUES (_NOMBRES, _APPATERNO, _APMATERNO, _DOCUMENTO, _CODIGO, '1');

                -- Obtener el ID de la nueva persona
                SET @last_persona_id = LAST_INSERT_ID();
                
                -- Insertar nuevo usuario
                INSERT INTO usuario (ID_PERSONA, ID_PRIVILEGIO, CONTRASENIA, ESTADO)
                VALUES (@last_persona_id, 2, _CONTRASENIA, '1');
                
                -- Obtener el ID del nuevo usuario
                SET @last_usuario_id = LAST_INSERT_ID();
                
                -- Insertar nuevo cuerpo educativo
                INSERT INTO cuerpo_educativo (ID_PERSONA, ID_CATEGORIA, ID_TIPO_VEHICULO, PLACA, ESTADO)
                VALUES (@last_persona_id, _ID_CATEGORIA, _ID_TIPO_VEHICULO, _PLACA, '1');

                -- Obtener el ID del nuevo cuerpo educativo
                SET @last_cuerpo_educativo_id = LAST_INSERT_ID();
                
                -- Mensaje de éxito
                SET __ICON = 'success';
                SET __MESSAGE_TEXT = 'Registro exitoso';
                SET __STATUS_CODE = '201';
            END IF;
        END IF;
    END IF;

    -- Mostrar los mensajes
    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END$$

DELIMITER ;



-- CREAR Y ACTUALIZAR DATOS ADMINISTRADOR
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_CU(
    IN _ID_USUARIO INT,
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CODIGO VARCHAR(9),
    IN _ID_PRIVILEGIO INT,
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Verificar si el documento ya está en uso
    SELECT COUNT(*) INTO contador FROM PERSONA
    WHERE DOCUMENTO = _DOCUMENTO;

    IF contador > 0 THEN
        -- Documento ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        IF _ID_USUARIO = 0 THEN
            -- Crear nuevo usuario
            INSERT INTO PERSONA (NOMBRES, APPATERNO, APMATERNO, DOCUMENTO, CODIGO, ESTADO)
            VALUES (_NOMBRES, _APPATERNO, _APMATERNO, _DOCUMENTO, _CODIGO, '1');

            SET @last_persona_id = LAST_INSERT_ID();

            INSERT INTO USUARIO (ID_PERSONA, ID_PRIVILEGIO, CONTRASENIA, ESTADO)
            VALUES (@last_persona_id, _ID_PRIVILEGIO, _CONTRASENIA, '1');

            SET __ICON = 'success';
            SET __MESSAGE_TEXT = 'Registro exitoso';
            SET __STATUS_CODE = '201';
        ELSE
            -- Actualizar usuario existente
            UPDATE PERSONA
            SET
                NOMBRES = _NOMBRES,
                APPATERNO = _APPATERNO,
                APMATERNO = _APMATERNO,
                DOCUMENTO = _DOCUMENTO,
                CODIGO = _CODIGO
            WHERE ID_PERSONA = (SELECT ID_PERSONA FROM USUARIO WHERE ID_USUARIO = _ID_USUARIO);

            UPDATE USUARIO
            SET
                ID_PRIVILEGIO = _ID_PRIVILEGIO,
                CONTRASENIA = _CONTRASENIA
            WHERE ID_USUARIO = _ID_USUARIO;

            SET __ICON = 'success';
            SET __MESSAGE_TEXT = 'Usuario actualizado correctamente';
            SET __STATUS_CODE = '202';
        END IF;
    END IF;

    -- Mostrar los mensajes
    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END$$

DELIMITER ;





-- = ELIMINAR USUARIO
DELIMITER $$
CREATE PROCEDURE PROC_USUARIO_DELETE(
    _ID_USUARIO INT
) BEGIN
    -- MENSAJES A LA INTERFAZ
    DECLARE __ICON VARCHAR(10) DEFAULT 'error';
    DECLARE __MESSAGE_TEXT VARCHAR(300) DEFAULT 'HA OCURRIDO UN ERROR';
    DECLARE __STATUS_CODE CHAR(3) DEFAULT '501';

    -- SABER SI NO SE ENCUENTRA O YA ESTA ELIMINADO
    DECLARE __NO_EXISTS INT DEFAULT 0;

    SELECT IF(ESTADO <> 0, ID_USUARIO , 0) INTO __NO_EXISTS FROM USUARIO
    WHERE ID_USUARIO  = _ID_USUARIO ;

    IF __NO_EXISTS = 0 THEN 
        -- MENSAJE
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = 'EL ELEMENTO NO EXISTE O YA HA SIDO ELIMINADO';
        SET __STATUS_CODE = '200';
    ELSE
        UPDATE USUARIO
            SET ESTADO = '0'
            WHERE ID_USUARIO  = _ID_USUARIO ;
        -- MENSAJE
            SET __ICON = 'success';
            SET __MESSAGE_TEXT = 'ELEMENTO ELIMINADO';
            SET __STATUS_CODE = '202';
    END IF;
    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$
DELIMITER ;


-- = ELIMINAR USUARIO DEFINITIVO
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_ELIMINAR_DEFINITIVO(
    IN _ID_USUARIO INT
)
BEGIN
    DECLARE _ID_PERSONA INT;

    -- Obtener el ID_PERSONA asociado al ID_USUARIO
    SELECT ID_PERSONA INTO _ID_PERSONA FROM USUARIO WHERE ID_USUARIO = _ID_USUARIO;

    -- Eliminar el usuario
    DELETE FROM USUARIO WHERE ID_USUARIO = _ID_USUARIO;

    -- Eliminar la persona asociada
    DELETE FROM PERSONA WHERE ID_PERSONA = _ID_PERSONA;
END$$

DELIMITER ;







-- = CREAR USUARIO

DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_CREAR(
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CODIGO VARCHAR(9),
    IN _ID_PRIVILEGIO INT,
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Verificar si el documento o código ya están en uso con estado '1' en usuario
    SELECT COUNT(*) INTO contador 
    FROM PERSONA p
    JOIN USUARIO u ON p.ID_PERSONA = u.ID_PERSONA
    WHERE (p.DOCUMENTO = _DOCUMENTO OR p.CODIGO = _CODIGO) AND u.ESTADO = '1';

    IF contador > 0 THEN
        -- Documento o código ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento o código ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Crear nuevo usuario
        INSERT INTO PERSONA (NOMBRES, APPATERNO, APMATERNO, DOCUMENTO, CODIGO, ESTADO)
        VALUES (_NOMBRES, _APPATERNO, _APMATERNO, _DOCUMENTO, _CODIGO, '1');

        SET @last_persona_id = LAST_INSERT_ID();

        INSERT INTO USUARIO (ID_PERSONA, ID_PRIVILEGIO, CONTRASENIA, ESTADO)
        VALUES (@last_persona_id, _ID_PRIVILEGIO, _CONTRASENIA, '1');

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Registro exitoso';
        SET __STATUS_CODE = '201';
    END IF;

    -- Mostrar los mensajes
    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END$$

DELIMITER ;



-- = ACTUALZIAR USUARIO

DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_ACTUALIZAR(
    IN _ID_USUARIO INT,
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CODIGO VARCHAR(9),
    IN _ID_PRIVILEGIO INT,
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE current_documento CHAR(8);
    DECLARE current_codigo VARCHAR(9);

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Obtener el documento y código actuales del usuario
    SELECT DOCUMENTO, CODIGO INTO current_documento, current_codigo
    FROM PERSONA
    WHERE ID_PERSONA = (SELECT ID_PERSONA FROM USUARIO WHERE ID_USUARIO = _ID_USUARIO);

    -- Verificar si el documento es diferente y ya está en uso
    IF _DOCUMENTO <> current_documento THEN
        SELECT COUNT(*) INTO contador FROM PERSONA
        WHERE DOCUMENTO = _DOCUMENTO;
    END IF;

    IF contador = 0 AND _CODIGO <> current_codigo THEN
        -- Verificar si el código es diferente y ya está en uso
        SELECT COUNT(*) INTO contador FROM PERSONA
        WHERE CODIGO = _CODIGO;
    END IF;

    IF contador > 0 THEN
        -- Documento o código ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento o código ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar usuario existente
        UPDATE PERSONA
        SET
            NOMBRES = _NOMBRES,
            APPATERNO = _APPATERNO,
            APMATERNO = _APMATERNO,
            DOCUMENTO = _DOCUMENTO,
            CODIGO = _CODIGO
        WHERE ID_PERSONA = (SELECT ID_PERSONA FROM USUARIO WHERE ID_USUARIO = _ID_USUARIO);

        UPDATE USUARIO
        SET
            ID_PRIVILEGIO = _ID_PRIVILEGIO,
            CONTRASENIA = _CONTRASENIA
        WHERE ID_USUARIO = _ID_USUARIO;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Usuario actualizado correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    -- Mostrar los mensajes
    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END$$

DELIMITER ;
