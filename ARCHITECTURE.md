# 🏗️ Architecture

## Overview

This application is a full-stack todo platform composed of a React frontend, a Go backend, and supporting infrastructure for caching and persistence.

> This document is written in a GitHub-friendly format using plain Markdown and an ASCII diagram so it renders reliably on GitHub.

### Core components

- **Frontend**: React + TypeScript user interface
- **Backend**: Go + Gin REST API
- **Cache**: Redis 7
- **Database**: MongoDB 7
- **Local orchestration**: Docker Compose

## Architecture diagram

```

┌─────────────────────────────────────────────────────────┐
│                      Client Browser                      │
└───────────────┬─────────────────────┬───────────────────┘
│                     │
┌───────▼──────┐      ┌──────▼──────┐
│  CloudFront  │      │     ALB     │
│     CDN      │      │  (HTTP/HTTPS)│
└───────┬──────┘      └──────┬──────┘
│                     │
┌───────▼──────┐      ┌──────▼──────┐
│  S3 Bucket   │      │  EC2 Auto   │
│  (Static)    │      │  Scaling    │
└──────────────┘      │  Group      │
└──────┬──────┘
│
┌────────────┼────────────┐
│            │            │
┌───────▼──────┐ ┌──▼────┐ ┌─────▼─────┐
│   Backend    │ │ Redis │ │ MongoDB   │
│   (Go API)   │ │ Cache │ │ (Atlas)   │
└──────────────┘ └───────┘ └───────────┘

```

## Request flow

1. The user opens the frontend in the browser.
2. The React app communicates with the Go API.
3. The backend applies request validation, middleware, and business logic.
4. The backend reads or writes todo data in MongoDB.
5. Redis is used as a cache layer for fast access and reduced database load.

## Deployment view

- **Local development**: Docker Compose starts the frontend, backend, Redis, and MongoDB containers.
- **Production path**: The README describes an AWS deployment flow using S3, CloudFront, ALB, EC2, and ECR.

