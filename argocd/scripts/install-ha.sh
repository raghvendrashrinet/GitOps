#!/bin/bash
# Description: Installs ArgoCD in a High Availability (HA) configuration.
# Ideal for: Production-like environments with at least 3 worker nodes.

set -e

NAMESPACE="argocd"

echo "Creating namespace: $NAMESPACE..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "Installing ArgoCD (High Availability)..."
# This manifest scales replicas and configures Redis Sentinel
kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml

echo "Waiting for HA components to initialize..."
# We wait for the API server specifically as a health check
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $NAMESPACE --timeout=300s

echo "---------------------------------------------------"
echo "ArgoCD HA Installation Complete!"
echo "Check pods to see replicas: kubectl get pods -n $NAMESPACE"
echo "Initial Admin Password:"
kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "---------------------------------------------------"
