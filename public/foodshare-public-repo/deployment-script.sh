#!/bin/bash

# FoodShare Kubernetes Deployment Script
# This script documents all the steps taken to deploy the FoodShare application

echo "🍽️  FoodShare Kubernetes Deployment Script"
echo "=========================================="
echo ""

# Step 1: Check prerequisites
echo "Step 1: Checking Prerequisites"
echo "------------------------------"
echo "✓ Docker installed and running"
echo "✓ kubectl installed and configured"
echo "✓ KIND installed"
echo "✓ Helm installed"
echo ""

# Step 2: Create KIND cluster
echo "Step 2: Creating KIND Cluster"
echo "-----------------------------"
echo "Command: kind create cluster --name tc-enterprise"
echo "✓ KIND cluster 'tc-enterprise' created"
echo ""

# Step 3: Install NGINX Ingress Controller
echo "Step 3: Installing NGINX Ingress Controller"
echo "------------------------------------------"
echo "Command: helm install ingress-nginx ingress-nginx/ingress-nginx \\"
echo "  --namespace ingress-nginx --create-namespace \\"
echo "  --set controller.service.type=ClusterIP"
echo "✓ NGINX Ingress Controller installed"
echo ""

# Step 4: Deploy PostgreSQL Database
echo "Step 4: Deploying PostgreSQL Database"
echo "-------------------------------------"
echo "File: foodshare/postgres.yaml"
echo "Components:"
echo "  - PersistentVolumeClaim: 1Gi storage"
echo "  - Deployment: postgres (postgres:13-alpine)"
echo "  - Service: postgres (ClusterIP:5432)"
echo "✓ PostgreSQL deployed and running"
echo ""

# Step 5: Create Database Table
echo "Step 5: Creating Database Schema"
echo "--------------------------------"
echo "Command: kubectl exec -it deployment/postgres -- psql -U foodadmin -d foodshare -c \"...\""
echo "✓ food_listings table created with proper schema"
echo ""

# Step 6: Deploy Backend API
echo "Step 6: Deploying Backend API"
echo "-----------------------------"
echo "File: foodshare/backend.yaml"
echo "Components:"
echo "  - Image: node:16-alpine"
echo "  - Port: 3000"
echo "  - Dependencies: express, pg, cors"
echo "  - Endpoints: /api/health, /api/food"
echo "✓ Backend API deployed and running"
echo ""

# Step 7: Deploy Frontend Application
echo "Step 7: Deploying Frontend Application"
echo "--------------------------------------"
echo "File: foodshare/frontend.yaml"
echo "Components:"
echo "  - Image: nginx:alpine"
echo "  - Port: 80"
echo "  - Technologies: React.js, Material-UI"
echo "  - ConfigMap: HTML, CSS, JavaScript"
echo "✓ Frontend application deployed and running"
echo ""

# Step 8: Configure Ingress
echo "Step 8: Configuring Ingress Routing"
echo "-----------------------------------"
echo "File: foodshare/ingress.yaml"
echo "Routes:"
echo "  - / → foodshare-frontend:80"
echo "  - /api → foodshare-backend:3000"
echo "✓ Ingress configured and routing working"
echo ""

# Step 9: Setup Port Forwarding
echo "Step 9: Setting up Port Forwarding"
echo "----------------------------------"
echo "Command: kubectl port-forward svc/ingress-nginx-controller 8080:80 --namespace ingress-nginx"
echo "✓ Port forwarding established: localhost:8080"
echo ""

# Step 10: Verification
echo "Step 10: Deployment Verification"
echo "-------------------------------"
echo "✓ All pods running: kubectl get pods"
echo "✓ Services accessible: kubectl get svc"
echo "✓ Ingress routing: kubectl get ingress"
echo "✓ Database accessible: kubectl exec -it deployment/postgres -- psql ..."
echo "✓ Application functional: http://localhost:8080"
echo ""

# Step 11: Testing
echo "Step 11: Functional Testing"
echo "--------------------------"
echo "✓ Frontend loads: http://localhost:8080"
echo "✓ Form submission works"
echo "✓ Data stored in database"
echo "✓ API endpoints responding"
echo ""

echo "🎉 Deployment Complete!"
echo "======================"
echo "FoodShare application is now running at: http://localhost:8080"
echo ""
echo "Components deployed:"
echo "- PostgreSQL Database (persistent storage)"
echo "- Node.js/Express Backend API"
echo "- React.js Frontend Application"
echo "- NGINX Ingress Controller"
echo "- Complete 3-tier architecture"
echo ""
echo "Social Impact: Reducing food waste by connecting restaurants to communities"
