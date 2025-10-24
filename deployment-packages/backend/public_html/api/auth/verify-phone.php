<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$input = json_decode(file_get_contents('php://input'), true);

if (empty($input['phone']) || empty($input['code'])) {
    $response = [
        'status' => 'error',
        'message' => 'Phone and code are required'
    ];
    http_response_code(400);
} else {
    $response = [
        'status' => 'success',
        'message' => 'Phone verified successfully'
    ];
}

echo json_encode($response);
?>
