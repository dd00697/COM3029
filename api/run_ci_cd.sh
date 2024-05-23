
echo "Triggering CI/CD pipeline..."
echo "Running deployment script..."

# Ensure the deploy.sh script is in the same directory and has executable permissions
if [ -f "./deploy.sh" ]; then
  chmod +x ./deploy.sh
  ./deploy.sh
else
  echo "Error: deploy.sh not found in $(pwd)"
  exit 127
fi