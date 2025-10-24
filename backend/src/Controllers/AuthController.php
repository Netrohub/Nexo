<?php

namespace NXOLand\Controllers;

class AuthController
{
    public function login($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Login endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function register($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Register endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function logout($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Logout endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function me($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Get current user endpoint - not implemented yet',
            'data' => []
        ]);
    }
}
