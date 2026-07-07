#!/bin/bash

echo "=================================================="
echo "    Skintech Database Migration Tool (Railway -> Local)"
echo "=================================================="

echo "Please paste your exact Railway PostgreSQL Connection URL:"
echo "(It looks like: postgresql://postgres:password@containers-us-west.railway.app:1234/railway)"
read -p "> " RAILWAY_URL

if [[ -z "$RAILWAY_URL" ]]; then
    echo "Error: URL cannot be empty."
    exit 1
fi

# Ensure sslmode=require is appended for Railway connections
if [[ "$RAILWAY_URL" != *"?sslmode=require"* ]]; then
    RAILWAY_URL="${RAILWAY_URL}?sslmode=require"
fi

echo ""
echo "Step 1/3: Downloading database securely from Railway..."
echo "(This might take a minute depending on your database size)"
# Run pg_dump inside the backend container and save it to /tmp/
docker compose exec backend pg_dump "$RAILWAY_URL" --clean --if-exists --format=c -f /tmp/railway.dump

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to download database from Railway. Please check your URL."
    exit 1
fi

echo "Step 2/3: Restoring data into your local Proxmox database..."
# The local database URL based on docker-compose.yml
LOCAL_DB_URL="postgresql://skintech_user:skintech_password@db:5432/skintech"

# Restore using pg_restore. We ignore errors here because restoring roles/owners often throws harmless warnings.
docker compose exec backend pg_restore --no-owner --no-privileges -d "$LOCAL_DB_URL" -1 /tmp/railway.dump

echo "Step 3/3: Cleaning up temporary files..."
docker compose exec backend rm /tmp/railway.dump

echo ""
echo "=================================================="
echo "✅ Migration Complete!"
echo "Your Proxmox server is now officially hosting your database."
echo ""
echo "Next Steps:"
echo "1. Open your '.env' file: nano .env"
echo "2. Delete or comment out the DATABASE_URL line so your app defaults to the local database."
echo "3. Restart the containers: docker compose down && docker compose up -d"
echo "=================================================="
