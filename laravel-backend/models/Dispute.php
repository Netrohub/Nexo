<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Builder;

class Dispute extends Model
{
    protected $fillable = [
        'order_id',
        'created_by',
        'assigned_to',
        'type',
        'reason',
        'description',
        'status',
        'resolution',
        'resolved_at',
    ];

    protected $casts = [
        'resolved_at' => 'datetime',
    ];

    protected $with = ['order', 'creator', 'assignee'];

    /**
     * Get the order
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Get the user who created the dispute
     */
    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the admin assigned to the dispute
     */
    public function assignee(): BelongsTo
    {
        return $this->belongsTo(User::class, 'assigned_to');
    }

    /**
     * Get all messages
     */
    public function messages(): HasMany
    {
        return $this->hasMany(DisputeMessage::class);
    }

    /**
     * Get all evidence
     */
    public function evidence(): HasMany
    {
        return $this->hasMany(DisputeEvidence::class);
    }

    /**
     * Scope for open disputes
     */
    public function scopeOpen(Builder $query): Builder
    {
        return $query->where('status', 'open');
    }

    /**
     * Scope for in review disputes
     */
    public function scopeInReview(Builder $query): Builder
    {
        return $query->where('status', 'in_review');
    }

    /**
     * Scope for resolved disputes
     */
    public function scopeResolved(Builder $query): Builder
    {
        return $query->where('status', 'resolved');
    }

    /**
     * Update dispute status
     */
    public function updateStatus(string $status, ?string $resolution = null): bool
    {
        $this->status = $status;
        
        if ($status === 'resolved' || $status === 'declined') {
            $this->resolution = $resolution;
            $this->resolved_at = now();
        }
        
        return $this->save();
    }
}
