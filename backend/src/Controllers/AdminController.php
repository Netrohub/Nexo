<?php

namespace NXOLand\Controllers;

class AdminController
{
    public function users($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Admin users endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function orders($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Admin orders endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function disputes($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Admin disputes endpoint - not implemented yet',
            'data' => []
        ]);
    }
}
