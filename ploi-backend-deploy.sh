#!/bin/bash

# Simple Ploi deployment script for NXOLand Backend
# This matches the script you have in your Ploi dashboard

cd /home/ploi/api.nxoland.com

# Install/update Composer dependencies
composer install --no-dev --optimize-autoloader

# Set proper permissions
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php

# Reload PHP-FPM
echo "" | sudo -S service php8.4-fpm reload

echo "Backend API deployed successfully!"
