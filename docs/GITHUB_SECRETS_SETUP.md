# GitHub Secrets Setup for Terraform Authentication

## Required GitHub Secrets

To fix the Terraform authentication issues in GitHub Actions, you need to set the following secrets in your GitHub repository:

### 1. Azure Service Principal Credentials

Go to your GitHub repository → Settings → Secrets and variables → Actions, and add these secrets:

| Secret Name | Description | Value |
|-------------|-------------|-------|
| `AZURE_CLIENT_ID` | Azure Service Principal Client ID | Your Service Principal's Client ID |
| `AZURE_CLIENT_SECRET` | Azure Service Principal Client Secret | Your Service Principal's Client Secret |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID | Your Azure Subscription ID |
| `AZURE_TENANT_ID` | Azure Tenant ID | Your Azure Tenant ID |

### 2. How to Get These Values

#### Option 1: Using Azure CLI (if you have access)
```bash
# Login to Azure
az login

# Get subscription ID
az account show --query id --output tsv

# Get tenant ID
az account show --query tenantId --output tsv

# Create Service Principal (if you don't have one)
az ad sp create-for-rbac --name "github-actions-terraform" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# The output will contain:
# {
#   "clientId": "YOUR_CLIENT_ID",
#   "clientSecret": "YOUR_CLIENT_SECRET",
#   "subscriptionId": "YOUR_SUBSCRIPTION_ID",
#   "tenantId": "YOUR_TENANT_ID"
# }
```

#### Option 2: From Azure Portal
1. Go to Azure Portal → Azure Active Directory → App registrations
2. Find your Service Principal or create a new one
3. Copy the Application (client) ID → `AZURE_CLIENT_ID`
4. Go to Certificates & secrets → New client secret → Copy the value → `AZURE_CLIENT_SECRET`
5. Go to Azure Portal → Subscriptions → Copy Subscription ID → `AZURE_SUBSCRIPTION_ID`
6. Go to Azure Portal → Azure Active Directory → Copy Tenant ID → `AZURE_TENANT_ID`

### 3. Current Error

The current error:
```
Error: Error building ARM Config: obtain subscription(***) from Azure CLI: parsing json result from the Azure CLI: waiting for the Azure CLI: exit status 1: ERROR: Please run 'az login' to setup account.
```

This indicates that Terraform is still trying to use Azure CLI authentication instead of Service Principal authentication, which means the environment variables are not being set correctly.

### 4. Verification

After setting the secrets, the GitHub Actions workflow should:
1. ✅ Successfully initialize Terraform
2. ✅ Use Service Principal authentication
3. ✅ Deploy resources to Azure

### 5. Troubleshooting

If you still get authentication errors:
1. Double-check that all 4 secrets are set correctly
2. Ensure the Service Principal has the necessary permissions (Contributor role on the subscription)
3. Verify the Service Principal is not expired
4. Check that the subscription ID and tenant ID are correct 