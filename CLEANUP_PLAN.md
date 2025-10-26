# Project Cleanup Plan

## Summary
This document outlines the cleanup plan for the NXOLand project to remove redundant, outdated, and temporary files.

## Files to Remove

### 1. Redundant Deployment Scripts (Multiple similar scripts doing the same thing)
- `upload-backend-to-ploi.sh` 
- `upload-backend-to-ploi.bat`
- `upload-complete-backend.sh`
- `troubleshoot-backend.sh`
- `backend-deploy-complete.sh`
- `backend-deploy-script.sh`
- `backend-deploy.zip` (143KB - can be recreated)
- `deploy-backend.sh`
- `deploy-both.sh`
- `deploy-frontend-fixed.sh`
- `deploy-frontend-ready.bat`
- `deploy-frontend-simple.bat`
- `deploy-frontend-windows.bat`
- `deploy-frontend-ploi.bat`
- `deploy-frontend-ploi.sh`
- `deploy-frontend.sh`
- `deploy-with-ploi-webhook.sh`
- `ploi-deploy.sh`
- `ploi-deploy-simple.sh`
- `ploi-deploy-with-env.sh`
- `ploi-deploy-script-final.sh`
- `ploi-deploy-script-fixed.sh`
- `ploi-deploy-script-final-fixed.sh`
- `ploi-backend-deploy.sh`
- `quick-deploy.sh`
- `hostinger-deploy.sh`
- `fix-ploi-permissions.sh`
- `create-backend-zip.bat`
- `create-backend-zip.sh`
- `prepare-for-ploi.bat`
- `test-ploi-webhook.bat`

**Keep:** `cleanup-project.sh` and `cleanup-project.bat` (needed for cleanup)

### 2. Configuration Files (Keep only essential ones)
Delete:
- `ploi.yml`
- `ploi-frontend.yml`
- `ploi-simple.yml`

Keep:
- `env.example`
- `env.production`
- `.gitignore`

### 3. Documentation Files (Consolidate into main README)
Delete redundant documentation:
- `COMPREHENSIVE_AUDIT_REPORT.md`
- `DEPLOY_MEMBERS_ENDPOINT_FIX.md`
- `FRONTEND_FIXES_COMPLETE.md`
- `FRONTEND_API_FIX_COMPLETE.md`
- `FRONTEND_BACKEND_CONNECTION_FIX.md`
- `DEPLOYMENT_READY.md`
- `DNS_CONFIGURATION_GUIDE.md`
- `COMPLETE_SOLUTION_SUMMARY.md`
- `DEPLOYMENT_GUIDE.md`
- `BACKEND_PLOI_DEPLOYMENT.md`
- `BACKEND_UPLOAD_INSTRUCTIONS.md`
- `KYC_VERIFICATION_FIX.md`
- `MANUAL_PLOI_UPLOAD_GUIDE.md`
- `PLOI_DEPLOYMENT.md`
- `PLOI_FIXED_DEPLOYMENT.md`
- `PLOI_FRONTEND_DEPLOYMENT.md`
- `PLOI_DEPLOYMENT_STEPS.md`
- `PROJECT_SPLIT_SUMMARY.md`
- `SAFE_REQUEST_HELPER_IMPLEMENTATION.md`
- `SEPARATE_DEPLOYMENT_GUIDE.md`

Keep:
- `README.md`
- `FIXES_APPLIED.md`
- `COMPREHENSIVE_AUDIT_REPORT.md` (maybe - it's comprehensive)

### 4. Test/Temporary Files
Delete:
- `test-api-connection.html`
- `update-api-calls.js`
- `debug-frontend-api.js`
- `build-frontend-production.sh` (can use standard build commands)

### 5. Unused Directories
- `laravel-backend/` - Should be in deployment-packages only
- `backend/` - Old PHP backend, no longer used
- `api-files/` - Old API files, should be in deployment-packages
- `node_modules/` - Should be in gitignore (already is)
- `deployment-packages/` - Consider if this is still needed

### 6. Backend Subdirectory Cleanup (nxoland-backend/)
Review and remove redundant scripts from `nxoland-backend/`:
- Multiple deploy scripts with similar functions
- Old fix scripts that are no longer relevant

### 7. Create Utilities Script
Create a consolidated deployment script that handles all deployment scenarios instead of having 30+ separate scripts.

## Cleanup Priority

### High Priority (Do First)
1. Remove all redundant deployment scripts
2. Remove old documentation files
3. Remove test/temporary files
4. Remove duplicate configuration files

### Medium Priority
1. Clean up `deployment-packages/` directory
2. Review and consolidate backend deployment scripts
3. Review and clean `laravel-backend/` vs `deployment-packages/`

### Low Priority
1. Create consolidated deployment script
2. Update documentation to reflect cleanup

## Expected Impact
- Reduce project size significantly
- Improve maintainability
- Reduce confusion about which script to use
- Cleaner repository structure

## Rollback Plan
All files are in git history, so can be restored if needed.
