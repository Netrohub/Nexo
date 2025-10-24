<?php

namespace App\Controllers;

use App\Models\User;
use App\Auth\JWT;

class AuthController
{
    private $userModel;

    public function __construct()
    {
        $this->userModel = new User();
    }

    public function login($vars = [])
    {
        try {
            $input = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($input['email']) || !isset($input['password'])) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Email and password are required',
                    'data' => []
                ]);
            }

            $email = $input['email'];
            $password = $input['password'];

            if (!$this->userModel->verifyPassword($email, $password)) {
                http_response_code(401);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Invalid credentials',
                    'data' => []
                ]);
            }

            $user = $this->userModel->findByEmail($email);
            unset($user['password']); // Remove password from response

            $token = JWT::generateToken([
                'user_id' => $user['id'],
                'email' => $user['email'],
                'name' => $user['name']
            ]);

            return json_encode([
                'status' => 'success',
                'message' => 'Login successful',
                'data' => [
                    'user' => $user,
                    'token' => $token
                ]
            ]);

        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Login failed: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function register($vars = [])
    {
        try {
            $input = json_decode(file_get_contents('php://input'), true);
            
            $required = ['name', 'email', 'password', 'password_confirmation'];
            foreach ($required as $field) {
                if (!isset($input[$field]) || empty($input[$field])) {
                    http_response_code(400);
                    return json_encode([
                        'status' => 'error',
                        'message' => "Field {$field} is required",
                        'data' => []
                    ]);
                }
            }

            if ($input['password'] !== $input['password_confirmation']) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Passwords do not match',
                    'data' => []
                ]);
            }

            // Check if user already exists
            if ($this->userModel->findByEmail($input['email'])) {
                http_response_code(409);
                return json_encode([
                    'status' => 'error',
                    'message' => 'User already exists',
                    'data' => []
                ]);
            }

            $userData = [
                'name' => $input['name'],
                'email' => $input['email'],
                'password' => $input['password'],
                'phone' => $input['phone'] ?? null,
                'roles' => json_encode(['user']),
                'kyc_status' => json_encode(['email' => false, 'phone' => false, 'identity' => false])
            ];

            $userId = $this->userModel->create($userData);
            $user = $this->userModel->findById($userId);

            $token = JWT::generateToken([
                'user_id' => $user['id'],
                'email' => $user['email'],
                'name' => $user['name']
            ]);

            return json_encode([
                'status' => 'success',
                'message' => 'Registration successful',
                'data' => [
                    'user' => $user,
                    'token' => $token
                ]
            ]);

        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Registration failed: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function logout($vars = [])
    {
        // JWT is stateless, so logout is handled on frontend
        return json_encode([
            'status' => 'success',
            'message' => 'Logout successful',
            'data' => []
        ]);
    }
    
    public function me($vars = [])
    {
        try {
            $currentUser = JWT::getCurrentUser();
            
            if (!$currentUser) {
                http_response_code(401);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Unauthorized',
                    'data' => []
                ]);
            }

            $user = $this->userModel->findById($currentUser['user_id']);
            
            if (!$user) {
                http_response_code(404);
                return json_encode([
                    'status' => 'error',
                    'message' => 'User not found',
                    'data' => []
                ]);
            }

            return json_encode([
                'status' => 'success',
                'message' => 'User data retrieved',
                'data' => $user
            ]);

        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to get user data: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
}
