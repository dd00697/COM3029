#!/bin/bash

echo "Triggering CI/CD pipeline..."
echo "Running deployment script..."

# Get the directory of this script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Ensure the deploy.sh script is in the api directory and has executable permissions
if [ -f "$SCRIPT_DIR/api/deploy.sh" ]; then
  chmod +x "$SCRIPT_DIR/api/deploy.sh"
  "$SCRIPT_DIR/api/deploy.sh"
else
  echo "Error: deploy.sh not found in $SCRIPT_DIR/api"
  exit 127
fi
