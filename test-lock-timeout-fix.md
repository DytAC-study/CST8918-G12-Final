# Test Lock Timeout Fix

This file is created to test the CI/CD pipeline with the latest lock-timeout fixes.

## Recent Fixes Applied

1. **Lock Timeout Implementation**:
   - Changed from `-lock=false` to `-lock-timeout=300s`
   - This allows Terraform to wait up to 5 minutes for locks instead of failing immediately
   - Applied to terraform-plan, terraform-apply, and drift-check jobs

2. **Provider Version Consistency**:
   - Added `.terraform.lock.hcl` files to git tracking
   - Removed `.terraform.lock.hcl` from `.gitignore`
   - Generated lock files with `terraform providers lock -platform=linux_amd64`

3. **Terraform Apply Job Fixes**:
   - Added `terraform init` to download providers
   - Removed invalid `terraform force-unlock -force` command
   - Using `-lock-timeout=300s` for proper lock handling

## Expected Behavior
- No provider plugin missing errors
- No invalid force-unlock command errors
- No provider version inconsistency errors
- Terraform will wait up to 5 minutes for locks instead of failing immediately

## Test Purpose
Trigger the workflow to verify the lock-timeout fix is working correctly. 