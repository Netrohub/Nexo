<?php

namespace NXOLand\Controllers;

class ProductController
{
    public function index($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Products list endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function show($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Product details endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
    
    public function store($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Create product endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function update($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Update product endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
    
    public function destroy($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Delete product endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
}
