DELIMITER $$

CREATE PROCEDURE PROC_CUERPO_EDUCATIVO_CREAR(
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CODIGO VARCHAR(9),
    IN _ID_CATEGORIA INT,
    IN _ID_TIPO_VEHICULO INT,
    IN _PLACA VARCHAR(7),
    IN _CONTRASENIA LONGTEXT
)
BEGIN
    DECLARE documento_existente INT;
    DECLARE codigo_existente INT;
    DECLARE placa_existente INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);

    -- Verificar si el documento ya está en uso por un usuario activo
    SELECT COUNT(*) INTO documento_existente FROM persona P
    INNER JOIN usuario U ON P.ID_PERSONA = U.ID_PERSONA
    WHERE P.DOCUMENTO = _DOCUMENTO AND U.ESTADO = '1';

    IF documento_existente > 0 THEN
        -- Documento ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Verificar si el código ya está en uso por un usuario activo
        SELECT COUNT(*) INTO codigo_existente FROM persona P
        INNER JOIN usuario U ON P.ID_PERSONA = U.ID_PERSONA
        WHERE P.CODIGO = _CODIGO AND U.ESTADO = '1';

        IF codigo_existente > 0 THEN
            -- Código ya en uso
            SET __ICON = 'warning';
            SET __MESSAGE_TEXT = '¡El código ya está en uso!';
            SET __STATUS_CODE = '200';
        ELSE
            -- Verificar si la placa ya está en uso por un cuerpo_educativo activo
            SELECT COUNT(*) INTO placa_existente FROM cuerpo_educativo
            WHERE PLACA = _PLACA AND ESTADO = '1';

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

                -- Insertar nuevo cuerpo educativo
                INSERT INTO cuerpo_educativo (ID_PERSONA, ID_CATEGORIA, ID_TIPO_VEHICULO, PLACA, ESTADO)
                VALUES (@last_persona_id, _ID_CATEGORIA, _ID_TIPO_VEHICULO, _PLACA, '1');

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



DELIMITER $$

CREATE PROCEDURE PROC_CUERPO_EDUCATIVO_ACTUALIZAR(
    IN _ID_CUERPO_EDUCATIVO INT,
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CODIGO VARCHAR(9),
    IN _ID_CATEGORIA INT,
    IN _ID_TIPO_VEHICULO INT,
    IN _PLACA VARCHAR(7),
    IN _CONTRASENIA LONGTEXT
)
BEGIN
    DECLARE documento_existente INT;
    DECLARE codigo_existente INT;
    DECLARE placa_existente INT;
    DECLARE current_documento CHAR(8);
    DECLARE current_codigo VARCHAR(9);
    DECLARE current_placa VARCHAR(6);
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE _ID_PERSONA INT;

    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Obtener el ID_PERSONA asociado al ID_CUERPO_EDUCATIVO
    SELECT ID_PERSONA INTO _ID_PERSONA FROM cuerpo_educativo WHERE ID_CUERPO_EDUCATIVO = _ID_CUERPO_EDUCATIVO;

    -- Obtener los valores actuales del documento, código y placa
    SELECT DOCUMENTO, CODIGO INTO current_documento, current_codigo
    FROM persona WHERE ID_PERSONA = _ID_PERSONA;
    SELECT PLACA INTO current_placa FROM cuerpo_educativo WHERE ID_CUERPO_EDUCATIVO = _ID_CUERPO_EDUCATIVO;

    -- Verificar si el nuevo documento está en uso por otra persona
    IF _DOCUMENTO <> current_documento THEN
        SELECT COUNT(*) INTO documento_existente FROM persona WHERE DOCUMENTO = _DOCUMENTO;
    END IF;

    -- Verificar si el nuevo código está en uso por otra persona
    IF _CODIGO <> current_codigo THEN
        SELECT COUNT(*) INTO codigo_existente FROM persona WHERE CODIGO = _CODIGO;
    END IF;

    -- Verificar si la nueva placa está en uso por otro cuerpo_educativo
    IF _PLACA <> current_placa THEN
        SELECT COUNT(*) INTO placa_existente FROM cuerpo_educativo WHERE PLACA = _PLACA;
    END IF;

    IF documento_existente > 0 THEN
        -- Documento ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSEIF codigo_existente > 0 THEN
        -- Código ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El código ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSEIF placa_existente > 0 THEN
        -- Placa ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡La placa ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar persona
        UPDATE persona
        SET NOMBRES = _NOMBRES,
            APPATERNO = _APPATERNO,
            APMATERNO = _APMATERNO,
            DOCUMENTO = _DOCUMENTO,
            CODIGO = _CODIGO
        WHERE ID_PERSONA = _ID_PERSONA;

        -- Actualizar cuerpo educativo
        UPDATE cuerpo_educativo
        SET ID_CATEGORIA = _ID_CATEGORIA,
            ID_TIPO_VEHICULO = _ID_TIPO_VEHICULO,
            PLACA = _PLACA
        WHERE ID_CUERPO_EDUCATIVO = _ID_CUERPO_EDUCATIVO;

        -- Actualizar usuario
        UPDATE usuario
        SET CONTRASENIA = _CONTRASENIA
        WHERE ID_PERSONA = _ID_PERSONA;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Actualización exitosa';
        SET __STATUS_CODE = '202';
    END IF;

    -- Mostrar los mensajes
    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE PROC_CUERPO_EDUCATIVO_ELIMINAR(
    IN _ID_CUERPO_EDUCATIVO INT
)
BEGIN
    DECLARE _ID_PERSONA INT;

    -- Obtener el ID_PERSONA asociado al ID_CUERPO_EDUCATIVO
    SELECT ID_PERSONA INTO _ID_PERSONA FROM cuerpo_educativo WHERE ID_CUERPO_EDUCATIVO = _ID_CUERPO_EDUCATIVO;

    -- Eliminar el cuerpo educativo
    DELETE FROM cuerpo_educativo WHERE ID_CUERPO_EDUCATIVO = _ID_CUERPO_EDUCATIVO;

    -- Eliminar el usuario asociado
    DELETE FROM usuario WHERE ID_PERSONA = _ID_PERSONA;

    -- Eliminar la persona asociada
    DELETE FROM persona WHERE ID_PERSONA = _ID_PERSONA;
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE PROC_CUERPO_EDUCATIVO_LIST()
BEGIN
  SELECT 
    CE.ID_CUERPO_EDUCATIVO,
    CE.ID_PERSONA,
    PE.NOMBRES,
    PE.APPATERNO,
    PE.APMATERNO,
    PE.DOCUMENTO,
    PE.CODIGO,
    CE.ID_CATEGORIA,
    CA.NOM_CATEGORIA,
    CE.ID_TIPO_VEHICULO,
    TV.NOM_TIPO_VEHICULO,
    CE.PLACA,
    CE.ESTADO
  FROM
    cuerpo_educativo CE 
    INNER JOIN persona PE ON PE.ID_PERSONA = CE.ID_PERSONA 
    INNER JOIN categoria CA ON CA.ID_CATEGORIA = CE.ID_CATEGORIA 
    INNER JOIN tipo_vehiculo TV ON TV.ID_TIPO_VEHICULO = CE.ID_TIPO_VEHICULO
  WHERE CE.ESTADO = '1'
  ORDER BY CE.ID_CUERPO_EDUCATIVO ASC;
END $$

DELIMITER ;
