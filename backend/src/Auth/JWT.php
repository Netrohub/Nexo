<?php

namespace App\Auth;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Firebase\JWT\ExpiredException;
use Firebase\JWT\SignatureInvalidException;

class JWT
{
    private static $secret;
    private static $algorithm = 'HS256';

    public static function init()
    {
        self::$secret = $_ENV['JWT_SECRET'] ?? 'your-secret-key-change-in-production';
    }

    public static function generateToken($payload)
    {
        self::init();
        
        $payload['iat'] = time();
        $payload['exp'] = time() + (24 * 60 * 60); // 24 hours
        
        return JWT::encode($payload, self::$secret, self::$algorithm);
    }

    public static function validateToken($token)
    {
        self::init();
        
        try {
            $decoded = JWT::decode($token, new Key(self::$secret, self::$algorithm));
            return (array) $decoded;
        } catch (ExpiredException $e) {
            throw new \Exception('Token has expired');
        } catch (SignatureInvalidException $e) {
            throw new \Exception('Invalid token signature');
        } catch (\Exception $e) {
            throw new \Exception('Invalid token');
        }
    }

    public static function getTokenFromHeader()
    {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
        
        if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
            return $matches[1];
        }
        
        return null;
    }

    public static function getCurrentUser()
    {
        $token = self::getTokenFromHeader();
        if (!$token) {
            return null;
        }
        
        try {
            $payload = self::validateToken($token);
            return $payload;
        } catch (\Exception $e) {
            return null;
        }
    }
}
