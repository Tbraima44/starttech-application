#!/bin/bash
set -e
BACKEND_URL=${1:-http://localhost:8080}
FRONTEND_URL=${2:-http://localhost:3000}
check_endpoint() {
    local url=$1 name=$2
    for i in {1..30}; do
        if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"; then
            echo "✅ $name is healthy"
            return 0
        fi
        sleep 10
    done
    echo "❌ $name failed health check"
    return 1
}
check_endpoint "$BACKEND_URL/health" "Backend"
check_endpoint "$FRONTEND_URL" "Frontend"
