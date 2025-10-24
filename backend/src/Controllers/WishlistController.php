<?php

namespace NXOLand\Controllers;

class WishlistController
{
    public function index($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Wishlist endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function store($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Add to wishlist endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function destroy($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Remove from wishlist endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
}
