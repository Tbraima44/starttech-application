#!/bin/sh
set -e

echo "Loading environment variables..."

# Source the .env file if it exists
if [ -f /app/.env ]; then
    echo "Found /app/.env, sourcing..."
    set -a
    . /app/.env
    set +a
else
    echo "No /app/.env found, using existing environment"
fi

echo "MONGO_URI is set to: ${MONGO_URI%%:*}//*****"

# Only wait for local MongoDB if we are NOT using Atlas (mongodb+srv)
if echo "$MONGO_URI" | grep -q "^mongodb+srv"; then
    echo "MongoDB Atlas detected – skipping local MongoDB wait"
else
    echo "Waiting for local MongoDB to be ready..."
    for i in $(seq 1 30); do
        if nc -z mongodb 27017 2>/dev/null; then
            echo "Local MongoDB is ready!"
            break
        fi
        echo "Attempt $i: MongoDB not ready yet, waiting..."
        sleep 2
    done
fi

echo "Starting server..."
exec /app/server