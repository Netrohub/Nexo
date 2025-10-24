<?php

namespace App\Controllers;

use App\Database\Database;
use App\Auth\JWT;

class CartController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function index($vars = [])
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

            $cartItems = $this->db->fetchAll(
                "SELECT c.*, p.name, p.price, p.images FROM cart c 
                 JOIN products p ON c.product_id = p.id 
                 WHERE c.user_id = :user_id AND c.status = 'active'",
                ['user_id' => $currentUser['user_id']]
            );

            $total = 0;
            foreach ($cartItems as $item) {
                $total += $item['price'] * $item['quantity'];
            }

            return json_encode([
                'status' => 'success',
                'message' => 'Cart retrieved successfully',
                'data' => [
                    'items' => $cartItems,
                    'total' => $total,
                    'count' => count($cartItems)
                ]
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to retrieve cart: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function store($vars = [])
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

            $input = json_decode(file_get_contents('php://input'), true);
            
            if (!isset($input['product_id']) || !isset($input['quantity'])) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Product ID and quantity are required',
                    'data' => []
                ]);
            }

            // Check if product exists
            $product = $this->db->fetch(
                "SELECT * FROM products WHERE id = :id AND status = 'active'",
                ['id' => $input['product_id']]
            );

            if (!$product) {
                http_response_code(404);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Product not found',
                    'data' => []
                ]);
            }

            // Check if item already in cart
            $existingItem = $this->db->fetch(
                "SELECT * FROM cart WHERE user_id = :user_id AND product_id = :product_id AND status = 'active'",
                ['user_id' => $currentUser['user_id'], 'product_id' => $input['product_id']]
            );

            if ($existingItem) {
                // Update quantity
                $newQuantity = $existingItem['quantity'] + $input['quantity'];
                $this->db->update('cart', 
                    ['quantity' => $newQuantity, 'updated_at' => date('Y-m-d H:i:s')], 
                    'id = :id', 
                    ['id' => $existingItem['id']]
                );
            } else {
                // Add new item
                $cartData = [
                    'user_id' => $currentUser['user_id'],
                    'product_id' => $input['product_id'],
                    'quantity' => $input['quantity'],
                    'status' => 'active',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s')
                ];
                $this->db->insert('cart', $cartData);
            }

            return json_encode([
                'status' => 'success',
                'message' => 'Item added to cart successfully',
                'data' => []
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to add item to cart: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function update($vars = [])
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

            $id = $vars['id'] ?? null;
            $input = json_decode(file_get_contents('php://input'), true);
            
            if (!$id) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Cart item ID is required',
                    'data' => []
                ]);
            }

            if (!isset($input['quantity'])) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Quantity is required',
                    'data' => []
                ]);
            }

            // Verify cart item belongs to user
            $cartItem = $this->db->fetch(
                "SELECT * FROM cart WHERE id = :id AND user_id = :user_id",
                ['id' => $id, 'user_id' => $currentUser['user_id']]
            );

            if (!$cartItem) {
                http_response_code(404);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Cart item not found',
                    'data' => []
                ]);
            }

            $this->db->update('cart', 
                ['quantity' => $input['quantity'], 'updated_at' => date('Y-m-d H:i:s')], 
                'id = :id', 
                ['id' => $id]
            );

            return json_encode([
                'status' => 'success',
                'message' => 'Cart item updated successfully',
                'data' => []
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to update cart item: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function destroy($vars = [])
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

            $id = $vars['id'] ?? null;
            
            if (!$id) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Cart item ID is required',
                    'data' => []
                ]);
            }

            // Verify cart item belongs to user
            $cartItem = $this->db->fetch(
                "SELECT * FROM cart WHERE id = :id AND user_id = :user_id",
                ['id' => $id, 'user_id' => $currentUser['user_id']]
            );

            if (!$cartItem) {
                http_response_code(404);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Cart item not found',
                    'data' => []
                ]);
            }

            $this->db->update('cart', 
                ['status' => 'removed', 'updated_at' => date('Y-m-d H:i:s')], 
                'id = :id', 
                ['id' => $id]
            );

            return json_encode([
                'status' => 'success',
                'message' => 'Cart item removed successfully',
                'data' => []
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to remove cart item: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
}