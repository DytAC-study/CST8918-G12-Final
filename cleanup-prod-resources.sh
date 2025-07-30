#!/bin/bash

# Clean up existing Azure resources in prod environment
# This script removes resources that are causing state drift

set -e

echo "🧹 Cleaning up existing Azure resources in prod environment..."

# Set environment variables for Azure authentication
export ARM_CLIENT_ID="$AZURE_CLIENT_ID"
export ARM_CLIENT_SECRET="$AZURE_CLIENT_SECRET"
export ARM_SUBSCRIPTION_ID="$AZURE_SUBSCRIPTION_ID"
export ARM_TENANT_ID="$AZURE_TENANT_ID"

RESOURCE_GROUP="cst8918-final-project-group-1"
NSG_NAME="prod-nsg"

echo "🗑️  Removing Network Security Rules..."

# Remove NSG rules
az network nsg rule delete \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "$NSG_NAME" \
    --name "allow-https" || echo "⚠️  allow-https rule not found"

az network nsg rule delete \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "$NSG_NAME" \
    --name "allow-http" || echo "⚠️  allow-http rule not found"

az network nsg rule delete \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "$NSG_NAME" \
    --name "allow-ssh" || echo "⚠️  allow-ssh rule not found"

az network nsg rule delete \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "$NSG_NAME" \
    --name "allow-lb-health-check" || echo "⚠️  allow-lb-health-check rule not found"

az network nsg rule delete \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "$NSG_NAME" \
    --name "deny-all-inbound" || echo "⚠️  deny-all-inbound rule not found"

echo "🗑️  Removing Log Analytics Workspace..."

# Remove Log Analytics Workspace
az monitor log-analytics workspace delete \
    --resource-group "$RESOURCE_GROUP" \
    --workspace-name "prod-aks-logs" || echo "⚠️  prod-aks-logs workspace not found"

echo "✅ Cleanup completed!"
echo "🎯 Next step: Create a new PR to trigger Terraform Apply" 