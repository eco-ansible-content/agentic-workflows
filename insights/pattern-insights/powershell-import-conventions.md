# Insight: PowerShell Module Import Conventions

**Date**: 2026-06-10  
**Category**: Pattern  
**Subcategory**: PowerShell-Import-Conventions  
**Applies To**: All Ansible Windows modules  
**Applied To Agents**: module-worker, enhancement-specialist  
**Severity**: High

## The Problem

AI agents generate incorrect PowerShell import patterns for Ansible modules:
1. Uses `#Requires` instead of `#AnsibleRequires`
2. Imports `Ansible.ModuleUtils.Legacy` instead of `Ansible.Basic`
3. Uses wrong flags like `-Module`
4. Inconsistent import styles across modules

**Observed in**: microsoft.scvmm PR #4, multiple SCVMM modules

## What We Learned

Ansible has specific conventions for PowerShell module imports that differ from standard PowerShell:

- **Use `#AnsibleRequires`** not `#Requires` (Ansible-specific directive)
- **Import `Ansible.Basic`** not `Ansible.ModuleUtils.Legacy` (modern pattern)
- **No `-Module` flag** in AnsibleRequires directives
- **Standardize on one import pattern** across entire collection

## The Solution

**Correct PowerShell module imports**:

### 1. Basic Module Creation

```powershell
#!powershell

# ✅ Correct Ansible imports
#AnsibleRequires -CSharpUtil Ansible.Basic
#AnsibleRequires -PowerShell Ansible.ModuleUtils.Legacy.HelperName

# ❌ WRONG - Don't use standard PowerShell #Requires
#Requires -Module Ansible.ModuleUtils.Legacy

# ❌ WRONG - Don't use -Module flag
#AnsibleRequires -Module Ansible.Basic
```

### 2. Module Utils Imports

```powershell
# ✅ Correct format for collection module_utils
#AnsibleRequires -PowerShell ansible_collections.namespace.collection.plugins.module_utils.helper_name

# Example for SCVMM:
#AnsibleRequires -PowerShell ansible_collections.microsoft.scvmm.plugins.module_utils.scvmm_compute
```

### 3. Module Creation Pattern

```powershell
#!powershell
#AnsibleRequires -CSharpUtil Ansible.Basic

$spec = @{
    options = @{
        name = @{ type = 'str'; required = $true }
        state = @{ type = 'str'; default = 'present'; choices = 'present', 'absent' }
    }
    supports_check_mode = $true
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

# NOT Ansible.ModuleUtils.Legacy
```

## Impact

**Before**: Modules fail to load, import errors, inconsistent patterns  
**After**: Clean imports, modules load correctly, maintainable code  
**Blockers Prevented**: Module import failures in CI/CD

## Applies To

- All Ansible Windows collections
- Any PowerShell-based Ansible module
- Module utilities in `plugins/module_utils/*.psm1`

## Standard Template

Add to module-worker agent:

```powershell
# Template for new PowerShell modules
#!powershell
#AnsibleRequires -CSharpUtil Ansible.Basic
#AnsibleRequires -PowerShell ansible_collections.NAMESPACE.COLLECTION.plugins.module_utils.UTIL_NAME

$spec = @{
    options = @{
        # ... module options
    }
    supports_check_mode = $true
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

try {
    # Module logic here
    $module.ExitJson()
} catch {
    $module.FailJson("Failed: $($_.Exception.Message)", $_)
}
```

## Code Review Checklist

- [ ] Uses `#AnsibleRequires` not `#Requires`
- [ ] Imports `Ansible.Basic` not `Ansible.ModuleUtils.Legacy`
- [ ] No `-Module` flag in import directives
- [ ] Collection module_utils use full ansible_collections path
- [ ] All modules in collection use same import pattern
