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

### 🔧 Recent Issues Resolved

#### 1. AKS Connection Timeout Issue
**Problem**: Initial kubectl connection timeout to AKS cluster
**Solution**: 
- Updated API server authorized IP ranges to include current public IP `174.112.71.173/32`
- Refreshed kubectl credentials using `az aks get-credentials`

#### 2. Docker Image Pull Issues
**Problem**: ImagePullBackOff errors due to missing Docker image and authentication
**Solution**:
- Built and pushed weather-app Docker image to ACR using multi-platform build
- Attached ACR to AKS cluster for authentication
- Reduced resource requests to fit node capacity

#### 3. Firewall/Network Security Group Issues
**Problem**: External access blocked by NSG rules
**Solution**:
- Added NodePort 32199 rule to allow LoadBalancer health checks
- Configured proper NSG rule priorities (100-4096)
- Verified all required ports (80, 443, 32199) are accessible

#### 4. GitHub Actions Azure Authentication Issues
**Problem**: OIDC federated identity authentication failing
**Solution**:
- Updated all workflows to use service principal authentication
- Created comprehensive setup documentation in `docs/AZURE_SETUP.md`
- Simplified authentication configuration for better reliability

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

## GitHub Actions Workflows

### Automated CI/CD Pipeline

1. **Static Analysis** (`static-analysis.yml`)
   - Runs on every push to any branch
   - Performs Terraform fmt, validate, and tfsec checks

2. **Terraform Planning** (`terraform-plan.yml`)
   - Runs on pull requests to main branch
   - Executes tflint and terraform plan

3. **Application Build** (`build-app.yml`)
   - Runs on pull requests to main branch
   - Builds and pushes Docker image to ACR
   - Tags images with commit SHA

4. **Application Deployment** (`deploy-app.yml`)
   - Deploys to test environment on pull requests
   - Deploys to production environment on merge to main

5. **Infrastructure Deployment** (`terraform-apply.yml`)
   - Runs on push to main branch
   - Applies infrastructure changes

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

### Weather App Module (`modules/weather-app/`)
- Azure Container Registry
- Redis cache configuration
- Kubernetes deployment and service

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

## Troubleshooting

### Common Issues

1. **Terraform State Conflicts**
```bash
terraform state list
terraform refresh
terraform init -reconfigure
```

2. **Docker Build Failures**
```bash
docker system prune -a
docker build --no-cache -t weather-app .
```

3. **Azure Authentication Issues**
```bash
az login
az account set --subscription "your-subscription-id"
```

4. **AKS Connection Issues**
```bash
az aks get-credentials --resource-group <resource-group> --name <cluster-name>
kubectl get nodes
```

5. **Network Security Group Issues**
```bash
az network nsg rule list --resource-group <resource-group> --nsg-name <nsg-name>
az network nsg rule create --resource-group <resource-group> --nsg-name <nsg-name> --name allow-nodeport --priority 115 --direction Inbound --access Allow --protocol Tcp --source-port-range "*" --destination-port-range "32199" --source-address-prefix "*" --destination-address-prefix "*"
```

6. **GitHub Actions Failures**
- Check workflow logs in GitHub Actions tab
- Verify Azure credentials and permissions
- Ensure all required secrets are configured

## Security Considerations

- All infrastructure changes go through pull request review
- Network security groups restrict access with proper firewall rules
- Azure managed identities for secure authentication
- Secrets stored in GitHub repository secrets
- Regular security scanning with tfsec

## Cost Optimization

- Development environment uses minimal resources
- Auto-scaling in production environment
- Regular cleanup of unused resources
- Monitoring and alerting for cost spikes

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

## GitHub Actions Workflow Screenshot

*[Screenshot of completed GitHub Actions workflows will be added here after successful deployment]*

---

**Test Comment**: Triggering workflow on main branch for screenshot capture.
