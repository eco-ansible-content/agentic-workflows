# PR Review Learnings - Language-Agnostic Version

## Source
PR #906 - windows.winget_package module  
Reviewer: jborean93 (Ansible.Windows collection maintainer)  
Date: 2026-06-30

**Key Insight**: These patterns apply to **ALL languages** (PowerShell, Python, Bash, etc.)

---

## 🚨 Top 9 Critical Patterns (Language-Agnostic)

### 1. **AI Hallucination - Non-Existent APIs/Features**
**Issue**: Used features that don't exist (environment variables, APIs, flags)
- **Example**: `WINGET_RUNNING_AS_SYSTEM` environment variable (doesn't exist)

**Root Cause**: AI invented plausible-sounding features without verification

**Learning**:
- ❌ **NEVER** assume features exist without documentation proof
- ✅ **ALWAYS** verify against official documentation
- ✅ **Search**: "Official [tool] documentation [feature type]"

---

### 2. **Ignored Collection Utilities - Reinvented the Wheel**
**Issue**: Used low-level language primitives instead of collection's shared utilities

**Examples by Language**:
- **PowerShell**: Used `System.Diagnostics.Process` instead of `Start-AnsibleWindowsProcess`
- **Python**: Using `subprocess.Popen` instead of `module.run_command()`
- **Bash**: Custom process handling instead of collection functions

**Impact**: 50 lines → 2 lines, missing features, bugs

**Learning**:
- ❌ **NEVER** start implementing without checking `module_utils/`
- ✅ **ALWAYS** search collection utilities FIRST
- ✅ **Common utilities** (all languages):
  - Process execution
  - HTTP requests
  - JSON/YAML parsing
  - File operations
  - Platform-specific APIs

---

### 3. **Text Parsing Over API - Fragile Implementation**
**Issue**: Parsed CLI text output instead of using language-native libraries

**Examples by Language**:
- **PowerShell**: Parsed `winget` text instead of `Microsoft.WinGet.Client` module
- **Python**: Parsed `aws` CLI instead of `boto3` SDK
- **Bash**: Parsed `docker ps` instead of `docker ps --format json`

**Impact**: Fragile, localization issues, ANSI codes, breaks easily

**Learning - API Preference Order by Language**:

**PowerShell**:
1. Native PowerShell modules/cmdlets
2. COM/WMI APIs
3. .NET APIs
4. CLI with --json
5. Text parsing (last resort)

**Python**:
1. Official Python SDK
2. Well-maintained libraries
3. REST APIs (via requests)
4. CLI with --json
5. Text parsing (last resort)

**Bash**:
1. System APIs (systemd, D-Bus)
2. CLI with structured output (--json, --xml)
3. Parsing /proc, /sys
4. Text parsing (last resort)

---

### 4. **Dangerous Parameters**
**Issue**: Exposed parameters that break remote execution

**Examples**:
- `allow_reboot` - kills WinRM/SSH connection
- Network changes during execution
- Disabling remote management mid-run

**Learning**:
- ❌ **NEVER** allow connection-breaking operations
- ✅ **Think**: "What if this runs over SSH/WinRM?"
- ✅ **Blocked operations**:
  - Reboots during execution
  - Network reconfigurations  
  - Killing parent processes
  - Disabling remote access

---

### 5. **Accessing Protected System Directories**
**Issue**: Accessed undocumented/protected directories

**Platform Examples**:

**Windows**:
- ❌ `WindowsApps` (UWP sandbox)
- ❌ `WinSxS` (assembly cache)
- ✅ `$env:LOCALAPPDATA`, `$env:ProgramFiles`

**Linux**:
- ❌ `/proc/kcore`, `/sys/firmware`
- ❌ `~/.local/share/flatpak` internals
- ✅ `/usr/bin`, `/opt`, use package manager APIs

**macOS**:
- ❌ `~/Library/Application Support/com.apple.*` internals
- ❌ `/System/Library/PrivateFrameworks`
- ✅ `/Applications`, use public APIs

**Learning**:
- ❌ **NEVER** access protected/undocumented paths
- ✅ **ALWAYS** use documented standard paths
- ✅ Research "[tool] installation path [OS]"

---

### 6. **Missing Bulk Operation Support**
**Issue**: Parameters only accept single values, not lists

**Examples**:
- Package names
- File paths
- Service names

**Learning**:
- ❌ **DON'T** assume single-item only
- ✅ **DO** default to lists for bulk operations:
  ```yaml
  # All languages - Ansible spec
  packages:
    type: list
    elements: str
  ```

---

### 7. **Inaccurate Platform/OS Documentation**
**Issue**: Claimed support without verification

**Example**: Said "Windows Server 2022" but actually only "Windows Server 2025"

**Learning**:
- ❌ **NEVER** guess OS/version support
- ✅ **ALWAYS** research official requirements
- ✅ **Be specific**: "Server 2025 (included) vs 2022 (manual, unsupported)"
- ✅ Search: "[tool] [OS] [version] support"

---

### 8. **Missing CLI Flags**
**Issue**: Didn't research available flags, leading to complex parsing

**Example**: Missing `--no-progress` → 30+ lines of ANSI parsing

**Common Flags to Look For** (adapt to tool):
- **Structured output**: `--json`, `--yaml`, `--xml`, `--format json`
- **Progress control**: `--no-progress`, `--no-color`, `--quiet`
- **Machine-readable**: `--machine-readable`, `--porcelain`

**Learning**:
- ❌ **DON'T** start parsing before checking flags
- ✅ **DO** run `[tool] --help` first
- ✅ WebSearch "[tool] JSON output", "[tool] structured output"

---

### 9. **Over-Complicated Code**
**Issue**: Complex solutions when simple ones exist

**Learning**:
- ❌ **DON'T** over-engineer
- ✅ **DO** start simple, add complexity only if needed
- ✅ **Rule**: If >10 lines, research if simpler way exists

---

## 📊 Root Cause Analysis

**Primary Issue**: **Insufficient Research Phase** (56% of problems)

Agents jumped to implementation without:
- Checking collection utilities
- Researching language-appropriate APIs
- Verifying features exist
- Checking CLI flags
- Researching OS requirements

---

## 🔄 New Phase: Pre-Implementation Research

**Before ANY code**, module-worker must:

### 1. Determine Implementation Language
Based on platform characteristics:
- Windows → PowerShell
- Linux/macOS → Python or Bash
- Network devices → Python (NETCONF/REST)

### 2. Search Collection Utilities
```bash
ls module_utils/
grep -r "[operation]" plugins/modules/
```

### 3. Research Language-Appropriate APIs

**For PowerShell**:
```
WebSearch("[tool] PowerShell module")
WebSearch("[tool] COM API")
WebSearch("[tool] .NET API")
```

**For Python**:
```
WebSearch("[tool] Python SDK")
WebSearch("[tool] Python library")  
WebSearch("[tool] REST API")
```

**For Bash**:
```
WebSearch("[tool] D-Bus interface")
WebSearch("[tool] JSON output")
```

### 4. Check CLI Flags (if using CLI)
```bash
[tool] --help
man [tool]
WebSearch("[tool] structured output")
```

### 5. Verify Features
```
WebSearch("[tool] environment variables official docs")
WebSearch("[feature] [tool] documentation")
```

### 6. Research Platform Support
```
WebSearch("[tool] [OS/platform] support")
# Examples:
# - "winget Windows Server 2025"
# - "podman RHEL 9 support"
# - "homebrew macOS Sonoma"
```

**Deliverable**: `docs/plans/research_findings.md`

---

## 🧪 New QA Checks (Language-Agnostic)

- [ ] No features used without documentation link
- [ ] Uses collection utilities (not low-level primitives)
- [ ] Uses language-appropriate APIs (not text parsing)
- [ ] No connection-breaking operations
- [ ] No protected directory access
- [ ] Main parameters support lists (bulk ops)
- [ ] OS/platform requirements verified
- [ ] CLI uses structured output flags where available
- [ ] Code simplicity check

---

## 🎓 Examples Across Languages

### Example 1: Use Collection Utilities

**PowerShell**:
```powershell
# ❌ Wrong - low-level
$proc = New-Object System.Diagnostics.Process
# ... 50 lines

# ✅ Right - collection utility  
#AnsibleRequires -PowerShell Ansible.Windows.Process
$result = Start-AnsibleWindowsProcess -FilePath $path -ArgumentList $args
```

**Python**:
```python
# ❌ Wrong - low-level
proc = subprocess.Popen([cmd], ...)
# ... 20 lines

# ✅ Right - collection utility
rc, stdout, stderr = module.run_command([cmd])
```

### Example 2: Language-Appropriate APIs

**PowerShell - Native Module**:
```powershell
# ❌ Wrong - text parsing
$output = & winget list | Select-String "pattern"

# ✅ Right - PowerShell module
Import-Module Microsoft.WinGet.Client
$packages = Get-WinGetPackage
```

**Python - SDK**:
```python
# ❌ Wrong - CLI parsing
output = subprocess.check_output(['aws', 's3', 'ls'])
buckets = [line.split()[2] for line in output.split('\n')]

# ✅ Right - Python SDK
import boto3
buckets = [b['Name'] for b in boto3.client('s3').list_buckets()['Buckets']]
```

**Bash - Structured Output**:
```bash
# ❌ Wrong - text parsing  
docker ps | grep "pattern" | awk '{print $1}'

# ✅ Right - JSON output
docker ps --format '{{json .}}' | jq -r '.ID'
```

---

## 🎯 Agent Updates Needed

### High Priority

1. **module-worker**: Add pre-implementation research phase
2. **module-worker**: Add language-based API preference logic
3. **module-worker**: Add collection utility search
4. **qa-coordinator**: Add language-agnostic safety checks

### Medium Priority

5. **platform-prerequisite-specialist**: Research language-appropriate APIs
6. **module-worker**: Default to list parameters
7. **jira-ingestion-specialist**: Extract OS/platform requirements

---

## 📈 Success Metrics

- **Research depth**: WebSearch queries per module
- **Utility usage**: % using collection utilities vs primitives
- **API adoption**: % using native APIs vs text parsing
- **QA pass rate**: Target 90% first-time pass

---

**Next Action**: Apply these learnings to agent definitions
