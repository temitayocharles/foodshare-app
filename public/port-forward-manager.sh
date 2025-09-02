#!/bin/bash

# FoodShare Port-Forward Manager
# This script keeps the port-forward running and restarts it if it stops

NAMESPACE="ingress-nginx"
SERVICE="ingress-nginx-controller"
LOCAL_PORT="8080"
REMOTE_PORT="80"

echo "🍽️  FoodShare Port-Forward Manager Started"
echo "Forwarding localhost:$LOCAL_PORT → $SERVICE:$REMOTE_PORT in namespace $NAMESPACE"
echo "Press Ctrl+C to stop"

while true; do
    echo "$(date): Starting port-forward..."
    kubectl port-forward svc/$SERVICE $LOCAL_PORT:$REMOTE_PORT --namespace $NAMESPACE

    echo "$(date): Port-forward stopped. Restarting in 5 seconds..."
    sleep 5
done
