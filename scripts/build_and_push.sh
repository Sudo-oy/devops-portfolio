#!/usr/bin/env bash
set -e

# Variables d'environnement depuis .env
export $(grep -v '^#' .env | xargs)

echo "📦 Build Docker image..."
docker build -t $DOCKER_USERNAME/myapp:latest ./app

echo "🔑 Login Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "🚀 Push Docker image..."
docker push $DOCKER_USERNAME/myapp:latest

echo "✅ Image poussée avec succès!"
