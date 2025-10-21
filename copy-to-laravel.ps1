# ============================================
# Copy NXOLand Backend Files to Laravel Project
# ============================================
# PowerShell script to copy migrations, models, and seeders

param(
    [Parameter(Mandatory=$true)]
    [string]$LaravelPath
)

Write-Host "🚀 NXOLand Backend File Copy Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Laravel path exists
if (-not (Test-Path $LaravelPath)) {
    Write-Host "❌ Error: Laravel project not found at: $LaravelPath" -ForegroundColor Red
    Write-Host "Please provide a valid Laravel project path." -ForegroundColor Yellow
    exit 1
}

# Verify it's a Laravel project
if (-not (Test-Path "$LaravelPath/artisan")) {
    Write-Host "❌ Error: Not a valid Laravel project (artisan file not found)" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found Laravel project at: $LaravelPath" -ForegroundColor Green
Write-Host ""

# Create directories if they don't exist
$directories = @(
    "$LaravelPath/database/migrations",
    "$LaravelPath/app/Models",
    "$LaravelPath/database/seeders"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "📁 Created directory: $dir" -ForegroundColor Yellow
    }
}

Write-Host ""

# Copy migrations
Write-Host "📦 Copying migration files..." -ForegroundColor Cyan
$migrationFiles = Get-ChildItem -Path ".\laravel-backend\migrations\*.php"
foreach ($file in $migrationFiles) {
    Copy-Item -Path $file.FullName -Destination "$LaravelPath\database\migrations\" -Force
    Write-Host "  ✅ Copied: $($file.Name)" -ForegroundColor Green
}

# Copy models
Write-Host ""
Write-Host "📦 Copying model files..." -ForegroundColor Cyan
$modelFiles = Get-ChildItem -Path ".\laravel-backend\models\*.php"
foreach ($file in $modelFiles) {
    Copy-Item -Path $file.FullName -Destination "$LaravelPath\app\Models\" -Force
    Write-Host "  ✅ Copied: $($file.Name)" -ForegroundColor Green
}

# Copy seeders
Write-Host ""
Write-Host "📦 Copying seeder files..." -ForegroundColor Cyan
$seederFiles = Get-ChildItem -Path ".\laravel-backend\seeders\*.php"
foreach ($file in $seederFiles) {
    Copy-Item -Path $file.FullName -Destination "$LaravelPath\database\seeders\" -Force
    Write-Host "  ✅ Copied: $($file.Name)" -ForegroundColor Green
}

# Summary
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "✅ All files copied successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  • Migration files: $($migrationFiles.Count)" -ForegroundColor White
Write-Host "  • Model files: $($modelFiles.Count)" -ForegroundColor White
Write-Host "  • Seeder files: $($seederFiles.Count)" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Yellow
Write-Host "  1. Update Laravel .env: DB_DATABASE=nxoland" -ForegroundColor White
Write-Host "  2. Create database: mysql -u root -p < laravel-backend/setup-mysql.sql" -ForegroundColor White
Write-Host "  3. Run migrations: php artisan migrate" -ForegroundColor White
Write-Host "  4. Seed database: php artisan db:seed" -ForegroundColor White
Write-Host ""
Write-Host "📁 Files copied to:" -ForegroundColor Cyan
Write-Host "  • $LaravelPath\database\migrations\" -ForegroundColor White
Write-Host "  • $LaravelPath\app\Models\" -ForegroundColor White
Write-Host "  • $LaravelPath\database\seeders\" -ForegroundColor White
Write-Host ""
Write-Host "🎉 Ready to migrate!" -ForegroundColor Green

# ============================================
# Usage:
# .\copy-to-laravel.ps1 -LaravelPath "C:\path\to\your\laravel-project"
# ============================================
