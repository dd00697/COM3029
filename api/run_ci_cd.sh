#!/bin/bash

echo "Triggering CI/CD pipeline..."
echo "Running deployment script..."

# Ensure the deploy.sh script is in the api directory and has executable permissions
if [ -f "./api/deploy.sh" ]; then
  chmod +x ./api/deploy.sh
  ./api/deploy.sh
else
  echo "Error: deploy.sh not found in $(pwd)/api"
  exit 127