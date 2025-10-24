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
                'disputes' => [
                    [
                        'id' => 1,
                        'order_id' => 'ORD-123',
                        'reason' => 'Item not as described',
                        'status' => 'open',
                        'created_at' => date('Y-m-d H:i:s')
                    ]
                ]
            ]
        ];
        break;
        
    case 'POST':
        $input = json_decode(file_get_contents('php://input'), true);
        $response = [
            'status' => 'success',
            'message' => 'Dispute created successfully',
            'data' => [
                'id' => 2,
                'order_id' => $input['order_id'] ?? 'ORD-456',
                'reason' => $input['reason'] ?? 'Dispute reason',
                'status' => 'open'
            ]
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
