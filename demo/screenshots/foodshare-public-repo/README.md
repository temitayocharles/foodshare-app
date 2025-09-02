# FoodShare Kubernetes Deployment Documentation

## Overview
This document provides comprehensive information about the FoodShare application deployed in a Kubernetes lab environment. FoodShare is a 3-tier web application designed to reduce food waste by connecting restaurants with surplus food to communities in need.

## Application Architecture

### 3-Tier Architecture:
1. **Frontend**: React.js with Material-UI (served by NGINX)
2. **Backend**: Node.js/Express API with PostgreSQL client
3. **Database**: PostgreSQL 13 with persistent storage

### Key Features:
- 🌱 **Social Impact**: Reduces food waste by connecting restaurants to communities
- 📱 **Responsive Design**: Works on desktop and mobile devices
- 🔄 **Real-time Updates**: Dynamic food listings display
- 💾 **Data Persistence**: PostgreSQL database storage
- 🚀 **Containerized**: Fully containerized with Docker/Kubernetes

## Kubernetes Deployment Details

### Cluster Information
- **Platform**: KIND (Kubernetes in Docker)
- **Nodes**: 1 control-plane node
- **Networking**: NGINX Ingress Controller
- **Storage**: Persistent Volumes for PostgreSQL

### Deployed Components

#### 1. PostgreSQL Database
```yaml
- Deployment: foodshare-postgres
- Service: postgres (ClusterIP)
- Persistent Volume: 1Gi storage
- Database: foodshare
- User: foodadmin
- Table: food_listings
```

#### 2. Backend API
```yaml
- Deployment: foodshare-backend
- Service: foodshare-backend (ClusterIP)
- Port: 3000
- Endpoints:
  - GET /api/health - Health check
  - GET /api/food - Get all food listings
  - POST /api/food - Add new food listing
```

#### 3. Frontend Application
```yaml
- Deployment: foodshare-frontend
- Service: foodshare-frontend (ClusterIP)
- Port: 80
- Technology: React.js + Material-UI
```

#### 4. Ingress Controller
```yaml
- Controller: ingress-nginx
- Service: ingress-nginx-controller (ClusterIP)
- Routing:
  - / → foodshare-frontend:80
  - /api → foodshare-backend:3000
```

## Deployment Steps

### 1. Infrastructure Setup
```bash
# Create KIND cluster
kind create cluster --name tc-enterprise

# Install NGINX Ingress Controller
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.type=ClusterIP
```

### 2. Database Deployment
```bash
kubectl apply -f foodshare/postgres.yaml
```

### 3. Backend Deployment
```bash
kubectl apply -f foodshare/backend.yaml
```

### 4. Frontend Deployment
```bash
kubectl apply -f foodshare/frontend.yaml
```

### 5. Ingress Configuration
```bash
kubectl apply -f foodshare/ingress.yaml
```

### 6. Port Forwarding
```bash
kubectl port-forward svc/ingress-nginx-controller 8080:80 --namespace ingress-nginx
```

## Application Access

### Local Development Access
- **URL**: http://localhost:8080
- **Port Forwarding**: Required for local access
- **Browser**: Any modern web browser

### API Endpoints
- **Health Check**: http://localhost:8080/api/health
- **Food Listings**: http://localhost:8080/api/food
- **Add Listing**: POST to http://localhost:8080/api/food

## Database Schema

```sql
CREATE TABLE food_listings (
    id SERIAL PRIMARY KEY,
    restaurant VARCHAR(255),
    food_type VARCHAR(255),
    quantity VARCHAR(255),
    expiry_date DATE,
    location VARCHAR(255),
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Sample Data
The application includes sample food listing data demonstrating the functionality.

## Technology Stack

### Frontend
- **Framework**: React.js 18
- **UI Library**: Material-UI 5.14.0
- **Styling**: CSS with Roboto font
- **HTTP Client**: Fetch API (browser native)

### Backend
- **Runtime**: Node.js 16 (Alpine Linux)
- **Framework**: Express.js 5.1.0
- **Database Client**: pg (PostgreSQL client)
- **CORS**: Enabled for cross-origin requests

### Database
- **Engine**: PostgreSQL 13
- **Image**: postgres:13-alpine
- **Storage**: Persistent Volume Claim (1Gi)

### Infrastructure
- **Container Runtime**: Docker (via Colima)
- **Orchestration**: Kubernetes (KIND)
- **Ingress**: NGINX Ingress Controller
- **Networking**: ClusterIP services

## Configuration Files

### Environment Variables
```bash
# Database Configuration
POSTGRES_DB=foodshare
POSTGRES_USER=foodadmin
POSTGRES_PASSWORD=FoodShare2025!

# Application Ports
BACKEND_PORT=3000
FRONTEND_PORT=80
INGRESS_PORT=8080
```

### Docker Images Used
- `postgres:13-alpine` - Database
- `node:16-alpine` - Backend runtime
- `nginx:alpine` - Frontend web server

## Monitoring and Troubleshooting

### Check Pod Status
```bash
kubectl get pods
```

### View Logs
```bash
# Backend logs
kubectl logs deployment/foodshare-backend

# Frontend logs
kubectl logs deployment/foodshare-frontend

# Database logs
kubectl logs deployment/postgres

# Ingress logs
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
```

### Database Access
```bash
kubectl exec -it deployment/postgres -- psql -U foodadmin -d foodshare
```

## Performance Metrics

### Resource Usage
- **Database**: ~50MB RAM, persistent storage
- **Backend**: ~30MB RAM, lightweight Node.js
- **Frontend**: ~10MB RAM, static files
- **Ingress**: ~20MB RAM, NGINX proxy

### Scalability
- Horizontal Pod Autoscaling can be configured
- Database connection pooling implemented
- Stateless backend design

## Security Considerations

### Network Security
- ClusterIP services (internal only)
- Ingress controller handles external access
- No direct external database access

### Application Security
- CORS enabled for web access
- Input validation on API endpoints
- SQL injection prevention with parameterized queries

## Future Enhancements

### Potential Improvements
1. **Authentication**: User login system
2. **Real-time Updates**: WebSocket integration
3. **Search/Filter**: Advanced food listing search
4. **Mobile App**: React Native companion app
5. **Analytics**: Usage tracking and reporting
6. **Notifications**: Email/SMS alerts for new listings

### Production Deployment
1. **Load Balancer**: External load balancer configuration
2. **SSL/TLS**: HTTPS certificate configuration
3. **Monitoring**: Prometheus/Grafana integration
4. **Backup**: Database backup strategy
5. **CI/CD**: Automated deployment pipeline

## Files Included

### Application Files
- `foodshare/backend.yaml` - Backend deployment and service
- `foodshare/frontend.yaml` - Frontend deployment and service
- `foodshare/postgres.yaml` - Database deployment and service
- `foodshare/ingress.yaml` - Ingress routing configuration

### Documentation Files
- `screenshots/cluster-status.txt` - Current cluster state
- `screenshots/pods-details.yaml` - Detailed pod information
- `screenshots/networking.yaml` - Network configuration
- `screenshots/database-content.txt` - Sample database data

## Deployment Verification

### Health Checks
✅ **Database**: PostgreSQL running and accessible
✅ **Backend**: API responding on port 3000
✅ **Frontend**: Web interface loading correctly
✅ **Ingress**: Routing working for / and /api paths
✅ **Port Forwarding**: Local access established

### Functional Tests
✅ **Data Submission**: Form submissions working
✅ **Data Retrieval**: Listings display correctly
✅ **Database Storage**: Data persistence confirmed
✅ **Error Handling**: Graceful error responses

## Conclusion

This FoodShare deployment demonstrates a complete 3-tier application running on Kubernetes with:
- Modern web technologies (React, Node.js, PostgreSQL)
- Container orchestration (Kubernetes)
- Production-ready architecture (ingress, persistent storage)
- Social impact focus (food waste reduction)

The deployment showcases Kubernetes capabilities for application orchestration, service discovery, persistent storage, and network routing in a local development environment.

---

**Deployed by**: TC Enterprise DevOps Platform
**Date**: September 1, 2025
**Environment**: KIND Cluster (Local Development)
**Application**: FoodShare v1.0
