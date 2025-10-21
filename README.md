# NXOLand - Nebula Marketplace Frontend

A production-ready React/Vite/Tailwind/shadcn UI marketplace frontend integrated with Laravel backend APIs.

## 🚀 Features

- **Stellar Dark Theme** - Complete glassmorphism design system with cosmic animations
- **RTL Support** - Full Arabic language support with proper text direction
- **Authentication** - Complete auth flow with JWT tokens and role-based access
- **API Integration** - Fully wired to Laravel backend with React Query caching
- **Form Validation** - React Hook Form + Zod validation throughout
- **Responsive Design** - Mobile-first design with Tailwind CSS
- **Type Safety** - Full TypeScript implementation

## 🛠 Tech Stack

- **Frontend**: React 18, TypeScript, Vite 5
- **Styling**: Tailwind CSS 3, shadcn/ui, Radix UI
- **State Management**: React Query (TanStack Query)
- **Forms**: React Hook Form + Zod validation
- **Routing**: React Router v6
- **Icons**: Lucide React
- **Animations**: Custom CSS animations + Framer Motion ready

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd NXOLand
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Setup**
   Create a `.env` file in the root directory:
   ```env
   # API Configuration
   VITE_API_BASE_URL=http://localhost:8000/api
   VITE_APP_NAME=NetroHub
   
   # Development
   VITE_APP_ENV=development
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

## 🏗 Project Structure

```
src/
├── components/           # Reusable UI components
│   ├── ui/              # shadcn/ui components
│   ├── Navbar.tsx       # Navigation with auth integration
│   ├── RequireAuth.tsx  # Authentication guard
│   └── ...
├── contexts/            # React contexts
│   ├── AuthContext.tsx  # Authentication state
│   └── LanguageContext.tsx # i18n context
├── hooks/               # Custom React hooks
│   └── useApi.ts        # API integration hooks
├── lib/                 # Utilities and configurations
│   ├── api.ts           # API client and types
│   └── utils.ts         # Helper functions
├── pages/               # Page components
│   ├── account/         # User account pages
│   ├── seller/          # Seller dashboard pages
│   ├── disputes/        # Dispute management pages
│   └── ...
└── App.tsx              # Main app component with routing
```

## 🔐 Authentication

The app uses JWT-based authentication with the following features:

- **Login/Register** - Full form validation with error handling
- **Protected Routes** - Role-based access control (customer, seller, admin)
- **Token Management** - Automatic token refresh and logout
- **User Context** - Global user state management

### Auth Flow

1. User logs in via `/login` or registers via `/register`
2. JWT token is stored in localStorage
3. `AuthContext` manages authentication state
4. `RequireAuth` component protects routes
5. API client automatically includes token in requests

## 🌐 API Integration

### API Client (`src/lib/api.ts`)

- **Typed API calls** - Full TypeScript support
- **Error handling** - Consistent error responses
- **Token management** - Automatic auth header injection
- **Base URL configuration** - Environment-based API endpoints

### React Query Hooks (`src/hooks/useApi.ts`)

- **Caching** - Automatic data caching and invalidation
- **Loading states** - Built-in loading and error states
- **Optimistic updates** - Immediate UI updates
- **Background refetching** - Automatic data synchronization

### Available Endpoints

#### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user
- `POST /api/auth/verify-phone` - Phone verification
- `POST /api/auth/kyc` - KYC submission

#### Products
- `GET /api/products` - List products with filters
- `GET /api/products/:id` - Get product details
- `GET /api/products?featured=true` - Get featured products

#### Cart & Orders
- `GET /api/cart` - Get user cart
- `POST /api/cart` - Add to cart
- `PUT /api/cart/:id` - Update cart item
- `DELETE /api/cart/:id` - Remove from cart
- `POST /api/orders` - Create order
- `GET /api/orders` - List user orders

#### Seller
- `GET /api/seller/dashboard-metrics` - Seller dashboard data
- `GET /api/seller/products` - Seller's products
- `POST /api/seller/products` - Create product
- `PUT /api/seller/products/:id` - Update product
- `DELETE /api/seller/products/:id` - Delete product
- `GET /api/seller/orders` - Seller orders
- `GET /api/seller/payouts` - Seller payouts

#### Disputes
- `GET /api/disputes` - User disputes
- `POST /api/disputes` - Create dispute
- `GET /api/disputes/:id` - Dispute details
- `POST /api/disputes/:id/messages` - Add message
- `POST /api/disputes/:id/evidence` - Upload evidence
- `GET /api/admin/disputes` - Admin dispute list
- `PUT /api/admin/disputes/:id` - Update dispute status

## 🎨 Design System

### Theme Configuration

The app uses a custom "Stellar Dark Theme" with:

- **Color Palette** - HSL-based color system
- **Glassmorphism** - Backdrop blur effects
- **Gradients** - Cosmic gradient backgrounds
- **Animations** - Smooth transitions and hover effects
- **Typography** - Inter + Poppins font stack

### Key CSS Classes

```css
.glass-card          /* Glassmorphism container */
.btn-glow           /* Glowing button effect */
.gradient-primary   /* Primary gradient background */
.card-hover         /* Card hover animations */
```

### RTL Support

- **Language switching** - English ↔ Arabic
- **Direction handling** - Automatic `dir` attribute
- **Layout flipping** - Proper RTL layout support
- **Emoji handling** - Correct emoji positioning in RTL

## 📱 Responsive Design

- **Mobile-first** - Optimized for mobile devices
- **Breakpoints** - sm, md, lg, xl, 2xl
- **Flexible layouts** - CSS Grid and Flexbox
- **Touch-friendly** - Proper touch targets

## 🔧 Development

### Available Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint
```

### Code Quality

- **ESLint** - Code linting with TypeScript support
- **TypeScript** - Full type safety
- **Prettier** - Code formatting (recommended)

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `VITE_API_BASE_URL` | Laravel API base URL | `http://localhost:8000/api` |
| `VITE_APP_NAME` | Application name | `NetroHub` |
| `VITE_APP_ENV` | Environment | `development` |

## 🚀 Deployment

### Build Process

1. **Build the app**
   ```bash
   npm run build
   ```

2. **Deploy the `dist/` folder** to your hosting provider

### Laravel Integration

For Laravel integration, ensure:

1. **CORS Configuration** - Allow your frontend domain
2. **API Routes** - All endpoints are properly defined
3. **Authentication** - Sanctum or JWT is configured
4. **File Uploads** - Proper handling for product images

### Environment Setup

Update your `.env` file for production:

```env
VITE_API_BASE_URL=https://your-laravel-domain.com/api
VITE_APP_NAME=NetroHub
VITE_APP_ENV=production
```

## 🧪 Testing

The app is ready for testing with:

- **Manual Testing** - All major user flows
- **API Integration** - Real backend connectivity
- **Responsive Testing** - Multiple device sizes
- **RTL Testing** - Arabic language support

## 📋 TODO / Future Enhancements

- [ ] Unit tests with React Testing Library
- [ ] E2E tests with Playwright
- [ ] Performance optimization
- [ ] PWA features
- [ ] Advanced animations
- [ ] Real-time notifications
- [ ] Advanced search filters

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:

- Check the documentation
- Review the code comments
- Open an issue on GitHub
- Contact the development team

---

**Built with ❤️ for the gaming community**