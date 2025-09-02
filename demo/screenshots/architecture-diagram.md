# FoodShare Application Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    🌐 User Browser                               │
│                    http://localhost:8080                        │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                🚪 NGINX Ingress Controller                      │
│                Namespace: ingress-nginx                        │
│                Service: ingress-nginx-controller               │
│                Port: 80 (internal)                             │
│                                                                │
│  Routing Rules:                                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Path: / → foodshare-frontend:80                      │   │
│  │  Path: /api → foodshare-backend:3000                  │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────┬───────────────────────────────────────────┘
                      │
          ┌───────────┴───────────┐
          │                      │
          ▼                      ▼
┌─────────────────┐    ┌─────────────────┐
│   🎨 Frontend   │    │   🚀 Backend    │
│   React + MUI  │    │   Node.js API   │
│   nginx:alpine │    │   node:16-alpine│
│   Port: 80     │    │   Port: 3000    │
│   Service:     │    │   Service:      │
│   ClusterIP    │    │   ClusterIP     │
└─────────────────┘    └─────────────────┘
          │                      │
          └──────────┬───────────┘
                     │
                     ▼
          ┌─────────────────┐
          │   🗄️ Database   │
          │   PostgreSQL   │
          │   postgres:13  │
          │   Port: 5432   │
          │   Service:     │
          │   ClusterIP    │
          │                │
          │   Persistent   │
          │   Volume: 1Gi  │
          └─────────────────┘
```

## Component Details

### 1. User Layer
- **Browser**: Any modern web browser
- **Access**: http://localhost:8080
- **Features**: Responsive web interface

### 2. Ingress Layer
- **Controller**: NGINX Ingress Controller
- **Purpose**: Route external traffic to internal services
- **Configuration**: Path-based routing (/ and /api)
- **Type**: ClusterIP (internal only)

### 3. Application Layer

#### Frontend Service
- **Technology**: React.js 18 + Material-UI 5.14.0
- **Web Server**: NGINX Alpine
- **Port**: 80
- **Features**:
  - Food listing form
  - Real-time data display
  - Responsive design
  - API integration

#### Backend Service
- **Technology**: Node.js 16 + Express.js 5.1.0
- **Database Client**: pg (PostgreSQL)
- **Port**: 3000
- **API Endpoints**:
  - `GET /api/health` - Health check
  - `GET /api/food` - Retrieve food listings
  - `POST /api/food` - Create food listing
- **Features**:
  - RESTful API
  - CORS enabled
  - Error handling
  - Database integration

### 4. Data Layer
- **Database**: PostgreSQL 13
- **Image**: postgres:13-alpine
- **Port**: 5432
- **Schema**: food_listings table
- **Storage**: Persistent Volume (1Gi)
- **Backup**: Data persistence across pod restarts

## Network Flow

### Frontend Access
```
User Browser → Port Forward (8080) → Ingress Controller → Frontend Service → Frontend Pod
```

### API Access
```
User Browser → Port Forward (8080) → Ingress Controller → Backend Service → Backend Pod → Database
```

### Database Access
```
Backend Pod → Database Service → Database Pod → Persistent Volume
```

## Security & Networking

### Service Types
- **Ingress**: ClusterIP (internal routing)
- **Frontend**: ClusterIP (internal only)
- **Backend**: ClusterIP (internal only)
- **Database**: ClusterIP (internal only)

### Security Features
- **Network Isolation**: All services internal-only
- **CORS**: Enabled for web access
- **Input Validation**: API request validation
- **SQL Injection Prevention**: Parameterized queries

## Scalability Features

### Horizontal Scaling
- **Stateless Design**: Frontend and backend can scale horizontally
- **Load Balancing**: Ingress controller distributes traffic
- **Database Connection**: Backend handles multiple connections

### Resource Management
- **Memory**: ~100MB total for all components
- **Storage**: 1Gi persistent volume for database
- **CPU**: Lightweight container images

## Deployment Architecture

### Kubernetes Objects
- **Deployments**: 3 (postgres, backend, frontend)
- **Services**: 3 (postgres, backend, frontend)
- **Ingress**: 1 (foodshare-ingress)
- **ConfigMap**: 1 (frontend content)
- **PersistentVolumeClaim**: 1 (database storage)

### Namespace Structure
```
default/
├── foodshare-postgres (deployment + svc + pvc)
├── foodshare-backend (deployment + svc)
├── foodshare-frontend (deployment + svc + configmap)
└── foodshare-ingress (ingress)

ingress-nginx/
└── ingress-nginx-controller (deployment + svc)
```

## Monitoring & Observability

### Health Checks
- **Application**: /api/health endpoint
- **Database**: Connection validation
- **Pods**: Kubernetes liveness/readiness probes

### Logging
- **Application Logs**: Container stdout/stderr
- **Access Logs**: NGINX ingress logs
- **Database Logs**: PostgreSQL logs

### Metrics
- **Pod Status**: kubectl get pods
- **Resource Usage**: kubectl top pods
- **Network Traffic**: Service endpoints

This architecture demonstrates a production-ready 3-tier application with proper separation of concerns, scalability features, and monitoring capabilities.
