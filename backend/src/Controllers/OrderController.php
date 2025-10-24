<?php

namespace NXOLand\Controllers;

class OrderController
{
    public function index($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Orders list endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function show($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Order details endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
    
    public function store($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Create order endpoint - not implemented yet',
            'data' => []
        ]);
    }
}
