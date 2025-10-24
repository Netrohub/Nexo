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
        'metrics' => [
            'total_products' => 25,
            'total_orders' => 45,
            'total_revenue' => 2500.00,
            'pending_orders' => 3,
            'products_sold' => 42
        ]
    ]
];

echo json_encode($response);
?>
