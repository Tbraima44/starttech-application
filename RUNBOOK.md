### ** starttech-application/RUNBOOK.md**

```markdown
# StartTech Application Runbook

This runbook covers the operation and maintenance of the full‑stack application (React frontend and Go backend), including CI/CD pipelines, deployment procedures, and troubleshooting.

## Table of Contents
- [Quick Reference](#quick-reference)
- [CI/CD Pipelines](#cicd-pipelines)
- [Manual Deployments](#manual-deployments)
- [Rolling Back a Deployment](#rolling-back-a-deployment)
- [Scaling the Backend](#scaling-the-backend)
- [Monitoring & Logs](#monitoring--logs)
- [Troubleshooting](#troubleshooting)
- [Environment Variables](#environment-variables)

---

## Quick Reference

| Component | URL / Identifier |
|-----------|-----------------|
| **Frontend (production)** |  |
| **Backend API (production)** |  |
| **S3 Bucket** |  |
| **CloudFront Distribution ID** |  |
| **ECR Repository** |  |
| **ASG Name** |  |
| **GitHub Actions** | Frontend:  |

---

## CI/CD Pipelines

Both pipelines are automatically triggered by pushes to `main` or `staging` branches.

### Frontend Pipeline (frontend-ci-cd.yml)
- **Test & Build:** Installs dependencies, runs linting, unit tests, security audit (`npm audit`), and builds the React app with Vite.
- **Deploy:** Syncs the `dist/` folder to the S3 bucket and invalidates the CloudFront cache.
- **Artifacts:** The production build uses `VITE_API_BASE_URL=/` to make API calls relative to the current domain (CloudFront proxies requests to the ALB).

### Backend Pipeline (backend-ci-cd.yml)
- **Test & Quality:** Lints the Go code (`golangci-lint`), runs unit/integration tests, and performs a security scan (`gosec`).
- **Build & Push:** Builds a Docker image, scans it with Trivy, tags it with the commit SHA, and pushes it to ECR.
- **Deploy:** Triggers an Auto Scaling Group instance refresh with a rolling update. It then waits for the refresh to complete and performs a health check against the ALB.

### Secret Variables Required
Both pipelines require these GitHub Secrets:
- `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`
- `S3_BUCKET_NAME`
- `CLOUDFRONT_DISTRIBUTION_ID`
- `ECR_REGISTRY` / `ECR_REPOSITORY`
- `ASG_NAME`
- `ALB_DNS`
- `DOMAIN_NAME` (optional)

---

---

Rolling Back a Deployment

Frontend Rollback

· Restore a previous version from a backup bucket (if available) or redeploy an older commit.
· Alternatively, use S3 versioning to revert objects, then invalidate CloudFront.

Backend Rollback

· Start an instance refresh using the previous working image tag:
  ```bash
  # Assume the previous image tag is main-<older-sha>
  aws autoscaling start-instance-refresh \
      --auto-scaling-group-name starttech-asg-production \
      --preferences '{"MinHealthyPercentage":50,"InstanceWarmup":300}' \
      --region us-east-1
  ```
· The launch template will pull the latest tag. If you need to roll back to an older image, update the launch template or manually run the container on each instance.

---

Scaling the Backend

The ASG is configured with min_size=1, max_size=10, desired_capacity=2. To change the capacity:

```bash
aws autoscaling set-desired-capacity \
    --auto-scaling-group-name starttech-asg-production \
    --desired-capacity 3 \
    --region us-east-1
```

Scaling policies exist but are not currently used. For auto‑scaling based on CPU, you can create CloudWatch alarms that trigger the scale-up and scale-down policies.

---

Monitoring & Logs

CloudWatch Dashboard

· Name: starttech-production
· Access: AWS Console → CloudWatch → Dashboards
· Widgets: Application metrics (CPU, ALB requests) and a Logs Insights widget showing top errors in the last hour.

Application Logs

· All backend logs are sent to the log group /aws/ec2/starttech-backend-production.
· Use Logs Insights for advanced queries:
  ```sql
  fields @timestamp, @message
  | filter @message like /ERROR/
  | stats count() by @message
  | sort count() desc
  | limit 10
  ```

Alarms

· High CPU and unhealthy host alarms send notifications to the configured email.

---

Troubleshooting

Frontend: Registration/Login Fails

1. Open the browser console (F12) and look for network errors.
2. Verify the API calls go to the correct domain (should be https://d3tmkdjghmqfr6.cloudfront.net/auth/...).
3. If you see Mixed Content errors, ensure the CloudFront distribution has behaviors for /auth/*, /api/*, /users/*, /tasks* that forward to the ALB origin.
4. If you see 401 errors after login, the JWT token may not be stored or attached. Check the browser’s Local Storage for a token key and verify the Axios interceptor in src/lib/apiClient.ts.

Frontend: Page Refresh Shows Error

· The SPA routing relies on CloudFront’s custom error response: 404 → /index.html (200).
· Ensure the S3 origin is the static website endpoint, not the REST endpoint. The website endpoint returns 404 for missing files (which triggers the error page) instead of 403.

Backend: Health Check Fails (502)

· Check the target group health in the AWS console.
· SSH/SSM into an instance and run docker logs backend.
· Common causes:
  · MONGO_URI not set or incorrect.
  · MongoDB Atlas IP whitelist missing the EC2 instance’s public IP.
  · Redis endpoint incorrect.

Backend: Instance Refresh Stuck

· If the refresh status remains InProgress for more than 20 minutes, cancel it:
  ```bash
  aws autoscaling cancel-instance-refresh \
      --auto-scaling-group-name starttech-asg-production \
      --region us-east-1
  ```
· Check the scaling activities for failures (e.g., instance type not eligible, key pair missing).

Backend: Container Crashes

· The entrypoint script may be waiting for a local MongoDB. If you’re using Atlas, update entrypoint.sh to skip the check when the URI starts with mongodb+srv.

---

Environment Variables

The backend requires these environment variables (passed via the EC2 launch template or Docker run):

Variable Example Description
PORT 8080 Server port
MONGO_URI mongodb+srv://... MongoDB Atlas connection string
DB_NAME todos Database name
JWT_SECRET_KEY production-secret Secret for signing JWT tokens
JWT_EXPIRATION_HOURS 72 Token expiration
ENABLE_CACHE false Enable/disable Redis caching
REDIS_ADDR master.starttech-redis-production.xsbsfs.use1.cache.amazonaws.com:6379 Redis endpoint
REDIS_PASSWORD (empty) Redis password (if any)
LOG_LEVEL debug Logging level
LOG_FORMAT text Log format (text/json)

The frontend uses VITE_API_BASE_URL (set in .env.production). For production, it should be / to make API calls relative to the CloudFront domain.

---

Additional Resources

· GitHub Actions Documentation
· AWS ECS/ECR Documentation
· React Query / TanStack Query

```

---
