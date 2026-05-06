#!/bin/bash
# Description: Installs ArgoCD in a Non-HA (Basic) configuration.
# Ideal for: Local development, Minikube, or testing.

set -e

NAMESPACE="argocd"

echo "Creating namespace: $NAMESPACE..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "Installing ArgoCD (Basic)..."
kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $NAMESPACE --timeout=300s

echo "---------------------------------------------------"
echo "ArgoCD Basic Installation Complete!"
echo "Initial Admin Password:"
kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "---------------------------------------------------"
