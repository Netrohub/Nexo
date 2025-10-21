<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->comment('Seller ID')->constrained()->onDelete('cascade');
            $table->foreignId('category_id')->constrained()->onDelete('restrict');
            $table->string('title');
            $table->string('slug')->unique();
            $table->text('description');
            $table->decimal('price', 10, 2);
            $table->decimal('discount_price', 10, 2)->nullable();
            $table->string('platform', 100)->nullable()->comment('Gaming/Social platform');
            $table->string('game', 100)->nullable()->comment('Game name');
            $table->string('account_level', 50)->nullable();
            $table->string('account_username', 100)->nullable();
            $table->text('setup_instructions')->nullable();
            $table->string('delivery_time', 50)->default('instant');
            $table->integer('stock_quantity')->default(1);
            $table->enum('status', ['draft', 'pending', 'active', 'sold', 'inactive', 'rejected'])->default('pending');
            $table->boolean('featured')->default(false);
            $table->timestamp('featured_until')->nullable();
            $table->integer('views_count')->default(0);
            $table->decimal('rating', 3, 2)->default(0.00);
            $table->integer('reviews_count')->default(0);
            $table->integer('sales_count')->default(0);
            $table->json('metadata')->nullable();
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes
            $table->index('user_id');
            $table->index('category_id');
            $table->index('slug');
            $table->index('status');
            $table->index('featured');
            $table->index('price');
            $table->index('rating');
            $table->index('created_at');
            
            // Full-text search
            $table->fullText(['title', 'description']);
        });

        Schema::create('product_images', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->constrained()->onDelete('cascade');
            $table->string('url');
            $table->string('alt_text')->nullable();
            $table->integer('order_index')->default(0);
            $table->boolean('is_primary')->default(false);
            $table->timestamps();
            
            $table->index('product_id');
            $table->index('is_primary');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('product_images');
        Schema::dropIfExists('products');
    }
};
