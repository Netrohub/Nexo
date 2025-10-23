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
        'coupons' => [
            [
                'id' => 1,
                'code' => 'WELCOME10',
                'discount' => 10,
                'type' => 'percentage',
                'usage_count' => 5,
                'max_uses' => 100,
                'expires_at' => '2024-12-31'
            ]
        ]
    ]
];

echo json_encode($response);
?>
