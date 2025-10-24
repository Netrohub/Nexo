<?php

namespace App\Controllers;

use App\Database\Database;

class ProductController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function index($vars = [])
    {
        try {
            $page = $_GET['page'] ?? 1;
            $limit = $_GET['limit'] ?? 12;
            $offset = ($page - 1) * $limit;
            
            $products = $this->db->fetchAll(
                "SELECT * FROM products WHERE status = 'active' LIMIT :limit OFFSET :offset",
                ['limit' => $limit, 'offset' => $offset]
            );
            
            $total = $this->db->fetch("SELECT COUNT(*) as total FROM products WHERE status = 'active'")['total'];
            
            return json_encode([
                'status' => 'success',
                'message' => 'Products retrieved successfully',
                'data' => $products,
                'meta' => [
                    'current_page' => (int)$page,
                    'last_page' => ceil($total / $limit),
                    'per_page' => (int)$limit,
                    'total' => (int)$total,
                    'from' => $offset + 1,
                    'to' => min($offset + $limit, $total)
                ]
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to retrieve products: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function show($vars = [])
    {
        try {
            $id = $vars['id'] ?? null;
            
            if (!$id) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Product ID is required',
                    'data' => []
                ]);
            }
            
            $product = $this->db->fetch(
                "SELECT * FROM products WHERE id = :id AND status = 'active'",
                ['id' => $id]
            );
            
            if (!$product) {
                http_response_code(404);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Product not found',
                    'data' => []
                ]);
            }
            
            return json_encode([
                'status' => 'success',
                'message' => 'Product retrieved successfully',
                'data' => $product
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to retrieve product: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function store($vars = [])
    {
        try {
            $input = json_decode(file_get_contents('php://input'), true);
            
            $required = ['name', 'description', 'price', 'category'];
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
            
            $productData = [
                'name' => $input['name'],
                'description' => $input['description'],
                'price' => $input['price'],
                'category' => $input['category'],
                'images' => json_encode($input['images'] ?? []),
                'status' => 'active',
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s')
            ];
            
            $productId = $this->db->insert('products', $productData);
            $product = $this->db->fetch("SELECT * FROM products WHERE id = :id", ['id' => $productId]);
            
            return json_encode([
                'status' => 'success',
                'message' => 'Product created successfully',
                'data' => $product
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to create product: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function update($vars = [])
    {
        try {
            $id = $vars['id'] ?? null;
            $input = json_decode(file_get_contents('php://input'), true);
            
            if (!$id) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Product ID is required',
                    'data' => []
                ]);
            }
            
            $updateData = array_filter($input, function($key) {
                return in_array($key, ['name', 'description', 'price', 'category', 'images', 'status']);
            }, ARRAY_FILTER_USE_KEY);
            
            $updateData['updated_at'] = date('Y-m-d H:i:s');
            
            $this->db->update('products', $updateData, 'id = :id', ['id' => $id]);
            $product = $this->db->fetch("SELECT * FROM products WHERE id = :id", ['id' => $id]);
            
            return json_encode([
                'status' => 'success',
                'message' => 'Product updated successfully',
                'data' => $product
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to update product: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
    
    public function destroy($vars = [])
    {
        try {
            $id = $vars['id'] ?? null;
            
            if (!$id) {
                http_response_code(400);
                return json_encode([
                    'status' => 'error',
                    'message' => 'Product ID is required',
                    'data' => []
                ]);
            }
            
            $this->db->update('products', ['status' => 'deleted', 'updated_at' => date('Y-m-d H:i:s')], 'id = :id', ['id' => $id]);
            
            return json_encode([
                'status' => 'success',
                'message' => 'Product deleted successfully',
                'data' => []
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            return json_encode([
                'status' => 'error',
                'message' => 'Failed to delete product: ' . $e->getMessage(),
                'data' => []
            ]);
        }
    }
}