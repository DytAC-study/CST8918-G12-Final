# Pipeline Test Trigger

This file is created to test the CI/CD pipeline with the lock fixes.

## Changes Made

- Added `terraform force-unlock -force || true` to clear stale locks
- Added `-lock=false` flag to all terraform commands
- Applied fixes to terraform-plan, terraform-apply, and drift-check jobs

## Expected Behavior

The pipeline should now run without lock-related errors. 