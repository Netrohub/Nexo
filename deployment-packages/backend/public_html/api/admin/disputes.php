<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$response = [
    'status' => 'success',
    'data' => [
        'disputes' => [
            [
                'id' => 1,
                'order_id' => 'ORD-123',
                'buyer' => 'John Doe',
                'seller' => 'Jane Smith',
                'reason' => 'Item not as described',
                'status' => 'open',
                'created_at' => '2024-01-01'
            ]
        ]
    ]
];

echo json_encode($response);
?>
