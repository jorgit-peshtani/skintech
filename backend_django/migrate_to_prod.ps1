$ErrorActionPreference = "Stop"

Write-Host "🚀 SkinTech Data Migration Tool" -ForegroundColor Cyan
Write-Host "This script will connect your LOCAL computer to the REMOTE Railway Database."
Write-Host "It will then run the migration and seeding scripts to fix the empty database."
Write-Host "---------------------------------------------------"

# 1. Ask for the Railway URL
$railwayUrl = Read-Host "👉 Paste your Railway PostgreSQL URL (from Railway -> Connect -> Public Networking URL)"

if ([string]::IsNullOrWhiteSpace($railwayUrl)) {
    Write-Host "❌ Error: access URL is required!" -ForegroundColor Red
    exit 1
}

# 2. Set the Environment Variable for this session
$env:DATABASE_URL = $railwayUrl
Write-Host "`n✅ Connected to Remote Database!" -ForegroundColor Green

# 3. Migrate Schema
Write-Host "`n📦 1/3 Running Migrations (Creating Tables)..."
python manage.py migrate

# 4. Import Products
Write-Host "`n🛍️  2/3 Importing Products..."
python import_oscar_products.py

# 5. Create Admin
Write-Host "`n👤 3/3 Creating Admin User..."
python create_admin.py

Write-Host "`n---------------------------------------------------"
Write-Host "🎉 MIGRATION COMPLETE!" -ForegroundColor Green
Write-Host "Your live website (Render) should now show all products and allow login."
Write-Host "Go to: https://skintech.onrender.com"
Read-Host "Press Enter to exit..."
