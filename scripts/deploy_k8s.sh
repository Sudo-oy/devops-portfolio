#!/usr/bin/env bash
set -e

# Charger les variables si .env existe
[ -f .env ] && export $(grep -v '^#' .env | xargs)

echo "☸️ Déploiement Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/sealed-secret.yaml

echo "✅ Déploiement terminé!"
