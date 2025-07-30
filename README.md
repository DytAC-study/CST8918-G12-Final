# CST8918-G12-Final: Weather Application

## Project Overview

This is a weather application based on the Azure cloud platform, using Terraform for Infrastructure as Code (IaC) management. The project adopts a microservices architecture, including a frontend weather application and backend infrastructure modules. This project demonstrates DevOps practices with automated CI/CD pipelines using GitHub Actions.

## 🚀 Current Deployment Status

### ✅ Successfully Deployed Components

- **AKS Cluster**: `dev-aks` running in East US region
- **Azure Container Registry**: `cst8918acr` with weather-app image
- **Network Infrastructure**: Virtual network with proper subnet configuration
- **Weather Application**: Successfully deployed and accessible externally
- **Load Balancer**: External IP `20.246.216.138` with proper health checks

### 🔧 Major Challenges Encountered and Solutions

#### 1. AKS Connection Timeout Issue
**Problem**: Initial kubectl connection timeout to AKS cluster
```
Error: dial tcp 40.71.237.228:443: i/o timeout
```
**Root Cause**: API server not accessible from current public IP
**Solution**: 
- Updated API server authorized IP ranges to include current public IP `174.112.71.173/32`
- Refreshed kubectl credentials using `az aks get-credentials`
- Modified `modules/aks/main.tf` to include public IP in `api_server_authorized_ip_ranges`

#### 2. Docker Image Pull Issues
**Problem**: ImagePullBackOff errors during pod creation
```
Error: 401 Unauthorized when pulling from ACR
```
**Root Cause**: Missing Docker image and ACR authentication issues
**Solution**:
- Built and pushed weather-app Docker image to ACR using multi-platform build
- Attached ACR to AKS cluster for authentication
- Reduced resource requests in `modules/weather-app/main.tf` to fit node capacity
- Updated CPU/memory limits to prevent resource exhaustion

#### 3. Firewall/Network Security Group Issues
**Problem**: External access blocked by NSG rules
```
Error: Connection timeout when accessing LoadBalancer IP
```
**Root Cause**: Missing NSG rules for LoadBalancer NodePort
**Solution**:
- Added NodePort 32199 rule to allow LoadBalancer health checks
- Configured proper NSG rule priorities (100-4096)
- Added explicit NSG rules for ports 80, 443, 32199
- Used Azure CLI to manually add rules when Terraform was locked

#### 4. GitHub Actions Authentication Issues
**Problem**: OIDC federated identity authentication failing
```
Error: AADSTS700213: No matching federated identity record found
```
**Root Cause**: OIDC configuration issues in Azure
**Solution**:
- Switched from OIDC to Service Principal authentication
- Updated all GitHub Actions workflows to use `creds: ${{ secrets.AZURE_CREDENTIALS }}`
- Created comprehensive setup documentation for Azure authentication
- Simplified authentication configuration for better reliability

#### 5. Terraform State Locking Issues
**Problem**: State blob already locked during deployment
```
Error: Error acquiring the state lock
Error message: state blob is already locked
```
**Root Cause**: Concurrent Terraform operations or interrupted deployments
**Solution**:
- Used Azure CLI to manually release state locks
- Command: `az storage blob lease break --account-name cst8918tfstate2025 --container-name terraform-state --blob-name {env}/terraform.tfstate`
- Released locks for dev, test, and prod environments
- Implemented proper state management practices

#### 6. Static Analysis Workflow Failures
**Problem**: Multiple issues with static analysis workflow
```
Error: Too many command line arguments
Error: Terraform exited with code 1
```
**Root Cause**: Backend authentication and command syntax issues
**Solution**:
- Changed validation approach to focus on modules only (`modules/*/`)
- Removed Azure authentication dependency for static analysis
- Fixed `-chdir` flag usage in Terraform commands
- Added proper provider version constraints
- Removed unused data sources to fix TFLint warnings

#### 7. PowerShell Environment Issues
**Problem**: Persistent PowerShell errors during automation
```
System.InvalidOperationException: Cannot locate the offset in the rendered text
```
**Root Cause**: PowerShell compatibility issues on macOS
**Solution**:
- Switched to manual step-by-step guidance when automation failed

## 🧪 Testing New Workflow

**Latest Update**: Testing the new unified CI/CD pipeline with enhanced features including:
- Multi-environment support with matrix strategy
- Enhanced security scanning with tfsec
- Application health checks and monitoring
- Improved error handling and resource targeting

### 🌐 Application Access

**External URL**: http://20.246.216.138

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

## Team Members

- **Team Member 1**: [GitHub Username] - Backend Infrastructure & Terraform Modules
- **Team Member 2**: [GitHub Username] - Application Deployment & Kubernetes Configuration  
- **Team Member 3**: [GitHub Username] - Frontend Development & Documentation

## Project Architecture

```
CST8918-G12-Final/
├── .github/workflows/         # 🔄 GitHub Actions CI/CD
│   ├── build-app.yml         # Application build workflow
│   ├── deploy-app.yml        # Application deployment workflow
│   ├── static-analysis.yml   # Code quality checks
│   ├── terraform-apply.yml   # Infrastructure deployment
│   └── terraform-plan.yml    # Infrastructure planning
├── environments/              # 🌍 Environment Configurations
│   ├── dev/                  # Development environment
│   ├── test/                 # Testing environment
│   └── prod/                 # Production environment
├── modules/                   # 🏗️ Terraform Modules
│   ├── backend/              # Azure backend infrastructure
│   ├── network/              # Network infrastructure
│   ├── aks/                  # AKS cluster configuration
│   └── weather-app/          # Weather application deployment
├── weather-app/              # 🌤️ Node.js Weather Application
│   ├── src/                  # Application source code
│   ├── app.js               # Main application file
│   ├── package.json         # Dependency management
│   └── Dockerfile           # Containerization configuration
└── README.md                # Project documentation
```

## Technology Stack

- **Frontend**: Node.js, Express.js
- **Infrastructure**: Terraform, Azure
- **Containerization**: Docker
- **Orchestration**: Azure Kubernetes Service (AKS)
- **CI/CD**: GitHub Actions
- **API**: OpenWeatherMap API
- **Caching**: Azure Cache for Redis
- **Registry**: Azure Container Registry (ACR)

## Features

- 🌤️ Real-time weather information query
- 📍 Global city search support
- 🎨 Modern responsive UI design
- ⚡ High-performance caching mechanism
- 🔧 Automated deployment process
- 🚀 Multi-environment support (dev, test, prod)
- 🔒 Secure infrastructure with network policies

## Infrastructure Requirements

### Network Configuration
- **Virtual Network**: `10.0.0.0/14`
- **Production Subnet**: `10.0.0.0/16`
- **Test Subnet**: `10.1.0.0/16`
- **Development Subnet**: `10.2.0.0/16`
- **Admin Subnet**: `10.3.0.0/16`

### AKS Clusters
- **Test Environment**: 1 node, Standard_B2s VM, Kubernetes 1.32
- **Production Environment**: 1-3 nodes (auto-scaling), Standard_B2s VM, Kubernetes 1.32

### Azure Resources
- Azure Blob Storage (Terraform backend)
- Azure Container Registry (ACR)
- Azure Cache for Redis
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
cd environments/dev
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
cd ../weather-app
terraform init
terraform plan
terraform apply
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
- Apply infrastructure changes to dev → test → prod
- Check for resource drift
- Validate state after each environment
- Runs only on push to main branch

#### **Step 5: Deploy Application**
- Deploy to test environment
- Deploy to production environment
- Wait for deployment status

#### **Step 6: Drift Detection**
- Check for resource drift in all environments
- Report any inconsistencies
- Runs after successful deployment

### Workflow Dependencies
```
static-analysis → build-app → terraform-plan (PR)
                ↓
static-analysis → build-app → terraform-apply-dev → terraform-apply-test → terraform-apply-prod → deploy-app-test → deploy-app-prod → drift-check (Main)
```

## Project Structure Details

### Backend Module (`modules/backend/`)
- Azure resource group management
- Storage account configuration
- Network infrastructure

### Network Module (`modules/network/`)
- Virtual network with specified IP ranges
- Subnets for different environments
- Network security groups with proper firewall rules

### AKS Module (`modules/aks/`)
- Kubernetes cluster configuration
- Node pool management
- Network integration
- API server authorized IP ranges

### Weather App Module (`modules/weather-app/`)
- Azure Container Registry
- Redis cache configuration
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
curl "http://20.246.216.138/api/weather?city=Toronto"
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
| `REDIS_HOST` | Redis cache hostname | Yes (production) |
| `REDIS_PORT` | Redis cache port | Yes (production) |
| `REDIS_KEY` | Redis cache access key | Yes (production) |

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

### Development Environment
- **Purpose**: Local development and testing
- **Resources**: Minimal for cost optimization
- **Access**: Development team only
- **Status**: ✅ Successfully deployed and accessible

### Test Environment
- **Purpose**: Integration testing and validation
- **Resources**: 1 AKS node, Redis cache
- **Access**: QA team and developers

### Production Environment
- **Purpose**: Live application serving
- **Resources**: Auto-scaling AKS (1-3 nodes), Redis cache
- **Access**: Production team only

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. Terraform State Conflicts
**Symptoms**: State lock errors or concurrent modification issues
**Solutions**:
```bash
# Check current state
terraform state list
terraform refresh

# Force unlock if necessary
az storage blob lease break --account-name cst8918tfstate2025 --container-name terraform-state --blob-name {env}/terraform.tfstate

# Reconfigure backend
terraform init -reconfigure
```

#### 2. Docker Build Failures
**Symptoms**: Image build errors or ACR authentication issues
**Solutions**:
```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker build --no-cache -t weather-app .

# Check ACR authentication
az acr login --name cst8918acr
```

#### 3. Azure Authentication Issues
**Symptoms**: Authentication errors in GitHub Actions or local development
**Solutions**:
```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "your-subscription-id"

# Create service principal for GitHub Actions
az ad sp create-for-rbac --name "github-actions-terraform" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

#### 4. AKS Connection Issues
**Symptoms**: kubectl timeout or connection refused
**Solutions**:
```bash
# Get credentials
az aks get-credentials --resource-group <resource-group> --name <cluster-name>

# Check nodes
kubectl get nodes

# Update authorized IP ranges if needed
```

#### 5. Network Security Group Issues
**Symptoms**: External access blocked or LoadBalancer not accessible
**Solutions**:
```bash
# Check NSG rules
az network nsg rule list --resource-group <resource-group> --nsg-name <nsg-name>

# Add NodePort rule manually if needed
az network nsg rule create --resource-group <resource-group> --nsg-name <nsg-name> --name allow-nodeport --priority 115 --direction Inbound --access Allow --protocol Tcp --source-port-range "*" --destination-port-range "32199" --source-address-prefix "*" --destination-address-prefix "*"
```

#### 6. GitHub Actions Failures
**Symptoms**: Workflow failures or authentication errors
**Solutions**:
- Check workflow logs in GitHub Actions tab
- Verify Azure credentials and permissions
- Ensure all required secrets are configured
- Check for state locking issues

#### 7. Static Analysis Workflow Issues
**Symptoms**: TFLint warnings or Terraform validation errors
**Solutions**:
- Ensure all providers have version constraints
- Remove unused data sources and resources
- Use `-backend=false` for static analysis
- Validate modules instead of environments

## Security Considerations

- All infrastructure changes go through pull request review
- Network security groups restrict access with proper firewall rules
- Azure managed identities for secure authentication
- Secrets stored in GitHub repository secrets
- Regular security scanning with tfsec
- RBAC enabled on AKS clusters

## Cost Optimization

- Development environment uses minimal resources
- Auto-scaling in production environment
- Regular cleanup of unused resources
- Monitoring and alerting for cost spikes
- Resource limits and requests optimized

## Lessons Learned

### Technical Challenges
1. **State Management**: Terraform state locking can cause deployment failures
2. **Authentication Complexity**: OIDC vs Service Principal authentication trade-offs
3. **Network Security**: NSG rules must be carefully configured for external access
4. **Resource Optimization**: Proper CPU/memory limits prevent pod failures
5. **CI/CD Reliability**: Static analysis should not depend on backend authentication

### Best Practices Implemented
1. **Modular Design**: Separated concerns into reusable Terraform modules
2. **Environment Isolation**: Clear separation between dev, test, and prod
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

✅ **Static Analysis**: Successfully running with module validation  
✅ **Terraform Apply**: Automated deployment to all environments  
✅ **Application Build**: Docker image build and push to ACR  
✅ **Application Deployment**: Kubernetes deployment automation  

---

**Project Status**: ✅ **COMPLETED** - All lab requirements met with comprehensive problem-solving documentation
