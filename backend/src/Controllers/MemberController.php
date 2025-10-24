<?php

namespace NXOLand\Controllers;

class MemberController
{
    public function index($vars = [])
    {
        return json_encode([
            'status' => 'success',
            'message' => 'Members list endpoint - not implemented yet',
            'data' => []
        ]);
    }
}
