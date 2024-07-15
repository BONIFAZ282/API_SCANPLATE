<?php

class CuerpoEducativoController {

    public function CREAR_CUERPO_EDUCATIVO() {
        $response = null;
        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_CUERPO_EDUCATIVO_CREAR(:NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CODIGO, :ID_CATEGORIA, :ID_TIPO_VEHICULO, :PLACA, :CONTRASENIA)");
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

    public function ACTUALIZAR_CUERPO_EDUCATIVO() {
        $response = null;
        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_CUERPO_EDUCATIVO_ACTUALIZAR(:ID_CUERPO_EDUCATIVO, :NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CODIGO, :ID_CATEGORIA, :ID_TIPO_VEHICULO, :PLACA, :CONTRASENIA)");
            $query->execute([
                "ID_CUERPO_EDUCATIVO" => $data->ID_CUERPO_EDUCATIVO,
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

    public function ELIMINAR_CUERPO_EDUCATIVO() {
        $response = null;
        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_CUERPO_EDUCATIVO_ELIMINAR(:ID_CUERPO_EDUCATIVO)");
            $query->execute(["ID_CUERPO_EDUCATIVO" => $data->ID_CUERPO_EDUCATIVO]);

            $response = array(
                "icon" => "success",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => "Cuerpo educativo eliminado correctamente",
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


    public function LISTAR_CUERPO_EDUCATIVO()
    {
      $query = Flight::db()->prepare("CALL PROC_CUERPO_EDUCATIVO_LIST");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }
}
