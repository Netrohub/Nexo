<?php

namespace NXOLand\Controllers;

class DisputeController
{
    public function index($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Disputes list endpoint - not implemented yet',
            'data' => []
        ]);
    }
    
    public function show($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Dispute details endpoint - not implemented yet',
            'data' => ['id' => $vars['id'] ?? null]
        ]);
    }
    
    public function store($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Create dispute endpoint - not implemented yet',
            'data' => []
        ]);
    }
}
