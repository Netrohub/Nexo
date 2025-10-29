# PowerShell script to seed Render database
# Usage: .\run-seed.ps1

Write-Host "🌱 NXOLand Render Database Seeder" -ForegroundColor Cyan
Write-Host ""

# Check if DATABASE_URL is provided
if (-not $env:DATABASE_URL) {
    Write-Host "⚠️  DATABASE_URL environment variable not found!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please get your Render database connection string:" -ForegroundColor White
    Write-Host "1. Go to: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a" -ForegroundColor Gray
    Write-Host "2. Click 'Connections' tab" -ForegroundColor Gray
    Write-Host "3. Copy the 'Internal Connection String'" -ForegroundColor Gray
    Write-Host ""
    $dbUrl = Read-Host "Paste your DATABASE_URL here (or press Enter to exit)"
    
    if ([string]::IsNullOrWhiteSpace($dbUrl)) {
        Write-Host "❌ No DATABASE_URL provided. Exiting." -ForegroundColor Red
        exit 1
    }
    
    $env:DATABASE_URL = $dbUrl
}

Write-Host "✅ DATABASE_URL found" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Checking dependencies..." -ForegroundColor Cyan

# Navigate to backend directory
$backendPath = Join-Path $PSScriptRoot "nxoland-backend"
if (-not (Test-Path $backendPath)) {
    Write-Host "❌ nxoland-backend directory not found!" -ForegroundColor Red
    exit 1
}

Set-Location $backendPath

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "📥 Installing dependencies..." -ForegroundColor Yellow
    npm install
}

# Check if Prisma is installed
if (-not (Get-Command "npx" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npx not found. Please install Node.js and npm." -ForegroundColor Red
    exit 1
}

Write-Host "🔧 Generating Prisma client..." -ForegroundColor Cyan
npx prisma generate

Write-Host ""
Write-Host "🌱 Starting database seeding..." -ForegroundColor Cyan
Write-Host ""

# Run the seed script
npx ts-node prisma/seed.ts

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 Seeding completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📧 Test Accounts:" -ForegroundColor Cyan
    Write-Host "  Admin: admin@nxoland.com / Password123!" -ForegroundColor White
    Write-Host "  Seller: seller1@nxoland.com / Password123!" -ForegroundColor White
    Write-Host "  User: user1@nxoland.com / Password123!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Seeding failed! Check the error above." -ForegroundColor Red
    exit 1
}

