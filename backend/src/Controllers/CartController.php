<?php

namespace NXOLand\Controllers;

class CartController
{
    public function index($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Cart endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function store($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Add to cart endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function update($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Update cart item endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
    
    public function destroy($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Remove from cart endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
}
