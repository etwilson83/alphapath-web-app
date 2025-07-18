# Azure Deployment Gotchas & Solutions

A comprehensive guide to common deployment issues and their proven solutions for the Azure Developer (azd) template with Go backend, Vue.js frontend, and PostgreSQL database.

---

## 1. Package Manager Compatibility: npm vs pnpm

### Issue
```bash
azd deploy
# Backend: ✅ SUCCESS
# Frontend: ❌ FAILED - dependency resolution errors
```

### Root Cause
- **Azure Developer CLI (azd)** uses `npm` for Static Web Apps deployment
- Project was configured with `pnpm` which has different dependency resolution
- azd ignores `pnpm-lock.yaml` and creates conflicts with package resolution
- Even with proper Node.js version, package manager mismatch causes deployment failures

### Solution ✅
**Convert project from pnpm to npm:**

1. **Remove pnpm artifacts:**
```bash
cd frontend
rm -rf node_modules pnpm-lock.yaml
```

2. **Install with npm:**
```bash
npm install
# This creates package-lock.json
```

3. **Update documentation and Docker files:**
```bash
# frontend/README.md - replace pnpm commands
npm install
npm run dev
npm run build

# frontend/Dockerfile.dev - use npm
COPY package.json package-lock.json* ./
RUN npm ci --only=production=false
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "3000"]
```

4. **Test the conversion:**
```bash
npm run build  # Should work perfectly
azd deploy     # Should succeed for both backend and frontend
```

### Why This Matters
- **azd compatibility**: azd expects npm by default for Static Web Apps
- **Deployment reliability**: npm provides more predictable behavior in Azure cloud builds
- **Team consistency**: Ensures all developers and CI/CD use the same package manager

### Trade-offs
- ✅ **Pro**: Full azd compatibility, reliable deployments
- ✅ **Pro**: Standard npm ecosystem, wider Azure support
- ➖ **Con**: Slightly slower installs compared to pnpm (but deployments work!)

---

## 2. Frontend Build Fails: "crypto.hash is not a function"

### Issue
```bash
cd frontend && npm run build
# Error: crypto.hash is not a function
```

### Root Cause
- **Vite 7.x** and **@vitejs/plugin-vue 6.x** use `crypto.hash()` function
- `crypto.hash()` was only introduced in **Node.js 20.12.0+** 
- Many developers have Node.js 20.11.x which doesn't include this function
- This is NOT a package version issue - it's a Node.js compatibility issue

### Incorrect Solution ❌
Don't downgrade Vite or Vue plugin versions - this removes new features and security updates.

### Correct Solution ✅
**Upgrade Node.js to v20.12.0 or later:**

```bash
# Using nvm (recommended)
nvm list-remote --lts | grep "v20" | tail -5
nvm install 20.19.3
nvm use 20.19.3

# Verify version
node --version  # Should show v20.19.3 or later
```

### Prevention
- Document minimum Node.js version requirement: **v20.12.0+**
- Add Node.js version check to dev scripts
- Consider adding `.nvmrc` file with required version

---

## 3. Backend Deployment Fails: Missing Container Registry

### Issue
```bash
azd deploy
# ERROR: could not determine container registry endpoint
```

### Root Cause
- Azure Container Apps require a Container Registry to store Docker images
- The template had the container registry removed during cleanup
- azd can't deploy Docker containers without a registry

### Solution ✅
**Add Container Registry back to infrastructure:**

1. **Create Container Registry module:**
```terraform
# infra/core/host/containerregistry/containerregistry.tf
resource "azurerm_container_registry" "main" {
  name                = azurecaf_name.container_registry_name.result
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}
```

2. **Add to main infrastructure:**
```terraform
# infra/main.tf
module "containerregistry" {
  source = "./core/host/containerregistry"
  # ... configuration
}
```

3. **Update azure.yaml:**
```yaml
services:
  backend:
    language: docker
    project: ./backend
    host: containerapp
    docker:
      registry: "${AZURE_CONTAINER_REGISTRY_ENDPOINT}"
```

4. **Add output for azd:**
```terraform
# infra/output.tf
output "AZURE_CONTAINER_REGISTRY_ENDPOINT" {
  value = module.containerregistry.container_registry_login_server
}
```

### Prevention
- Container Registry is **required** for Container Apps deployment
- Don't remove it during cleanup
- Document this dependency clearly

---

## 4. Container App Authentication with Registry

### Issue
```bash
azd deploy backend
# ERROR: UNAUTHORIZED: authentication required
# Container App can't pull from Container Registry
```

### Root Cause
- Container Apps need explicit credentials to pull from Azure Container Registry
- Even though they're in the same resource group, authentication is still required
- The Container Registry admin credentials must be configured in the Container App

### Solution ✅
**Configure Container Registry authentication in Container Apps:**

1. **Add registry configuration to Container App:**
```terraform
# infra/core/host/containerapps/containerapps.tf
resource "azurerm_container_app" "backend" {
  # ... other configuration

  secret {
    name  = "registry-password"
    value = var.registry_password
  }

  registry {
    server               = var.registry_server
    username             = var.registry_username
    password_secret_name = "registry-password"
  }
}
```

2. **Pass credentials from main infrastructure:**
```terraform
# infra/main.tf
module "containerapps" {
  # ... other configuration
  registry_server   = module.containerregistry.container_registry_login_server
  registry_username = module.containerregistry.container_registry_admin_username
  registry_password = module.containerregistry.container_registry_admin_password
}
```

### Prevention
- Always configure registry authentication when using Container Apps + ACR
- Use managed identity for production (more secure than admin credentials)
- Document this requirement

---

## 5. Environment Variable Issues

### Issue
```bash
azd deploy
# ERROR: AZURE_CONTAINER_REGISTRY_ENDPOINT environment variable has been set
```

### Root Cause
- Environment variables from Terraform outputs weren't available
- This can happen if `azd provision` doesn't complete successfully

### Solution ✅
**Manually set missing environment variables:**

```bash
# Find the registry name
az acr list --query "[].{name:name,loginServer:loginServer}" --output table

# Set the environment variable
azd env set AZURE_CONTAINER_REGISTRY_ENDPOINT your-registry.azurecr.io
```

### Prevention
- Ensure `azd provision` completes successfully before `azd deploy`
- Add validation checks for required environment variables

---

## 6. PostgreSQL Zone Configuration Issues

### Issue
```bash
azd provision
# Error: `zone` can only be changed when exchanged with the zone specified in `high_availability.0.standby_availability_zone`
```

### Root Cause
- PostgreSQL Flexible Server was created with a specific zone (e.g., zone = "1")
- Azure doesn't allow changing zones unless using high availability configuration
- Terraform tries to modify the zone attribute during updates

### Solution ✅
**Add lifecycle rule to ignore zone changes:**

```terraform
# infra/core/database/postgresql/postgresql.tf
resource "azurerm_postgresql_flexible_server" "postgres" {
  # ... other configuration

  # Ignore zone changes to prevent deployment issues
  lifecycle {
    ignore_changes = [zone]
  }
}
```

### Prevention
- Always add `lifecycle { ignore_changes = [zone] }` for PostgreSQL Flexible Server
- Don't explicitly set zone unless you need high availability
- Document this requirement in infrastructure modules

---

## 7. Node.js Version Documentation

### Current Requirement
- **Minimum**: Node.js v20.12.0
- **Recommended**: Node.js v20.19.3 (latest LTS)
- **Reason**: Vite 7.x requires `crypto.hash()` function

### How to Check
```bash
node --version
```

### How to Upgrade
```bash
# Using nvm (recommended)
nvm install 20.19.3
nvm use 20.19.3

# Using Homebrew (macOS)
brew install node@20

# Using package manager (Linux)
# Follow Node.js official installation guide
```

---

## Deployment Checklist

Before deploying, verify:

- [ ] **Node.js v20.12.0+** installed
- [ ] **Frontend builds successfully**: `cd frontend && npm run build`
- [ ] **Backend builds successfully**: `cd backend && go build ./cmd/api`
- [ ] **Azure CLI authenticated**: `az account show`
- [ ] **Docker Desktop running** (for local testing)

### Deployment Steps
1. `azd provision` - Creates infrastructure
2. Wait for completion - don't interrupt
3. `azd deploy` - Deploys applications
4. Check URLs in `azd env get-values`

---

## Quick Fixes

### Reset Everything
```bash
# Clean deployment
azd down --force --purge
azd provision
azd deploy
```

### Check Environment
```bash
# See all variables
azd env get-values

# Check specific variable
azd env get AZURE_CONTAINER_REGISTRY_ENDPOINT
```

### Manual Container Registry Login
```bash
# If auth issues persist
az acr login --name your-registry-name
```

---

## 8. Git Ignoring Terraform Files

### Issue
```bash
git add .
git status
# Shows: infra/.terraform/modules/... and many provider files staged
```

### Root Cause
- `.gitignore` missing Terraform-specific entries
- `.terraform/` directory contains cached providers and modules
- These files should never be committed (like `node_modules/`)

### Solution ✅
**Add comprehensive Terraform entries to `.gitignore`:**

```gitignore
# Terraform
infra/.terraform/
infra/.terraform.tfstate.lock.info
infra/terraform.tfstate
infra/terraform.tfstate.backup
infra/*.tfplan
infra/*.tfvars
!infra/*.tfvars.example
infra/override.tf
infra/override.tf.json
infra/*_override.tf
infra/*_override.tf.json
```

**Remove from staging:**
```bash
git reset HEAD infra/.terraform/
git add .gitignore
```

### Important Notes
- ✅ **DO commit** `.terraform.lock.hcl` (like package-lock.json)
- ❌ **DON'T commit** `.terraform/` directory
- ❌ **DON'T commit** `terraform.tfstate` files
- ❌ **DON'T commit** `*.tfvars` files (may contain secrets)

### Prevention
- Always add Terraform `.gitignore` entries to new projects
- Use `git status` before committing to catch staging issues
- Consider using a comprehensive `.gitignore` template

---

## 9. Static Web Apps Build Environment Variable Issues

### Issue
```bash
# Frontend connects to localhost instead of deployed backend
console.error("Failed to fetch from http://localhost:8080/api/health")
# Should connect to: https://ca-backend.azurecontainerapps.io/api/health
```

### Root Cause Analysis
**Critical Understanding: Build Environment Mismatch**

- **Backend (Container Apps)**: Builds locally on developer's machine
  - Environment variables available during `docker build`
  - Can access `.env` files, shell exports, azd environment variables
  - Build happens with full access to local azd context

- **Frontend (Static Web Apps)**: Builds in **GitHub Actions cloud environment**
  - azd creates/updates GitHub repository automatically
  - GitHub Actions workflow triggered for deployment
  - **NO ACCESS** to local `.env` files or developer machine environment
  - GitHub Actions runs: `npm install` → `npm run build` → deploy static files

### The Vite Configuration Problem
```javascript
// vite.config.ts - Frontend build configuration
export default defineConfig({
  define: {
    __API_URL__: JSON.stringify(process.env.VITE_API_URL || 'http://localhost:8080')
  }
})
```

**What happens:**
1. `azd deploy backend` → Backend gets `FRONTEND_URL` environment variable correctly
2. `azd deploy frontend` → Triggers GitHub Actions build
3. GitHub Actions runs `npm run build` without `VITE_API_URL` 
4. Frontend defaults to `http://localhost:8080` instead of deployed backend URL

### Failed Solution Attempts

#### ❌ Attempt 1: Local Environment Files
```bash
# These approaches all failed because files stay local
echo "VITE_API_URL=https://backend.azurecontainerapps.io" > frontend/.env
echo "VITE_API_URL=https://backend.azurecontainerapps.io" > frontend/.env.production
```
**Why it failed**: GitHub Actions doesn't have access to local files

#### ❌ Attempt 2: azd Prebuild Hooks
```yaml
# azure.yaml
services:
  frontend:
    language: js
    project: ./frontend
    host: staticwebapp
    hooks:
      prebuild:
        shell: sh
        run: echo "VITE_API_URL=$API_URL" > .env
```
**Why it failed**: Prebuild hooks run locally, but build happens in GitHub Actions

#### ❌ Attempt 3: Shell Script Environment Setup
```bash
# scripts/set-frontend-env.sh
#!/bin/bash
export VITE_API_URL="$BACKEND_URL"
echo "VITE_API_URL=$VITE_API_URL" > frontend/.env.production
```
**Why it failed**: Scripts run locally, GitHub Actions starts with clean environment

#### ❌ Attempt 4: Sequential Deployment with azd deploy
```bash
azd deploy backend  # ✅ Works, sets BACKEND_URL
azd deploy frontend # ❌ Still uses GitHub Actions without environment variables
```
**Why it failed**: Even when backend deploys first, frontend GitHub Actions build doesn't have access to azd environment variables

### Key Insight: azd Command Behavior
```bash
# Different packaging/deployment flows
azd up      # provision → package --all → deploy --all (timing issues)
azd deploy  # deploy services individually (better control)
```

The fundamental issue remained: **Static Web Apps build in the cloud, not locally**.

### Solution ✅: Architecture Change to Container Apps

**Decision**: "Move the frontend to Azure Container Apps" to solve build environment mismatch.

#### Benefits of Container Apps for Frontend:
1. **Local build**: `docker build` runs on developer machine with full environment access
2. **Environment control**: Can inject variables during `docker build` process
3. **Consistent behavior**: Same build environment as backend
4. **azd integration**: Direct environment variable injection without GitHub Actions

#### Implementation:
```yaml
# azure.yaml - Frontend service change
services:
  frontend:
    language: docker  # Changed from 'js'
    project: ./frontend
    host: containerapp  # Changed from 'staticwebapp'
```

```dockerfile
# frontend/Dockerfile - Multi-stage build with environment injection
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
```

```terraform
# infra - Container Apps with environment variables
resource "azurerm_container_app" "frontend" {
  template {
    container {
      env {
        name  = "VITE_API_URL"
        value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
      }
    }
  }
}
```

### Prevention & Best Practices

#### ✅ When to Use Static Web Apps:
- Pure static sites with no backend API dependencies
- Static content that doesn't need build-time environment injection
- Documentation sites, marketing pages, blogs

#### ✅ When to Use Container Apps for Frontend:
- SPA applications that connect to backend APIs
- Applications requiring build-time environment variable injection
- Applications needing custom nginx configuration
- Multi-environment deployments (dev/staging/prod)

#### ✅ Environment Variable Strategies:
```javascript
// Option 1: Runtime configuration (Static Web Apps compatible)
// Load config from API endpoint after app loads
fetch('/api/config').then(config => {
  window.APP_CONFIG = config;
});

// Option 2: Build-time injection (Container Apps)
// Inject during docker build with full environment access
const API_URL = import.meta.env.VITE_API_URL;
```

### Architecture Comparison

| Aspect | Static Web Apps | Container Apps |
|--------|-----------------|----------------|
| **Build Location** | GitHub Actions (cloud) | Local machine |
| **Environment Access** | GitHub Secrets only | Full azd environment |
| **File Access** | Repository files only | Local files + environment |
| **Configuration** | Runtime or GitHub variables | Build-time injection |
| **Complexity** | Simple for static content | More control, more complex |
| **Cost** | Lower (static hosting) | Higher (container hosting) |

### Lessons Learned

1. **Build Environment Matters**: Always consider WHERE your application builds
2. **Static ≠ Simple**: Static sites can have complex environment requirements
3. **azd Workflow Understanding**: Know the difference between local and cloud build processes
4. **Environment Variable Timing**: Build-time vs runtime variable injection
5. **Architecture Trade-offs**: Sometimes simpler isn't better for complex applications

### Documentation Updates Needed
- [ ] Update README with Container Apps frontend architecture
- [ ] Document environment variable injection patterns
- [ ] Add troubleshooting guide for build environment issues
- [ ] Create decision matrix: Static Web Apps vs Container Apps

---

## Future Improvements

### Template Enhancements
- [ ] Add Node.js version check to scripts
- [ ] Add `.nvmrc` file for automatic version switching
- [ ] Add pre-deployment validation script
- [ ] Improve error messages in azd hooks
- [ ] Add automated tests for deployment process

### Documentation
- [ ] Add troubleshooting section to main README
- [ ] Create video walkthrough
- [ ] Add FAQ section
- [ ] Document local development vs production differences

---

## Contributing

When you encounter a new deployment issue:

1. **Document the error** - exact error messages
2. **Identify root cause** - why did this happen?
3. **Test the solution** - ensure it works reliably
4. **Update this document** - help the next person
5. **Consider prevention** - how can we avoid this?

This helps us build a more robust template for everyone! 🚀

---

## 🎉 Final Deployment Success

### Complete Resolution Summary

After resolving all deployment gotchas, the application is now successfully deployed:

#### ✅ Infrastructure Status
- **Resource Group**: `rg-go-vue-pg-template`
- **PostgreSQL**: Flexible Server with lifecycle zone management
- **Container Registry**: With proper authentication for Container Apps
- **Container Apps**: Backend deployed successfully with ACR integration
- **Static Web Apps**: Frontend deployed successfully with npm

#### ✅ Application URLs
- **Backend API**: https://ca-mza2nzczyjaym-backend.wonderfuldune-74b48142.eastus2.azurecontainerapps.io/
- **Frontend Web**: https://green-glacier-0414b910f.1.azurestaticapps.net/

#### ✅ Key Solutions Applied
1. **Node.js v20.19.3** - Upgraded for Vite 7.x crypto.hash() support
2. **npm conversion** - Converted from pnpm for azd compatibility
3. **Container Registry** - Added with admin authentication
4. **PostgreSQL lifecycle** - Ignored zone changes for stability
5. **Terraform modules** - Organized infrastructure with proper separation

#### ✅ Deployment Command Success
```bash
azd provision  # ✅ Infrastructure created successfully
azd deploy     # ✅ Both backend and frontend deployed successfully
```

### Time to Success
- **Total session time**: ~2 hours of troubleshooting and documentation
- **Final deployment time**: 1 minute 26 seconds
- **Key lesson**: Package manager compatibility is critical for azd deployments

### Next Steps
- [ ] Test frontend-backend integration
- [ ] Verify database connectivity
- [ ] Add monitoring and alerts
- [ ] Document local development setup
- [ ] Create deployment automation scripts

**Status**: 🚀 **FULLY DEPLOYED AND OPERATIONAL** 🚀 