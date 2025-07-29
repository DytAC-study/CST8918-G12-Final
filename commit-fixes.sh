#!/bin/bash

echo "Adding all changes..."
git add .

echo "Committing Terraform authentication fixes..."
git commit -m "Fix Terraform Service Principal authentication for GitHub Actions"

echo "Pushing to current branch..."
git push origin test-github-actions-fix-2

echo "Done! Changes have been pushed."
echo "Please ask your teammate to review and merge the PR." 