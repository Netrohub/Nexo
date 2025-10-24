#!/bin/bash

# Create .env file for NXOLand Backend
# This script should be run on the Ploi server

echo "📝 Creating .env file for NXOLand Backend..."

# Change to the project directory
cd /home/ploi/api.nxoland.com

# Check if .env already exists
if [ -f ".env" ]; then
    echo "✅ .env file already exists"
    echo "📋 Current .env contents:"
    cat .env
else
    echo "📝 Creating new .env file..."
    
    # Create .env file with proper content
    cat > .env << 'EOF'
APP_NAME=NXOLand API
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.nxoland.com

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=your_username
DB_PASSWORD=your_password

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_here
JWT_ALGORITHM=HS256

# CORS Configuration
CORS_ALLOWED_ORIGINS=https://nxoland.com,https://www.nxoland.com

# API Configuration
API_VERSION=v1
API_PREFIX=api
EOF

    # Set proper permissions
    chmod 644 .env
    
    echo "✅ .env file created successfully"
    echo "📋 .env file contents:"
    cat .env
fi

echo "🎉 .env file is ready!"
