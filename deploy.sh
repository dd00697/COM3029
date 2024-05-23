#!/bin/bash

# Build the Docker image
docker build -t my_model:latest .

# Tag the Docker image
docker tag my_model:latest dd00697/my_model:latest

# Log in to Docker Hub
echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

# Push the Docker image to Docker Hub
docker push dd00697/my_model:latest

# Deploy the Docker container 
docker-compose down
docker-compose up -d