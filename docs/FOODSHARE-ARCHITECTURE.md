# FoodShare Architecture & Technical Documentation

## 🏗️ System Architecture

### High-Level Architecture

FoodShare follows a modern microservices architecture deployed within the TC Enterprise DevOps Platform, utilizing containerization and orchestration for scalability and reliability.

```
┌─────────────────────────────────────────────────────────────┐
│                    TC Enterprise DevOps Platform            │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                 FoodShare Application                   │ │
│  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │ │
│  │  │  React      │    │   Nginx     │    │ Node.js     │  │ │
│  │  │ Frontend    │◄──►│   Proxy     │◄──►│ Backend     │  │ │
│  │  │             │    │             │    │             │  │ │
│  │  └─────────────┘    └─────────────┘    └─────────────┘  │ │
│  │         │                    │                    │     │ │
│  │         └────────────────────┼────────────────────┘     │ │
│  │                              ▼                          │ │
│  │                 ┌─────────────────────┐                 │ │
│  │                 │   PostgreSQL        │                 │ │
│  │                 │   Database          │                 │ │
│  │                 └─────────────────────┘                 │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Component Details

#### 1. Frontend Layer (React)
- **Technology**: React 18 with Material-UI
- **Deployment**: Served by nginx in Kubernetes
- **Features**:
  - Single Page Application (SPA)
  - Responsive design for mobile and desktop
  - Real-time updates using WebSockets
  - Progressive Web App (PWA) capabilities

#### 2. API Gateway (nginx)
- **Role**: Reverse proxy and load balancer
- **Configuration**: ConfigMap-based for easy updates
- **Features**:
  - SSL/TLS termination
  - Rate limiting
  - Request routing to backend services
  - Static asset serving with caching

#### 3. Backend Layer (Node.js/Express)
- **Technology**: Node.js 16+ with Express.js
- **Architecture**: RESTful API design
- **Features**:
  - JWT-based authentication
  - Input validation and sanitization
  - Error handling and logging
  - Database connection pooling

#### 4. Data Layer (PostgreSQL)
- **Technology**: PostgreSQL 13+
- **Features**:
  - ACID compliance
  - JSONB for flexible data storage
  - Full-text search capabilities
  - Connection pooling with pg

## 🔧 Technical Specifications

### Database Schema

#### Core Tables

```sql
-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(50) NOT NULL, -- 'donor', 'recipient', 'admin'
    organization VARCHAR(255),
    phone VARCHAR(50),
    location TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Food listings table
CREATE TABLE food_listings (
    id SERIAL PRIMARY KEY,
    restaurant VARCHAR(255) NOT NULL,
    food_type VARCHAR(255) NOT NULL,
    quantity VARCHAR(255) NOT NULL,
    expiry_date DATE NOT NULL,
    location VARCHAR(255) NOT NULL,
    allergies TEXT,
    donor_id INTEGER REFERENCES users(id),
    status VARCHAR(50) DEFAULT 'available', -- 'available', 'claimed', 'expired'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Food claims table
CREATE TABLE food_claims (
    id SERIAL PRIMARY KEY,
    food_listing_id INTEGER REFERENCES food_listings(id),
    claimant_id INTEGER REFERENCES users(id),
    claim_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pickup_time TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'completed', 'cancelled'
    notes TEXT
);

-- Organizations table
CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100), -- 'restaurant', 'grocery', 'food_bank', 'charity'
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    contact_person VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### API Endpoints

#### Authentication Endpoints
```
POST   /api/auth/register     - User registration
POST   /api/auth/login        - User authentication
POST   /api/auth/logout       - User logout
GET    /api/auth/profile      - Get current user profile
PUT    /api/auth/profile      - Update user profile
```

#### Food Management Endpoints
```
GET    /api/food              - Get all available food listings
POST   /api/food              - Create new food listing
GET    /api/food/:id          - Get specific food listing
PUT    /api/food/:id          - Update food listing
DELETE /api/food/:id          - Delete food listing
POST   /api/food/:id/claim    - Claim a food listing
GET    /api/food/my-listings  - Get user's food listings
```

#### Organization Endpoints
```
GET    /api/organizations     - Get all organizations
POST   /api/organizations     - Create new organization
GET    /api/organizations/:id - Get organization details
PUT    /api/organizations/:id - Update organization
DELETE /api/organizations/:id - Delete organization
```

### Security Implementation

#### Authentication Flow
1. User submits credentials
2. Server validates credentials against database
3. JWT token generated with user information and expiration
4. Token returned to client for subsequent requests
5. Client includes token in Authorization header
6. Server validates token on protected routes

#### Password Security
- bcrypt hashing with salt rounds
- Minimum password requirements
- Password reset functionality
- Account lockout after failed attempts

#### API Security
- Input validation using Joi
- SQL injection prevention with parameterized queries
- XSS protection with helmet.js
- CORS configuration for cross-origin requests
- Rate limiting to prevent abuse

## 🚀 Deployment Architecture

### Kubernetes Deployment

#### Services Overview
```yaml
# Frontend Service
apiVersion: v1
kind: Service
metadata:
  name: foodshare-frontend
spec:
  selector:
    app: foodshare-frontend
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP

# Backend Service
apiVersion: v1
kind: Service
metadata:
  name: foodshare-backend
spec:
  selector:
    app: foodshare-backend
  ports:
    - port: 3000
      targetPort: 3000
  type: ClusterIP

# Database Service
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
  type: ClusterIP
```

#### ConfigMaps and Secrets

```yaml
# nginx Configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: foodshare-nginx-config
data:
  default.conf: |
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        location /api/ {
            proxy_pass http://foodshare-backend:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

# Frontend Content
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-content
data:
  index.html: |
    <!DOCTYPE html>
    <html lang="en">
    <!-- Complete HTML content -->
    </html>
```

### Docker Configuration

#### Backend Dockerfile
```dockerfile
FROM node:16-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache postgresql-client

# Copy package files
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

USER nextjs

EXPOSE 3000

CMD ["node", "server.js"]
```

#### Frontend Dockerfile
```dockerfile
FROM nginx:alpine

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

## 📊 Monitoring & Observability

### Application Metrics
- Response times for API endpoints
- Error rates by endpoint
- User registration and login metrics
- Food listing creation and claim rates

### Infrastructure Metrics
- Container resource utilization (CPU, memory)
- Database connection pool status
- Network traffic and latency
- Pod restart counts and reasons

### Logging Strategy
- Structured logging with Winston
- Log levels: ERROR, WARN, INFO, DEBUG
- Centralized log aggregation
- Log retention policies

## 🔧 Development Workflow

### Local Development Setup
1. Clone repository
2. Set up local PostgreSQL database
3. Configure environment variables
4. Run backend and frontend in development mode
5. Use hot reloading for rapid development

### Testing Strategy
- Unit tests for individual functions
- Integration tests for API endpoints
- End-to-end tests for user workflows
- Performance testing for scalability validation

### CI/CD Pipeline
1. Code quality checks (ESLint, Prettier)
2. Unit and integration tests
3. Security scanning
4. Docker image building
5. Deployment to staging environment
6. Automated testing in staging
7. Production deployment with blue-green strategy

## 🚀 Scaling Considerations

### Horizontal Scaling
- Stateless backend services
- Load balancer distribution
- Database read replicas
- CDN for static assets

### Performance Optimization
- Database query optimization
- Caching layer (Redis)
- API response compression
- Image optimization for food photos

### High Availability
- Multi-zone deployment
- Database failover configuration
- Load balancer health checks
- Automated backup and recovery

## 🔒 Security Measures

### Network Security
- Network policies in Kubernetes
- Service mesh (Istio) for traffic management
- SSL/TLS encryption for all communications
- Web Application Firewall (WAF)

### Data Security
- Database encryption at rest
- Secure API key management
- Regular security updates
- Vulnerability scanning

### Compliance
- GDPR compliance for EU users
- Data retention policies
- User consent management
- Audit logging for sensitive operations

## 📈 Future Enhancements

### Planned Features
- Mobile application (React Native)
- Real-time notifications
- Advanced search and filtering
- Integration with food delivery services
- AI-powered food matching
- Sustainability tracking and reporting

### Technical Improvements
- GraphQL API implementation
- Microservices architecture migration
- Event-driven architecture with Kafka
- Machine learning for demand prediction
- Blockchain for food traceability

---

This architecture document provides a comprehensive overview of the FoodShare application's technical implementation, deployment strategy, and future roadmap. For specific implementation details, refer to the codebase and API documentation.</content>
<parameter name="filePath">/Volumes/256-B/tc-enterprise-devops-platform/FOODSHARE-ARCHITECTURE.md
