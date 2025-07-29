#!/bin/bash

echo "Adding RBAC fix..."
git add modules/aks/main.tf

echo "Committing RBAC fix..."
git commit -m "Fix RBAC configuration for AKS cluster to resolve tfsec warning"

echo "Pushing to main branch..."
git push origin main

echo "RBAC fix has been pushed to main branch!"
echo "This should resolve the tfsec security warning." 