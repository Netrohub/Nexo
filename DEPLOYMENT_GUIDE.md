# NXOLand Deployment Guide

## Project Structure

The project has been split into two independent parts:

```
/frontend          # React + Vite frontend
/backend           # PHP backend API
```

## Frontend Deployment (nxoland.com)

### 1. Build the Frontend
```bash
cd frontend
npm install
npm run build
```

### 2. Upload to Hostinger
- Upload all contents from `/frontend/dist/` to `/public_html/` on Hostinger
- The main domain (nxoland.com) will serve the static files

### 3. Environment Variables
The frontend uses these environment variables:
- `VITE_API_BASE_URL=https://api.nxoland.com` (points to backend)
- `VITE_COMING_SOON_MODE=false` (set to true for maintenance mode)

## Backend Deployment (api.nxoland.com)

### 1. Install Dependencies
```bash
cd backend
composer install
```

### 2. Configure Environment
Update `/backend/.env` with your database credentials:
```
DB_HOST=your_host
DB_DATABASE=your_database
DB_USERNAME=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_secret_key
```

### 3. Upload to Hostinger
- Upload the entire `/backend/` folder to `/public_html/api/` on Hostinger
- The subdomain (api.nxoland.com) will serve the PHP API

### 4. Test the API
After deployment, test the API:
```bash
curl https://api.nxoland.com/api/ping
```
Should return: `{"ok": true}`

## DNS Configuration

Make sure your DNS is configured:
- `nxoland.com` → points to main hosting (frontend)
- `api.nxoland.com` → points to same hosting with `/api/` subdirectory

## Development Commands

### Frontend Development
```bash
cd frontend
npm run dev          # Start development server
npm run build         # Build for production
npm run preview       # Preview production build
```

### Backend Development
```bash
cd backend
composer install      # Install dependencies
# Test endpoints with curl or Postman
```

## API Endpoints

The backend provides these endpoints:

### Health Check
- `GET /api/ping` - Returns `{"ok": true}`

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - User logout

### Products
- `GET /api/products` - List products
- `GET /api/products/{id}` - Get product details
- `POST /api/products` - Create product (seller)
- `PUT /api/products/{id}` - Update product (seller)
- `DELETE /api/products/{id}` - Delete product (seller)

### Cart & Orders
- `GET /api/cart` - Get cart items
- `POST /api/cart` - Add to cart
- `PUT /api/cart/{id}` - Update cart item
- `DELETE /api/cart/{id}` - Remove from cart
- `GET /api/orders` - List orders
- `GET /api/orders/{id}` - Get order details
- `POST /api/orders` - Create order

### Wishlist
- `GET /api/wishlist` - Get wishlist
- `POST /api/wishlist` - Add to wishlist
- `DELETE /api/wishlist/{id}` - Remove from wishlist

### Disputes
- `GET /api/disputes` - List disputes
- `GET /api/disputes/{id}` - Get dispute details
- `POST /api/disputes` - Create dispute

### Seller
- `GET /api/seller/dashboard` - Seller dashboard
- `GET /api/seller/products` - Seller products
- `GET /api/seller/orders` - Seller orders

### Admin
- `GET /api/admin/users` - Admin users list
- `GET /api/admin/orders` - Admin orders list
- `GET /api/admin/disputes` - Admin disputes list

### Members
- `GET /api/members` - Members list

## Troubleshooting

### Frontend Issues
- Check that `VITE_API_BASE_URL` is correctly set
- Ensure all static assets are uploaded to `/public_html/`
- Check browser console for API connection errors

### Backend Issues
- Verify PHP version is 8.0 or higher
- Check that Composer dependencies are installed
- Ensure `.htaccess` is uploaded and working
- Test with `curl https://api.nxoland.com/api/ping`

### CORS Issues
- The backend includes CORS headers for cross-origin requests
- If you encounter CORS issues, check the headers in `/backend/public/index.php`

## Security Notes

- Update JWT_SECRET in backend/.env
- Use HTTPS for both frontend and backend
- Configure proper database credentials
- Set up proper file permissions on the server
