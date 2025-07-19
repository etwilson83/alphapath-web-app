# Azure Network Architecture - WSI Processing App

## * THIS IS A WORK IN PROGRESS *

## Network Boundaries

```
Internet
    |
    | (HTTPS only)
    |
┌───▼───────────────────────────────────────────────────────────┐
│                    Public Zone                                │
│                                                               │
│  ┌─────────────────┐    ┌─────────────────────────────────┐   │
│  │   Static CDN    │    │   Application Gateway + WAF     │   │
│  │   (Vue App)     │    │   (Go API ingress)              │   │
│  └─────────────────┘    └─────────────────────────────────┘   │
│                                    │                          │
└────────────────────────────────────┼──────────────────────────┘
                                     │
                                     ▼
┌───────────────────────────────────────────────────────────────┐
│                       VNet (Private)                          │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                  Private Subnet 1                       │  │
│  │                                                         │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │   Go API    │  │  Postgres   │  │  Prefect Server │  │  │
│  │  │(Container   │  │ (Azure DB)  │  │  (Container     │  │  │
│  │  │ Apps)       │  │             │  │   Apps)         │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │  
│  │                  Private Subnet 2                       │  │
│  │                                                         │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │              Azure Batch Pool                    │   │  │
│  │  │           (No public IPs)                        │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  └─────────────────────────────────────────────────────────┘  │ 
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                  Private Endpoints                      │  │
│  │                                                         │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │              Blob Storage                         │  │  │
│  │  │           (Private endpoint)                      │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

## Traffic Flow

### 1. User Uploads WSI File
```
User → Vue App → Go API → Generates SAS token → User uploads directly to Blob
```

### 2. Processing Pipeline
```
Go API → Prefect API → Spawns Azure Batch jobs → Process from Blob → Results to Blob
```

### 3. Status Updates
```
Prefect → Webhook to Go API → Updates frontend via WebSocket/polling
```

## Security Layers

### **Network Security Groups (NSGs)**
- **Public subnet**: Only 80/443 inbound
- **Private subnet 1**: Only internal traffic + specific ports
- **Private subnet 2**: Only internal traffic from subnet 1

### **Key Components**
- **Application Gateway**: WAF protection, SSL termination
- **Private endpoints**: Blob storage never touches internet
- **Managed identities**: Service-to-service auth without secrets
- **Container Apps**: Built-in VNet integration

### **What you manage**
- VNet + subnets (simple 3-subnet setup)
- NSG rules
- Private endpoints for blob storage
- Application Gateway config

### **What Azure manages**
- Container Apps networking
- Azure Batch pool networking
- Managed database security
- Private endpoint DNS

## Simple but Prod-Ready Checklist

✅ **VNet with 3 subnets** (public gateway, private services, private compute)  
✅ **Application Gateway + WAF** (DDoS protection, SSL)  
✅ **Private endpoints** for blob storage  
✅ **NSGs** locking down inter-subnet traffic  
✅ **Managed identities** for service auth  
✅ **No public IPs** on batch pools