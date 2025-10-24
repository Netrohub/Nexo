<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $response = [
            'status' => 'success',
            'data' => [
                'products' => [
                    [
                        'id' => 1,
                        'name' => 'My Product',
                        'price' => 99.99,
                        'status' => 'active',
                        'views' => 150,
                        'sales' => 5
                    ]
                ]
            ]
        ];
        break;
        
    case 'POST':
        $response = [
            'status' => 'success',
            'message' => 'Product created successfully',
            'data' => [
                'id' => 2,
                'name' => 'New Product',
                'price' => 149.99
            ]
        ];
        break;
        
    case 'DELETE':
        $response = [
            'status' => 'success',
            'message' => 'Product deleted successfully'
        ];
        break;
        
    default:
        $response = [
            'status' => 'error',
            'message' => 'Method not allowed'
        ];
        http_response_code(405);
        break;
}

echo json_encode($response);
?>
