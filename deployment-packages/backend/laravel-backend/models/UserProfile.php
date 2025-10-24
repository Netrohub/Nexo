<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserProfile extends Model
{
    protected $fillable = [
        'user_id',
        'bio',
        'country',
        'city',
        'address',
        'postal_code',
        'date_of_birth',
        'gender',
        'language',
        'timezone',
        'kyc_status',
        'kyc_document_type',
        'kyc_document_number',
        'kyc_document_url',
        'kyc_verified_at',
        'seller_rating',
        'seller_verified',
        'seller_verified_at',
        'total_sales',
        'total_revenue',
        'metadata',
    ];

    protected $casts = [
        'date_of_birth' => 'date',
        'kyc_verified_at' => 'datetime',
        'seller_verified' => 'boolean',
        'seller_verified_at' => 'datetime',
        'seller_rating' => 'decimal:2',
        'total_revenue' => 'decimal:2',
        'metadata' => 'array',
    ];

    /**
     * Get the user that owns the profile
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Check if user has verified KYC
     */
    public function isKycVerified(): bool
    {
        return $this->kyc_status === 'verified';
    }

    /**
     * Check if user is verified seller
     */
    public function isVerifiedSeller(): bool
    {
        return $this->seller_verified === true;
    }
}
