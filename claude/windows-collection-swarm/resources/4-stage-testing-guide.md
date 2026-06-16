# 4-Stage Testing Loop for Windows Ansible Modules

Every module MUST pass all 4 stages before approval. This is non-negotiable.

## Overview

```
Module Implementation
        ↓
Stage 1: Initial Run (Basic Functionality)
        ↓
Stage 2: Idempotency (No Changes on Repeat)
        ↓
Stage 3: Check Mode (Dry-Run Accuracy)
        ↓
Stage 4: Error Handling (Graceful Failure)
        ↓
    APPROVED ✓
```

## Stage 1: Initial Run

**Purpose**: Verify the module works and achieves its intended functionality.

**Test Objective**: Module executes successfully on first run and returns expected state.

**Commands**:
```bash
ansible-test integration <module_name> --python 3.9 --inventory tests/inventory.winrm
```

**Success Criteria**:
- Exit code: 0
- No errors in output
- `changed: true` (if module made changes)
- Return values match documentation
- Resource is in desired state

**Example Test**:
```yaml
- name: Create resource on first run
  namespace.collection.module_name:
    name: test_resource
    state: present
  register: result

- name: Verify creation succeeded
  assert:
    that:
      - result is changed
      - result.resource.name == "test_resource"
      - result.resource.state == "present"
```

**Common Failures**:
- Missing required parameters
- Incorrect permissions on target
- Resource conflicts
- Invalid parameter values

**Fix Approach**:
1. Check module parameter validation
2. Verify WinRM connectivity
3. Check target host permissions
4. Review parameter types and values

## Stage 2: Idempotency

**Purpose**: Verify the module is truly idempotent (running twice makes no changes on second run).

**Test Objective**: Running the same task twice shows `changed: false` on the second run.

**Commands**:
```bash
# Run the same test twice in succession
ansible-test integration <module_name> --python 3.9 --inventory tests/inventory.winrm
ansible-test integration <module_name> --python 3.9 --inventory tests/inventory.winrm
```

**Success Criteria**:
- Second run exit code: 0
- Second run shows `changed: false`
- Resource state unchanged
- No errors or warnings

**Example Test**:
```yaml
- name: Create resource (first run)
  namespace.collection.module_name:
    name: test_resource
    state: present
  register: first_run

- name: Create resource again (second run)
  namespace.collection.module_name:
    name: test_resource
    state: present
  register: second_run

- name: Verify idempotency
  assert:
    that:
      - first_run is changed
      - second_run is not changed
      - second_run.resource.state == first_run.resource.state
```

**Common Failures**:
- Module doesn't check current state
- Module always recreates resources
- Timestamp/metadata changes trigger `changed: true`
- Comparison logic is broken

**Fix Approach**:
1. Add state checking before operations
2. Compare current vs. desired state
3. Only set `changed: true` if actual change made
4. Ignore non-functional metadata (timestamps, etc.)

**Idempotency Pattern**:
```powershell
# Get current state
$currentState = Get-CurrentResource -Name $name

# Compare with desired state
if ($currentState.Property -ne $desiredProperty) {
    # State differs - make change
    Set-Resource -Name $name -Property $desiredProperty
    $module.Result.changed = $true
} else {
    # State matches - no change needed
    $module.Result.changed = $false
}
```

## Stage 3: Check Mode (Dry-Run)

**Purpose**: Verify check mode works correctly (reports changes without making them).

**Test Objective**: Module reports what would change without actually changing it.

**Commands**:
```bash
ansible-test integration <module_name> --check --python 3.9 --inventory tests/inventory.winrm
```

**Success Criteria**:
- Exit code: 0
- Reports `changed: true` if resource would be changed
- No actual changes made to system
- Return values indicate planned changes

**Example Test**:
```yaml
- name: Remove existing resource
  namespace.collection.module_name:
    name: test_resource
    state: absent

- name: Run in check mode
  namespace.collection.module_name:
    name: test_resource
    state: present
  check_mode: yes
  register: check_result

- name: Verify check mode reported change
  assert:
    that:
      - check_result is changed

- name: Verify resource was NOT actually created
  namespace.collection.module_name_info:
    name: test_resource
  register: verify

- name: Confirm no actual change
  assert:
    that:
      - verify.exists == false
```

**Common Failures**:
- Module doesn't respect `check_mode` parameter
- Module makes changes even in check mode
- Module reports `changed: false` when it should report `changed: true`
- Module fails in check mode

**Fix Approach**:
1. Add `supports_check_mode = $true` to module spec
2. Check `$module.CheckMode` before making changes
3. Still set `$module.Result.changed` correctly
4. Ensure all code paths work in check mode

**Check Mode Pattern**:
```powershell
if ($currentState -ne $desiredState) {
    # Change is needed
    if (-not $module.CheckMode) {
        # Only make actual change if NOT in check mode
        Set-Resource -Name $name -State $desiredState
    }
    # Report change in both modes
    $module.Result.changed = $true
} else {
    $module.Result.changed = $false
}
```

## Stage 4: Error Handling

**Purpose**: Verify the module fails gracefully with meaningful errors on invalid input.

**Test Objective**: Invalid parameters produce clear, actionable error messages.

**Commands**:
```bash
# Run test that intentionally uses invalid parameters
ansible-test integration <module_name>_errors --python 3.9 --inventory tests/inventory.winrm
```

**Success Criteria**:
- Module fails (doesn't crash)
- Error message is meaningful
- Error message is actionable
- No stack traces exposed to user

**Example Test**:
```yaml
- name: Try invalid parameter
  namespace.collection.module_name:
    name: ""  # Invalid: empty name
    state: present
  register: error_result
  ignore_errors: yes

- name: Verify graceful failure
  assert:
    that:
      - error_result is failed
      - error_result.msg is defined
      - error_result.msg | length > 0
      - "'empty' in error_result.msg | lower or 'required' in error_result.msg | lower"

- name: Try invalid state
  namespace.collection.module_name:
    name: test_resource
    state: invalid_state
  register: error_result_2
  ignore_errors: yes

- name: Verify meaningful error
  assert:
    that:
      - error_result_2 is failed
      - "'choice' in error_result_2.msg | lower or 'invalid' in error_result_2.msg | lower"
```

**Common Error Scenarios to Test**:
1. Empty/null required parameters
2. Invalid enum values (e.g., `state: "invalid"`)
3. Malformed paths
4. Permission denied
5. Resource not found
6. Conflicting parameters

**Good Error Messages**:
```powershell
# Bad
$module.FailJson("Error")

# Better
$module.FailJson("Parameter 'name' is required")

# Best
$module.FailJson("Parameter 'name' cannot be empty. Provide a valid resource name.")
```

**Error Handling Pattern**:
```powershell
# Parameter validation
if ([string]::IsNullOrWhiteSpace($name)) {
    $module.FailJson("Parameter 'name' cannot be empty. Provide a valid resource name.")
}

# Operation error handling
try {
    $result = Get-Resource -Name $name
} catch [System.UnauthorizedAccessException] {
    $module.FailJson("Permission denied accessing resource '$name'. Ensure you have administrator privileges.", $_)
} catch [System.IO.FileNotFoundException] {
    $module.FailJson("Resource '$name' not found. Verify the resource exists.", $_)
} catch {
    $module.FailJson("Failed to access resource '$name': $($_.Exception.Message)", $_)
}
```

## Testing Checklist

Use this checklist for every module:

### Stage 1: Initial Run
- [ ] Module executes without errors
- [ ] Returns expected changed status
- [ ] Resource is in desired state
- [ ] Return values match documentation

### Stage 2: Idempotency
- [ ] Second run shows `changed: false`
- [ ] Resource state remains stable
- [ ] No spurious changes reported
- [ ] Works across multiple runs

### Stage 3: Check Mode
- [ ] Module supports check mode
- [ ] Reports changes without making them
- [ ] Return values are accurate
- [ ] No side effects occur

### Stage 4: Error Handling
- [ ] Empty required parameters fail gracefully
- [ ] Invalid enum values fail with clear message
- [ ] Permission errors are meaningful
- [ ] All error paths tested

## Automated Test Execution

Run all 4 stages automatically:

```bash
#!/bin/bash
MODULE=$1

echo "Stage 1: Initial Run"
ansible-test integration $MODULE --python 3.9

echo "Stage 2: Idempotency"
ansible-test integration $MODULE --python 3.9

echo "Stage 3: Check Mode"
ansible-test integration $MODULE --check --python 3.9

echo "Stage 4: Error Handling"
ansible-test integration ${MODULE}_errors --python 3.9

echo "All stages complete!"
```

## Failure Recovery

If a stage fails:

1. **Attempt 1**: Analyze test output, fix obvious issue
2. **Attempt 2**: Review module code, fix implementation
3. **Attempt 3**: Modify test if test logic is wrong
4. **Report**: If unresolvable after 3 attempts, escalate

## QA Coordinator Responsibilities

The QA Coordinator agent MUST:
1. Run all 4 stages for every module
2. Verify each stage passes before proceeding
3. Invoke code-reviewer if any stage fails
4. Re-run all 4 stages after fixes
5. Only approve module after all stages pass

## Documentation Requirements

Test files must include comments indicating which stage is being tested:

```yaml
---
# 4-Stage Testing Loop: module_name

# Stage 1: Initial Run
- name: Test basic functionality
  # ...

# Stage 2: Idempotency
- name: Test second run shows no changes
  # ...

# Stage 3: Check Mode
- name: Test check mode doesn't make changes
  # ...

# Stage 4: Error Handling
- name: Test graceful failure on invalid input
  # ...
```

## Success Metrics

A module passes the 4-stage loop when:
- All 4 stages execute without fatal errors
- Idempotency is proven (second run unchanged)
- Check mode works correctly
- Error messages are meaningful

Only then can QA Coordinator mark the module as approved.
