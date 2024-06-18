<?php

class PlacaContoller{
    public function BUSCAR_PLACA()
    {
      try {
        // Obtener la placa enviada en la solicitud
        $PLACA = Flight::request()->data->PLACA;
  
        // Llamar al procedimiento almacenado para buscar la placa
        $query = Flight::db()->prepare("CALL PROC_BUSCAR_PLACA(:PLACA)");
        $query->bindParam(':PLACA', $PLACA, PDO::PARAM_STR);
        $query->execute();
  
        // Obtener los resultados
        $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
        // Si hay resultados, devolverlos
        if (!empty($result)) {
          Flight::json($result);
        } else {
          // Si no hay resultados, devolver un mensaje indicando que la placa no se encuentra
          Flight::json(["mensaje" => "Placa no encontrada"]);
        }
      } catch (Exception $err) {
        // En caso de error, devolver un mensaje de error
        Flight::json(["error" => $err->getMessage()], 500);
      }
    }

    public function LISTAR_PLACA_ESCANEADA()
    {
      $query = Flight::db()->prepare("CALL PROC_PLACA_ESCANEADA");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }

    
    public function DIAS_PLACA_ESCANEADA()
    {
      $query = Flight::db()->prepare("CALL PROC_DIAS_ENTRADAS_VEHICULOS");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }
    
    public function MES_PLACA_ESCANEADA()
    {
      $query = Flight::db()->prepare("CALL PROC_MES_ENTRADAS_VEHICULOS");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }

    public function ANIO_PLACA_ESCANEADA()
    {
      $query = Flight::db()->prepare("CALL PROC_ANIO_ENTRADAS_VEHICULOS");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }


    public function CATEGORIA_PLACA_ESCANEADA()
    {
      $query = Flight::db()->prepare("CALL PROC_CATEGORIAS_PLACA");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }

    public function VEHICULO_PLACA_ESCANEADA()
    {
      $query = Flight::db()->prepare("CALL PROC_VEHICULOS_PLACA");
      $query->execute();
      $result = $query->fetchAll(PDO::FETCH_ASSOC);
  
      // Imprimimos en JSON
      Flight::json($result);
    }


    public function INSERTAR_PLACA_ESCANEADA() {
      try {
          // Obtener la placa enviada en la solicitud
          $PLACA = Flight::request()->data->PLACA;

          // Llamar al procedimiento almacenado para insertar la placa escaneada
          $query = Flight::db()->prepare("CALL PROC_INSERTAR_PLACA_ESCANEADA(:PLACA)");
          $query->bindParam(':PLACA', $PLACA, PDO::PARAM_STR);
          $query->execute();

          // Responder con un mensaje de éxito
          Flight::json(["mensaje" => "Placa escaneada insertada exitosamente"]);
      } catch (Exception $err) {
          // En caso de error, devolver un mensaje de error
          Flight::json(["error" => $err->getMessage()], 500);
      }
  }


  public function SALIDA_PLACA() {
    try {
        // Obtener la placa enviada en la solicitud
        $PLACA = Flight::request()->data->PLACA;

        // Llamar al procedimiento almacenado para actualizar la salida de la placa
        $query = Flight::db()->prepare("CALL PROC_SALIDA_PLACA(:PLACA)");
        $query->bindParam(':PLACA', $PLACA, PDO::PARAM_STR);
        $query->execute();

        // Verificar si se actualizó alguna fila
        if ($query->rowCount() > 0) {
            Flight::json(["mensaje" => "Salida registrada correctamente"]);
        } else {
            Flight::json(["mensaje" => "No se encontró una entrada activa para la placa proporcionada"]);
        }
    } catch (Exception $err) {
        // En caso de error, devolver un mensaje de error
        Flight::json(["error" => $err->getMessage()], 500);
    }
}

  
}
