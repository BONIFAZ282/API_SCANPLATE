<?php
// CORS
// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");
// Permitir los métodos de solicitud GET, POST y OPTIONS
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// Permitir el envío de encabezados personalizados
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Permitir las cookies en las solicitudes
header("Access-Control-Allow-Credentials: true");
// Si la solicitud es de tipo OPTIONS, envía solo las cabeceras CORS y finaliza la ejecución del script
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("HTTP/1.1 200 OK");
    exit();
}
