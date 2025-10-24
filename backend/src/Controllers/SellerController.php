<?php

namespace NXOLand\Controllers;

class SellerController
{
    public function dashboard($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Seller dashboard endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function products($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Seller products endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function orders($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Seller orders endpoint - not implemented yet',
            'data' => []
        ]);
    }
}
