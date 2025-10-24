<?php

require_once __DIR__ . '/../vendor/autoload.php';

use FastRoute\RouteCollector;
use FastRoute\Dispatcher;
use FastRoute\simpleDispatcher;

// Load environment variables (optional)
try {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
    $dotenv->load();
} catch (Exception $e) {
    // .env file not found or invalid, continue with defaults
    error_log('Warning: Could not load .env file: ' . $e->getMessage());
}

// CORS headers - Restrict to specific domains
$allowedOrigins = [
    'https://nxoland.com',
    'https://www.nxoland.com',
    'http://localhost:3000',
    'http://localhost:4173',
    'http://localhost:4174'
];

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (in_array($origin, $allowedOrigins)) {
    header("Access-Control-Allow-Origin: {$origin}");
} else {
    header('Access-Control-Allow-Origin: https://nxoland.com');
}

header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Access-Control-Allow-Credentials: true');
header('Content-Type: application/json');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Define routes
$dispatcher = \FastRoute\simpleDispatcher(function(RouteCollector $r) {
    // Health check
    $r->get('/api/ping', function() {
        return json_encode(['ok' => true]);
    });
    
    // Auth routes
    $r->post('/api/auth/login', 'AuthController@login');
    $r->post('/api/auth/register', 'AuthController@register');
    $r->post('/api/auth/logout', 'AuthController@logout');
    $r->get('/api/auth/me', 'AuthController@me');
    
    // Product routes
    $r->get('/api/products', 'ProductController@index');
    $r->get('/api/products/{id}', 'ProductController@show');
    $r->post('/api/products', 'ProductController@store');
    $r->put('/api/products/{id}', 'ProductController@update');
    $r->delete('/api/products/{id}', 'ProductController@destroy');
    
    // Cart routes
    $r->get('/api/cart', 'CartController@index');
    $r->post('/api/cart', 'CartController@store');
    $r->put('/api/cart/{id}', 'CartController@update');
    $r->delete('/api/cart/{id}', 'CartController@destroy');
    
    // Order routes
    $r->get('/api/orders', 'OrderController@index');
    $r->get('/api/orders/{id}', 'OrderController@show');
    $r->post('/api/orders', 'OrderController@store');
    
    // Wishlist routes
    $r->get('/api/wishlist', 'WishlistController@index');
    $r->post('/api/wishlist', 'WishlistController@store');
    $r->delete('/api/wishlist/{id}', 'WishlistController@destroy');
    
    // Dispute routes
    $r->get('/api/disputes', 'DisputeController@index');
    $r->get('/api/disputes/{id}', 'DisputeController@show');
    $r->post('/api/disputes', 'DisputeController@store');
    
    // Seller routes
    $r->get('/api/seller/dashboard', 'SellerController@dashboard');
    $r->get('/api/seller/products', 'SellerController@products');
    $r->get('/api/seller/orders', 'SellerController@orders');
    
    // Admin routes
    $r->get('/api/admin/users', 'AdminController@users');
    $r->get('/api/admin/orders', 'AdminController@orders');
    $r->get('/api/admin/disputes', 'AdminController@disputes');
    
    // Members
    $r->get('/api/members', 'MemberController@index');
});

// Get the current request method and URI
$httpMethod = $_SERVER['REQUEST_METHOD'];
$uri = $_SERVER['REQUEST_URI'];

// Remove query string (?foo=bar) and decode URI
if (false !== $pos = strpos($uri, '?')) {
    $uri = substr($uri, 0, $pos);
}
$uri = rawurldecode($uri);

// Dispatch the request
$routeInfo = $dispatcher->dispatch($httpMethod, $uri);

switch ($routeInfo[0]) {
    case Dispatcher::NOT_FOUND:
        http_response_code(404);
        echo json_encode(['error' => 'Not Found']);
        break;
        
    case Dispatcher::METHOD_NOT_ALLOWED:
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
        break;
        
    case Dispatcher::FOUND:
        $handler = $routeInfo[1];
        $vars = $routeInfo[2];
        
        if (is_callable($handler)) {
            echo $handler();
        } else {
            // Handle controller@method format
            list($controller, $method) = explode('@', $handler);
            $controllerClass = "\\App\\Controllers\\{$controller}";
            
            if (class_exists($controllerClass)) {
                $controllerInstance = new $controllerClass();
                if (method_exists($controllerInstance, $method)) {
                    echo $controllerInstance->$method($vars);
                } else {
                    http_response_code(500);
                    echo json_encode(['error' => 'Method not found']);
                }
            } else {
                http_response_code(500);
                echo json_encode(['error' => 'Controller not found']);
            }
        }
        break;
}
