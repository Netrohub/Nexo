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
        'payouts' => [
            [
                'id' => 1,
                'amount' => 500.00,
                'status' => 'pending',
                'requested_at' => '2024-01-01',
                'processed_at' => null
            ]
        ]
    ]
];

echo json_encode($response);
?>
