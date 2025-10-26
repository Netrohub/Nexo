#!/bin/bash

# NXOLand Project Cleanup Script
# This script removes redundant, outdated, and temporary files

set -e

echo "🧹 Starting NXOLand Project Cleanup..."
echo ""

# 1. Remove redundant deployment scripts
echo "📋 Removing redundant deployment scripts..."
rm -f upload-backend-to-ploi.sh
rm -f upload-backend-to-ploi.bat
rm -f upload-complete-backend.sh
rm -f troubleshoot-backend.sh
rm -f backend-deploy-complete.sh
rm -f backend-deploy-script.sh
rm -f backend-deploy.zip
rm -f deploy-backend.sh
rm -f deploy-both.sh
rm -f deploy-frontend-fixed.sh
rm -f deploy-frontend-ready.bat
rm -f deploy-frontend-simple.bat
rm -f deploy-frontend-windows.bat
rm -f deploy-frontend-ploi.bat
rm -f deploy-frontend-ploi.sh
rm -f deploy-frontend.sh
rm -f deploy-with-ploi-webhook.sh
rm -f ploi-deploy.sh
rm -f ploi-deploy-simple.sh
rm -f ploi-deploy-with-env.sh
rm -f ploi-deploy-script-final.sh
rm -f ploi-deploy-script-fixed.sh
rm -f ploi-deploy-script-final-fixed.sh
rm -f ploi-backend-deploy.sh
rm -f quick-deploy.sh
rm -f hostinger-deploy.sh
rm -f fix-ploi-permissions.sh
rm -f create-backend-zip.bat
rm -f create-backend-zip.sh
rm -f prepare-for-ploi.bat
rm -f test-ploi-webhook.bat
echo "✅ Removed redundant deployment scripts"

# 2. Remove redundant configuration files
echo "📋 Removing redundant configuration files..."
rm -f ploi.yml
rm -f ploi-frontend.yml
rm -f ploi-simple.yml
echo "✅ Removed redundant configuration files"

# 3. Remove redundant documentation
echo "📋 Removing redundant documentation..."
rm -f COMPREHENSIVE_AUDIT_REPORT.md
rm -f DEPLOY_MEMBERS_ENDPOINT_FIX.md
rm -f FRONTEND_FIXES_COMPLETE.md
rm -f FRONTEND_API_FIX_COMPLETE.md
rm -f FRONTEND_BACKEND_CONNECTION_FIX.md
rm -f DEPLOYMENT_READY.md
rm -f DNS_CONFIGURATION_GUIDE.md
rm -f COMPLETE_SOLUTION_SUMMARY.md
rm -f DEPLOYMENT_GUIDE.md
rm -f BACKEND_PLOI_DEPLOYMENT.md
rm -f BACKEND_UPLOAD_INSTRUCTIONS.md
rm -f KYC_VERIFICATION_FIX.md
rm -f MANUAL_PLOI_UPLOAD_GUIDE.md
rm -f PLOI_DEPLOYMENT.md
rm -f PLOI_FIXED_DEPLOYMENT.md
rm -f PLOI_FRONTEND_DEPLOYMENT.md
rm -f PLOI_DEPLOYMENT_STEPS.md
rm -f PROJECT_SPLIT_SUMMARY.md
rm -f SAFE_REQUEST_HELPER_IMPLEMENTATION.md
rm -f SEPARATE_DEPLOYMENT_GUIDE.md
echo "✅ Removed redundant documentation"

# 4. Remove test/temporary files
echo "📋 Removing test/temporary files..."
rm -f test-api-connection.html
rm -f update-api-calls.js
rm -f debug-frontend-api.js
rm -f build-frontend-production.sh
echo "✅ Removed test/temporary files"

# 5. Remove unused directories (with confirmation)
echo "📋 Checking unused directories..."
if [ -d "laravel-backend" ]; then
    echo "⚠️  Found 'laravel-backend' directory - removing"
    rm -rf laravel-backend
fi
if [ -d "backend" ]; then
    echo "⚠️  Found 'backend' directory - removing"
    rm -rf backend
fi
if [ -d "api-files" ]; then
    echo "⚠️  Found 'api-files' directory - removing"
    rm -rf api-files
fi
echo "✅ Cleaned up unused directories"

# 6. Clean up backend subdirectory
echo "📋 Cleaning up backend subdirectory..."
if [ -d "nxoland-backend" ]; then
    cd nxoland-backend
    
    # Remove redundant deploy scripts
    rm -f deploy-name-fix.sh
    rm -f deploy-complete-fix.sh
    rm -f deploy-fixed.sh
    rm -f deploy-nest-fixed.sh
    rm -f upload-changes.sh
    rm -f fix-cart-and-usernames.sh
    rm -f complete-name-fix.md
    rm -f fix-env-and-deploy.sh
    rm -f fix-env-config.sh
    rm -f deploy-admin-endpoints.sh
    rm -f deploy-complete-fix.sh
    rm -f deploy-cors-fix-robust.sh
    rm -f deploy-cors-fix.sh
    rm -f deploy-members-endpoint.sh
    rm -f deploy-name-fix.sh
    rm -f deploy-nest-fixed.sh
    rm -f deploy-without-db-fix.sh
    rm -f deploy-username-fix.ps1
    rm -f deploy-username-fix.sh
    rm -f emergency-fix.sh
    rm -f fix-cart-and-usernames.sh
    rm -f setup-env.sh
    rm -f troubleshoot-email.sh
    rm -f upload-changes.sh
    
    # Remove old SQL files
    rm -f fix-undefined-names.sql
    rm -f fix-undefined-usernames.sql
    
    cd ..
    echo "✅ Cleaned up backend subdirectory"
fi

echo ""
echo "🎉 Cleanup complete!"
echo ""
echo "Summary:"
echo "- Removed redundant deployment scripts"
echo "- Removed redundant configuration files"
echo "- Removed redundant documentation"
echo "- Removed test/temporary files"
echo "- Cleaned up unused directories"
echo ""
echo "Next steps:"
echo "1. Review the changes: git status"
echo "2. Commit the cleanup: git add -A && git commit -m 'chore: Clean up redundant files'"
echo "3. Push the changes: git push origin main"
