# Terraform Infrastructure

This azd template uses Terraform to provision Azure infrastructure with a modular, scalable approach.

## 🚀 Getting Started

**The template works out of the box with local state:**

```bash
azd init
azd up
```

That's it! No additional setup required.

## 🏗️ Architecture

The infrastructure is organized into clean, reusable modules:

- **PostgreSQL** (`infra/core/database/postgresql/`) - Managed PostgreSQL database
- **Container Apps** (`infra/core/host/containerapps/`) - Backend API hosting
- **Static Web Apps** (`infra/core/host/staticwebapp/`) - Frontend hosting

## 📁 Project Structure

```
infra/
├── main.tf                    # Main infrastructure definition
├── provider.tf                # Azure provider configuration  
├── variables.tf               # Input variables
├── output.tf                  # Output values
└── core/                      # Reusable modules
    ├── database/postgresql/   # PostgreSQL module
    ├── host/containerapps/    # Container Apps module
    └── host/staticwebapp/     # Static Web Apps module
```

## 🔄 Remote State (Optional)

### When to Use Remote State

- **Team development** - Multiple developers working on the same infrastructure
- **CI/CD pipelines** - Automated deployments need shared state
- **Production environments** - State backup and collaboration

### Quick Setup

1. **Create storage resources:**
   ```bash
   # Create resource group for terraform state
   az group create --name "rg-tfstate-myproject" --location "northcentralus"
   
   # Create storage account (name must be globally unique)
   az storage account create \
     --name "tfstatemyproject$(date +%s)" \
     --resource-group "rg-tfstate-myproject" \
     --sku Standard_LRS \
     --encryption-services blob
   
   # Create container
   az storage container create \
     --name "tfstate" \
     --account-name "tfstatemyproject..."
   ```

2. **Update `infra/provider.tf`:**
   ```hcl
   terraform {
     # ... existing configuration ...
     
     backend "azurerm" {
       resource_group_name  = "rg-tfstate-myproject"
       storage_account_name = "tfstatemyproject..."
       container_name       = "tfstate"
       key                  = "terraform.tfstate"
       use_azuread_auth     = true  # Recommended for security
     }
   }
   ```

3. **Migrate existing state:**
   ```bash
   cd infra
   terraform init -migrate-state
   ```

### Authentication Options

**Azure CLI (Recommended for development):**
```hcl
backend "azurerm" {
  # ... storage config ...
  use_cli = true
}
```

**Managed Identity (Recommended for CI/CD):**
```hcl
backend "azurerm" {
  # ... storage config ...
  use_azuread_auth = true
}
```

## 🛠️ Development Workflow

### Local Development
```bash
# Make infrastructure changes
cd infra
terraform plan        # Preview changes
terraform apply       # Apply changes

# Or use azd
azd provision         # Provisions infrastructure only
azd up                # Full deployment (infra + apps)
```

### Adding New Resources

1. **Create or update modules** in `infra/core/`
2. **Reference modules** in `infra/main.tf`
3. **Add outputs** in `infra/output.tf` (exposed as azd environment variables)
4. **Test changes** with `azd provision`

### Environment Variables

Terraform outputs are automatically available as azd environment variables:

```bash
azd env get-values
# POSTGRES_SERVER_FQDN=myserver.postgres.database.azure.com
# BACKEND_APP_URL=https://myapp.azurecontainerapps.io
```

## 🔒 Security Best Practices

- ✅ **Use Azure AD authentication** for state storage
- ✅ **Store secrets in Key Vault** (not in state files)
- ✅ **Use Managed Identity** for resource access
- ✅ **Restrict storage account access** with firewalls/private endpoints
- ✅ **Review terraform plans** before applying

## 🆘 Troubleshooting

**State lock issues:**
```bash
# Force unlock if needed (use carefully)
terraform force-unlock <lock-id>
```

**State out of sync:**
```bash
# Import existing resources
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/...

# Refresh state
terraform refresh
```

**Start fresh:**
```bash
# Reset to local state
rm -rf .terraform
terraform init
```

## 📚 Learn More

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Developer CLI Documentation](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)
- [Terraform State Management](https://developer.hashicorp.com/terraform/language/state) 