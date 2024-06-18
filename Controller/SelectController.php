<?php

class SelectController
{
    function SELECT_PRIVILEGIO()
    {
        $query = Flight::db()->prepare("CALL PROC_SELECT_PRIVILEGIO()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    function SELECT_CATEGORIA()
    {
        $query = Flight::db()->prepare("CALL PROC_SELECT_CATEGORIA()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    function SELECT_TIPO_VEHICULO()
    {
        $query = Flight::db()->prepare("CALL PROC_SELECT_TIPO_VEHICULO()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    function SELECT_SEGURIDAD()
    {
        $query = Flight::db()->prepare("CALL PROC_SELECT_SEGURIDAD()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    function PlacaReport(){
        $vehiculo = [];
        $categoria = [];

        $query = Flight::db()->prepare("CALL PROC_SELECT_TIPO_VEHICULO()");
        $query->execute();
        $vehiculo = $query->fetchAll(PDO::FETCH_ASSOC);
    
        // PROC_LIST_ANIOADQUISICION
        $query = Flight::db()->prepare("CALL PROC_SELECT_CATEGORIA()");
        $query->execute();
        $categoria = $query->fetchAll(PDO::FETCH_ASSOC);
    
        // Imprimimos en JSON
        Flight::json(
          array(
            "dVehiculo" => $vehiculo,
            "dCategoria" => $categoria
          )
        );
    }
}