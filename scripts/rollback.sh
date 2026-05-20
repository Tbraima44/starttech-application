#!/bin/bash
set -e
SERVICE=${1}
ENVIRONMENT=${2:-production}
case "$SERVICE" in
    frontend)
        echo "Rolling back frontend..."
        aws s3 cp "s3://starttech-frontend-$ENVIRONMENT-backup/" "s3://starttech-frontend-$ENVIRONMENT/" --recursive
        aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT_ID" --paths "/*"
        ;;
    backend)
        echo "Rolling back backend..."
        aws autoscaling start-instance-refresh --auto-scaling-group-name "starttech-asg-$ENVIRONMENT"
        ;;
    *)
        echo "Usage: $0 <frontend|backend> [environment]"; exit 1 ;;
esac
