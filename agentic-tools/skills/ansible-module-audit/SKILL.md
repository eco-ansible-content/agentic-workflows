---
name: ansible-module-audit
description: Use when auditing an Ansible module for API/cmdlet coverage, module_utils usage, integration test completeness, test cleanup, and test module reuse. Works on any platform — Windows, cloud, network, Linux. Produces a scored report out of 100.
---

# Ansible Module Audit

Audits a single Ansible module for quality and completeness across five dimensions. Platform-agnostic — works on any Ansible collection (Windows/PowerShell, cloud/REST, network/CLI, Linux/command).

## Usage

```
/ansible-module-audit scvmm_cloud
/ansible-module-audit ec2_instance
/ansible-module-audit ios_config
```

The argument is a module name from the collection in the current working directory.

## When to Use

- After implementing a module — to verify completeness before PR
- During code review — to assess module quality objectively
- Before release — to audit modules for gaps

## Execution Steps

Follow these steps exactly. Do NOT ask clarifying questions — research autonomously.

### Step 0: Resolve Paths and Detect Platform

Extract the module name from the user's argument. Determine the collection root from the current working directory. Read `galaxy.yml` to get the collection namespace and name.

**Locate module files:**

```bash
find plugins/modules/ -name "<module_name>.*" -type f
```

Determine the module type from what exists:

| Files found | Module type | Platform |
|-------------|-------------|----------|
| `.py` + `.ps1` | PowerShell module | Windows (SCVMM, AD, Exchange, etc.) |
| `.py` only | Python module | Cloud, network, Linux, or any non-Windows |

Read ALL module files found.

**Locate shared utilities:**

```bash
find plugins/module_utils/ -type f \( -name "*.py" -o -name "*.psm1" -o -name "*.ps1" \)
```

Read all module_utils files to catalog available shared functions/classes.

**Locate integration tests:**

Check these paths in order for a test target:
1. `tests/integration/targets/<module_name>/` — exact match
2. `tests/integration/targets/<base_name>/` — for `_info` modules, try the base name (e.g., `ec2_instance` for `ec2_instance_info`)
3. If neither exists, mark tests as missing (dimensions 3-5 score 0).

If a test target is found, read all YAML files under it recursively.

**Identify the platform's API surface type:**

Read the module implementation to determine how it interacts with the managed platform:

| Signal | API type | Search strategy |
|--------|----------|-----------------|
| PowerShell cmdlet calls (`Get-*`, `New-*`, `Set-*`, `Remove-*`, etc.) | **Cmdlet** | Search for platform cmdlets on Microsoft docs |
| HTTP/REST calls (`requests`, `urllib`, `open_url`, SDK client methods) | **REST API** | Search for platform REST API reference |
| CLI commands (`run_command`, `send_command`, connection plugins) | **CLI** | Search for platform CLI command reference |
| SDK method calls (boto3, azure SDK, google-cloud, etc.) | **SDK** | Search for SDK method reference for the resource |

Store the detected API type — it determines how Step 1 runs.

### Step 1: API/Cmdlet Coverage (25 points)

**Goal:** Verify the module uses all relevant platform operations for its resource type.

**1a. Extract operations used in the module:**

Based on the detected API type:

**Cmdlet modules (PowerShell):**
- Find all cmdlet calls matching platform patterns (e.g., `*-SC*` for SCVMM, `*-Az*` for Azure, `*-AD*` for Active Directory)
- Exclude cmdlets used only as dependency lookups for related objects (e.g., `Get-SCVMHostGroup` inside a cloud module)

**REST/SDK modules (Python):**
- Find all API calls: HTTP methods (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`) or SDK method calls (`client.create_*`, `client.describe_*`, `client.delete_*`, etc.)
- Map to CRUD operations: which operations does the module support?
- Exclude calls used only for dependency lookups

**CLI modules (network):**
- Find all CLI commands sent to the device
- Map to configuration operations supported

**1b. Research available operations:**

Search for the platform's full API surface for this resource type:

```
WebSearch("<platform> <resource_type> PowerShell cmdlets site:learn.microsoft.com")   # Cmdlet
WebSearch("<platform> <resource_type> REST API reference")                             # REST
WebSearch("<platform> <resource_type> CLI commands reference")                         # CLI
WebSearch("boto3 <service> <resource_type> methods")                                  # AWS SDK
WebSearch("azure SDK <resource_type> operations python")                              # Azure SDK
```

Build a table of all operations that exist for this resource type. Classify each as:
- **Used** — called in the module
- **Not applicable** — outside this module's scope (belongs in a different module)
- **Missing** — a relevant operation the module should support but doesn't

**1c. Score:**

| Condition | Points |
|-----------|--------|
| Module covers all applicable operations | 25 |
| Covers most, 1-2 missing non-critical operations | 20 |
| Missing operations that represent core functionality | 10-15 |
| Covers only a fraction of available operations | 0-10 |

For **info modules**: the primary operation is read/list/get. Score 25 if it retrieves the resource and exposes all useful properties. Deduct if it filters out important properties that the API returns.

### Step 2: module_utils Usage (20 points)

**Goal:** Verify the module uses shared utilities instead of duplicating code.

**2a. Catalog available module_utils:**

From the files read in Step 0, build a catalog of every exported function/class:

**For Python module_utils (`.py`):**
- List all public functions and classes (not prefixed with `_`)
- Note what each does (connection helpers, API wrappers, argument spec builders, error handlers, result formatters)

**For PowerShell module_utils (`.psm1`):**
- List all functions in `Export-ModuleMember`
- Note what each does

**2b. Check module imports and usage:**

**Python modules** — look for:
```python
from ansible_collections.<namespace>.<name>.plugins.module_utils.<util> import <function>
```

**PowerShell modules** — look for:
```powershell
#AnsibleRequires -PowerShell ansible_collections.<namespace>.<name>.plugins.module_utils.<util>
```

For each available utility function/class, determine if the module SHOULD be using it based on what the module does.

**2c. Check for code duplication:**

Look for patterns in the module that duplicate what module_utils already provides. Common duplication patterns:

| Pattern in module | Should use instead |
|-------------------|--------------------|
| Manual API/platform connection setup | Shared connection helper |
| Manual result dict building with property iteration | Shared result formatter |
| Manual parameter comparison for change detection | Shared diff/comparison utility |
| Inline error handling boilerplate repeated from other modules | Shared error handler |
| Copy-pasted argument spec fragments | Shared argument spec builder |
| Manual pagination logic | Shared pagination helper |
| Manual retry/backoff logic | Shared retry utility |

Also compare against 2-3 other modules in the same collection — if they all use a shared function for the same task but this module does it inline, that's duplication.

**2d. Score:**

| Condition | Points |
|-----------|--------|
| Uses all applicable module_utils, no duplication | 20 |
| Uses most, minor duplication (1-2 instances) | 15 |
| Significant duplication or missing key utility usage | 5-10 |
| Does not import module_utils / massive duplication | 0-5 |

### Step 3: Integration Test Coverage (25 points)

**Goal:** Verify tests cover all module functionality with check mode, idempotency, and result assertions.

**3a. Read integration tests:**

Read all YAML files in the test target directory recursively.

**3b. Check test coverage matrix:**

For **action modules** (manage resources), verify tests exist for:

| Test scenario | What to look for |
|---------------|------------------|
| **Create** | Calls module with `state: present` (or equivalent), asserts `changed`, asserts return values |
| **Create idempotency** | Runs same create again, asserts `not changed` |
| **Update** | Modifies a property, asserts `changed` and updated values |
| **Update idempotency** | Runs same update again, asserts `not changed` |
| **Delete** | Calls module with `state: absent` (or equivalent), asserts `changed` |
| **Delete idempotency** | Runs delete again, asserts `not changed` |
| **Delete non-existent** | Deletes something that doesn't exist, asserts `not changed` |
| **Check mode create** | `check_mode: true`, asserts `changed`, then verifies no actual change |
| **Check mode update** | `check_mode: true`, asserts `changed`, then verifies no actual change |
| **Check mode delete** | `check_mode: true`, asserts `changed`, then verifies no actual change |
| **Info verification** | After each mutation, uses the `_info` module (or equivalent read) to verify actual state |
| **Return value assertions** | Asserts specific field values, not just `is defined` or `is not none` |

For **info modules** (read-only), verify tests exist for:

| Test scenario | What to look for |
|---------------|------------------|
| **List all** | Calls without filters, asserts results returned |
| **Get by name/id** | Calls with specific filter, asserts correct object returned |
| **Get non-existent** | Calls with invalid filter, asserts empty/no result |
| **Field validation** | Asserts returned fields have expected values (not just `is defined`) |

**3c. Score:**

| Condition | Points |
|-----------|--------|
| All applicable test scenarios covered with value assertions | 25 |
| Most scenarios covered, minor gaps (1-2 missing) | 20 |
| Core CRUD tested but missing check mode or idempotency | 10-15 |
| Minimal tests or significant gaps | 0-10 |

### Step 4: Test Cleanup (15 points)

**Goal:** Verify tests clean up all resources they create, leaving a clean environment.

**4a. Check always block:**

Read the main test entry point (typically `tasks/main.yml`). Verify:

| Check | What to look for |
|-------|------------------|
| **block/always structure** | Tests wrapped in `block:` with an `always:` section |
| **Removes primary resource** | The `always` block removes the main resource under test |
| **Removes dependency resources** | Any supporting resources created for test setup are also cleaned up |
| **Uses modules for cleanup** | Cleanup uses Ansible modules (`state: absent` or equivalent), not raw commands |
| **ignore_errors on cleanup** | Cleanup tasks have `ignore_errors: true` so one failure doesn't skip the rest |
| **Validates removal** | After cleanup, verifies the resource is actually gone (via info module or equivalent) |

**4b. Check for resource leaks:**

Scan ALL test files for resources created (via `state: present`, `register:`, or any creation task) that are NOT cleaned up in the `always` block. This includes:
- The primary resource under test
- Supporting/dependency resources (e.g., a VPC created to test a subnet module, a VM created to test a disk module)
- Any resource created in any included task file

**4c. Score:**

| Condition | Points |
|-----------|--------|
| Full always block with cleanup, validation, and ignore_errors | 15 |
| Always block exists with cleanup but missing validation or ignore_errors | 10 |
| Partial cleanup — some resources leaked | 5 |
| No always block or no cleanup | 0 |

### Step 5: Test Module Reuse (15 points)

**Goal:** Verify tests use existing Ansible modules instead of raw/shell commands.

**5a. Check for raw command anti-patterns:**

Scan all integration test files for these patterns:

| Anti-pattern | Description |
|--------------|-------------|
| `ansible.builtin.command:` | Running CLI commands when a module exists for the operation |
| `ansible.builtin.shell:` | Running shell commands when a module exists |
| `ansible.builtin.raw:` | Raw SSH/WinRM commands |
| `ansible.windows.win_shell:` | PowerShell commands when a Windows module exists |
| `ansible.windows.win_command:` | Windows commands when a module exists |
| `ansible.windows.win_powershell:` | PowerShell scripts when a module exists |
| `ansible.builtin.uri:` | Direct HTTP calls when a module wraps that API |

For EACH instance found, determine:
1. What operation is the raw command performing?
2. Does an existing module in the same collection (or a well-known supporting collection) handle this operation?
3. If yes → flag as anti-pattern. If no module exists → acceptable.

**5b. Check for proper module usage:**

Verify that test setup and teardown uses:
- Modules from the **same collection** for creating/removing test dependencies
- Modules from **supporting collections** where the same collection doesn't cover it
- The **`_info` counterpart** module for verification (not raw queries)

**5c. Exceptions (not penalized):**

- Raw commands for operations where NO module exists in any available collection
- `set_fact` / `assert` / `debug` / `fail` / `pause` — standard test utilities
- `ansible.builtin.include_tasks` / `ansible.builtin.import_tasks` — task organization
- `ansible.builtin.wait_for` / `ansible.builtin.wait_for_connection` — timing utilities
- `ansible.builtin.setup` / `ansible.builtin.gather_facts` — fact gathering
- Platform-specific bootstrap that genuinely has no module equivalent

**5d. Score:**

| Condition | Points |
|-----------|--------|
| All operations use existing modules, no unnecessary raw commands | 15 |
| Mostly modules, 1-2 raw commands where a module exists | 10 |
| Mix of modules and raw commands | 5 |
| Heavily relies on raw commands despite modules being available | 0 |

### Step 6: Print Output

Print the full audit to the conversation. Do NOT create files.

Use this format:

```markdown
## Module Audit: <module_name>

**Collection:** <namespace>.<name>
**Platform:** <detected platform type>
**API type:** <Cmdlet / REST API / SDK / CLI>

### Summary

**Overall Score: XX/100**

| # | Dimension | Score | Max | Status |
|---|-----------|-------|-----|--------|
| 1 | API/Cmdlet Coverage | XX | 25 | <PASS/WARN/FAIL> |
| 2 | module_utils Usage | XX | 20 | <PASS/WARN/FAIL> |
| 3 | Integration Test Coverage | XX | 25 | <PASS/WARN/FAIL> |
| 4 | Test Cleanup | XX | 15 | <PASS/WARN/FAIL> |
| 5 | Test Module Reuse | XX | 15 | <PASS/WARN/FAIL> |

Status thresholds: PASS = ≥80% of max, WARN = 50-79%, FAIL = <50%

---

### 1. API/Cmdlet Coverage (XX/25)

**Operations found for <ResourceType>:**

| Operation | Status | Notes |
|-----------|--------|-------|
| <Get/List/Describe cmdlet or endpoint> | Used | — |
| <Create cmdlet or endpoint> | Used | — |
| <Update cmdlet or endpoint> | Missing | Could support updating <property> |
| <Delete cmdlet or endpoint> | Used | — |

<1-2 sentence finding>

### 2. module_utils Usage (XX/20)

| Utility | Used | Should Use | Notes |
|---------|------|------------|-------|
| <shared_function_1> | Yes | Yes | — |
| <shared_function_2> | No | Yes | Module does this inline |

<1-2 sentence finding>

### 3. Integration Test Coverage (XX/25)

| Test Scenario | Present | Notes |
|---------------|---------|-------|
| Create | Yes | Asserts changed + return values |
| Create idempotency | Yes | — |
| Update | Yes | — |
| Update idempotency | No | Missing |
| Delete | Yes | — |
| Delete idempotency | No | Missing |
| Check mode (create) | No | Missing |
| Check mode (update) | Yes | — |
| Check mode (delete) | No | Missing |
| Info verification | Yes | After each mutation |
| Return value assertions | Partial | Uses `is defined` instead of exact values |

<1-2 sentence finding>

### 4. Test Cleanup (XX/15)

| Check | Status |
|-------|--------|
| block/always structure | Yes/No |
| Removes primary resource | Yes/No |
| Removes dependency resources | Yes/No/N/A |
| Uses modules for cleanup | Yes/No |
| ignore_errors on cleanup | Yes/No |
| Validates removal | Yes/No |

<1-2 sentence finding>

### 5. Test Module Reuse (XX/15)

| Anti-pattern | Instances | Details |
|--------------|-----------|---------|
| shell/command for module-covered ops | 0 | — |
| raw scripts for setup/teardown | 0 | — |
| direct API calls bypassing modules | 0 | — |

<1-2 sentence finding>

---

### Recommendations

- <Actionable item per finding, ordered by impact>
- <Each recommendation references the specific dimension>
```

**Status thresholds:**
- **PASS**: Score ≥ 80% of dimension max
- **WARN**: Score 50-79% of dimension max
- **FAIL**: Score < 50% of dimension max

## Important Rules

- **Print** output to conversation — do NOT save to files
- Do NOT ask clarifying questions — research autonomously
- This is a **read-only** analysis — do not modify any files
- When checking API/cmdlet coverage, always search online docs — do not rely on memory
- Score objectively — do not inflate scores to be polite
- Info modules are scored differently from action modules in dimensions 1 and 3
- If integration tests do not exist at all, dimensions 3-5 all score 0
- Adapt terminology to the platform: "cmdlets" for PowerShell, "endpoints" for REST, "methods" for SDK, "commands" for CLI
