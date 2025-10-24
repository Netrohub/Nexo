<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('user_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->text('bio')->nullable();
            $table->char('country', 2)->nullable();
            $table->string('city', 100)->nullable();
            $table->text('address')->nullable();
            $table->string('postal_code', 20)->nullable();
            $table->date('date_of_birth')->nullable();
            $table->enum('gender', ['male', 'female', 'other'])->nullable();
            $table->string('language', 5)->default('en');
            $table->string('timezone', 50)->default('UTC');
            
            // KYC fields
            $table->enum('kyc_status', ['pending', 'verified', 'rejected'])->default('pending');
            $table->string('kyc_document_type', 50)->nullable();
            $table->string('kyc_document_number', 100)->nullable();
            $table->string('kyc_document_url')->nullable();
            $table->timestamp('kyc_verified_at')->nullable();
            
            // Seller fields
            $table->decimal('seller_rating', 3, 2)->default(0.00);
            $table->boolean('seller_verified')->default(false);
            $table->timestamp('seller_verified_at')->nullable();
            $table->integer('total_sales')->default(0);
            $table->decimal('total_revenue', 15, 2)->default(0.00);
            
            // Metadata
            $table->json('metadata')->nullable();
            
            $table->timestamps();
            
            // Indexes
            $table->index('kyc_status');
            $table->index('seller_rating');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_profiles');
    }
};
