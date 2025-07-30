# Screenshot Checklist for Lab Demonstration

## 📸 Required Screenshots for Lab Completion

### 1. GitHub Repository & CI/CD
- [ ] **GitHub Actions Dashboard**
  - Show unified workflow running successfully
  - Complete CI/CD pipeline with all steps
  - Screenshot: `.github/workflows/` showing single workflow file

- [ ] **Pull Request Process**
  - PR creation and review process
  - Code review comments and approvals
  - Merge to main branch
  - Screenshot: PR page with review status

- [ ] **Repository Structure**
  - Complete project file structure
  - Modules, environments, workflows
  - Screenshot: Repository root showing all directories

### 2. Azure Infrastructure
- [ ] **Azure Portal - Resource Group**
  - All deployed resources in one view
  - AKS cluster, ACR, network resources
  - Screenshot: Resource group overview

- [ ] **AKS Cluster Status**
  - Cluster running status
  - Node pool configuration
  - Screenshot: AKS cluster details page

- [ ] **Azure Container Registry**
  - Docker images stored
  - Repository access
  - Screenshot: ACR repositories page

- [ ] **Network Configuration**
  - Virtual network and subnets
  - Network security groups
  - Screenshot: Network topology

### 3. Application Deployment
- [ ] **Weather Application UI**
  - Main application page
  - Weather search functionality
  - Screenshot: `http://20.246.216.138` main page

- [ ] **API Response**
  - Weather API JSON response
  - Health check endpoint
  - Screenshot: API response in browser/Postman

- [ ] **Load Balancer Status**
  - External IP configuration
  - Health check status
  - Screenshot: Load balancer details

### 4. Kubernetes Resources
- [ ] **Pod Status**
  ```bash
  kubectl get pods -o wide
  ```
  - All pods running successfully
  - Screenshot: Terminal output

- [ ] **Service Configuration**
  ```bash
  kubectl get services
  ```
  - LoadBalancer service details
  - Screenshot: Terminal output

- [ ] **Node Status**
  ```bash
  kubectl get nodes
  ```
  - Node pool status
  - Screenshot: Terminal output

### 5. Terraform Infrastructure
- [ ] **Terraform Plan Output**
  ```bash
  terraform plan
  ```
  - No changes needed (infrastructure up to date)
  - Screenshot: Terminal output showing "No changes"

- [ ] **Terraform State**
  ```bash
  terraform state list
  ```
  - All managed resources
  - Screenshot: Terminal output

- [ ] **Azure Storage Backend**
  - State file in Azure Storage
  - Screenshot: Storage account showing terraform-state container

### 6. CI/CD Pipeline Evidence
- [ ] **Unified Workflow Runs**
  - Complete pipeline execution
  - All steps running in sequence
  - Screenshot: GitHub Actions complete-pipeline runs

- [ ] **Static Analysis Results**
  - tfsec, tflint, terraform validate results
  - Screenshot: Static analysis step output

- [ ] **Build and Deploy Logs**
  - Docker build and push logs
  - Application deployment logs
  - Infrastructure deployment logs
  - Screenshot: Build and deploy step outputs

### 7. Documentation
- [ ] **README.md**
  - Complete project documentation
  - Problem-solving section
  - Screenshot: README page on GitHub

- [ ] **Resource Drift Management**
  - Drift detection step in unified workflow
  - Documentation in English
  - Screenshot: Drift detection step output

### 8. Security & Best Practices
- [ ] **RBAC Configuration**
  - AKS RBAC enabled
  - Screenshot: AKS cluster RBAC settings

- [ ] **Network Security**
  - NSG rules configuration
  - Screenshot: Network security group rules

- [ ] **Static Analysis**
  - tfsec security scan results
  - Screenshot: Security analysis output

## 🎯 Demonstration Script

### Opening (2-3 minutes)
1. **Project Overview**
   - Show repository structure
   - Explain the weather application concept
   - Highlight DevOps practices used

### Infrastructure (3-4 minutes)
2. **Azure Resources**
   - Show AKS cluster running
   - Display ACR with Docker images
   - Explain network configuration

### Application (2-3 minutes)
3. **Working Application**
   - Demonstrate weather app functionality
   - Show API responses
   - Prove external accessibility

### CI/CD (3-4 minutes)
4. **Automation Pipeline**
   - Show GitHub Actions workflows
   - Demonstrate PR process
   - Explain drift detection

### Code Quality (2-3 minutes)
5. **Best Practices**
   - Show static analysis results
   - Explain security measures
   - Highlight documentation

### Problem Solving (2-3 minutes)
6. **Challenges Overcome**
   - Show README problem-solving section
   - Explain major issues and solutions
   - Demonstrate troubleshooting skills

## 📝 Notes for Screenshots

### Before Taking Screenshots:
1. **Clean up browser tabs** - Only show relevant pages
2. **Use high resolution** - Ensure text is readable
3. **Include timestamps** - Show current date/time
4. **Highlight key information** - Use browser highlighting if needed
5. **Organize by category** - Group related screenshots together

### Screenshot Tips:
- **Full screen capture** for overview shots
- **Zoom in** for detailed configuration
- **Include context** - Show surrounding UI elements
- **Multiple angles** - Show different aspects of the same feature
- **Before/after** - If showing problem resolution

## ✅ Final Checklist

Before submitting:
- [ ] All screenshots are clear and readable
- [ ] Screenshots show current working state
- [ ] All lab requirements are demonstrated
- [ ] Problem-solving documentation is included
- [ ] CI/CD pipeline is fully functional
- [ ] Application is accessible externally
- [ ] All infrastructure is properly deployed
- [ ] Code quality checks are passing

## 🎉 Ready for Submission

With these screenshots, you'll have comprehensive evidence that:
- ✅ Infrastructure as Code is implemented
- ✅ Containerization is working
- ✅ Kubernetes deployment is successful
- ✅ CI/CD pipeline is automated
- ✅ Application is functional and accessible
- ✅ Security best practices are followed
- ✅ Documentation is complete
- ✅ Problem-solving skills are demonstrated 