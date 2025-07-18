# AZD Template: Go + Vue.js + PostgreSQL

A production-ready Azure Developer CLI (azd) template demonstrating a full-stack application with Go backend, Vue.js frontend, and PostgreSQL database. This template includes basic security configurations suitable for cloud deployment.

## Architecture

- **Frontend**: Vue.js 3 with TypeScript (deployed to Azure Container Apps)
- **Backend**: Go with Gin framework (deployed to Azure Container Apps)
- **Database**: PostgreSQL (Azure Database for PostgreSQL)
- **Infrastructure**: Terraform for Azure resources

## Security Features

This template implements basic security patterns suitable for cloud-hosted web applications:

### Backend Security
- **CORS Configuration**: Domain-specific CORS policies (no wildcard origins)
- **HTTPS Enforcement**: Automatic HTTPS redirects and security headers in production
- **Request Validation**: Content-type validation and request size limits (1MB)
- **Security Headers**: 
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `X-XSS-Protection: 1; mode=block`
  - `Strict-Transport-Security` (production only)

### Frontend-Backend Communication
- **Environment-based API URLs**: Configurable backend endpoints (no hardcoded URLs)
- **Secure Cross-Origin Requests**: Proper CORS configuration

## Deployment

The infrastructure automatically wires the services together with proper URLs:

```bash
# Deploy the complete stack
azd deploy
```

### Service URLs
After deployment, the services are connected as follows:
- Frontend calls backend via `VITE_API_URL` (injected at build time)
- Backend allows CORS requests from `FRONTEND_URL` (set by infrastructure)

### Environment Variables
The deployment automatically configures:
- `FRONTEND_URL`: Static Web App URL → passed to Container Apps for CORS
- `VITE_API_URL`: Container Apps URL → injected into frontend build

## Local Development

For local development with security features:

```bash
# Start all services
./scripts/dev.sh

# Services will be available at:
# Frontend: http://localhost:3000
# Backend:  http://localhost:8080
# Database: postgresql://developer:developer123@localhost:5432/research_app
```

In development mode:
- CORS allows `http://localhost:3000` (configurable via `FRONTEND_URL`)
- HTTPS enforcement is disabled
- Security headers are still applied

## Template Security Notes

This template demonstrates **basic** security patterns suitable for a template:

✅ **Included**:
- Domain-specific CORS
- HTTPS enforcement
- Basic request validation
- Security headers

🚫 **Not Included** (add per-project):
- Authentication/authorization
- Custom domains with certificates
- WAF rules
- Private networking (VNets)
- Advanced monitoring/alerting

The goal is to show secure communication patterns while keeping the template simple and deployable out-of-the-box.

## API Endpoints

- `GET /health` - Health check
- `GET /api/hello` - Demo endpoint with database integration
- `GET /api/users` - List users
- `POST /api/users` - Create user
- `GET /api/users/{id}` - Get user by ID
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

## Other Notes
### Cold Start Behavior

Both frontend and backend containers are configured with `min_replicas = 0`, meaning they will scale to zero when idle. Azure Container Apps has a **fixed 5-minute idle timeout** that cannot be configured - after 5 minutes of no traffic, containers automatically scale to zero.

When you first visit the app or after 5+ minutes of inactivity, you'll experience cold starts:
- Frontend: ~2-3 seconds to start container
- Backend: ~3-5 seconds to start container + establish database connection

This is normal behavior for cost optimization in development environments. To eliminate cold starts, set `min_replicas = 1` in the Terraform configuration, but this will increase costs as containers stay running.  
  
https://github.com/microsoft/azure-container-apps/issues/597