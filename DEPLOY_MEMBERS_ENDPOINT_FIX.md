# Deploy Members Endpoint Fix

## Problem
The `/api/users/members` endpoint was returning a 404 error because it was protected by authentication guards and didn't have the `@Public()` decorator.

## Solution
Added the `@Public()` decorator to the members endpoint in `src/users/public-users.controller.ts`.

## Deployment Steps

### Option 1: Using Ploi Panel
1. Log in to your Ploi panel at https://ploi.io
2. Go to your server and find the "api.nxoland.com" site
3. Click on "Deploy" or "Deployments"
4. Click "Deploy Now" to pull the latest code and restart the backend

### Option 2: Using SSH
SSH into your server and run:

```bash
# Navigate to the backend directory
cd /home/ploi/api.nxoland.com

# Pull the latest changes
git pull origin master

# Build the application
npm run build

# Restart the backend with PM2
pm2 restart nxoland-backend

# Check the status
pm2 status

# Test the endpoint
curl http://localhost:3000/api/users/members
```

### Option 3: Using the Deployment Script
If you have SSH access, you can also run:

```bash
cd /home/ploi/api.nxoland.com
chmod +x deploy-members-endpoint.sh
./deploy-members-endpoint.sh
```

## Verification

After deployment, test the endpoint:

```bash
# Test locally
curl http://localhost:3000/api/users/members

# Test externally
curl https://api.nxoland.com/api/users/members
```

You should now see a 200 response with user data instead of a 404 error.

## What Was Fixed

**File:** `nxoland-backend/src/users/public-users.controller.ts`

**Change:** Added `@Public()` decorator to the `getMembers()` method:

```typescript
import { Public } from '../auth/decorators';

@Get('members')
@Public()  // ← This allows public access
@ApiOperation({ summary: 'Get all members (public)' })
@ApiResponse({ status: 200, description: 'Members list retrieved' })
async getMembers() {
  return this.usersService.findAll();
}
```

## Expected Behavior

- ✅ The endpoint is now accessible without authentication
- ✅ Returns a 200 status code with member data
- ✅ Frontend should be able to load the members page successfully

## Troubleshooting

If the endpoint still returns 404 after deployment:

1. Check PM2 logs: `pm2 logs nxoland-backend`
2. Restart PM2: `pm2 restart nxoland-backend`
3. Check if the code was pulled: `git log --oneline -5`
4. Verify the build: Check if `dist/users/public-users.controller.js` exists
5. Clear browser cache and try again

## Summary

The fix has been committed and pushed to the `master` branch. You just need to deploy it to your server using one of the methods above.
