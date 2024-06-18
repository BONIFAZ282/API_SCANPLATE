<?php


class UsuarioController
{
  public function LISTAR_USUARIOS_1()
  {
    $query = Flight::db()->prepare("CALL PROC_USUARIO_LIST_1");
    $query->execute();
    $result = $query->fetchAll(PDO::FETCH_ASSOC);

    // Imprimimos en JSON
    Flight::json($result);
  }

  public function LISTAR_USUARIOS_0()
  {
    $query = Flight::db()->prepare("CALL PROC_USUARIO_LIST_0");
    $query->execute();
    $result = $query->fetchAll(PDO::FETCH_ASSOC);

    // Imprimimos en JSON
    Flight::json($result);
  }

  public function LOGIN_USUARIO()
  {
    $data = Flight::request()->data;
    $usuario = new Usuario();

    try {
      // Obtenemos usuario
      $result = $usuario->LOGIN($data);

      if (count($result) > 0) {
        $tk = new Token();
        $jwt = $tk->generarToken(sha1($result[0]["NOMBRES"]), 1);

        // Añadir el token al resultado
        $result[0]["token"] = $jwt;
      }

      Flight::json($result);
    } catch (Exception $e) {
      Flight::json(array("message" => $e->getMessage()), 500);
    }
  }


  public function CREAR_USUARIO_NATURAL()
  {
    // Respuesta
    $response = null;

    try {
      $data = Flight::request()->data;

      // Armado de consulta
      $query = Flight::db()->prepare("CALL PROC_USUARIO_REGISTER(:NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CODIGO, :ID_CATEGORIA, :ID_TIPO_VEHICULO, :PLACA, :CONTRASENIA)");
      // Ejecutamos la consulta
      $query->execute([
        "NOMBRES" => $data->NOMBRES,
        "APPATERNO" => $data->APPATERNO,
        "APMATERNO" => $data->APMATERNO,
        "DOCUMENTO" => $data->DOCUMENTO,
        "CODIGO" => $data->CODIGO,
        "ID_CATEGORIA" => $data->ID_CATEGORIA,
        "ID_TIPO_VEHICULO" => $data->ID_TIPO_VEHICULO,
        "PLACA" => $data->PLACA,
        "CONTRASENIA" => $data->CONTRASENIA
      ]);

      // Lo asociamos
      $result = $query->fetchAll(PDO::FETCH_ASSOC);

      // Armamos nuestra respuesta
      $response = array(
        "icon" => $result[0]["ICON"],
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $result[0]["MESSAGE_TEXT"],
        "statusCode" => $result[0]["STATUS_CODE"]
      );

      // En caso haya errores
    } catch (Exception $err) {
      // Enviamos informe del error
      $response = array(
        "icon" => "error",
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $err->getMessage(),
        "statusCode" => "500",
        "data" => null
      );
    }

    // Imprimimos en JSON
    Flight::json($response, intval($response["statusCode"]));
  }



  function ELIMINAR_USUARIO()
  {
    // Respuesta
    $response = null;

    try {
      $data = Flight::request()->data;
      $query = Flight::db()->prepare("CALL PROC_USUARIO_DELETE(:ID_USUARIO)");
      $query->execute([
        "ID_USUARIO" => $data->ID_USUARIO
      ]);
      $result = $query->fetchAll(PDO::FETCH_ASSOC);

      // Armamos nuestra respuesta
      $response = array(
        "icon" => $result[0]["ICON"],
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $result[0]["MESSAGE_TEXT"],
        "statusCode" => $result[0]["STATUS_CODE"]
      );
    } catch (Exception $err) {
      // Enviamos informe del error
      $response = array(
        "icon" => "error",
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $err->getMessage(),
        "statusCode" => "500",
        "data" => null
      );
    }

    // Imprimimos en JSON
    Flight::json($response, intval($response["statusCode"]));
  }


  public function ELIMINAR_USUARIO_DEFINITIVO() {
    $response = null;
    try {
        $data = Flight::request()->data;

        $query = Flight::db()->prepare("CALL PROC_USUARIO_ELIMINAR_DEFINITIVO(:ID_USUARIO)");
        $query->execute(["ID_USUARIO" => $data->ID_USUARIO]);

        $response = array(
            "icon" => "success",
            "title" => "MENSAJE DEL SISTEMA",
            "text" => "Usuario eliminado definitivamente",
            "statusCode" => "200"
        );

    } catch (Exception $err) {
        $response = array(
            "icon" => "error",
            "title" => "MENSAJE DEL SISTEMA",
            "text" => $err->getMessage(),
            "statusCode" => "500",
            "data" => null
        );
    }

    Flight::json($response, intval($response["statusCode"]));
}










  public function CREAR_USUARIO()
  {
    $response = null;
    try {
      $data = Flight::request()->data;

      $query = Flight::db()->prepare("CALL PROC_USUARIO_CREAR(:NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CODIGO, :ID_PRIVILEGIO, :CONTRASENIA)");
      $query->execute([
        "NOMBRES" => $data->NOMBRES,
        "APPATERNO" => $data->APPATERNO,
        "APMATERNO" => $data->APMATERNO,
        "DOCUMENTO" => $data->DOCUMENTO,
        "CODIGO" => $data->CODIGO,
        "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO,
        "CONTRASENIA" => $data->CONTRASENIA
      ]);

      $result = $query->fetchAll(PDO::FETCH_ASSOC);

      $response = array(
        "icon" => $result[0]["ICON"],
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $result[0]["MESSAGE_TEXT"],
        "statusCode" => $result[0]["STATUS_CODE"]
      );
    } catch (Exception $err) {
      $response = array(
        "icon" => "error",
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $err->getMessage(),
        "statusCode" => "500",
        "data" => null
      );
    }

    Flight::json($response, intval($response["statusCode"]));
  }

  public function ACTUALIZAR_USUARIO()
  {
    $response = null;
    try {
      $data = Flight::request()->data;

      $query = Flight::db()->prepare("CALL PROC_USUARIO_ACTUALIZAR(:ID_USUARIO, :NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CODIGO, :ID_PRIVILEGIO, :CONTRASENIA)");
      $query->execute([
        "ID_USUARIO" => $data->ID_USUARIO,
        "NOMBRES" => $data->NOMBRES,
        "APPATERNO" => $data->APPATERNO,
        "APMATERNO" => $data->APMATERNO,
        "DOCUMENTO" => $data->DOCUMENTO,
        "CODIGO" => $data->CODIGO,
        "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO,
        "CONTRASENIA" => $data->CONTRASENIA
      ]);

      $result = $query->fetchAll(PDO::FETCH_ASSOC);

      $response = array(
        "icon" => $result[0]["ICON"],
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $result[0]["MESSAGE_TEXT"],
        "statusCode" => $result[0]["STATUS_CODE"]
      );
    } catch (Exception $err) {
      $response = array(
        "icon" => "error",
        "title" => "MENSAJE DEL SISTEMA",
        "text" => $err->getMessage(),
        "statusCode" => "500",
        "data" => null
      );
    }

    Flight::json($response, intval($response["statusCode"]));
  }
}
