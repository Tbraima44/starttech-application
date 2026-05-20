#!/bin/bash
set -e
ENVIRONMENT=${1:-staging}
IMAGE_TAG="${2:-latest}"
echo "Deploying backend to $ENVIRONMENT..."
aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin "$ECR_REGISTRY"
docker build -t "starttech-backend-$ENVIRONMENT:$IMAGE_TAG" ./backend
docker push "starttech-backend-$ENVIRONMENT:$IMAGE_TAG"
aws autoscaling start-instance-refresh \
    --auto-scaling-group-name "starttech-asg-$ENVIRONMENT"
echo "Backend deployment initiated!"
