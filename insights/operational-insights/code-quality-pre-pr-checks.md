# Insight: Code Quality Pre-PR Checks

**Date**: 2026-06-10  
**Category**: Operational  
**Subcategory**: Code-Quality-Pre-PR  
**Applies To**: All collection builds  
**Applied To Agents**: qa-coordinator, release-specialist, ci-validation-specialist  
**Severity**: High

## The Problem

Collections are being submitted to PRs with fundamental quality issues that should be caught before submission:

1. **Missing implementations** - public modules with no PowerShell .ps1 file
2. **Undefined functions** - modules call helpers that don't exist
3. **Dead code** - imports that are never used ("defensive imports")
4. **Inconsistent metadata** - author names vary (AI names, "Steve", "Gemini")
5. **Wrong file formats** - Python docs instead of YAML
6. **Scaffolding tests** - tests that only validate failure, not success
7. **No test coverage** - empty test directories despite CI matrix

**Observed in**: SCVMM collection review (9 blockers, 14 warnings before PR)

## What We Learned

We need **pre-PR quality gates** that prevent these issues from reaching reviewers:

- Maintainers waste time on basic issues that automation should catch
- First impressions matter - shipping broken code damages trust
- Many issues are detectable without running code (static analysis)
- Tests should validate success, not just expected failure

## The Solution

**Add Pre-PR Quality Check Phase** (before Phase 8: Delivery):

### Phase 7.5: Pre-PR Quality Audit

**Execute before creating PR**:

```bash
echo "🔍 Running pre-PR quality checks..."

# 1. Check for orphaned module files
echo "Checking for missing implementations..."
PYTHON_MODULES=$(find plugins/modules -name "*.py" -not -name "__*" | wc -l)
POWERSHELL_MODULES=$(find plugins/modules -name "*.ps1" | wc -l)

if [ "$PYTHON_MODULES" != "$POWERSHELL_MODULES" ]; then
  echo "❌ ERROR: Python/PowerShell module count mismatch"
  echo "   Python: $PYTHON_MODULES, PowerShell: $POWERSHELL_MODULES"
  echo "   Every .py must have matching .ps1"
  exit 1
fi

# 2. Check for undefined function calls
echo "Checking for undefined functions..."
for ps1_file in plugins/modules/*.ps1; do
  # Extract function calls like Get-SomethingInfo
  CALLED_FUNCTIONS=$(grep -oE "Get-[A-Z][A-Za-z0-9]+" "$ps1_file" | sort -u)
  
  for func in $CALLED_FUNCTIONS; do
    # Check if function exists in module_utils or same file
    if ! grep -rq "function $func" plugins/module_utils/ "$ps1_file"; then
      echo "⚠️  WARNING: $func called in $(basename $ps1_file) but not defined"
    fi
  done
done

# 3. Check for unused imports
echo "Checking for defensive/unused imports..."
for psm1_file in plugins/module_utils/*.psm1; do
  # Get imported modules
  IMPORTS=$(grep -oE "#AnsibleRequires.*" "$psm1_file" || true)
  
  if [ -n "$IMPORTS" ]; then
    # Check if any code uses these imports
    if ! grep -v "^#" "$psm1_file" | grep -qE "(Export-ModuleMember|function|cmdlet)"; then
      echo "⚠️  Defensive import detected in $(basename $psm1_file)"
    fi
  fi
done

# 4. Check author consistency
echo "Checking author metadata..."
AUTHORS=$(grep -r "author:" plugins/modules/*.py | cut -d':' -f3- | sort -u)
AUTHOR_COUNT=$(echo "$AUTHORS" | wc -l | tr -d ' ')

if [ "$AUTHOR_COUNT" -gt 3 ]; then
  echo "⚠️  WARNING: $AUTHOR_COUNT different author formats detected"
  echo "$AUTHORS"
  echo "   Standardize to: 'Cloud Content Team <cloud-content@redhat.com>'"
fi

# 5. Check for Python docs (should be YAML)
echo "Checking documentation format..."
PYTHON_DOCS=$(grep -l "DOCUMENTATION = '''" plugins/modules/*.py 2>/dev/null || true)
if [ -n "$PYTHON_DOCS" ]; then
  echo "❌ ERROR: Found Python-formatted docs (should be YAML)"
  echo "$PYTHON_DOCS"
  exit 1
fi

# 6. Check test quality
echo "Checking test coverage..."
TEST_TARGETS=$(find tests/integration/targets -mindepth 1 -maxdepth 1 -type d | wc -l)
ALIAS_ONLY=$(find tests/integration/targets -name "aliases" -not -path "*/tasks/*" | wc -l)
IGNORE_ERRORS=$(grep -r "ignore_errors: true" tests/integration/targets/ | wc -l)

REAL_TESTS=$((TEST_TARGETS - ALIAS_ONLY))
echo "   Total targets: $TEST_TARGETS"
echo "   Alias-only: $ALIAS_ONLY"
echo "   Real tests: $REAL_TESTS"
echo "   Using ignore_errors: $IGNORE_ERRORS"

if [ "$IGNORE_ERRORS" -gt "$((REAL_TESTS / 2))" ]; then
  echo "⚠️  WARNING: More than 50% of tests use ignore_errors"
  echo "   Tests should validate success, not expected failure"
fi

# 7. Check for test files
UNIT_TESTS=$(find tests/unit -name "test_*.py" 2>/dev/null | wc -l)
if [ "$UNIT_TESTS" -eq 0 ] && [ -d tests/unit ]; then
  echo "⚠️  WARNING: Empty tests/unit/ directory"
  echo "   Either add unit tests or remove empty directory"
fi

echo ""
echo "✅ Pre-PR quality checks complete"
```

## Impact

**Before**: 9 blockers + 14 warnings reached PR review  
**After**: Catch issues before PR, maintainer reviews focus on design  
**Time Saved**: Hours per PR review cycle

## Applies To

- All collection builds (full_build and enhancement modes)
- Any PR to upstream collections
- Internal code reviews

## Integration Point

Add between Phase 7 (CI Validation) and Phase 8 (Delivery):

```
Phase 7: CI/CD Validation → Pass
Phase 7.5: Pre-PR Quality Audit → NEW
Phase 8: Delivery (PR Creation) → Only if 7.5 passes
```

## Checklist for QA-Coordinator

Before approving delivery:
- [ ] No orphaned module files (.py without .ps1)
- [ ] No undefined function calls
- [ ] No unused/defensive imports
- [ ] Author metadata consistent
- [ ] Documentation in YAML format
- [ ] Tests validate success, not just failure
- [ ] No empty test directories in CI matrix
