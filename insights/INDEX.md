# Insights Index

**Last Updated**: 2026-06-10  
**Total Insights**: 7 (detailed) + 17 quick-reference entries  
**Version**: 1.3.0

## Quick Navigation

- [Quick Reference Log](#quick-reference-log) - Fast agent reference (read by lead-architect on startup)
- [Platform Insights](#platform-insights) - Platform-specific discoveries
- [Pattern Insights](#pattern-insights) - Pattern adaptations and improvements  
- [Operational Insights](#operational-insights) - Failures, prerequisites, environment handling

---

## Quick Reference Log

**File**: `/insights/quick-reference.log`

**Purpose**: One-liner insights read by `lead-architect` on every run startup

**Format**: `CATEGORY|SUBCATEGORY|ONE-LINE SOLUTION`

**Current Entries**: 0 (will grow with production runs)

**Example Format**:
```
Platform|REST-API-Rate-Limiting|Check 429 status, use Retry-After header, exponential backoff 60→120→240s
Pattern|Idempotency-Check|Always check current state before create/update operations
Operational|Hung-Installer|Monitor log filesize every 10s, kill if no growth for 60s
```

---

## Platform Insights

### REST API Platforms

#### [EXAMPLE: REST API Rate Limiting Detection](platform-insights/EXAMPLE_rest-api-rate-limiting.md)
**Added**: 2024-05-28 | **Applies To**: REST APIs with 429 responses | **Impact**: 95% → 100% success rate

*NOTE: This is an example file showing the format. Real insights from production runs will appear below.*

### Windows Platforms

#### [Windows Package Management Patterns](platform-insights/windows-package-management.md)
**Added**: 2026-06-02 | **Applies To**: Windows collections (winget, PackageManagement/OneGet) | **Impact**: Prevents auto-detection collision, documents SYSTEM context path resolution

---

### CLI-Based Platforms
*Coming from production runs*

### Database Platforms
*Coming from production runs*

### SOAP API Platforms
*Coming from production runs*

---

## Pattern Insights

### Provider/Backend Patterns

#### [Provider Auto-Detection Collision](pattern-insights/provider-auto-detection-collision.md)
**Added**: 2026-06-02 | **Applies To**: Modules with pluggable provider systems | **Impact**: Prevents CI failures from provider loop iteration

#### [Ansible required_if Limitations](pattern-insights/required-if-limitations.md)
**Added**: 2026-06-02 | **Applies To**: Multi-provider modules with conditional validation | **Impact**: Preserves backward-compatible error messages when moving to manual validation

### PowerShell Best Practices

#### [PowerShell Error Handling Best Practices](pattern-insights/powershell-error-handling-best-practices.md)
**Added**: 2026-06-10 | **Applies To**: All Windows PowerShell modules | **Impact**: Prevents loss of stack traces, improves debugging, follows community standards

#### [PowerShell Import Conventions](pattern-insights/powershell-import-conventions.md)
**Added**: 2026-06-10 | **Applies To**: All Ansible Windows modules | **Impact**: Fixes import errors, standardizes module structure

### Idempotency Patterns
*Coming from production runs*

### Error Recovery Patterns
*Coming from production runs*

### Testing Patterns
*Coming from production runs*

---

## Operational Insights

### CI/CD Workflows

#### [Enhancement Mode CI/CD Workflow](operational-insights/enhancement-mode-cicd-workflow.md)
**Added**: 2026-06-02 | **Applies To**: Fork-based PR workflows, Azure Pipelines CI | **Impact**: Documents full delivery lifecycle including PR management and targeted CI fix strategies

#### [Code Quality Pre-PR Checks](operational-insights/code-quality-pre-pr-checks.md)
**Added**: 2026-06-10 | **Applies To**: All collection builds before PR creation | **Impact**: Catches 9+ blockers and 14+ warnings before maintainer review

### Prerequisite Installation
*Coming from production runs*

### Environment Detection
*Coming from production runs*

### Recovery Strategies
*Coming from production runs*

---

## How This Index Works

This index is **automatically maintained** by the `learning-evolution-specialist` agent.

After each run:
1. Agent captures and sanitizes lessons
2. Writes insight files to appropriate category
3. Updates this index with new entries
4. Commits to git (or leaves for maintainer review)

**Format for entries**:
```markdown
### [Insight Title](category/filename.md)
**Added**: YYYY-MM-DD | **Applies To**: Characteristics | **Impact**: Brief description
```

---

## Statistics

### By Category
- Platform Insights: 1 detailed + 4 quick-ref entries
- Pattern Insights: 4 detailed + 7 quick-ref entries
- Operational Insights: 2 detailed + 6 quick-ref entries

### Top Contributors
- **ACA-6275 Run 1** (ansible.windows, 2026-06-02): 4 detailed insights, 13 quick-ref entries
- **ACA-6275 Run 2** (ansible.windows, 2026-06-03): 14 quick-ref entries (one-PR-per-module strategy)
- **SCVMM Code Review** (microsoft.scvmm, 2026-06-10): 3 detailed insights, 3 quick-ref entries from maintainer feedback

### Success Rate Improvements
- **ACA-6275 Run 1**: 35/36 CI checks (97.2%), 2 code fixes needed, single PR strategy
- **ACA-6275 Run 2**: PR #907 all green first try (100%), PR #906 56/58 (96.6%, infra-only failures), zero code fixes needed
- **Trend**: Learned patterns from Run 1 eliminated code-related CI failures in Run 2
- **Duration**: Run 1 ~6 hours, Run 2 ~3 hours (50% reduction via applied learnings and parallel PRs)

---

*This index grows with every production run. Check back after your team's first few builds!*
