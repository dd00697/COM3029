#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

# Create the database if it doesn't exist
# PGPASSWORD=$PASSWORD psql -U $DBUSERNAME -h $HOST -tc "SELECT 1 FROM pg_database WHERE datname = '$DATABASE'" | grep -q 1 || PGPASSWORD=$PASSWORD psql -U $DBUSERNAME -h $HOST -c "CREATE DATABASE $DATABASE;"

# Connect to the database and create the log_data table if it doesn't exist
PGPASSWORD=$PASSWORD psql -U $DBUSERNAME -h $HOST -d $DATABASE -c "
CREATE TABLE IF NOT EXISTS log_data (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_input TEXT NOT NULL,
    model_prediction TEXT NOT NULL
);
"

echo "Database setup completed."