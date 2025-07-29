#!/bin/bash

echo "Adding RBAC fix..."
git add modules/aks/main.tf

echo "Committing RBAC fix..."
git commit -m "Fix RBAC configuration for AKS cluster to resolve tfsec warning"

echo "Pushing to new branch..."
git push origin fix-rbac-configuration

echo "Creating Pull Request..."
gh pr create --title "Fix RBAC Configuration for AKS Cluster" --body "This PR fixes the RBAC configuration for AKS clusters to resolve tfsec security warnings.

## Changes Made
- Added explicit `role_based_access_control_enabled = true` configuration
- This ensures proper role-based access control is enabled for all AKS clusters
- Resolves tfsec warning: azure-container-use-rbac-permissions

## Security Impact
- Improves security posture by ensuring RBAC is properly configured
- Follows Azure security best practices
- Addresses potential security vulnerabilities

## Testing
- This change will be tested by the Static Analysis workflow
- tfsec should now pass without RBAC-related warnings"

echo "Pull Request created successfully!"
echo "Please ask your teammate to review and merge the PR." 