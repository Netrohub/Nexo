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
        'categories' => [
            [
                'id' => 1,
                'name' => 'Electronics',
                'slug' => 'electronics',
                'products_count' => 25,
                'status' => 'active'
            ],
            [
                'id' => 2,
                'name' => 'Gaming',
                'slug' => 'gaming',
                'products_count' => 15,
                'status' => 'active'
            ]
        ]
    ]
];

echo json_encode($response);
?>
