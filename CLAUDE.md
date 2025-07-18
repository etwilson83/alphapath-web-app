# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Azure Developer CLI (azd) template for a full-stack application with:
- **Backend**: Go with Gin framework and PostgreSQL
- **Frontend**: Vue.js 3 with TypeScript, Pinia, and TailwindCSS
- **Infrastructure**: Terraform for Azure Container Apps deployment
- **Database**: PostgreSQL (local Docker for dev, Azure Database for production)

## Development Commands

### Full Development Environment
```bash
# Start complete development stack (requires Docker)
./scripts/dev.sh

# Stop and clean up
./scripts/clean.sh

# Clean with data removal (destructive)
./scripts/clean.sh --data
```

### Backend (Go)
```bash
cd backend

# Run locally (requires .env file)
go run cmd/api/main.go

# Run tests with coverage
go test -v -cover ./...

# Lint (requires golangci-lint)
golangci-lint run
```

### Frontend (Vue.js)
```bash
cd frontend

# Install dependencies
npm install  # or pnpm install

# Development server
npm run dev

# Build for production
npm run build

# Type checking
npm run type-check

# Run unit tests
npm run test:unit
```

### Testing
```bash
# Run full test suite for both backend and frontend
./scripts/test.sh
```

## Architecture

### Service Communication
- Frontend communicates with backend via `VITE_API_URL` environment variable
- Backend allows CORS requests from `FRONTEND_URL` (configurable)
- Local development: Frontend (3000) → Backend (8080) → PostgreSQL (5432)

### Backend Structure
- `cmd/api/main.go`: Application entry point
- `internal/api/`: HTTP handlers, middleware, and routing
- `internal/config/`: Environment configuration management
- `internal/database/`: Database connection and migrations
- `internal/models/`: Data models and business logic

### Frontend Structure
- Vue 3 composition API with TypeScript
- Pinia for state management
- Vue Router for navigation
- TailwindCSS + DaisyUI for styling
- Vitest for unit testing

### Security Features
- CORS configuration with domain-specific origins
- HTTPS enforcement in production
- Security headers (X-Content-Type-Options, X-Frame-Options, etc.)
- Request validation and size limits

## Key Configuration Files

- `docker-compose.yml`: Local development environment
- `backend/internal/config/config.go`: Backend configuration management
- `frontend/vite.config.ts`: Frontend build configuration
- `infra/main.tf`: Azure infrastructure as code

## Database

### Local Development
- PostgreSQL runs in Docker container
- Connection: `postgresql://developer:developer123@localhost:5432/research_app`
- Migrations run automatically on backend startup
- Initial schema: `scripts/init-db.sql`

### Database Shell Access
```bash
docker-compose exec postgres psql -U developer -d research_app
```

## API Endpoints

- `GET /health` - Health check
- `GET /api/hello` - Demo endpoint with database integration  
- `GET /api/users` - List users
- `POST /api/users` - Create user
- `GET /api/users/{id}` - Get user by ID
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

## Deployment

The application deploys to Azure Container Apps using Terraform:
- Frontend and backend run as separate container apps
- PostgreSQL uses Azure Database for PostgreSQL
- Container images built and pushed to Azure Container Registry
- Environment variables automatically configured for service communication

```bash
# Deploy to Azure (requires azd CLI)
azd deploy
```