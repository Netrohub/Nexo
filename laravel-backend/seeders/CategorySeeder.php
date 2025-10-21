<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Social Media',
                'slug' => 'social-media',
                'description' => 'Social media accounts including Instagram, TikTok, YouTube, Twitter',
                'icon' => 'smartphone',
                'is_active' => true,
                'order_index' => 1,
                'metadata' => json_encode([
                    'platforms' => ['Instagram', 'TikTok', 'YouTube', 'Twitter', 'Facebook', 'Snapchat'],
                ]),
            ],
            [
                'name' => 'Gaming',
                'slug' => 'gaming',
                'description' => 'Game accounts for Steam, PlayStation, Xbox, Epic Games, and more',
                'icon' => 'gamepad-2',
                'is_active' => true,
                'order_index' => 2,
                'metadata' => json_encode([
                    'platforms' => ['Steam', 'PlayStation', 'Xbox', 'Epic Games', 'Battle.net', 'Origin'],
                    'popular_games' => ['Fortnite', 'PUBG', 'Valorant', 'League of Legends', 'CS:GO'],
                ]),
            ],
            [
                'name' => 'Digital Services',
                'slug' => 'digital-services',
                'description' => 'Streaming accounts, VPNs, cloud storage, and other digital services',
                'icon' => 'cloud',
                'is_active' => true,
                'order_index' => 3,
                'metadata' => json_encode([
                    'services' => ['Netflix', 'Spotify', 'Disney+', 'VPN', 'Cloud Storage'],
                ]),
            ],
            [
                'name' => 'Software',
                'slug' => 'software',
                'description' => 'Software licenses and activation keys',
                'icon' => 'code',
                'is_active' => true,
                'order_index' => 4,
                'metadata' => json_encode([
                    'types' => ['Operating Systems', 'Productivity', 'Security', 'Design Tools'],
                ]),
            ],
            [
                'name' => 'Entertainment',
                'slug' => 'entertainment',
                'description' => 'Entertainment and media accounts',
                'icon' => 'tv',
                'is_active' => true,
                'order_index' => 5,
            ],
        ];

        foreach ($categories as $category) {
            Category::updateOrCreate(
                ['slug' => $category['slug']],
                $category
            );
        }

        $this->command->info('✅ Categories seeded successfully!');
    }
}
