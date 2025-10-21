<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $roles = [
            [
                'name' => 'Customer',
                'slug' => 'customer',
                'description' => 'Regular customer who can browse and purchase products',
                'permissions' => json_encode([
                    'browse_products',
                    'purchase_products',
                    'create_reviews',
                    'create_disputes',
                    'manage_wishlist',
                ]),
            ],
            [
                'name' => 'Seller',
                'slug' => 'seller',
                'description' => 'Verified seller who can list and sell products',
                'permissions' => json_encode([
                    'create_products',
                    'manage_products',
                    'view_seller_dashboard',
                    'manage_orders',
                    'view_payouts',
                ]),
            ],
            [
                'name' => 'Admin',
                'slug' => 'admin',
                'description' => 'Platform administrator with full access',
                'permissions' => json_encode([
                    'manage_all_users',
                    'manage_all_products',
                    'manage_all_orders',
                    'manage_disputes',
                    'manage_categories',
                    'view_analytics',
                    'manage_settings',
                ]),
            ],
            [
                'name' => 'Moderator',
                'slug' => 'moderator',
                'description' => 'Content moderator who can review and approve listings',
                'permissions' => json_encode([
                    'review_products',
                    'manage_disputes',
                    'ban_users',
                ]),
            ],
        ];

        foreach ($roles as $role) {
            Role::updateOrCreate(
                ['slug' => $role['slug']],
                $role
            );
        }

        $this->command->info('✅ Roles seeded successfully!');
    }
}
