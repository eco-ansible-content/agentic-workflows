# Insight: PowerShell Error Handling Best Practices

**Date**: 2026-06-10  
**Category**: Pattern  
**Subcategory**: PowerShell-Error-Handling  
**Applies To**: All Windows modules using PowerShell  
**Applied To Agents**: module-worker, enhancement-specialist, refactor-specialist  
**Severity**: High

## The Problem

AI-generated PowerShell code exhibits several error-handling anti-patterns:
1. Overuses `$Error.Clear()` - loses stack traces and error context
2. Overuses `ErrorAction` parameter, especially `Ignore` vs proper `SilentlyContinue`
3. Sets `$ErrorActionPreference` at module level (unusual and problematic)
4. Uses error suppression instead of proper `try/catch` blocks

**Observed in**: SCVMM collection review, microsoft.scvmm PR #4

## What We Learned

PowerShell error handling has community standards that AI agents don't naturally follow:

- **Never use `$Error.Clear()`** in production modules - you lose debugging info
- **Prefer `try/catch`** over `ErrorAction` parameters for controlled error handling
- **Use `SilentlyContinue`** not `Ignore` when suppressing expected errors
- **Don't set `$ErrorActionPreference`** globally in modules

## The Solution

**Update module-worker and enhancement-specialist**:

1. **Ban `$Error.Clear()`**:
```powershell
# ❌ NEVER do this
$Error.Clear()
Get-SomeCmdlet ...

# ✅ Instead, use try/catch
try {
    Get-SomeCmdlet ...
} catch {
    # Handle specific error
}
```

2. **Use try/catch for error handling**:
```powershell
# ❌ Don't suppress with ErrorAction
Get-Resource -Name $Name -ErrorAction Ignore

# ✅ Use try/catch for control flow
try {
    $resource = Get-Resource -Name $Name -ErrorAction Stop
} catch [ResourceNotFoundException] {
    # Expected - resource doesn't exist
    $resource = $null
}
```

3. **When you must use ErrorAction, use SilentlyContinue**:
```powershell
# ❌ Ignore loses too much context
Get-Item -Path $Path -ErrorAction Ignore

# ✅ SilentlyContinue is better
Get-Item -Path $Path -ErrorAction SilentlyContinue
```

4. **Never set global ErrorActionPreference**:
```powershell
# ❌ Don't do this in modules
$ErrorActionPreference = 'Stop'

# ✅ Use -ErrorAction on individual cmdlets
Get-Something -ErrorAction Stop
```

## Impact

**Before**: Modules lose error context, debugging is hard, unexpected failures
**After**: Proper error handling, stack traces preserved, better debugging
**Time Saved**: Hours of debugging per module

## Applies To

- All Windows PowerShell modules
- Any module using SCVMM, Hyper-V, Active Directory, Exchange cmdlets
- Module utilities that wrap PowerShell APIs

## Code Review Checklist

When reviewing PowerShell modules:
- [ ] No `$Error.Clear()` anywhere
- [ ] No global `$ErrorActionPreference` setting
- [ ] `try/catch` used for error handling
- [ ] `ErrorAction` only used with `Stop` or `SilentlyContinue`
- [ ] No bare `Ignore` usage
