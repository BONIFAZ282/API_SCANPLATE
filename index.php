<?php
// Configuracion
require './config/cors.php';

// JWT
require './vendor/firebase/php-jwt/src/JWT.php';
require './config/JWTConfig.php';

// Bliblioteca Flight
require 'flight/Flight.php';

//MODAL
require './Model/Token.php';
require './Model/Usuario.php';

// Llamado a los ficheros correpondientes de cada controlador

require './Controller/SelectController.php';
require './Controller/PlacaController.php';
require './Controller/UsuarioController.php';
require './Controller/PrivilegioController.php';
require './Controller/CategoriaController.php';
require './Controller/TipoVehiculoController.php';
require './Controller/SeguridadController.php';
require './Controller/CocheraController.php';
require './Controller/CuerpoEducativoController.php';


// |||||||||||||| DATABASE ||||||||||||||||||||||||
require './config/dbConfig.php';

// Registro a Flight con las configuraciones de DB
Flight::register('db', 'PDO', $GLOBALS["db"]);

// Ruta principal devuelvo mensaje por GET para probar el correcto funcionanmiento de API
Flight::route('GET /', function () {
    $data = array('info' => 'API SISCAP CSJICA');
    Flight::json($data);
});

// ||||||||||||||||||| RUTAS |||||||||||||||||||||||||||

// SELECT
$selectController = new SelectController();
Flight::route('GET /select/privilegio', array($selectController, 'SELECT_PRIVILEGIO'));
Flight::route('GET /select/categoria', array($selectController, 'SELECT_CATEGORIA'));
Flight::route('GET /select/vehiculo', array($selectController, 'SELECT_TIPO_VEHICULO'));
Flight::route('POST /select/rplacas', array($selectController, 'PlacaReport'));



// USUARIOS
$usuarioController = new UsuarioController();
Flight::route('POST /auth', array($usuarioController, "LOGIN_USUARIO"));
Flight::route('GET /usuario/list', array($usuarioController, "LISTAR_USUARIOS_1"));
Flight::route('GET /usuario/list/eliminado', array($usuarioController, "LISTAR_USUARIOS_0"));
Flight::route('POST /usuario/crear', array($usuarioController, "CREAR_USUARIO"));
Flight::route('POST /usuario/actualizar', array($usuarioController, "ACTUALIZAR_USUARIO"));
Flight::route('POST /usuario/natural', array($usuarioController, "CREAR_USUARIO_NATURAL"));
Flight::route('POST /usuario/delete', array($usuarioController, "ELIMINAR_USUARIO"));
Flight::route('POST /usuario/eliminar_definitivo', array($usuarioController, "ELIMINAR_USUARIO_DEFINITIVO"));


$educativoController = new CuerpoEducativoController();

Flight::route('POST /cuerpo_educativo/crear', array($educativoController, "CREAR_CUERPO_EDUCATIVO"));
Flight::route('POST /cuerpo_educativo/actualizar', array($educativoController, "ACTUALIZAR_CUERPO_EDUCATIVO"));
Flight::route('POST /cuerpo_educativo/eliminar', array($educativoController, "ELIMINAR_CUERPO_EDUCATIVO"));
Flight::route('GET /cuerpo_educativo/list', array($educativoController, "LISTAR_CUERPO_EDUCATIVO"));



// PRIVILEGIO
$privilegioController = new PrivilegioController();
Flight::route('GET /privilegio/list', array($privilegioController, "PRIVILEGIO_LISTAR"));
Flight::route('POST /privilegio/create', array($privilegioController, "PRIVILEGIO_CU"));
Flight::route('POST /privilegio/delete', array($privilegioController, "PRIVILEGIO_DELETE"));


// CATEGORIA
$categoriController = new CategoriaController();
Flight::route('GET /categoria/list', array($categoriController, "CATEGORIA_LISTAR"));
Flight::route('POST /categoria/create', array($categoriController, "CATEGORIA_CU"));
Flight::route('POST /categoria/delete', array($categoriController, "CATEGORIA_DELETE"));


// TIPO VEHICULO
$vehiculoController = new TipoVehiculoController();
Flight::route('GET /vehiculo/list', array($vehiculoController, "TIPO_VEHICULO_LISTAR"));
Flight::route('POST /vehiculo/create', array($vehiculoController, "TIPO_VEHICULO_CU"));
Flight::route('POST /vehiculo/delete', array($vehiculoController, "TIPO_VEHICULO_DELETE"));


// PLACA
$placaController = new PlacaContoller();
Flight::route('POST /placa/buscar', array($placaController, "BUSCAR_PLACA"));   
Flight::route('GET /placa/dia', array($placaController, "DIAS_PLACA_ESCANEADA"));
Flight::route('GET /placa/mes', array($placaController, "MES_PLACA_ESCANEADA"));
Flight::route('GET /placa/anio', array($placaController, "ANIO_PLACA_ESCANEADA"));
Flight::route('GET /placa/vehiculo', array($placaController, "VEHICULO_PLACA_ESCANEADA"));
Flight::route('GET /placa/categoria', array($placaController, "CATEGORIA_PLACA_ESCANEADA"));
Flight::route('POST /reporte/placa', array($placaController, "LISTAR_PLACA_ESCANEADA"));
Flight::route('POST /placa/insertar', array($placaController, "INSERTAR_PLACA_ESCANEADA"));
Flight::route('POST /placa/salida', array($placaController, "SALIDA_PLACA"));


//COCHERA
$cocheraController = new CocheraController();
Flight::route('GET /cochera', array($cocheraController, "COCHERA_LISTAR"));


// Iniciar Flight
Flight::start();
