# Azure Setup for GitHub Actions

This document explains how to set up Azure authentication for GitHub Actions workflows.

## Problem

The GitHub Actions workflows were failing with the following error:
```
Error: AADSTS700213: No matching federated identity record found for presented assertion subject 'repo:DytAC-study/CST8918-G12-Final:ref:refs/heads/main'
```

This occurs because the OIDC (OpenID Connect) federated identity credentials are not properly configured in Azure.

## Solution

We've updated all GitHub Actions workflows to use **Service Principal Authentication** instead of OIDC, which is simpler and more reliable.

## Setup Instructions

### 1. Create Azure Service Principal

Run the following Azure CLI commands to create a service principal:

```bash
# Login to Azure
az login

# Create service principal with Contributor role
az ad sp create-for-rbac --name "CST8918-G12-Final-SP" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth
```

### 2. Configure GitHub Secrets

The command above will output JSON credentials. Copy this JSON and add it as a GitHub secret:

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `AZURE_CREDENTIALS`
5. Value: Paste the entire JSON output from the service principal creation

### 3. Additional Required Secrets

You'll also need these secrets for the workflows to function properly:

- `ACR_LOGIN_SERVER`: Your Azure Container Registry login server (e.g., `cst8918acr.azurecr.io`)

### 4. Verify Setup

After setting up the secrets, the GitHub Actions workflows should work properly:

- **terraform-plan.yml**: Runs on pull requests to main branch
- **terraform-apply.yml**: Runs on pushes to main branch
- **build-app.yml**: Builds and pushes Docker images
- **deploy-app.yml**: Deploys applications to AKS clusters

## Updated Workflow Files

The following workflow files have been updated to use service principal authentication:

- `.github/workflows/terraform-apply.yml`
- `.github/workflows/terraform-plan.yml`
- `.github/workflows/build-app.yml`
- `.github/workflows/deploy-app.yml`

## Security Notes

- The service principal has Contributor role, which is sufficient for Terraform operations
- Credentials are stored securely in GitHub Secrets
- Service principal can be rotated by creating a new one and updating the secret

## Troubleshooting

### Common Issues

1. **"No matching federated identity record"**
   - Solution: Use service principal authentication instead of OIDC

2. **"Insufficient permissions"**
   - Ensure the service principal has Contributor role on the subscription
   - Check that the service principal has access to the resource group

3. **"ACR login failed"**
   - Ensure the service principal has AcrPush role on the container registry
   - Verify the ACR_LOGIN_SERVER secret is correct

### Commands to Fix Permissions

```bash
# Add AcrPush role to service principal for ACR
az role assignment create \
  --assignee "SERVICE_PRINCIPAL_ID" \
  --role "AcrPush" \
  --scope "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP/providers/Microsoft.ContainerRegistry/registries/REGISTRY_NAME"

# Verify role assignments
az role assignment list --assignee "SERVICE_PRINCIPAL_ID"
```

## Migration from OIDC

If you were previously using OIDC authentication, you can remove these secrets:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID` 
- `AZURE_SUBSCRIPTION_ID`

And replace them with:
- `AZURE_CREDENTIALS` (JSON service principal credentials) 