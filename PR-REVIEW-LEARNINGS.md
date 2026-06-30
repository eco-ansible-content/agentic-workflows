# PR Review Learnings - WinGet Module

## Source
PR #906 - windows.winget_package module
Reviewer: jborean93 (Ansible.Windows collection maintainer)
Date: 2026-06-30

---

## 🚨 CRITICAL Issues Found

### 1. **AI Hallucination - Non-Existent Environment Variable**
**Issue**: Module used `WINGET_RUNNING_AS_SYSTEM` environment variable that doesn't exist in WinGet
**Root Cause**: AI invented a plausible-sounding variable without verification
**Impact**: Code that does nothing, reduces trust

**Learning for Agents**:
- ❌ **NEVER** assume environment variables exist without documentation proof
- ✅ **ALWAYS** verify against official documentation before using env vars
- ✅ **Search pattern**: "Official docs for [tool] environment variables"
- ✅ **Fallback**: If env var not documented, it probably doesn't exist

**Action**: Update module-worker and qa-coordinator to:
1. Flag any environment variable usage for verification
2. Require documentation link for any env var used
3. WebSearch official docs before using env vars

---

### 2. **Ignored Collection Utilities - Reinvented the Wheel**
**Issue**: Module used `System.Diagnostics.Process` instead of collection's `Start-AnsibleWindowsProcess`
**Root Cause**: Agent didn't research existing collection utilities before implementing
**Impact**: 
- More complex code (50 lines vs 30 lines)
- Missing features (UTF-8 encoding, deadlock prevention)
- Argument escaping bugs
- Doesn't follow collection patterns

**Learning for Agents**:
- ❌ **NEVER** start implementing without checking collection utilities
- ✅ **ALWAYS** search for `module_utils/` before implementing common operations
- ✅ **Pattern**: "Does this collection have utilities for [operation]?"
- ✅ **Common utilities**: Process execution, HTTP requests, JSON parsing, registry access

**Action**: Update module-worker to:
1. **Phase 1**: Search `module_utils/` directory
2. **Phase 2**: Review existing modules for patterns
3. **Phase 3**: Only implement if no utility exists
4. Add to prerequisites: "Available module_utils: [list]"

---

### 3. **Text Parsing Over API - Fragile Implementation**
**Issue**: Parsed CLI text output instead of using COM API (`Microsoft.WinGet.Client`)
**Root Cause**: Took easiest path (CLI) without researching better options
**Impact**:
- Fragile parsing logic (breaks with output changes)
- ANSI escape code handling needed
- Localization issues
- More code, more bugs

**Learning for Agents**:
- ❌ **NEVER** parse text output if an API exists
- ✅ **ALWAYS** research: "Does [tool] have PowerShell module/COM API?"
- ✅ **Preference order**: 
  1. Native PowerShell cmdlets
  2. COM/WMI APIs
  3. .NET APIs
  4. CLI with structured output (JSON/XML)
  5. CLI text parsing (last resort)

**Action**: Update platform-prerequisite-specialist research to:
1. Search for "[tool] PowerShell module" first
2. Search for "[tool] COM API" second
3. Only recommend CLI if no API exists
4. Document API availability in prerequisites.md

---

### 4. **Dangerous Parameter Exposed**
**Issue**: Module exposed `allow_reboot` parameter
**Root Cause**: Didn't think through Ansible execution model
**Impact**: Could kill WinRM connection mid-execution, causing undefined state

**Learning for Agents**:
- ❌ **NEVER** allow operations that break the connection
- ✅ **ALWAYS** consider: "What if this runs over WinRM/SSH?"
- ✅ **Blocked operations**: 
  - Reboots during module execution
  - Network changes that break connection
  - Disabling remote management
  - Killing parent process

**Action**: Update module-worker with safety rules:
1. Flag any reboot-related parameters
2. Block connection-breaking operations
3. Provide `reboot_required` output instead of `allow_reboot` input
4. Add note: "Use ansible.windows.win_reboot module after this task"

---

### 5. **Accessing Protected System Directories**
**Issue**: Module searched `Program Files\WindowsApps` (protected system directory)
**Root Cause**: Didn't understand Windows security model
**Impact**: Unreliable, may fail with access denied, violates Windows design

**Learning for Agents**:
- ❌ **NEVER** access WindowsApps or other protected system directories
- ✅ **ALWAYS** use published/documented paths only
- ✅ **Windows protected paths**:
  - `WindowsApps` (UWP sandbox)
  - `WinSxS` (side-by-side assembly cache)
  - `System32/config` (registry hives)
- ✅ **Correct paths**: `$env:LOCALAPPDATA`, `$env:ProgramFiles`, `$env:PATH`

**Action**: Update module-worker with Windows path rules:
1. Block access to protected directories
2. Use environment variables for paths
3. Research "[tool] installation path Windows" before implementing

---

### 6. **Missing Bulk Operation Support**
**Issue**: Parameters only accept single string, not lists
**Root Cause**: Didn't consider common use cases
**Impact**: Users must loop instead of batch operations

**Learning for Agents**:
- ❌ **NEVER** assume single-item operations only
- ✅ **ALWAYS** consider: "Will users want to do this in bulk?"
- ✅ **Default to lists for**:
  - Package names
  - File paths
  - Service names
  - User/group names
  - Any noun that could be plural

**Action**: Update module-worker pattern:
1. Main parameters default to `type=list, elements=str`
2. Add both single and batch examples
3. Implement loop logic for batch operations

---

### 7. **Inaccurate Documentation**
**Issue**: Module claimed Windows Server 2022 support, but WinGet only included in Server 2025
**Root Cause**: Assumed without verifying
**Impact**: Users try on unsupported OS and fail

**Learning for Agents**:
- ❌ **NEVER** guess OS/version support
- ✅ **ALWAYS** research official requirements
- ✅ **Search pattern**: "[tool] Windows Server support", "[tool] system requirements"
- ✅ **Be specific**: "Server 2025 (included) vs Server 2022 (manual install, unsupported)"

**Action**: Update jira-ingestion-specialist to extract:
1. Minimum OS version
2. Whether pre-installed or requires setup
3. Support status (official/experimental/unsupported)

---

### 8. **Missing CLI Flags**
**Issue**: Didn't use `--no-progress` flag, leading to complex ANSI escape code parsing
**Root Cause**: Didn't research all CLI flags before implementing
**Impact**: Unnecessary complexity (30+ lines of parsing code eliminated by one flag)

**Learning for Agents**:
- ❌ **NEVER** start parsing before checking all CLI flags
- ✅ **ALWAYS** research: "[tool] disable progress", "[tool] JSON output", "[tool] quiet mode"
- ✅ **Common flags to look for**:
  - `--json` / `--format json`
  - `--quiet` / `--silent`
  - `--no-progress` / `--no-color`
  - `--machine-readable`

**Action**: Update module-worker research phase:
1. Run `[tool] --help` to see all flags
2. Search for structured output flags first
3. Use flags to avoid parsing complexity

---

### 9. **Over-Complicated Code**
**Issue**: Complex version check when `winget --version` would suffice
**Root Cause**: Over-engineering
**Impact**: More code to maintain, harder to debug

**Learning for Agents**:
- ❌ **NEVER** over-engineer when simple solutions exist
- ✅ **ALWAYS** ask: "What's the simplest way to do this?"
- ✅ **Prefer**: Built-in commands over custom parsing
- ✅ **Rule**: If solution is >10 lines, research if there's a simpler way

**Action**: Update module-worker to:
1. Start with simplest approach
2. Only add complexity if required
3. Comment why complexity is needed

---

## 📊 Impact Analysis

**Total Issues**: 9 critical patterns identified
**Root Causes**:
1. Insufficient research (5 issues)
2. AI hallucinations (1 issue)
3. Not following collection patterns (1 issue)
4. Over-engineering (1 issue)
5. Missing use cases (1 issue)

**Primary Root Cause**: **Insufficient Research Phase** (56% of issues)

---

## 🎯 Recommended Agent Updates

### High Priority (Fix Next Run)

1. **jira-ingestion-specialist**: Add OS/version requirement extraction
2. **module-worker**: Add collection utility search phase
3. **module-worker**: Add environment variable verification
4. **module-worker**: Add API-first research pattern
5. **qa-coordinator**: Add safety check for connection-breaking operations

### Medium Priority (Fix Soon)

6. **module-worker**: Default to list parameters
7. **module-worker**: Add Windows path security rules
8. **platform-prerequisite-specialist**: Research PowerShell modules/COM APIs

### Low Priority (Incremental Improvement)

9. **module-worker**: Simplicity check before committing code
10. **learning-evolution-specialist**: Cross-reference PR feedback patterns

---

## 🔄 Process Improvements

### New Phase: **Pre-Implementation Research**

Before writing ANY code, module-worker must:

1. **Search collection utilities**
   ```bash
   ls module_utils/
   grep -r "Process\|HTTP\|Registry" plugins/modules/
   ```

2. **Verify APIs exist**
   ```
   WebSearch("[tool] PowerShell module")
   WebSearch("[tool] COM API")
   ```

3. **Check CLI flags**
   ```bash
   [tool] --help
   WebSearch("[tool] JSON output")
   ```

4. **Verify environment variables**
   ```
   WebSearch("[tool] environment variables official documentation")
   ```

5. **Research OS support**
   ```
   WebSearch("[tool] Windows Server 2025 support")
   WebSearch("[tool] system requirements")
   ```

**Deliverable**: `docs/plans/research_findings.md` before writing code

---

## 🧪 New QA Checks

Add to qa-coordinator checklist:

- [ ] No environment variables used without documentation link
- [ ] Uses collection utilities (not System.Diagnostics.Process)
- [ ] Uses API/cmdlets instead of text parsing (where available)
- [ ] No connection-breaking operations (reboots, network changes)
- [ ] No access to protected directories (WindowsApps, WinSxS)
- [ ] Main parameters support lists (bulk operations)
- [ ] OS requirements verified and documented
- [ ] CLI uses structured output flags (--json, --no-progress)
- [ ] Code simplicity check (could this be simpler?)

---

## 📚 Documentation Template Updates

Add to module documentation:

```yaml
requirements:
  - [Tool] version X.X or higher
  - Windows Server YYYY (included) OR Windows 10/11 (version)
  - For older OS: Manual installation required (link to docs)
  
notes:
  - Running in non-interactive sessions (WinRM/SSH) requires [specific setup]
  - First-run agreements accepted automatically via [flag]
  - Uses [API/COM/CLI] for [reason]
  
seealso:
  - module: ansible.windows.win_reboot
    description: Use after this module if reboot_required=true
```

---

## 🎓 Training Examples

### Example 1: Environment Variable Verification

❌ **Wrong**:
```powershell
$env:WINGET_RUNNING_AS_SYSTEM = "1"  # AI hallucination
```

✅ **Right**:
```powershell
# Research first: WebSearch("WinGet environment variables official docs")
# Result: No such env var exists in docs → Don't use it
```

### Example 2: Use Collection Utilities

❌ **Wrong**:
```powershell
$process = New-Object System.Diagnostics.Process
$process.StartInfo.FileName = $wingetPath
# ... 50 lines of boilerplate
```

✅ **Right**:
```powershell
#AnsibleRequires -PowerShell Ansible.Windows.Process
$result = Start-AnsibleWindowsProcess -FilePath $wingetPath -ArgumentList $args
# Done! 2 lines, handles UTF-8, escaping, buffering automatically
```

### Example 3: API Over Text Parsing

❌ **Wrong**:
```powershell
$output = & winget list | Select-String "pattern"
# Parse text, handle ANSI codes, deal with localization
```

✅ **Right**:
```powershell
Import-Module Microsoft.WinGet.Client
$packages = Get-WinGetPackage
# Structured objects, no parsing needed
```

---

## 📈 Success Metrics

Track these in future runs:

- **Research depth**: How many WebSearch queries per module?
- **Utility usage**: % of modules using collection utilities
- **API vs CLI**: % using APIs instead of text parsing
- **Parameter design**: % with list support for bulk ops
- **QA pass rate**: First-time pass vs rework needed

**Target**: 90% first-time QA pass rate after implementing these learnings

---

## 🔗 References

- PR: https://github.com/ansible-collections/ansible.windows/pull/906
- WinGet Docs: https://learn.microsoft.com/en-us/windows/package-manager/winget/
- Microsoft.WinGet.Client: https://www.powershellgallery.com/packages/Microsoft.WinGet.Client/
- Ansible.Windows Collection: https://github.com/ansible-collections/ansible.windows

---

**Next Action**: Create insight entries for each learning to apply to future module builds.

