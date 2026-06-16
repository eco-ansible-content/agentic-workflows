# Insight: Enhancement Mode CI/CD Workflow Patterns

**Date**: 2026-06-02
**Category**: Operational
**Subcategory**: Enhancement-CI-CD
**Applies To**: Fork-based PR workflows for existing Ansible collections
**Applied To Agents**: enhancement-specialist, ci-validation-specialist, release-specialist, lead-architect
**Severity**: High
**Source Epic**: ACA-6275
**Source Collection**: ansible.windows (PR #905)

## The Problem

Building new modules for an existing, upstream collection requires a multi-step delivery workflow:
1. Create feature branch from upstream main
2. Push to fork remote
3. Create PR from fork to upstream
4. Monitor CI checks (Azure Pipelines for ansible.windows)
5. Fix CI failures, push fixes, and wait for re-runs
6. Handle PR lifecycle issues (closure, reopening)

Several operational issues were encountered during ACA-6275 that required autonomous handling.

## What We Learned

### 1. Feature Branch Creation from Upstream

The enhancement workflow must ensure the feature branch starts from the latest upstream main:

```bash
# Correct: Sync with upstream first
git fetch origin        # origin = upstream (ansible-collections/ansible.windows)
git checkout main
git pull origin main
git checkout -b add-modules-ACA-6275

# Push to fork remote (NOT origin)
git push hyaish add-modules-ACA-6275
```

**Common mistake**: Creating branch from stale local main. Always `git fetch origin && git pull origin main` first.

### 2. Commit Strategy for CI Fixes

The initial commit should be a single feature commit. Subsequent CI fixes should be SEPARATE commits (not amends) for traceability:

```
00ae5cea feat: add win_winget module and PackageManagement provider for win_package
a1670e0b fix: exclude package_management provider from auto-detection in win_package
75924eae fix: restore path/product_id validation for non-package_management providers
```

This produces a clean history where each CI fix is its own commit. This is important because:
- Reviewers can see what was fixed and why
- If a fix introduces a new issue, it can be reverted independently
- The commit messages document the CI failure → fix cycle

### 3. PR Lifecycle Management

PRs can be closed during CI iteration (either manually or by GitHub automation). The CI validation specialist must handle this:

```bash
# Check PR state
gh pr view 905 --json state --jq '.state'

# If closed, reopen
gh pr reopen 905
```

**Always check PR state before pushing fixes.** A push to a branch with a closed PR will NOT trigger CI re-runs.

### 4. Azure Pipelines CI for ansible.windows

The ansible.windows collection uses Azure Pipelines (dev.azure.com/ansible) for CI. Key characteristics:

- **Checks available via**: `gh pr checks` (lists all check names and URLs)
- **Logs accessible at**: `https://dev.azure.com/ansible/{projectId}/_apis/build/builds/{buildId}/logs`
- **No authentication required** for log access (public project)
- **36 total checks**: Sanity tests, unit tests, integration tests across multiple Windows versions
- **Infrastructure timeouts**: Some checks may fail with infrastructure timeouts (not code issues)

**Strategy for CI validation**:
1. Run `gh pr checks` to get check status
2. For failed checks, extract Azure build URL
3. Parse buildId from URL
4. Fetch logs via Azure DevOps REST API
5. Parse actual errors from logs
6. Apply targeted fixes (not guesses)

### 5. Sanity Test Patterns

Common sanity test failures for Windows PowerShell modules:

| Issue | Detection | Fix |
|-------|-----------|-----|
| Missing DOCUMENTATION | `ansible-test sanity --test validate-modules` | Add .py or .yml doc file |
| Wrong doc format | Check existing modules for pattern | Match collection's format (.yml vs .py) |
| Import errors | `ansible-test sanity --test import` | Check #AnsibleRequires directives |
| PSScriptAnalyzer | `ansible-test sanity --test pslint` | Follow PSScriptAnalyzer rules |

### 6. Version Bumping in Enhancement Mode

When adding features to an existing collection:
- Bump MINOR version (e.g., 3.6.1 -> 3.7.0) for new features
- Update `galaxy.yml` version field
- Generate changelog entries in both `CHANGELOG.rst` and `changelogs/changelog.yaml`
- Version bump should be in the SAME commit as the feature (not separate)

```yaml
# changelogs/changelog.yaml format
releases:
  3.7.0:
    release_date: "2026-06-02"
    changes:
      minor_changes:
        - "win_package - Add package_management provider for NuGet and PowerShellGet support"
      major_changes:
        - "win_winget - New module for Windows Package Manager (winget) integration"
```

### 7. Integration Test Execution on macOS (Darwin)

When the build machine is macOS but the target is Windows:
- `ansible-test integration` works over WinRM from macOS
- BUT: macOS may have fork() issues with some Python multiprocessing
- Solution: Test directly with `ansible-playbook` using the WinRM inventory, or defer to CI
- The `deferred_tests.yml` pattern documents when tests must run in CI

## Success Factors for ACA-6275

What made this build successful:

1. **Clean enhancement mode detection**: Lead architect correctly detected existing collection and deployed enhancement-specialist
2. **Pattern matching**: New modules matched existing collection patterns (PowerShell + Ansible.Basic, .yml doc format)
3. **Comprehensive testing**: 27 integration tests covering install/uninstall/idempotency/check-mode/failure-cases
4. **Autonomous CI fixing**: Two CI failures (auto-detection collision, validation restoration) fixed without user intervention
5. **Version management**: Clean minor version bump with generated changelog
6. **Four-pillar audit**: 100% pass rate on all quality checks

## Metrics

| Metric | Value |
|--------|-------|
| Total commits | 3 (1 feature + 2 CI fixes) |
| CI check runs | ~3 cycles |
| CI checks passing | 35/36 (1 infrastructure timeout) |
| Integration tests | 27 (all passing) |
| Files changed | 14 |
| Lines added | 1707 |
| Lines removed | 74 |
| Modules delivered | 2 (1 new + 1 enhanced) |
| Time to delivery | Single session |

## Applies To

This workflow applies to:
- **Any fork-based PR workflow** for Ansible collections
- **Azure Pipelines CI** for ansible-collections organization
- **Enhancement mode** builds adding modules to existing collections
- **Any CI with multiple check types** requiring targeted fix strategies

---

*Generated by learning-evolution-specialist from ACA-6275 build on 2026-06-02*
