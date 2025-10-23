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
                'wishlist' => [
                    [
                        'id' => 1,
                        'name' => 'Wishlist Item 1',
                        'price' => 99.99,
                        'image' => 'https://via.placeholder.com/300x200'
                    ]
                ]
            ]
        ];
        break;
        
    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        $response = [
            'status' => 'success',
            'message' => 'Item added to wishlist',
            'data' => $input
        ];
        break;
        
    case 'DELETE':
        $response = [
            'status' => 'success',
            'message' => 'Item removed from wishlist'
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
