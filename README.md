# CST8918-G12-Final: Weather Application

## Project Overview

This is a weather application based on the Azure cloud platform, using Terraform for Infrastructure as Code (IaC) management. The project adopts a microservices architecture, including a frontend weather application and backend infrastructure modules. This project demonstrates DevOps practices with automated CI/CD pipelines using GitHub Actions.

## Team Members

- **Team Member 1**: Yutian Du [DytAC](https://github.com/DytAC-study) - Backend Infrastructure & Terraform Modules
- **Team Member 2**: Cong Zhao [zhao0294](https://github.com/zhao0294) - Application Deployment & Kubernetes Configuration  
- **Team Member 3**: Jianyi Fan [JianyiF](https://github.com/JianyiF), [nealfan01](https://github.com/nealfan01) - Frontend Development & Documentation
                      (both account are used to commit, nealfan01 are used locally when commit)

## Project Architecture

```
CST8918-G12-Final/
├── .github/workflows/         # GitHub Actions CI/CD
│   └── complete-pipeline.yml  # Unified CI/CD pipeline
├── environments/              # Environment Configurations
│   ├── dev/                   # Development environment
│   ├── test/                  # Testing environment (ACTIVE)
│   └── prod/                  # Production environment
├── modules/                   # Terraform Modules
│   ├── backend/               # Azure backend infrastructure
│   ├── network/               # Network infrastructure
│   ├── aks/                   # AKS cluster configuration
│   └── weather-app/           # Weather application deployment
├── weather-app/               # Node.js Weather Application
│   ├── src/                   # Application source code
│   ├── app.js                 # Main application file
│   ├── package.json           # Dependency management
│   └── Dockerfile             # Containerization configuration
└── README.md                  # Project documentation
```

## Current Deployment Status

### Successfully Deployed Components

- **AKS Cluster**: `test-aks` running in East US region
- **Azure Container Registry**: `cst8918acr` with weather-app image
- **Network Infrastructure**: Virtual network with proper subnet configuration
- **Weather Application**: Successfully deployed and **externally accessible**
- **Load Balancer**: External IP `52.255.209.132` with proper health checks
- **CI/CD Pipeline**: Complete automated deployment pipeline

### **LIVE APPLICATION ACCESS**

**External URL**: http://4.157.192.48

**Available Endpoints**:
- **Health Check**: `GET /health` - Returns application status
- **Weather API**: `GET /api/weather?city={city}` - Returns weather data
- **Main Page**: `GET /` - Interactive weather application UI

**Example API Response**:
```json
{
  "city": "Toronto",
  "temperature": 32,
  "condition": "Clouds", 
  "description": "broken clouds",
  "humidity": 42,
  "windSpeed": 5,
  "pressure": 1016,
  "icon": "04d"
}
```

### Major Challenges Encountered and Solutions

#### 1. Terraform State Locking Issues
**Problem**: State blob already locked during deployment
```
Error: Error acquiring the state lock
Error message: state blob is already locked
```
**Root Cause**: Concurrent Terraform operations or interrupted deployments
**Solution**:
- Used `-lock-timeout=300s` for Terraform commands
- Added `terraform init` before apply operations
- Ensured consistent provider versions with `.terraform.lock.hcl`

#### 2. External Access Issues
**Problem**: LoadBalancer external IP not accessible
```
Error: Connection timeout when accessing LoadBalancer IP
```
**Root Cause**: NSG rules blocking external access and missing LoadBalancer annotations
**Solution**:
- **Removed blocking NSG rule**: `deny-all-inbound` rule was preventing external access
- **Added LoadBalancer annotations**:
  - `service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path: "/health"`
  - `service.beta.kubernetes.io/azure-load-balancer-internal: "false"`
- **Updated NSG rules**: Changed `allow-http` source prefix from `10.0.0.0/8` to `*`

#### 3. Resource Constraints in AKS
**Problem**: Pods stuck in `Pending` state due to CPU exhaustion
```
Error: 0/1 nodes are available: 1 Insufficient cpu
```
**Root Cause**: AKS managed components consuming CPU resources
**Solution**:
- **Reduced resource requirements**: Changed CPU requests from 250m to 100m, limits from 500m to 200m
- **Reduced replica count**: Changed from 2 to 1 replica to fit node capacity
- **Optimized deployment**: Removed unnecessary deployments to free up resources

#### 4. Workflow Trigger Issues
**Problem**: GitHub Actions workflows not triggering on pull requests
**Root Cause**: Workflow configuration and trigger detection issues
**Solution**:
- **Added trigger comments**: Added comments to force workflow execution
- **Updated workflow configuration**: Ensured proper trigger conditions
- **Fixed namespace references**: Updated all kubectl commands to use `weather-app` namespace

#### 5. Health Check Timeouts
**Problem**: `kubectl wait` timeout for LoadBalancer service readiness
```
Error: timeout waiting for service to be ready
```
**Root Cause**: LoadBalancer provisioning delays and external access issues
**Solution**:
- **Replaced `kubectl wait`**: Used direct IP check with `timeout` and `grep`
- **Added internal access test**: Test internal connectivity before external
- **Increased timeout values**: Extended timeouts for Azure network propagation

#### 6. Module Configuration Issues
**Problem**: Reference to undeclared resources in Terraform modules
```
Error: Reference to undeclared resource
```
**Root Cause**: Removed data sources but references remained in outputs
**Solution**:
- **Cleaned up network module**: Removed unused subnet data sources
- **Updated environment configs**: Changed subnet references to use available resources
- **Fixed AKS module**: Changed Log Analytics from data source to resource

## Latest Workflow Status

**Current Pipeline**: Complete CI/CD pipeline with enhanced error handling
- **Static Analysis**: Terraform validation and security scanning
- **Build Application**: Docker image build and push to ACR
- **Terraform Apply**: Infrastructure deployment to test environment
- **Deploy Application**: Kubernetes deployment with health checks
- **Health Check**: External access validation

### Application Access

**External URL**: http://4.157.192.48

<img width="1916" height="867" alt="image" src="https://github.com/user-attachments/assets/ee54fa18-5aea-4ee6-b8af-9ea0d336cc92" />

**Available Endpoints**:
- **Health Check**: `GET /health` - Returns application status
- **Weather API**: `GET /api/weather?city={city}` - Returns weather data
- **Main Page**: `GET /` - Interactive weather application UI

**Example API Response**:
```json
{
  "city": "Toronto",
  "temperature": 32,
  "condition": "Clouds", 
  "description": "broken clouds",
  "humidity": 42,
  "windSpeed": 5,
  "pressure": 1016,
  "icon": "04d"
}
```



## Technology Stack

- **Frontend**: Node.js, Express.js
- **Infrastructure**: Terraform, Azure
- **Containerization**: Docker
- **Orchestration**: Azure Kubernetes Service (AKS)
- **CI/CD**: GitHub Actions
- **API**: OpenWeatherMap API
- **Registry**: Azure Container Registry (ACR)

## Features

- Real-time weather information query
- Global city search support
- Modern responsive UI design
- High-performance application
- Automated deployment process
- Multi-environment support (dev, test, prod)
- Secure infrastructure with network policies

## Infrastructure Requirements

### Network Configuration
- **Virtual Network**: `10.0.0.0/14`
- **Test Subnet**: `10.1.0.0/16` (ACTIVE)
- **Network Security Group**: Properly configured for external access

### AKS Clusters
- **Test Environment**: 1 node, Standard_B2s VM, Kubernetes 1.32 (ACTIVE)

### Azure Resources
- Azure Blob Storage (Terraform backend)
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)

## Quick Start

### Prerequisites

- Azure CLI
- Terraform
- Docker
- Node.js (for local development)
- GitHub account with repository access

### Local Development

1. **Clone the repository**
```bash
git clone https://github.com/DytAC-study/CST8918-G12-Final.git
cd CST8918-G12-Final
```

2. **Install dependencies**
```bash
cd weather-app
npm install
```

3. **Set environment variables**
```bash
export OPENWEATHER_API_KEY="your_api_key_here"
export PORT=3000
```

4. **Start the application**
```bash
npm start
```

The application will run at `http://localhost:3000`

### Cloud Deployment

1. **Initialize Terraform**
```bash
cd environments/test
terraform init
```

2. **Configure Azure authentication**
```bash
az login
```

3. **Deploy infrastructure**
```bash
terraform plan
terraform apply
```

4. **Deploy the application**
```bash
kubectl apply -f environments/test/weather-service.yaml
```

## GitHub Actions Workflow

### Complete CI/CD Pipeline (`complete-pipeline.yml`)

Our project uses a **single unified workflow** that executes all steps in sequence:

#### **Step 1: Static Analysis**
- Terraform format checking
- Terraform validation
- TFLint analysis
- tfsec security scanning
- Runs on every push and PR

#### **Step 2: Build Application**
- Multi-platform Docker image build
- Push to Azure Container Registry
- Depends on successful static analysis

#### **Step 3: Terraform Planning** (PR only)
- Plan infrastructure changes for all environments
- Upload plan artifacts for review
- Runs only on pull requests

#### **Step 4: Terraform Apply** (Main branch only)
- Apply infrastructure changes to test environment
- Check for resource drift
- Validate state after deployment
- Runs only on push to main branch

#### **Step 5: Deploy Application**
- Deploy to test environment
- Wait for deployment status
- Health check validation

#### **Step 6: Drift Detection**
- Check for resource drift in test environment
- Report any inconsistencies
- Runs after successful deployment

### Workflow Dependencies
```
static-analysis → build-app → terraform-plan (PR)
                ↓
static-analysis → build-app → terraform-apply → deploy-app → drift-check (Main)
```

## Project Structure Details

### Backend Module (`modules/backend/`)
- Azure resource group management
- Storage account configuration
- Network infrastructure

### Network Module (`modules/network/`)
- Virtual network with specified IP ranges
- Test subnet configuration
- Network security groups with proper firewall rules

### AKS Module (`modules/aks/`)
- Kubernetes cluster configuration
- Node pool management
- Network integration
- API server authorized IP ranges

### Weather App Module (`modules/weather-app/`)
- Azure Container Registry
- Kubernetes deployment and service
- Resource limits and requests optimization

### Weather Application (`weather-app/`)
- Express.js web server
- OpenWeatherMap API integration
- Responsive frontend interface

## API Documentation

### Weather Query API
- **Endpoint**: `/api/weather`
- **Method**: GET
- **Parameters**: `city` (city name)
- **Returns**: JSON format weather data

Example request:
```bash
curl "http://4.157.192.48/api/weather?city=Toronto"
```

Example response:
```json
{
  "city": "Toronto",
  "temperature": 32,
  "condition": "Clouds",
  "description": "broken clouds",
  "humidity": 42,
  "windSpeed": 5,
  "pressure": 1016,
  "icon": "04d"
}
```

## Environment Variables

| Variable Name | Description | Required |
|---------------|-------------|----------|
| `OPENWEATHER_API_KEY` | OpenWeatherMap API key | Yes |
| `PORT` | Application port | No (default: 3000) |

## Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Create a Pull Request

### Branch Protection Rules
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Require at least one approving review before merging

## Deployment Environments

### Test Environment (ACTIVE)
- **Purpose**: Integration testing and validation
- **Resources**: 1 AKS node, LoadBalancer service
- **Access**: Externally accessible at http://4.157.192.48
- **Status**: Successfully deployed and accessible

### Development Environment
- **Purpose**: Local development and testing
- **Resources**: Minimal for cost optimization
- **Access**: Development team only

### Production Environment
- **Purpose**: Live application serving
- **Resources**: Auto-scaling AKS (1-3 nodes)
- **Access**: Production team only

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. Terraform State Conflicts
**Symptoms**: State lock errors or concurrent modification issues
**Solutions**:
```bash
# Use lock timeout
terraform plan -lock-timeout=300s
terraform apply -lock-timeout=300s

# Check current state
terraform state list
terraform refresh
```

#### 2. External Access Issues
**Symptoms**: LoadBalancer external IP not accessible
**Solutions**:
```bash
# Check NSG rules
az network nsg rule list --resource-group <resource-group> --nsg-name <nsg-name>

# Remove blocking rules
az network nsg rule delete --resource-group <resource-group> --nsg-name <nsg-name> --name deny-all-inbound

# Update allow rules
az network nsg rule update --resource-group <resource-group> --nsg-name <nsg-name> --name allow-http --source-address-prefix "*"
```

#### 3. Resource Constraints
**Symptoms**: Pods stuck in `Pending` state
**Solutions**:
```bash
# Check node resources
kubectl top nodes
kubectl describe pod <pod-name>

# Reduce resource requirements in deployment
kubectl edit deployment weather-app -n weather-app
```

#### 4. Workflow Issues
**Symptoms**: GitHub Actions not triggering
**Solutions**:
- Check workflow configuration
- Ensure proper trigger conditions
- Add trigger comments to force execution

## Security Considerations

- All infrastructure changes go through pull request review
- Network security groups restrict access with proper firewall rules
- Azure managed identities for secure authentication
- Secrets stored in GitHub repository secrets
- Regular security scanning with tfsec
- RBAC enabled on AKS clusters

## Cost Optimization

- Test environment uses minimal resources (1 node)
- Resource limits and requests optimized
- Regular cleanup of unused resources
- Monitoring and alerting for cost spikes

## Lessons Learned

### Technical Challenges
1. **State Management**: Terraform state locking requires proper timeout configuration
2. **Network Security**: NSG rules must be carefully configured for external access
3. **Resource Optimization**: Proper CPU/memory limits prevent pod failures
4. **LoadBalancer Configuration**: Annotations are crucial for proper external access
5. **CI/CD Reliability**: Workflow triggers need careful configuration

### Best Practices Implemented
1. **Modular Design**: Separated concerns into reusable Terraform modules
2. **Environment Isolation**: Clear separation between environments
3. **Security First**: Implemented proper network policies and RBAC
4. **Documentation**: Comprehensive troubleshooting and setup guides
5. **Automation**: Full CI/CD pipeline with quality gates

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

- OpenWeatherMap API for weather data
- Azure cloud platform support
- Terraform for Infrastructure as Code
- GitHub Actions for CI/CD automation

---

**CST8918 Final Project - Group 12**  
*Building a weather application with modern cloud-native technologies and DevOps practices*

## GitHub Actions Workflow Status

**Static Analysis**: Successfully running with module validation  
**Terraform Apply**: Automated deployment to test environment  
**Application Build**: Docker image build and push to ACR  
**Application Deployment**: Kubernetes deployment automation  
**External Access**: Application accessible at http://4.157.192.48  

---

## GitHub Actions Workflow Screenshot
Complete GitHub Actions Workflow
<img width="1892" height="626" alt="image" src="https://github.com/user-attachments/assets/daf04480-be7a-4de5-bc29-a1c5561911da" />

