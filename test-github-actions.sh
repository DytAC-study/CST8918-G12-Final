#!/bin/bash

# 创建新分支
git checkout -b test-github-actions-fix

# 添加更改
git add README.md

# 提交更改
git commit -m "Test GitHub Actions authentication fix"

# 推送到远程分支
git push origin test-github-actions-fix

# 创建Pull Request
gh pr create --title "Test GitHub Actions Authentication Fix" --body "This PR tests if the GitHub Actions authentication fix is working properly after updating the Azure login configuration to use service principal credentials."

echo "Branch created and PR submitted successfully!"
echo "Please ask your teammate to review and merge the PR." 