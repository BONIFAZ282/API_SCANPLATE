<?php

class PrivilegioController
{
    function PRIVILEGIO_LISTAR()
    {
        $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_LISTAR()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        //imprimir en JSON
        Flight::json($result);
    }

    function PRIVILEGIO_CU()
    {
        // Respuesta
        $response = null;

        try {
            $data = Flight::request()->data;
            $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_CU(:ID_PRIVILEGIO, :NOM_PRIVILEGIO)");
            $query->execute([
                "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO,
                "NOM_PRIVILEGIO" => $data->NOM_PRIVILEGIO
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


    function PRIVILEGIO_DELETE()
    {
        // Respuesta
        $response = null;

        try {
            $data = Flight::request()->data;
            $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_DELETE(:ID_PRIVILEGIO)");
            $query->execute([
                "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO
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

}