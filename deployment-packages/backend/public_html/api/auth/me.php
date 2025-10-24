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
        'user' => [
            'id' => 1,
            'name' => 'Test User',
            'email' => 'user@example.com',
            'role' => 'buyer',
            'kyc_status' => 'pending',
            'phone_verified' => false
        ]
    ]
];

echo json_encode($response);
?>
