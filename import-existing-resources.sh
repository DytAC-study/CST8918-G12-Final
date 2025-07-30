#!/bin/bash

# Import existing Azure resources to Terraform state
# This script handles state drift by importing existing resources

set -e

echo "🔧 Importing existing Azure resources to Terraform state..."

# Set environment variables for Azure authentication
export ARM_CLIENT_ID="$AZURE_CLIENT_ID"
export ARM_CLIENT_SECRET="$AZURE_CLIENT_SECRET"
export ARM_SUBSCRIPTION_ID="$AZURE_SUBSCRIPTION_ID"
export ARM_TENANT_ID="$AZURE_TENANT_ID"

# Function to import resource
import_resource() {
    local resource_id="$1"
    local terraform_address="$2"
    local environment="$3"
    
    echo "📥 Importing $terraform_address..."
    cd "environments/$environment"
    
    terraform import "$terraform_address" "$resource_id" || {
        echo "⚠️  Failed to import $terraform_address, continuing..."
    }
    
    cd ../..
}

# Import Log Analytics Workspace for prod environment
echo "📊 Importing Log Analytics Workspace..."
import_resource \
    "/subscriptions/***/resourceGroups/cst8918-final-project-group-1/providers/Microsoft.OperationalInsights/workspaces/prod-aks-logs" \
    "module.aks.azurerm_log_analytics_workspace.main" \
    "prod"

# Import Network Security Rules for prod environment
echo "🔒 Importing Network Security Rules..."

# allow-https rule
import_resource \
    "/subscriptions/***/resourceGroups/cst8918-final-project-group-1/providers/Microsoft.Network/networkSecurityGroups/prod-nsg/securityRules/allow-https" \
    "module.network.azurerm_network_security_rule.allow_https" \
    "prod"

# allow-http rule
import_resource \
    "/subscriptions/***/resourceGroups/cst8918-final-project-group-1/providers/Microsoft.Network/networkSecurityGroups/prod-nsg/securityRules/allow-http" \
    "module.network.azurerm_network_security_rule.allow_http" \
    "prod"

# allow-ssh rule
import_resource \
    "/subscriptions/***/resourceGroups/cst8918-final-project-group-1/providers/Microsoft.Network/networkSecurityGroups/prod-nsg/securityRules/allow-ssh" \
    "module.network.azurerm_network_security_rule.allow_ssh" \
    "prod"

# allow-lb-health-check rule
import_resource \
    "/subscriptions/***/resourceGroups/cst8918-final-project-group-1/providers/Microsoft.Network/networkSecurityGroups/prod-nsg/securityRules/allow-lb-health-check" \
    "module.network.azurerm_network_security_rule.allow_lb_health_check" \
    "prod"

# deny-all-inbound rule
import_resource \
    "/subscriptions/***/resourceGroups/cst8918-final-project-group-1/providers/Microsoft.Network/networkSecurityGroups/prod-nsg/securityRules/deny-all-inbound" \
    "module.network.azurerm_network_security_rule.deny_all_inbound" \
    "prod"

echo "✅ Import completed!"
echo "🎯 Next step: Create a new PR to trigger Terraform Apply" 