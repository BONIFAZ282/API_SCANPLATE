DELIMITER $$

CREATE PROCEDURE PROC_BUSCAR_PLACA(
    IN pPlaca VARCHAR(6)
)
BEGIN
    DECLARE placa_encontrada INT;
    
    -- Verificar si la placa existe en la tabla CUERPO_ESTUDIANTIL
    SELECT COUNT(*) INTO placa_encontrada FROM cuerpo_educativo WHERE PLACA = pPlaca;
    
    IF placa_encontrada > 0 THEN
        -- Placa encontrada, mostrar los datos
        SELECT P.DOCUMENTO AS 'DNI', P.CODIGO, P.APPATERNO, P.APMATERNO, P.NOMBRES, TV.NOM_TIPO_VEHICULO, CE.PLACA
        FROM cuerpo_educativo CE
        INNER JOIN persona P ON CE.ID_PERSONA = P.ID_PERSONA
        INNER JOIN tipo_vehiculo TV ON CE.ID_TIPO_VEHICULO = TV.ID_TIPO_VEHICULO
        WHERE CE.PLACA = pPlaca;
    ELSE
        -- Placa no encontrada
        SELECT 'Placa no encontrada' AS 'Mensaje';
    END IF;
    
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE PROC_PLACA_ESCANEADA()
BEGIN
    SELECT 
    	PE.ID_PLACA_ESCANEADA,
        P.ID_PERSONA,
        P.NOMBRES,
        P.APPATERNO,
        P.APMATERNO,
        P.DOCUMENTO,
        P.CODIGO,
        CE.PLACA,
        TV.ID_TIPO_VEHICULO,
        TV.NOM_TIPO_VEHICULO,
        C.ID_CATEGORIA,
        C.NOM_CATEGORIA,
        PE.FECHA_INGRESO,
        PE.FECHA_SALIDA,
        PE.REGISTRO
    FROM 
        placa_escaneada PE
    INNER JOIN cuerpo_educativo CE ON PE.ID_CUERPO_EDUCATIVO = CE.ID_CUERPO_EDUCATIVO
    INNER JOIN persona P ON CE.ID_PERSONA = P.ID_PERSONA
    INNER JOIN tipo_vehiculo TV ON CE.ID_TIPO_VEHICULO = TV.ID_TIPO_VEHICULO
    INNER JOIN categoria C ON CE.ID_CATEGORIA = C.ID_CATEGORIA;
END$$

DELIMITER ;




-- Procedimiento para vehículos por día
DELIMITER //

CREATE PROCEDURE PROC_DIAS_ENTRADAS_VEHICULOS()
BEGIN
    SELECT 
        DATE(FECHA_INGRESO) AS dia,
        COUNT(*) AS cantidad_vehiculos
    FROM 
        placa_escaneada
    GROUP BY 
        DATE(FECHA_INGRESO);
END //

DELIMITER ;


-- Procedimiento para vehículos por mes

DELIMITER //

CREATE PROCEDURE PROC_MES_ENTRADAS_VEHICULOS()
BEGIN
    SELECT 
        YEAR(FECHA_INGRESO) AS anio,
        MONTH(FECHA_INGRESO) AS mes,
        COUNT(*) AS cantidad_vehiculos
    FROM 
        placa_escaneada
    GROUP BY 
        YEAR(FECHA_INGRESO), MONTH(FECHA_INGRESO);
END //

DELIMITER ;


-- Procedimiento para vehículos por año
DELIMITER //

CREATE PROCEDURE PROC_ANIO_ENTRADAS_VEHICULOS()
BEGIN
    SELECT 
        YEAR(FECHA_INGRESO) AS anio,
        COUNT(*) AS cantidad_vehiculos
    FROM 
        placa_escaneada
    GROUP BY 
        YEAR(FECHA_INGRESO);
END //

DELIMITER ;



-- Procedimiento para NOM_CATEGORIAS:
DELIMITER $$

CREATE PROCEDURE PROC_CATEGORIAS_PLACA()
BEGIN
    SELECT 
        c.NOM_CATEGORIA, 
        COUNT(ce.ID_CUERPO_EDUCATIVO) AS cantidad
    FROM 
        cuerpo_educativo ce
    JOIN 
        categoria c ON ce.ID_CATEGORIA = c.ID_CATEGORIA
    GROUP BY 
        c.NOM_CATEGORIA;
END $$

DELIMITER ;


-- Procedimiento para TIPO_VEHICULOS:
DELIMITER $$

CREATE PROCEDURE PROC_VEHICULOS_PLACA()
BEGIN
    SELECT 
        tv.NOM_TIPO_VEHICULO, 
        COUNT(ce.ID_CUERPO_EDUCATIVO) AS cantidad
    FROM 
        cuerpo_educativo ce
    JOIN 
        tipo_vehiculo tv ON ce.ID_TIPO_VEHICULO = tv.ID_TIPO_VEHICULO
    GROUP BY 
        tv.NOM_TIPO_VEHICULO;
END $$

DELIMITER ;


-- Insertar Placa escaneada

DELIMITER $$

CREATE PROCEDURE PROC_INSERTAR_PLACA_ESCANEADA(
    IN pPlaca VARCHAR(7)
)
BEGIN
    DECLARE vID_CUERPO_EDUCATIVO INT;
    DECLARE vRows INT;

    -- Buscar el ID_CUERPO_EDUCATIVO correspondiente a la placa
    SELECT ID_CUERPO_EDUCATIVO INTO vID_CUERPO_EDUCATIVO
    FROM cuerpo_educativo
    WHERE PLACA = pPlaca
    LIMIT 1;

    -- Verificar el número de filas que coinciden con la placa
    SELECT COUNT(*) INTO vRows
    FROM cuerpo_educativo
    WHERE PLACA = pPlaca;

    -- Si hay más de una fila, lanzar un error
    IF vRows > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Más de una placa encontrada';
    ELSEIF vRows = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Placa no encontrada';
    ELSE
        -- Insertar los datos en la tabla placa_escaneada
        INSERT INTO placa_escaneada (ID_CUERPO_EDUCATIVO, FECHA_INGRESO, FECHA_SALIDA, REGISTRO, ESTADO)
        VALUES (vID_CUERPO_EDUCATIVO, NOW(), NULL, 'E', '1');
        
        -- Actualizar la cantidad disponible en la tabla estacionamiento
        UPDATE estacionamiento
        SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE - 1
        WHERE COD_ESTACIONAMIENTO = 1; -- Cambia esto por el código de tu estacionamiento
    END IF;
END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE PROC_SALIDA_PLACA(
    IN pPlaca VARCHAR(7)
)
BEGIN
    DECLARE vID_CUERPO_EDUCATIVO INT;
    
    -- Actualizar la fecha de salida en la tabla placa_escaneada
    UPDATE placa_escaneada PE
    INNER JOIN cuerpo_educativo CE ON PE.ID_CUERPO_EDUCATIVO = CE.ID_CUERPO_EDUCATIVO
    SET PE.FECHA_SALIDA = NOW(), PE.REGISTRO = 'S'
    WHERE CE.PLACA = pPlaca AND PE.FECHA_SALIDA IS NULL;

    -- Buscar el ID_CUERPO_EDUCATIVO correspondiente a la placa
    SELECT CE.ID_CUERPO_EDUCATIVO INTO vID_CUERPO_EDUCATIVO
    FROM cuerpo_educativo CE
    WHERE CE.PLACA = pPlaca
    LIMIT 1;

    -- Disminuir en 1 la cantidad disponible en la tabla estacionamiento
    UPDATE estacionamiento
    SET CANTIDAD_DISPONIBLE = CANTIDAD_DISPONIBLE + 1
    WHERE COD_ESTACIONAMIENTO = 1; -- Cambia esto por el código de tu estacionamiento
    
    -- En caso de que quieras verificar si se actualizó realmente un registro en la tabla placa_escaneada
    -- y actuar en consecuencia, puedes hacerlo aquí.
END$$
DELIMITER ;