# Blocked Modules Tracking System

This document explains the tracking system for modules that cannot be fully tested due to environment issues, enabling resume capability when the environment is fixed.

## Concept

When prerequisites fail partially:
1. **Build continues** with degraded environment
2. **Modules are built** (code generation works)
3. **Some modules are tested** (environment-compatible ones)
4. **Blocked modules are tracked** in manifest
5. **User fixes environment later**
6. **Resume testing** picks up blocked modules
7. **Achieve 100% coverage** incrementally

## File Structure

### 1. Blocked Modules Manifest

**Location**: `docs/plans/blocked_modules.md`

**Format**:
```markdown
# Blocked Modules Manifest

**Collection**: <namespace>.<name>
**Last Updated**: <timestamp>
**Environment Status**: DEGRADED | PARTIAL | FIXED

---

## Environment Issues

### Issue #1: SCVMM Server Not Installed
**Status**: ❌ BLOCKING
**Affects**: 7 modules
**Required For**:
- SCVMM Server installation
- SQL Server backend functional
- At least 1 Hyper-V host added to SCVMM

**How to Fix**:
```bash
# Install SCVMM Server
# See: docs/plans/prerequisite_installation_log.md for original attempt logs

# Quick test to verify fixed:
Import-Module VirtualMachineManager
Get-SCVMMServer -ComputerName localhost
Get-SCVMHost
```

**When Fixed**: Run `resume-testing.sh scvmm_server`

---

### Issue #2: PostgreSQL Not Installed
**Status**: ⚠️ DEGRADED (using SQLite instead)
**Affects**: 3 modules
**Required For**:
- PostgreSQL 13+ installed
- Test database created

**How to Fix**:
```bash
# Install PostgreSQL
choco install postgresql -y

# Create test database
psql -c "CREATE DATABASE test_db;"
```

**When Fixed**: Run `resume-testing.sh postgresql`

---

## Blocked Modules

### Total Summary
- **Total Modules**: 20
- **Fully Tested**: 13 (65%)
- **Blocked**: 7 (35%)
- **Environment Fixed**: 0/2 issues

---

### Module: scvmm_host

**Status**: ⚠️ CODE COMPLETE, TESTS BLOCKED
**Jira**: EPIC-123
**Path**: `plugins/modules/scvmm_host.ps1`

**Build Status**:
- ✅ Module code written
- ✅ Documentation complete
- ✅ Syntax checks passed
- ✅ Code review passed

**Test Status**:
- ❌ Stage 1 (Initial Run): BLOCKED - No SCVMM Server
- ❌ Stage 2 (Idempotency): BLOCKED
- ❌ Stage 3 (Check Mode): BLOCKED
- ❌ Stage 4 (Error Handling): BLOCKED

**Blocked By**: Issue #1 (SCVMM Server Not Installed)

**Ready to Test**: NO
**Test Command**:
```bash
ansible-test integration scvmm_host --python 3.9
```

**Last Attempt**: 2026-05-27 14:32:15
**Attempt Log**: `tests/integration/targets/scvmm_host/attempt_1.log`

**What to Run When Fixed**:
```bash
# 1. Verify environment
Import-Module VirtualMachineManager
Get-SCVMMServer -ComputerName localhost

# 2. Run integration tests
cd ~/agentic-workflow-collections/microsoft/scvmm
ansible-test integration scvmm_host --python 3.9

# 3. If passes, mark as DONE in module_backlog.md
```

---

### Module: scvmm_vm

**Status**: ⚠️ CODE COMPLETE, TESTS BLOCKED
**Jira**: EPIC-124
**Path**: `plugins/modules/scvmm_vm.ps1`

**Build Status**:
- ✅ Module code written
- ✅ Documentation complete
- ✅ Syntax checks passed
- ✅ Code review passed

**Test Status**:
- ❌ Stage 1 (Initial Run): BLOCKED
- ❌ Stage 2 (Idempotency): BLOCKED
- ❌ Stage 3 (Check Mode): BLOCKED
- ❌ Stage 4 (Error Handling): BLOCKED

**Blocked By**: Issue #1 (SCVMM Server Not Installed)

**Dependencies**: Requires scvmm_host to be tested first (creates hosts)

**Test Command**:
```bash
ansible-test integration scvmm_vm --python 3.9
```

**Last Attempt**: 2026-05-27 14:35:22
**Attempt Log**: `tests/integration/targets/scvmm_vm/attempt_1.log`

---

### Module: scvmm_library_share

**Status**: ⚠️ CODE COMPLETE, TESTS BLOCKED
**Jira**: EPIC-125
**Path**: `plugins/modules/scvmm_library_share.ps1`

**Build Status**:
- ✅ Module code written
- ✅ Documentation complete
- ✅ Syntax checks passed
- ✅ Code review passed

**Test Status**:
- ❌ All stages BLOCKED

**Blocked By**: Issue #1 (SCVMM Server Not Installed)

**Test Command**:
```bash
ansible-test integration scvmm_library_share --python 3.9
```

---

### Module: app_postgres_user

**Status**: ⚠️ CODE COMPLETE, DEGRADED TESTS
**Jira**: EPIC-145
**Path**: `plugins/modules/app_postgres_user.ps1`

**Build Status**:
- ✅ Module code written
- ✅ Documentation complete
- ✅ Syntax checks passed
- ✅ Code review passed

**Test Status**:
- ⚠️ Stage 1: PASSED (using SQLite workaround)
- ⚠️ Stage 2: PASSED (using SQLite)
- ⚠️ Stage 3: PASSED (using SQLite)
- ⚠️ Stage 4: PASSED (using SQLite)

**Blocked By**: Issue #2 (PostgreSQL not installed - using SQLite)

**Notes**:
- Currently tested against SQLite instead of PostgreSQL
- Tests PASS but not with intended database
- Should retest with PostgreSQL when available

**Test Command** (when PostgreSQL fixed):
```bash
# Update inventory to use PostgreSQL
vim tests/inventory.winrm  # Change db_engine: postgresql

# Rerun tests
ansible-test integration app_postgres_user --python 3.9
```

---

## Resume Testing Commands

### Resume All Blocked Modules
```bash
cd ~/agentic-workflow-collections/microsoft/scvmm

# Check environment first
./scripts/verify_environment.sh

# Run all blocked module tests
for module in scvmm_host scvmm_vm scvmm_library_share; do
    echo "Testing $module..."
    ansible-test integration $module --python 3.9
    if [ $? -eq 0 ]; then
        echo "✅ $module PASSED"
        # Update blocked_modules.md
    else
        echo "❌ $module FAILED"
    fi
done
```

### Resume Specific Issue
```bash
# After fixing SCVMM Server installation:
./scripts/resume_testing.sh --issue scvmm_server

# This will:
# 1. Verify SCVMM Server is working
# 2. Run tests for all modules blocked by SCVMM
# 3. Update blocked_modules.md with results
# 4. Update module_backlog.md to mark [x] DONE
```

### Verify Single Module
```bash
# Test one specific module
ansible-test integration scvmm_host --python 3.9

# If passes, manually update:
# 1. blocked_modules.md - Change status to ✅ TESTED
# 2. module_backlog.md - Change [ ] to [x]
```

---

## Automation: Resume Testing Script

**Location**: `scripts/resume_testing.sh`

```bash
#!/bin/bash
# Resume testing for blocked modules after environment is fixed

COLLECTION_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BLOCKED_MANIFEST="$COLLECTION_ROOT/docs/plans/blocked_modules.md"

# Parse issue parameter
ISSUE=$1

if [ -z "$ISSUE" ]; then
    echo "Usage: ./resume_testing.sh <issue_name>"
    echo "Example: ./resume_testing.sh scvmm_server"
    exit 1
fi

# Verify environment for this issue
echo "=== Verifying Environment for: $ISSUE ==="

case $ISSUE in
    scvmm_server)
        # Verify SCVMM Server
        pwsh -Command "Import-Module VirtualMachineManager; Get-SCVMMServer -ComputerName localhost"
        if [ $? -ne 0 ]; then
            echo "❌ SCVMM Server still not working"
            exit 1
        fi
        AFFECTED_MODULES=("scvmm_host" "scvmm_vm" "scvmm_library_share" "scvmm_cloud" "scvmm_network" "scvmm_template" "scvmm_service_template")
        ;;
    
    postgresql)
        # Verify PostgreSQL
        psql -c "SELECT version();" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "❌ PostgreSQL still not working"
            exit 1
        fi
        AFFECTED_MODULES=("app_postgres_user" "app_postgres_database" "app_postgres_schema")
        ;;
    
    *)
        echo "Unknown issue: $ISSUE"
        exit 1
        ;;
esac

echo "✅ Environment verified for: $ISSUE"
echo ""

# Run tests for affected modules
echo "=== Testing Affected Modules ==="
PASSED=0
FAILED=0

for MODULE in "${AFFECTED_MODULES[@]}"; do
    echo ""
    echo "Testing: $MODULE"
    echo "================================"
    
    ansible-test integration $MODULE --python 3.9
    
    if [ $? -eq 0 ]; then
        echo "✅ $MODULE PASSED"
        ((PASSED++))
        
        # Update blocked_modules.md
        sed -i "s/### Module: $MODULE/### Module: $MODULE\\n\\n**Status**: ✅ FULLY TESTED (environment fixed)/" "$BLOCKED_MANIFEST"
        
        # Update module_backlog.md
        sed -i "s/- \[ \] $MODULE/- [x] $MODULE/" "$COLLECTION_ROOT/docs/plans/module_backlog.md"
    else
        echo "❌ $MODULE FAILED (check logs)"
        ((FAILED++))
    fi
done

echo ""
echo "=== Resume Testing Summary ==="
echo "Issue: $ISSUE"
echo "Total Modules: ${#AFFECTED_MODULES[@]}"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✅ All modules now fully tested!"
    echo "Environment issue '$ISSUE' is resolved."
    
    # Update issue status in blocked_modules.md
    sed -i "s/\*\*Status\*\*: ❌ BLOCKING/\*\*Status\*\*: ✅ FIXED/" "$BLOCKED_MANIFEST"
else
    echo "⚠️ Some modules still failing. Check logs."
fi
```

---

## Workflow Integration

### During Initial Build (Degraded Environment)

1. **Platform Prerequisite Specialist** reports partial failure
2. **Lead Architect** decides to proceed with degraded environment
3. **Module Workers** build ALL modules (code generation unaffected)
4. **QA Coordinator** tests environment-compatible modules
5. **QA Coordinator** creates `blocked_modules.md` for incompatible modules
6. **Release Specialist** delivers collection with `blocked_modules.md` included

### After Environment is Fixed

1. **User fixes environment** (installs SCVMM, PostgreSQL, etc.)
2. **User runs**: `./scripts/resume_testing.sh scvmm_server`
3. **Script verifies** environment is now working
4. **Script runs tests** for all blocked modules
5. **Script updates** both `blocked_modules.md` and `module_backlog.md`
6. **When all tests pass**: Collection is 100% tested
7. **Git commit**: "Completed testing for previously blocked modules"

---

## Status Transitions

### Module Status Progression

```
[ ] TODO                    (Module not built yet)
    ↓
[~] IN PROGRESS            (Module being built)
    ↓
[!] CODE COMPLETE          (Code written, tests blocked by environment)
    ↓
[x] DONE                   (Fully tested and approved)
```

### Environment Status Progression

```
❌ BLOCKING                (Issue prevents testing)
    ↓
⚠️ DEGRADED               (Workaround in place, not ideal)
    ↓
✅ FIXED                   (Issue resolved, full testing possible)
```

---

## Example: Full Lifecycle

### Day 1: Initial Build with Failed SCVMM

```
1. Prerequisites: SCVMM Server installation fails
2. Lead Architect: Proceed with degraded environment (SCVMM Console only)
3. Build Phase: All 20 modules built
4. QA Phase: 
   - 13 modules tested (Hyper-V, SQL, info modules)
   - 7 modules blocked (SCVMM write operations)
5. Output: blocked_modules.md created with 7 blocked modules
6. Delivery: Collection pushed with 65% test coverage
```

**blocked_modules.md created**:
```markdown
# Blocked Modules Manifest

Environment Issue: SCVMM Server Not Installed
Blocked Modules: 7
Tested Modules: 13
Coverage: 65%

[Details for each blocked module...]
```

### Day 3: User Fixes SCVMM

```bash
# User installs SCVMM Server successfully
Install-SCVMM

# Verify it's working
Get-SCVMMServer -ComputerName localhost
# ✅ Works!

# Resume testing
cd ~/agentic-workflow-collections/microsoft/scvmm
./scripts/resume_testing.sh scvmm_server

# Output:
# ✅ scvmm_host PASSED
# ✅ scvmm_vm PASSED
# ✅ scvmm_library_share PASSED
# ✅ scvmm_cloud PASSED
# ✅ scvmm_network PASSED
# ✅ scvmm_template PASSED
# ✅ scvmm_service_template PASSED
#
# All modules now fully tested!

# Git commit
git add .
git commit -m "Completed testing for SCVMM modules after environment fix"
git push
```

**blocked_modules.md updated**:
```markdown
# Blocked Modules Manifest

Environment Issue: SCVMM Server Not Installed
Status: ✅ FIXED (2026-05-30)
Previously Blocked: 7 modules
Now Tested: 20/20
Coverage: 100% ✅
```

---

## Benefits

1. **Progressive Testing**: Don't block entire build for partial environment issues
2. **Clear Tracking**: Know exactly which modules need retesting
3. **Reproducible**: Anyone can pick up and continue testing
4. **Automation**: Scripts handle the resume process
5. **Documentation**: Clear instructions on how to fix environment
6. **Traceability**: Know when, why, and how modules were blocked
7. **100% Goal**: Eventually achieve full coverage incrementally
