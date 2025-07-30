# Resource Drift Management

## Overview

Resource drift occurs when the actual state of cloud resources differs from the state recorded in Terraform state files. This typically happens when:

1. Resources are manually modified through the cloud console
2. Other automation tools modify resources
3. Cloud service providers automatically update resources
4. Team members directly modify resources through Azure Portal

## Solution

### 1. Unified CI/CD Pipeline

We ensure all resource changes go through CI/CD by:

#### Automated Detection
- **Daily Drift Checks**: `terraform-drift-check.yml` workflow automatically checks for resource drift in all environments daily
- **PR Checks**: Every PR runs `terraform-plan.yml` to detect changes
- **Apply Validation**: `terraform-apply.yml` checks for drift before applying changes

#### State Management
- Use Azure Storage as Terraform state backend
- Separate state files by environment: `dev/terraform.tfstate`, `test/terraform.tfstate`, `prod/terraform.tfstate`
- Enable state locking to prevent concurrent modifications

### 2. Drift Detection Mechanism

#### Automated Detection
```bash
# Detect drift
terraform plan -detailed-exitcode

# Exit codes:
# 0 = No changes
# 1 = Error
# 2 = Changes detected (drift)
```

#### Manual Detection
```bash
# Detect drift in specific environment
cd environments/dev
terraform init
terraform plan
```

### 3. Drift Handling Strategies

#### Strategy 1: Auto-fix (Recommended for dev/test environments)
```bash
# Automatically apply changes to fix drift
terraform apply -auto-approve
```

#### Strategy 2: Manual Review (Recommended for prod environment)
```bash
# 1. View drift details
terraform plan -detailed-exitcode

# 2. Review changes
terraform show tfplan

# 3. Apply manually if needed
terraform apply tfplan
```

#### Strategy 3: Import External Changes
```bash
# If external changes are expected, import to Terraform state
terraform import azurerm_resource_group.example /subscriptions/.../resourceGroups/example
```

### 4. Prevention Measures

#### Access Control
- Restrict direct access to Azure resources
- Use Azure RBAC to control permissions
- Enable Azure Policy to prevent manual modifications

#### Monitoring and Alerts
- Set up Azure Monitor alerts
- Configure resource change notifications
- Regularly review access logs

#### Best Practices
1. **Prohibit Manual Changes**: All resource changes must go through Terraform
2. **Code Review**: All Terraform changes require PR review
3. **Environment Isolation**: Complete isolation between dev/test/prod environments
4. **State Backup**: Regularly backup Terraform state files

### 5. Troubleshooting

#### Common Issues

**Issue 1: Corrupted State File**
```bash
# Solution: Reinitialize
terraform init -reconfigure
```

**Issue 2: Resource Deleted but State Not Updated**
```bash
# Solution: Remove from state
terraform state rm azurerm_resource_group.example
```

**Issue 3: Resource ID Changes**
```bash
# Solution: Update state
terraform state mv azurerm_resource_group.old azurerm_resource_group.new
```

#### Debug Commands
```bash
# View current state
terraform show

# View plan details
terraform plan -out=tfplan
terraform show tfplan

# Validate configuration
terraform validate

# Format code
terraform fmt
```

### 6. CI/CD Integration

#### Workflow Files
- `terraform-plan.yml`: Check changes on PR
- `terraform-apply.yml`: Apply changes when merged to main
- `terraform-drift-check.yml`: Periodic drift checks

#### Trigger Conditions
- Code changes trigger plan
- Merge to main triggers apply
- Scheduled tasks check for drift

### 7. Team Collaboration

#### Development Process
1. Create feature branch
2. Modify Terraform configuration
3. Submit PR
4. Automatic plan check
5. Code review
6. Merge to main
7. Automatic apply

#### Emergency Fixes
1. Create hotfix branch
2. Apply emergency fix
3. Create PR immediately
4. Quick review and merge
5. Automatic deployment

## Summary

Through unified CI/CD pipeline and automated drift detection, we can:

1. **Reduce Drift**: All changes managed through code
2. **Quick Detection**: Automated drift detection
3. **Safe Fixes**: Controlled changes through PR process
4. **Maintain Consistency**: Ensure all environment states are consistent

This solution effectively addresses resource drift issues and ensures infrastructure predictability and consistency. 