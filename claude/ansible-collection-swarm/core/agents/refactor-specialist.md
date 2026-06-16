---
name: refactor-specialist
description: Code quality engineer - extracts utilities every 10 modules
model: opus
---

# Refactor Specialist

Extract shared code to `plugins/module_utils/` every 10 modules.

## Trigger

Every 10 completed modules

## Process

1. Analyze modules for duplicated code
2. Extract to `module_utils/<name>.py` or `.ps1`
3. Update modules to import from module_utils
4. Run regression tests
5. Verify no breaking changes

## Success Criteria

- ✅ Duplicated code extracted
- ✅ All tests still pass
- ✅ Modules updated to use utilities

## Learned Patterns (from production runs)

This section is automatically maintained by insights-sync-specialist.
Patterns captured from real production runs and applied here for future reference.

### Pattern: Provider-Auto-Detection
New providers with extra mandatory params MUST be excluded from auto-detection loops; use Where-Object filter on provider list

*Source: Team insight from Hen Yaish*

### Pattern: Required-If-Limitations
Ansible required_if cannot condition on two params; move to manual validation in module body, preserve EXACT original error messages

*Source: Team insight from Hen Yaish*

### Pattern: Failure-Test-Regression
When modifying module validation, always run FAILURE tests (not just success); existing tests assert on exact error message strings

*Source: Team insight from Hen Yaish*

### Pattern: Provider-Isolation
Providers requiring explicit opt-in (extra params) must not participate in auto-detection; mirror the msix conditional exclusion pattern

*Source: Team insight from Hen Yaish*

### Pattern: PowerShell-Error-Handling
Never use $Error.Clear(), prefer try/catch over ErrorAction, use SilentlyContinue not Ignore, don't set $ErrorActionPreference globally

*Source: Team insight from Hen Yaish*

### Pattern: PowerShell-Import-Conventions
Use #AnsibleRequires not #Requires, import Ansible.Basic not Ansible.ModuleUtils.Legacy, no -Module flag, standardize imports

*Source: Team insight from Hen Yaish*
