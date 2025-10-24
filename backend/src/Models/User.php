<?php

namespace App\Models;

use App\Database\Database;

class User
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function create($data)
    {
        $data['password'] = password_hash($data['password'], PASSWORD_DEFAULT);
        $data['created_at'] = date('Y-m-d H:i:s');
        $data['updated_at'] = date('Y-m-d H:i:s');
        
        return $this->db->insert('users', $data);
    }

    public function findByEmail($email)
    {
        return $this->db->fetch(
            "SELECT * FROM users WHERE email = :email",
            ['email' => $email]
        );
    }

    public function findById($id)
    {
        return $this->db->fetch(
            "SELECT id, name, email, phone, avatar, roles, kyc_status, created_at, updated_at FROM users WHERE id = :id",
            ['id' => $id]
        );
    }

    public function update($id, $data)
    {
        $data['updated_at'] = date('Y-m-d H:i:s');
        return $this->db->update('users', $data, 'id = :id', ['id' => $id]);
    }

    public function verifyPassword($email, $password)
    {
        $user = $this->findByEmail($email);
        if (!$user) {
            return false;
        }
        
        return password_verify($password, $user['password']);
    }

    public function getAll($limit = 10, $offset = 0)
    {
        return $this->db->fetchAll(
            "SELECT id, name, email, phone, avatar, roles, kyc_status, created_at FROM users LIMIT :limit OFFSET :offset",
            ['limit' => $limit, 'offset' => $offset]
        );
    }

    public function getTotal()
    {
        $result = $this->db->fetch("SELECT COUNT(*) as total FROM users");
        return $result['total'];
    }
}
