<?php

class CocheraController
{
    function COCHERA_LISTAR()
    {
        $query = Flight::db()->prepare("CALL PROC_MOSTRAR_ESTACIONAMIENTO()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        //imprimir en JSON
        Flight::json($result);
    }
}