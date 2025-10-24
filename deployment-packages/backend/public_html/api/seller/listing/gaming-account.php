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
    'message' => 'Gaming account listing created successfully',
    'data' => [
        'id' => 1,
        'title' => 'Premium Gaming Account',
        'price' => 199.99,
        'game' => 'Fortnite',
        'level' => 100
    ]
];

echo json_encode($response);
?>
