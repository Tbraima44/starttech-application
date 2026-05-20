#!/bin/bash
set -e
ENVIRONMENT=${1:-staging}
echo "Deploying frontend to $ENVIRONMENT..."
cd frontend
npm ci
npm run build
aws s3 sync build/ "s3://starttech-frontend-$ENVIRONMENT" --delete
aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT_ID" --paths "/*"
echo "Frontend deployment complete!"
