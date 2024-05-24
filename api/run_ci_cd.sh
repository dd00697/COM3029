#!/bin/bash

echo "Triggering CI/CD pipeline..."
echo "Running deployment script..."

# Print the current directory and list files for debugging
echo "Current directory: $(pwd)"
echo "Contents of current directory:"
ls -la

# Get the directory of this script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Print the script directory for debugging
echo "Script directory: $SCRIPT_DIR"

# Ensure the deploy.sh script is in the api directory and has executable permissions
if [ -f "$SCRIPT_DIR/deploy.sh" ]; then
  chmod +x "$SCRIPT_DIR/deploy.sh"
  "$SCRIPT_DIR/deploy.sh"
else
  echo "Error: deploy.sh not found in $SCRIPT_DIR"
  exit 127
fi
