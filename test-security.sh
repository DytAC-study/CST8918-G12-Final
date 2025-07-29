#!/bin/bash

# Test script to validate Terraform security configurations

echo "=== Testing Terraform Security Configurations ==="

# Check if RBAC is enabled in AKS module
echo "Checking RBAC configuration in AKS module..."
if grep -q "role_based_access_control" modules/aks/main.tf; then
    echo "✓ RBAC configuration found in AKS module"
else
    echo "✗ RBAC configuration missing in AKS module"
fi

# Check if logging is enabled in AKS module
echo "Checking logging configuration in AKS module..."
if grep -q "oms_agent" modules/aks/main.tf; then
    echo "✓ OMS Agent configuration found in AKS module"
else
    echo "✗ OMS Agent configuration missing in AKS module"
fi

# Check if HTTPS is enabled in storage account
echo "Checking HTTPS configuration in backend module..."
if grep -q "enable_https_traffic_only" modules/backend/main.tf; then
    echo "✓ HTTPS traffic only enabled in backend module"
else
    echo "✗ HTTPS traffic only not enabled in backend module"
fi

# Check if TLS version is set
echo "Checking TLS version in backend module..."
if grep -q "min_tls_version" modules/backend/main.tf; then
    echo "✓ Minimum TLS version set in backend module"
else
    echo "✗ Minimum TLS version not set in backend module"
fi

# Check if admin access is disabled in ACR
echo "Checking ACR admin access..."
if grep -q "admin_enabled.*false" modules/weather-app/main.tf; then
    echo "✓ ACR admin access disabled"
else
    echo "✗ ACR admin access not properly configured"
fi

# Check if SSL is enabled for Redis
echo "Checking Redis SSL configuration..."
if grep -q "non_ssl_port_enabled.*false" modules/weather-app/main.tf; then
    echo "✓ Redis SSL properly configured"
else
    echo "✗ Redis SSL not properly configured"
fi

echo "=== Security Configuration Test Complete ===" 