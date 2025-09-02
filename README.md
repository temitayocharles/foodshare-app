# FoodShare - Reducing Food Waste

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)](https://www.postgresql.org/)
[![React](https://img.shields.io/badge/React-18+-61dafb.svg)](https://reactjs.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ed.svg)](https://www.docker.com/)

> Connecting restaurants with leftover food to communities in need, reducing food waste and fighting hunger.

## 🌟 Overview

FoodShare is a comprehensive platform that connects restaurants, grocery stores, and food donors with local communities and organizations in need. Our mission is to reduce food waste while addressing food insecurity through technology-driven solutions.

### 🎯 Key Features

- **Real-time Food Listings**: Restaurants can post available surplus food instantly
- **Smart Matching**: AI-powered matching between donors and recipients
- **Quality Assurance**: Built-in quality checks and safety protocols
- **Community Impact**: Track environmental and social impact metrics
- **Mobile-First Design**: Responsive web application accessible on all devices
- **Multi-language Support**: Available in multiple languages for diverse communities

## 🏗️ Architecture

### System Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React Frontend│    │   Nginx Proxy   │    │ Node.js Backend │
│                 │◄──►│                 │◄──►│                 │
│ - Food Listings │    │ - API Gateway   │    │ - REST API      │
│ - Donor Portal  │    │ - Load Balancer │    │ - Auth Service  │
│ - Admin Dashboard│   │ - SSL Termination│   │ - Business Logic│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 ▼
                    ┌─────────────────┐
                    │  PostgreSQL DB  │
                    │                 │
                    │ - Food Listings │
                    │ - User Accounts │
                    │ - Transactions  │
                    │ - Analytics     │
                    └─────────────────┘
```

### Technology Stack

#### Frontend
- **React 18** - Modern JavaScript library for building user interfaces
- **Material-UI** - React components implementing Google's Material Design
- **Axios** - HTTP client for API communication
- **React Router** - Declarative routing for React applications

#### Backend
- **Node.js 16+** - JavaScript runtime built on Chrome's V8 engine
- **Express.js** - Fast, unopinionated web framework for Node.js
- **PostgreSQL** - Advanced open-source relational database
- **JWT** - JSON Web Tokens for authentication
- **bcrypt** - Password hashing library

#### Infrastructure
- **Docker** - Containerization platform
- **Kubernetes** - Container orchestration system
- **nginx** - High-performance HTTP server and reverse proxy
- **PostgreSQL** - Primary database
- **Redis** - Caching and session storage

## 🚀 Quick Start

### Prerequisites

- **Node.js** 16 or higher
- **PostgreSQL** 13 or higher
- **Docker** (optional, for containerized deployment)
- **Kubernetes** (optional, for production deployment)

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/temitayocharles/foodshare-app.git
   cd foodshare-app
   ```

2. **Database Setup**
   ```bash
   # Create PostgreSQL database
   createdb foodshare

   # Set up database schema
   psql -d foodshare -f database/schema.sql
   ```

3. **Backend Setup**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Edit .env with your database credentials
   npm run dev
   ```

4. **Frontend Setup**
   ```bash
   cd frontend
   npm install
   npm start
   ```

5. **Access the Application**
   - Frontend: http://localhost:3000
   - API Documentation: http://localhost:3001/docs

### Docker Deployment

```bash
# Build and run with Docker Compose
docker-compose up -d

# Or build individual services
docker build -t foodshare-backend ./backend
docker build -t foodshare-frontend ./frontend
```

### Kubernetes Deployment

```bash
# Deploy to Kubernetes cluster
kubectl apply -f k8s/

# Check deployment status
kubectl get pods
kubectl get services
```

## 📁 Project Structure

```
foodshare-app/
├── backend/                    # Node.js/Express backend
│   ├── src/
│   │   ├── controllers/       # Route controllers
│   │   ├── models/           # Database models
│   │   ├── middleware/       # Custom middleware
│   │   ├── routes/           # API routes
│   │   ├── services/         # Business logic services
│   │   └── utils/            # Utility functions
│   ├── tests/                # Backend tests
│   ├── Dockerfile
│   └── package.json
├── frontend/                  # React frontend
│   ├── public/
│   ├── src/
│   │   ├── components/       # React components
│   │   ├── pages/           # Page components
│   │   ├── services/        # API services
│   │   ├── utils/           # Utility functions
│   │   └── styles/          # CSS styles
│   ├── tests/               # Frontend tests
│   ├── Dockerfile
│   └── package.json
├── database/                 # Database files
│   ├── migrations/          # Database migrations
│   ├── seeds/              # Seed data
│   └── schema.sql          # Database schema
├── k8s/                     # Kubernetes manifests
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   ├── database-deployment.yaml
│   └── services.yaml
├── docs/                    # Documentation
│   ├── api/                # API documentation
│   ├── deployment/         # Deployment guides
│   └── development/        # Development guides
├── docker-compose.yml      # Docker Compose configuration
├── .env.example           # Environment variables template
└── README.md              # This file
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the backend directory:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=foodshare
DB_USER=foodadmin
DB_PASSWORD=your_secure_password

# JWT Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3001
NODE_ENV=development

# External Services
REDIS_URL=redis://localhost:6379
```

### Database Schema

The application uses the following main tables:

- **users** - User accounts (donors, recipients, admins)
- **food_listings** - Available food items
- **food_claims** - Claimed food items
- **organizations** - Partner organizations
- **analytics** - Usage and impact metrics

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
npm run test:coverage
```

### Frontend Tests
```bash
cd frontend
npm test
npm run test:e2e
```

### Integration Tests
```bash
npm run test:integration
```

## 📚 API Documentation

### Authentication Endpoints

```
POST /api/auth/register     # User registration
POST /api/auth/login        # User login
POST /api/auth/logout       # User logout
GET  /api/auth/profile      # Get user profile
```

### Food Listings Endpoints

```
GET    /api/food            # Get all food listings
POST   /api/food            # Create new food listing
GET    /api/food/:id        # Get specific food listing
PUT    /api/food/:id        # Update food listing
DELETE /api/food/:id        # Delete food listing
POST   /api/food/:id/claim  # Claim food listing
```

### User Management Endpoints

```
GET    /api/users           # Get all users (admin only)
GET    /api/users/:id       # Get user details
PUT    /api/users/:id       # Update user profile
DELETE /api/users/:id       # Delete user (admin only)
```

## 🚀 Deployment

### Production Deployment Checklist

- [ ] Environment variables configured
- [ ] Database backups configured
- [ ] SSL certificates installed
- [ ] Monitoring and logging set up
- [ ] Load balancer configured
- [ ] CDN configured for static assets
- [ ] Security headers configured

### Scaling Considerations

- **Horizontal Scaling**: Multiple backend instances behind load balancer
- **Database Scaling**: Read replicas for high-traffic queries
- **Caching**: Redis for session and API response caching
- **CDN**: Static asset delivery optimization

## 🔒 Security

### Authentication & Authorization
- JWT-based authentication
- Role-based access control (RBAC)
- Password hashing with bcrypt
- Session management

### Data Protection
- Input validation and sanitization
- SQL injection prevention
- XSS protection
- CSRF protection
- HTTPS enforcement

### Infrastructure Security
- Container security scanning
- Network segmentation
- Regular security updates
- Access logging and monitoring

## 📊 Monitoring & Analytics

### Application Metrics
- Response times and throughput
- Error rates and types
- User engagement metrics
- Food waste reduction metrics

### Infrastructure Monitoring
- Server resource utilization
- Database performance
- Network traffic analysis
- Security incident detection

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code Standards
- ESLint for JavaScript/React code
- Prettier for code formatting
- Husky for git hooks
- Commit message conventions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Local restaurants and food donors
- Community organizations and food banks
- Open source contributors
- Environmental and social impact partners

## 📞 Support

- **Documentation**: [docs.foodshare.app](https://docs.foodshare.app)
- **Issues**: [GitHub Issues](https://github.com/temitayocharles/foodshare-app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/temitayocharles/foodshare-app/discussions)
- **Email**: support@foodshare.app

---

**FoodShare** - Making a difference, one meal at a time. 🍽️✨</content>
<parameter name="filePath">/Volumes/256-B/tc-enterprise-devops-platform/FOODSHARE-README.md
