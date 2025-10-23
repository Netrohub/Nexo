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
        'stats' => [
            'total_users' => 1250,
            'total_products' => 340,
            'total_orders' => 89,
            'total_revenue' => 12500.50,
            'pending_disputes' => 3,
            'new_users_today' => 12
        ],
        'recent_orders' => [
            [
                'id' => 1,
                'user' => 'John Doe',
                'total' => 99.99,
                'status' => 'completed',
                'created_at' => date('Y-m-d H:i:s')
            ]
        ]
    ]
];

echo json_encode($response);
?>
