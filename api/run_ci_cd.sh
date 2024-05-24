#!/bin/bash

echo "Triggering CI/CD pipeline..."

echo "Running deployment script..."
bash deploy.sh

# Log the output of each command to ensure it runs correctly
if [ $? -eq 0 ]; then
  echo "Deployment script ran successfully."
else
  echo "Deployment script failed."
  exit 1
fi

