# FoodShare Deployment Guide

## 🚀 Deployment Overview

This guide covers deploying FoodShare within the TC Enterprise DevOps Platform using Kubernetes and KIND (Kubernetes in Docker).

## 📋 Prerequisites

- **Kubernetes Cluster**: KIND cluster running
- **kubectl**: Configured to access the cluster
- **Docker**: For building container images
- **PostgreSQL**: Database server running

## 🏗️ Current Deployment Status

FoodShare is currently deployed and running within the TC Enterprise DevOps Platform with the following components:

### Active Services
```bash
kubectl get pods | grep foodshare
# foodshare-backend-597db89bdd-mf976    1/1     Running   0          6h14m
# foodshare-frontend-67cd7d7d45-vft4h   1/1     Running   0          73m

kubectl get services | grep foodshare
# foodshare-backend    ClusterIP   10.96.171.83   <none>        3000/TCP   6h36m
# foodshare-frontend   ClusterIP   10.96.85.227   <none>        80/TCP     6h34m
```

### Configuration Files
- `nginx-config.yaml` - nginx proxy configuration
- `frontend-content` ConfigMap - React application
- Backend deployment with embedded Node.js application

## 🔧 Manual Deployment Steps

### 1. Database Setup

Ensure PostgreSQL is running and create the foodshare database:

```bash
# Connect to PostgreSQL
kubectl exec -it postgres-pod -- psql -U postgres

# Create database and user
CREATE DATABASE foodshare;
CREATE USER foodadmin WITH PASSWORD 'FoodShare2025!';
GRANT ALL PRIVILEGES ON DATABASE foodshare TO foodadmin;

# Create tables
\c foodshare;
CREATE TABLE food_listings (
    id SERIAL PRIMARY KEY,
    restaurant VARCHAR(255) NOT NULL,
    food_type VARCHAR(255) NOT NULL,
    quantity VARCHAR(255) NOT NULL,
    expiry_date DATE NOT NULL,
    location VARCHAR(255) NOT NULL,
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Deploy Backend Service

```yaml
# Save as backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: foodshare-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: foodshare-backend
  template:
    metadata:
      labels:
        app: foodshare-backend
    spec:
      containers:
      - name: backend
        image: node:16-alpine
        ports:
        - containerPort: 3000
        command: ["sh", "-c"]
        args:
        - |
          apk add --no-cache postgresql-client &&
          npm install express pg cors &&
          cat > server.js << 'EOF'
          const express = require("express");
          const { Client } = require("pg");
          const cors = require("cors");

          const app = express();
          app.use(cors());
          app.use(express.json());

          const client = new Client({
            host: "postgres",
            port: 5432,
            database: "foodshare",
            user: "foodadmin",
            password: "FoodShare2025!"
          });

          client.connect();

          app.get("/api/food", async (req, res) => {
            try {
              const result = await client.query("SELECT * FROM food_listings ORDER BY created_at DESC");
              res.json(result.rows);
            } catch (err) {
              res.status(500).json({ error: err.message });
            }
          });

          app.post("/api/food", async (req, res) => {
            try {
              const { restaurant, food_type, quantity, expiry_date, location, allergies } = req.body;
              const result = await client.query(
                "INSERT INTO food_listings (restaurant, food_type, quantity, expiry_date, location, allergies) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *",
                [restaurant, food_type, quantity, expiry_date, location, allergies]
              );
              res.json(result.rows[0]);
            } catch (err) {
              res.status(500).json({ error: err.message });
            }
          });

          app.listen(3000, () => {
            console.log("FoodShare Backend running on port 3000");
          });
          EOF
          node server.js

---
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
```

### 3. Deploy Frontend Service

```yaml
# Save as frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: foodshare-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: foodshare-frontend
  template:
    metadata:
      labels:
        app: foodshare-frontend
    spec:
      containers:
      - name: frontend
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/conf.d
        - name: frontend-content
          mountPath: /usr/share/nginx/html
      volumes:
      - name: nginx-config
        configMap:
          name: foodshare-nginx-config
      - name: frontend-content
        configMap:
          name: frontend-content

---
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
```

### 4. Apply Configurations

```bash
# Apply nginx configuration
kubectl apply -f nginx-config.yaml

# Apply deployments
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

# Check deployment status
kubectl get pods
kubectl get services
```

### 5. Port Forwarding

```bash
# Forward frontend service to local port 3000
kubectl port-forward svc/foodshare-frontend 3000:80

# Access the application at http://localhost:3000
```

## 🐳 Docker Compose Deployment (Alternative)

For local development without Kubernetes:

```yaml
# docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_DB: foodshare
      POSTGRES_USER: foodadmin
      POSTGRES_PASSWORD: FoodShare2025!
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build: ./backend
    ports:
      - "3001:3000"
    environment:
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=foodshare
      - DB_USER=foodadmin
      - DB_PASSWORD=FoodShare2025!
    depends_on:
      - postgres

  frontend:
    build: ./frontend
    ports:
      - "3000:80"
    depends_on:
      - backend

volumes:
  postgres_data:
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Backend Cannot Connect to Database
```bash
# Check database connectivity
kubectl exec foodshare-backend-pod -- nc -zv postgres 5432

# Check database logs
kubectl logs postgres-pod
```

#### 2. Frontend Not Loading
```bash
# Check nginx configuration
kubectl exec foodshare-frontend-pod -- nginx -t

# Check nginx logs
kubectl logs foodshare-frontend-pod
```

#### 3. Port Forwarding Issues
```bash
# Kill existing port forwarding
pkill -f "kubectl port-forward"

# Try different port
kubectl port-forward svc/foodshare-frontend 8080:80
```

### Health Checks

```bash
# Check pod status
kubectl get pods -o wide

# Check service endpoints
kubectl get endpoints

# Check logs
kubectl logs foodshare-backend-pod --tail=20
kubectl logs foodshare-frontend-pod --tail=20
```

## 📊 Monitoring

### Application Health
```bash
# Check backend health
curl http://localhost:3000/api/health

# Check database connectivity
kubectl exec foodshare-backend-pod -- psql -h postgres -U foodadmin -d foodshare -c "SELECT COUNT(*) FROM food_listings;"
```

### Resource Usage
```bash
# Check pod resource usage
kubectl top pods

# Check node resources
kubectl top nodes
```

## 🔄 Updates and Rollbacks

### Rolling Updates
```bash
# Update backend image
kubectl set image deployment/foodshare-backend backend=node:18-alpine

# Check rollout status
kubectl rollout status deployment/foodshare-backend

# Rollback if needed
kubectl rollout undo deployment/foodshare-backend
```

### Configuration Updates
```bash
# Update nginx config
kubectl apply -f nginx-config.yaml

# Update frontend content
kubectl create configmap frontend-content --from-file=index.html --dry-run=client -o yaml | kubectl apply -f -
```

## 🚀 Production Deployment

### Production Considerations

1. **Security**:
   - Use secrets for database credentials
   - Enable HTTPS with TLS certificates
   - Configure network policies
   - Set up proper RBAC

2. **Scalability**:
   - Configure horizontal pod autoscaling
   - Set up load balancer
   - Configure database connection pooling
   - Implement caching layer

3. **Monitoring**:
   - Set up Prometheus and Grafana
   - Configure logging aggregation
   - Set up alerts for critical issues
   - Monitor application metrics

4. **Backup**:
   - Database backups
   - Configuration backups
   - Application logs archiving

### Production Deployment Script

```bash
#!/bin/bash
# production-deploy.sh

echo "🚀 Starting FoodShare production deployment..."

# Apply Kubernetes manifests
kubectl apply -f k8s/production/

# Wait for deployments
kubectl wait --for=condition=available --timeout=300s deployment/foodshare-backend
kubectl wait --for=condition=available --timeout=300s deployment/foodshare-frontend

# Run database migrations
kubectl exec deployment/foodshare-backend -- npm run migrate

# Health checks
curl -f http://foodshare-backend:3000/api/health || exit 1

echo "✅ FoodShare deployed successfully!"
```

## 📞 Support

For deployment issues:
1. Check the troubleshooting section above
2. Review Kubernetes logs: `kubectl logs <pod-name>`
3. Verify network connectivity: `kubectl get services`
4. Check resource constraints: `kubectl describe pod <pod-name>`

For application-specific issues, refer to the main README.md file.</content>
<parameter name="filePath">/Volumes/256-B/tc-enterprise-devops-platform/FOODSHARE-DEPLOYMENT.md
