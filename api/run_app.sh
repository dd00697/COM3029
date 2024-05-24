#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Default device is cpu
DEVICE="cpu"

# Check if an argument is passed, if so, use it as the device
if [ $# -gt 0 ]; then
  DEVICE=$1
fi

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo ".env file not found. Please create one with the necessary environment variables."
    exit 1
fi

# Check if PostgreSQL is installed
if ! command -v psql > /dev/null; then
    echo "psql command not found. Please install PostgreSQL and ensure psql is in your PATH."
    exit 1
fi

sh setup_db.sh

echo "Database setup completed."

# Activate the virtual environment
#source ~/venvs/nlp/bin/activate

# Run the app
echo "Starting the app on device: $DEVICE"
python app.py --device $DEVICE