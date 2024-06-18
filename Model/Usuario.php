<?php
class Usuario
{
  public function LOGIN($data)
  {
    $query = Flight::db()->prepare(

      "SELECT 
      PERSONA.DOCUMENTO, 
      PERSONA.CODIGO, 
      PERSONA.NOMBRES, 
      PERSONA.APPATERNO, 
      PERSONA.APMATERNO, 
      USUARIO.CONTRASENIA, 
      privilegio.NOM_PRIVILEGIO AS 'NOMBRE_PRIVILEGIO',
      cuerpo_educativo.PLACA,
      tipo_vehiculo.NOM_TIPO_VEHICULO
      FROM 
          PERSONA
      JOIN 
          USUARIO ON PERSONA.ID_PERSONA = USUARIO.ID_PERSONA
      JOIN 
          privilegio ON privilegio.ID_PRIVILEGIO = USUARIO.ID_PRIVILEGIO
      LEFT JOIN 
          cuerpo_educativo ON PERSONA.ID_PERSONA = cuerpo_educativo.ID_PERSONA
      LEFT JOIN 
          tipo_vehiculo ON cuerpo_educativo.ID_TIPO_VEHICULO = tipo_vehiculo.ID_TIPO_VEHICULO
      WHERE
          PERSONA.DOCUMENTO = :DOCUMENTO AND
          USUARIO.CONTRASENIA = :CONTRASENIA;");

    $query->execute([
      "DOCUMENTO" => $data->DOCUMENTO,
      "CONTRASENIA" => $data->CONTRASENIA
    ]);

    return $query->fetchAll(PDO::FETCH_ASSOC);
  }
}