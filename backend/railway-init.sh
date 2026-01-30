#!/bin/bash
# Railway Deployment Script
# Run this after deploying to Railway to initialize the database

echo "🗄️  Initializing SkinTech Database on Railway..."
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null
then
    echo "❌ Railway CLI not found. Installing..."
    npm i -g @railway/cli
fi

# Login to Railway (if not already logged in)
echo "🔐 Logging into Railway..."
railway login

# Link to your project
echo "🔗 Linking to your Railway project..."
railway link

# Run database initialization
echo "🏗️  Creating database tables..."
railway run python init_db.py

echo ""
echo "✅ Database initialized successfully!"
echo "🎉 Your backend is ready to use!"
