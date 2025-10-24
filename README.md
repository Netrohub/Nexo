# NXOLand - Split Project Structure

This project has been split into two independent parts for better deployment and maintenance.

## Project Structure

```
/frontend          # React + Vite frontend
├── src/           # React components and pages
├── public/        # Static assets
├── dist/          # Production build output (after npm run build)
├── package.json   # Frontend dependencies
├── vite.config.ts # Vite configuration
└── .env           # Environment variables

/backend           # PHP backend API
├── public/        # Web root (upload to /public_html/api on Hostinger)
│   ├── index.php  # Entry point
│   └── .htaccess  # URL rewriting
├── src/           # PHP source code
│   └── Controllers/ # API controllers
├── vendor/        # Composer dependencies
├── composer.json  # PHP dependencies
└── .env           # Environment variables
```

## Deployment

### Frontend (nxoland.com)
1. Run `npm run build` in the `/frontend` directory
2. Upload contents of `/frontend/dist/` to `/public_html/` on Hostinger

### Backend (api.nxoland.com)
1. Run `composer install` in the `/backend` directory
2. Upload entire `/backend/` folder to `/public_html/api/` on Hostinger

## Development

### Frontend
```bash
cd frontend
npm install
npm run dev
```

### Backend
```bash
cd backend
composer install
# Test with: curl https://api.nxoland.com/api/ping
```

## Environment Variables

### Frontend (.env)
```
VITE_API_BASE_URL=https://api.nxoland.com
VITE_COMING_SOON_MODE=false
```

### Backend (.env)
```
APP_NAME=NXOLand API
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.nxoland.com
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret_key_here
JWT_ALGORITHM=HS256
```

## API Endpoints

The backend provides the following endpoints:

- `GET /api/ping` - Health check
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/me` - Get current user
- `GET /api/products` - List products
- `GET /api/products/{id}` - Get product details
- `GET /api/cart` - Get cart items
- `GET /api/orders` - List orders
- `GET /api/wishlist` - Get wishlist
- `GET /api/disputes` - List disputes
- `GET /api/seller/dashboard` - Seller dashboard
- `GET /api/admin/users` - Admin users list
- `GET /api/members` - Members list

All endpoints return JSON responses with the following format:
```json
{
  "status": "success|error",
  "message": "Description",
  "data": {}
}
```
