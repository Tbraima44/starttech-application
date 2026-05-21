A full-stack todo application with React frontend, Go backend, Redis caching, and MongoDB database.


## 📦 Tech Stack

| Component   | Technology                | Purpose                    |
|------------|---------------------------|----------------------------|
| Frontend   | React 18 + TypeScript     | User interface             |
| Backend    | Go 1.24 + Gin             | REST API                   |
| Cache      | Redis 7                   | Session/caching            |
| Database   | MongoDB 7                 | Data persistence           |
| Build      | Docker + Docker Compose   | Containerization           |
| CI/CD      | GitHub Actions            | Automated deployment       |
| IaC        | Terraform                 | Infrastructure provisioning|

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose v2+
- Node.js 18+ (for local frontend development)
- Go 1.24+ (for local backend development)

### Local Development

```bash
# Clone the repository
git clone https://github.com/Tbraima44/starttech-application.git
cd starttech-application

# Set up environment variables
cp backend/.env.example backend/.env
# Edit backend/.env with your values

cp frontend/.env.example frontend/.env
# Edit frontend/.env with your values

# Start all services with Docker Compose
docker compose up -d

# Or start individual services
docker compose up backend redis mongodb
```

Access the Application

Service URL
Frontend http://localhost:3000
Backend http://localhost:8080
Redis redis://localhost:6379
MongoDB mongodb://localhost:27017

API Endpoints

```bash
# Health check
curl http://localhost:8080/ping

# Welcome message
curl http://localhost:8080/

# API documentation (Swagger)
# Available when running in development mode
```

📁 Project Structure

```
starttech-application/
├── .github/
│   └── workflows/
│       ├── frontend-ci-cd.yml    # Frontend CI/CD pipeline
│       ├── backend-ci-cd.yml     # Backend CI/CD pipeline
│       └── security-scan.yml     # Scheduled security scans
├── frontend/                     # React application
│   ├── src/
│   │   ├── components/           # React components
│   │   ├── services/             # API services
│   │   └── utils/                # Utility functions
│   ├── .env.example              # Example environment variables
│   └── Dockerfile                # Frontend Docker image
├── backend/                      # Go API
│   ├── cmd/server/               # Application entry point
│   ├── internal/                 # Private application code
│   │   ├── handlers/             # HTTP handlers
│   │   ├── models/               # Data models
│   │   ├── services/             # Business logic
│   │   ├── repository/           # Database layer
│   │   ├── middleware/            # HTTP middleware
│   │   └── config/               # Configuration
│   ├── .env.example              # Example environment variables
│   ├── Dockerfile                # Backend Docker image
│   ├── entrypoint.sh             # Container entrypoint script
    ├── go.mod
    ├── go.sh
    └── go.sum
├── scripts/                      # Deployment scripts
│   ├── deploy-frontend.sh        # Deploy frontend to S3
│   ├── deploy-backend.sh         # Deploy backend to EC2
│   ├── health-check.sh           # Health check script
│   └── rollback.sh               # Rollback script
├── docker-compose.yml            # Local development setup
├── CONTRIBUTING.md
└── README.md                     # This file
```

🔒 Environment Variables

Backend (.env)

PORT=8080
MONGO_URI=enter-your-mongodb-uri-here
DB_NAME=todos
JWT_SECRET_KEY=change-me-to-a-random-string
JWT_EXPIRATION_HOURS=72
ENABLE_CACHE=false
REDIS_ADDR=redis:6379
REDIS_PASSWORD=
LOG_LEVEL=debug
LOG_FORMAT=text

Frontend (.env)

Variable Description Default
REACT_APP_API_URL Backend API URL http://localhost:8080/api
REACT_APP_ENVIRONMENT=development

🚀 CI/CD Pipeline

The application uses GitHub Actions for automated deployment:

Frontend Pipeline

1. 🧪 Test: Linting, unit tests, security scan
2. 🏗️ Build: Production React bundle
3. 📤 Deploy: Sync to S3, invalidate CloudFront cache

Backend Pipeline

1. 🧪 Test: Linting, unit tests, integration tests
2. 🏗️ Build: Docker image build + vulnerability scan
3. 📦 Push: Push to Amazon ECR
4. 🚀 Deploy: Rolling update to EC2 Auto Scaling Group

Required GitHub Secrets

Secret Description
AWS_ACCESS_KEY_ID AWS access key
AWS_SECRET_ACCESS_KEY AWS secret key
S3_BUCKET_NAME Frontend S3 bucket name
CLOUDFRONT_DISTRIBUTION_ID CloudFront distribution ID
ECR_REGISTRY ECR registry URL
ECR_REPOSITORY ECR repository name
ASG_NAME Auto Scaling Group name
ALB_DNS Application Load Balancer DNS

📊 Monitoring

· CloudWatch Logs: All application logs
· CloudWatch Metrics: CPU, memory, request counts
· Health Checks: ALB target group health checks
· Alarms: CPU utilization, unhealthy hosts, high error rates

🔧 Troubleshooting

Common Issues

Backend won't start

```bash
# Check logs
docker compose logs backend

# Verify MongoDB connection
docker compose exec mongodb mongosh --eval "db.runCommand({ ping: 1 })"
```

Frontend can't reach backend

```bash
# Check if backend is healthy
curl http://localhost:8080/ping

# Verify CORS settings in backend config
```

Port conflicts

```bash
# Check what's using the ports
lsof -i :3000
lsof -i :8080
```

🤝 Contributing

1. Fork the repository
2. Create a feature branch (git checkout -b feature/amazing-feature)
3. Commit changes (git commit -m 'feat: add amazing feature')
4. Push to branch (git push origin feature/amazing-feature)
5. Open a Pull Request

Commit Convention

· feat: New features
· fix: Bug fixes
· docs: Documentation changes
· test: Adding/updating tests
· chore: Maintenance tasks

📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

👥 Authors

· Innocent - @Innocent9712
· Tbraima44 - @Tbraima44

🙏 Acknowledgments

· AltSchool Africa - DevOps Engineering Program
· Gin Framework
· MongoDB Atlas
· AWS