# Code Review Learnings - PR #905

**Date**: 2026-06-02  
**PR**: https://github.com/ansible-collections/ansible.windows/pull/905  
**Reviewer**: Akasurde (ansible-collections maintainer)  
**Epic**: ACA-6275 - Package Management Modernization  
**Status**: CHANGES_REQUESTED

---

## Summary

First PR from ansible-collection-swarm received detailed code review with 22 comments. All feedback captured and converted into agent improvements. **Zero impact on upstream main** - PR never merged.

---

## Key Learnings

### 1. ⭐⭐⭐ One Module Per PR

**Feedback**: "Let us stick to one module per PR."

**Issue**: PR bundled both win_winget (NEW) and win_package (ENHANCEMENT)

**Learning**: Even if Epic specifies multiple modules, maintainers prefer **separate PRs** for easier review and independent merging.

**Agent Updates**:
- **lead-architect**: Added "PR Strategy for Enhancement Mode" section
- Asks user: "One PR per module or bundle all?" (defaults to one-per-module)
- Creates separate branches: `add-module-{module_name}` per module

---

### 2. ⭐⭐⭐ Don't Include Release Artifacts in PRs

**Feedback**: 
- "No need to add changelog for new module; tooling does it automatically"
- "We update this file when we do the new release"

**Files to Exclude**:
- ❌ `changelogs/changelog.yaml` (maintainer updates during release)
- ❌ `CHANGELOG.rst` (maintainer updates during release)
- ❌ Changelog fragments for NEW modules (tooling auto-generates)
- ❌ Version bump in `galaxy.yml` (maintainer does during release)

**What TO Include**:
- ✅ Changelog fragments ONLY for enhancements to existing modules

**Agent Updates**:
- **enhancement-specialist**: Step 0 - Determine changelog strategy
  - NEW modules: Skip changelog fragment
  - ENHANCED modules: Create fragment
- **release-specialist**: Added "PR Mode vs Release Mode" section
  - Don't bump version
  - Don't run antsibull-changelog release
  - Don't modify changelog.yaml or CHANGELOG.rst

---

### 3. ⭐⭐ Don't Include Planning Docs in PRs

**Feedback**: "I don't think this file is required" (repeated 4 times)

**Files Flagged**:
- `docs/plans/completion_report.md`
- `docs/plans/module_backlog.md`
- `docs/plans/prerequisites.md`
- `docs/plans/project_context.yml`

**Why**: These are **internal swarm artifacts**, not part of the collection.

**Agent Updates**:
- **enhancement-specialist**: Step 0 - Update .gitignore
  ```bash
  # Add to .gitignore
  docs/plans/
  ```
- **release-specialist**: Reset staged planning docs before commit
  ```bash
  git reset HEAD docs/plans/ 2>/dev/null || true
  ```

---

### 4. ⭐⭐ Use Semantic Markup in Documentation

**Feedback**: 10 suggestions to convert backticks to semantic markup

**Pattern**:
```diff
- The `package_management` provider uses `product_id`
+ The V(package_management) provider uses O(product_id)
```

**Markup Types**:
- `V(value)` - Option values: `V(present)`, `V(package_management)`
- `O(option)` - Option names: `O(state)`, `O(provider)`
- `C(code)` - Code literals: `C(NuGet)`, `C(PowerShellGet)`

**Agent Updates**:
- **enhancement-specialist**: Added "Documentation Markup (CRITICAL)" section
- Check existing modules for markup style
- Match collection's documentation format

---

### 5. ⭐ Extract Helper Functions (DRY)

**Feedback**: "Combine this code into a single function"

**Context**: win_winget.ps1 had duplicate code for package identification

**Learning**: Maintainers value Don't Repeat Yourself (DRY) principle

**Future**: refactor-specialist should run before delivery to identify duplicate code

---

### 6. ⭐⭐ Separate Bug Fixes from Features

**Feedback**: "Can we move this change into a separate PR?"

**Context**: Bug fix bundled with new feature in same file

**Learning**: Even in same file, bug fixes should be **separate PRs** from feature additions

**Agent Impact**: enhancement-specialist should only include code directly related to new feature

---

### 7. ⭐ Remove Redundant Documentation

**Feedback**: "Already mentioned in the description"

**Context**: Duplicate information in notes section

**Learning**: Don't repeat content already in module description

---

## Impact Summary

| Category | Agent | Change Type | Priority |
|----------|-------|-------------|----------|
| PR Scope | lead-architect | Added PR strategy question | HIGH |
| Release Process | enhancement-specialist | Step 0: PR mode prep | HIGH |
| Release Process | release-specialist | PR mode vs release mode | HIGH |
| Documentation | enhancement-specialist | Semantic markup guidance | MEDIUM |
| Repository Hygiene | enhancement-specialist | .gitignore for planning docs | MEDIUM |
| Code Quality | refactor-specialist | DRY enforcement | LOW |

---

## Agent Files Modified

1. **lead-architect** (`ansible-collection-swarm-lead-architect.md`)
   - Added "PR Strategy for Enhancement Mode" section after Phase 0
   - Decision point: one PR per module vs bundled
   - Execution logic based on user choice

2. **enhancement-specialist** (`ansible-collection-swarm-enhancement-specialist.md`)
   - Added "Step 0: PR Mode Preparation" (MANDATORY FIRST STEP)
     - ACTION 1: Update .gitignore (exclude docs/plans/)
     - ACTION 2: Determine changelog strategy (NEW vs ENHANCED)
   - Added "Documentation Markup (CRITICAL)" to Step 4 constraints
     - V()/O()/C() semantic markup rules
     - Verification bash commands

3. **release-specialist** (`ansible-collection-swarm-release-specialist.md`)
   - Added "PR Mode vs Release Mode" section
     - DO NOT: version bump, changelog generation, changelog.yaml
     - DO: changelog fragments only for enhancements
   - Updated git staging to exclude planning docs and version files

---

## Validation Checklist for Next Run

Before next enhancement run, verify agents execute:

**lead-architect**:
- [ ] Asks "One PR per module?" if Epic has multiple modules
- [ ] Creates appropriate branch strategy based on answer

**enhancement-specialist**:
- [ ] Step 0: Adds `docs/plans/` to .gitignore
- [ ] Step 0: Identifies NEW vs ENHANCED modules
- [ ] Step 4: Uses V()/O()/C() semantic markup in docs
- [ ] Does NOT create changelog fragments for NEW modules
- [ ] Creates changelog fragments ONLY for ENHANCED modules

**release-specialist**:
- [ ] Does NOT bump version in galaxy.yml
- [ ] Does NOT run antsibull-changelog release
- [ ] Does NOT modify changelog.yaml or CHANGELOG.rst
- [ ] Excludes docs/plans/ from git staging
- [ ] Excludes version/changelog files from git staging

---

## Testing Strategy

**Clean Slate Test**:
1. ✅ Delete local branch: `add-modules-ACA-6275`
2. ✅ Delete fork branch: `add-modules-ACA-6275`
3. ✅ Pull latest from origin/main
4. ✅ Reinstall swarm with updated agents

**Next Run**:
- Execute same Epic (ACA-6275) or new Epic
- Monitor for:
  - .gitignore updated
  - No docs/plans/ files in commits
  - Semantic markup in documentation
  - No version bumps in PR
  - No changelog.yaml modifications
  - PR created per module (if multi-module Epic)

---

## References

- **PR**: https://github.com/ansible-collections/ansible.windows/pull/905
- **Epic**: ACA-6275
- **Execution Log**: `/Users/hyaish/Documents/Git/ansible_collections/ansible/windows/docs/plans/swarm_execution_log_ACA-6275.md`
- **Review Date**: 2026-06-01, 2026-06-02
- **Maintainer**: Akasurde

---

## Status

- **Learnings**: Captured ✅
- **Agents**: Updated ✅
- **Plugin**: Reinstalled ✅
- **Branches**: Cleaned ✅
- **Ready for Next Run**: ✅

---

*Document created: 2026-06-03*  
*Last updated: 2026-06-03*
