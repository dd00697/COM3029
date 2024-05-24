#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Build the Docker image
echo "Building Docker image..."
docker build -t my_model:latest .

# Tag the Docker image
echo "Tagging Docker image..."
docker tag my_model:latest dd000697/my_model:latest

# Log in to Docker Hub
echo "Logging into Docker Hub..."
echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

# Push the Docker image to Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push dd000697/my_model:latest

# Deploy the Docker container
echo "Deploying Docker container..."
docker-compose down
docker-compose up -d

echo "Deployment completed successfully."
