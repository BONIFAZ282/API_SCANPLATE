<?php

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class Token
{
  public static function generarToken($username, $days)
  {
    $key = $GLOBALS["KEY"];
    /* creating access token */
    $issuedAt = time();
    // jwt valid for 60 days (60 seconds * 60 minutes * 24 hours * 60 days)
    $expirationTime = $issuedAt + 60 * 60 * 24 * $days;
    $payload = array(
      'username' => $username,
      'iat' => $issuedAt,
      'exp' => $expirationTime,
    );
    $alg = 'HS256';
    return JWT::encode($payload, $key, $alg);
  }

  public static function IsAuthorization($authHeader)
  {
    $key = $GLOBALS["KEY"];
    list($jwt) = sscanf($authHeader, 'Bearer %s');

    if (!$jwt) {
      Flight::halt(401, 'No se proporcionó un token JWT');
    }

    try {
      $decoded = JWT::decode($jwt, new Key($key, 'HS256'));

      return isset($decoded->username);
    } catch (Exception $e) {
      return false;
    }
  }

  public static function WhoIsUser($authHeader)
  {
    $key = $GLOBALS["KEY"];
    list($jwt) = sscanf($authHeader, 'Bearer %s');

    try {
      $decoded = JWT::decode($jwt, new Key($key, 'HS256'));

      return $decoded->username;
    } catch (Exception $e) {
      return "";
    }
  }
}