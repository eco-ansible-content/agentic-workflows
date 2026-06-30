# PR Review Learnings - Universal Patterns

## Source
PR #906 - windows.winget_package module  
Reviewer: jborean93  
Date: 2026-06-30

**Key Insight**: These patterns apply to **ALL languages and platforms**

---

## 🚨 Top 9 Critical Patterns (Universal)

### 1. **AI Hallucination - Non-Existent APIs/Features**
**Issue**: Used features that don't exist
**Root Cause**: AI invented plausible-sounding features without verification

**Universal Learning**:
- ❌ **NEVER** assume features exist without documentation proof
- ✅ **ALWAYS** verify against official documentation
- ✅ **Search pattern**: `"[tool] official documentation [feature-type]"`

---

### 2. **Ignored Collection Utilities - Reinvented the Wheel**
**Issue**: Used low-level language primitives instead of collection's shared utilities

**Universal Pattern**:
```
❌ Wrong: Use language's raw primitives (50+ lines)
✅ Right: Use collection's module_utils (2-5 lines)
```

**Universal Learning**:
- ❌ **NEVER** start implementing without checking `module_utils/`
- ✅ **ALWAYS** search collection utilities FIRST
- ✅ **Common operations** (all languages):
  - Process execution
  - HTTP requests
  - JSON/YAML parsing
  - File operations
  - Platform-specific APIs

**Action**:
```bash
# Step 1: Search what exists
ls module_utils/
grep -r "[operation-name]" plugins/modules/

# Step 2: Use existing utilities
# Step 3: Only implement if nothing exists
```

---

### 3. **Text Parsing Over API - Fragile Implementation**
**Issue**: Parsed CLI text output instead of using native libraries

**Universal API Preference Order** (works for ANY language):

```
1. Collection module_utils
2. Official SDK/library for [tool] in [language]
3. Well-maintained third-party libraries
4. Platform native APIs (COM/WMI/D-Bus/JNI/FFI)
5. CLI with structured output (--json, --xml, --yaml)
6. CLI text parsing ← LAST RESORT
```

**Universal Research Pattern**:
```
WebSearch("[tool] [language] SDK")
WebSearch("[tool] [language] library")
WebSearch("[tool] [language] API")
WebSearch("[tool] structured output")
```

**Examples** (pattern applies to ANY language):
- **PowerShell**: Module → COM → .NET → CLI-JSON → Text
- **Python**: SDK → Library → REST → CLI-JSON → Text
- **Bash**: systemd/D-Bus → CLI-JSON → Text
- **Java**: SDK → Library → JNI → CLI-JSON → Text
- **Go**: Library → cgo → CLI-JSON → Text
- **Ruby**: Gem → FFI → CLI-JSON → Text
- **Rust**: Crate → FFI → CLI-JSON → Text

---

### 4. **Dangerous Parameters**
**Issue**: Exposed parameters that break remote execution (SSH/WinRM)

**Universal Blocked Operations** (all platforms):
- ❌ Reboots during module execution
- ❌ Network changes that break connection
- ❌ Disabling remote management
- ❌ Killing parent/connection processes

**Universal Learning**:
- ❌ **NEVER** allow connection-breaking operations
- ✅ **ALWAYS** ask: "What if this runs remotely?"
- ✅ **Pattern**: Provide `*_required` output, not `allow_*` input
  - Example: `reboot_required: true` (output) not `allow_reboot: true` (input)

---

### 5. **Accessing Protected System Directories**
**Issue**: Accessed undocumented/protected system paths

**Universal Pattern by Platform**:

**Windows**:
- ❌ Protected: `WindowsApps`, `WinSxS`, `System32\config`
- ✅ Use: `%LOCALAPPDATA%`, `%ProgramFiles%`, `%PATH%`

**Linux**:
- ❌ Protected: `/proc/kcore`, `/sys/firmware`, package internals
- ✅ Use: `/usr/bin`, `/opt`, `/var/lib/[package]`, package manager APIs

**macOS**:
- ❌ Protected: `~/Library/.../com.apple.*`, `/System/.../PrivateFrameworks`
- ✅ Use: `/Applications`, public `~/Library` paths, APIs

**Any Other Platform**:
- ❌ Protected: Internal/undocumented directories
- ✅ Use: Documented public paths, environment variables, APIs

**Universal Research**:
```
WebSearch("[tool] installation path [OS]")
WebSearch("[tool] standard location [platform]")
```

---

### 6. **Missing Bulk Operation Support**
**Issue**: Parameters only accept single values

**Universal Learning**:
- ❌ **DON'T** assume single-item operations
- ✅ **DO** default main parameters to lists:
  ```yaml
  # Universal pattern (Ansible parameter spec)
  items:
    type: list
    elements: str
  ```

**Applies to**:
- Package names
- File paths
- Service names
- User/group names
- Any noun that could be plural

---

### 7. **Inaccurate Platform/OS Documentation**
**Issue**: Claimed platform support without verification

**Universal Learning**:
- ❌ **NEVER** guess platform/OS/version support
- ✅ **ALWAYS** research official requirements
- ✅ **Be specific**: "Version X.Y (included) vs Version X.Z (manual install, unsupported)"

**Universal Research Pattern**:
```
WebSearch("[tool] [platform] [version] support")
WebSearch("[tool] system requirements")
WebSearch("[tool] compatibility [OS]")

# Examples for ANY platform:
# - "kubectl Windows Server 2025 support"
# - "podman RHEL 9 compatibility"
# - "homebrew macOS Sonoma requirements"
# - "nvm FreeBSD support"
```

---

### 8. **Missing CLI Flags**
**Issue**: Didn't research available CLI flags

**Universal CLI Flags to Look For** (adapt names to tool):
- **Structured output**: `--json`, `--yaml`, `--xml`, `--format [type]`, `--output [type]`
- **Progress control**: `--no-progress`, `--no-color`, `--no-ansi`, `--quiet`, `--silent`
- **Machine-readable**: `--machine-readable`, `--porcelain`, `--parsable`
- **Verbosity**: `--verbose`, `-v`, `--debug`

**Universal Research**:
```bash
# Step 1: Check help
[tool] --help
[tool] -h
man [tool]

# Step 2: Search for structured output
WebSearch("[tool] JSON output")
WebSearch("[tool] structured output")
WebSearch("[tool] machine readable")
```

---

### 9. **Over-Complicated Code**
**Issue**: Complex solutions when simple ones exist

**Universal Rule**:
- ❌ **DON'T** over-engineer
- ✅ **DO** start with simplest solution
- ✅ **Check**: If solution >10 lines, research if simpler way exists

---

## 📊 Root Cause Analysis (Universal)

**Primary Issue**: **Insufficient Research Phase** (56% of all issues)

Agents skipped research and jumped to implementation without:
1. Checking collection utilities
2. Researching language-appropriate libraries/SDKs
3. Verifying features exist in documentation
4. Checking available CLI flags
5. Researching platform requirements

---

## 🔄 Universal Pre-Implementation Research Phase

**BEFORE writing ANY code in ANY language**:

### Phase 1: Determine Implementation Language
```
Based on platform characteristics:
- What language does this platform typically use?
- What language are existing similar modules written in?
- What language has the best tool support for this platform?
```

### Phase 2: Search Collection Utilities
```bash
# Universal - works for any collection
ls module_utils/
grep -r "[operation-name]" plugins/modules/
grep -r "[tool-name]" plugins/modules/
```

### Phase 3: Research Language-Appropriate Libraries
```
# Universal pattern - substitute [language]
WebSearch("[tool] [language] SDK")
WebSearch("[tool] [language] library")
WebSearch("[tool] [language] official client")
WebSearch("[tool] API documentation")

# Examples for ANY language:
# PowerShell: "[tool] PowerShell module"
# Python: "[tool] Python SDK"
# Java: "[tool] Java client library"
# Go: "[tool] Go package"
# Ruby: "[tool] Ruby gem"
# Rust: "[tool] Rust crate"
# C#: "[tool] .NET library"
# JavaScript: "[tool] npm package"
```

### Phase 4: Check CLI Capabilities (if no library exists)
```bash
# Universal
[tool] --help
man [tool]

WebSearch("[tool] JSON output")
WebSearch("[tool] structured output format")
WebSearch("[tool] machine readable output")
```

### Phase 5: Verify Features
```
# Universal pattern
WebSearch("[feature] [tool] official documentation")
WebSearch("[tool] environment variables")
WebSearch("[tool] configuration options")
```

### Phase 6: Research Platform Requirements
```
# Universal pattern
WebSearch("[tool] [platform] [version] support")
WebSearch("[tool] system requirements")

# Examples for ANY platform:
# Windows: "[tool] Windows Server 2025"
# Linux: "[tool] Ubuntu 24.04", "[tool] RHEL 9"
# macOS: "[tool] macOS Sonoma"
# BSD: "[tool] FreeBSD 14"
# Solaris: "[tool] Solaris 11"
```

**Deliverable**: `docs/plans/research_findings.md` (regardless of language)

---

## 🧪 Universal QA Checklist

**Works for ANY language, ANY platform**:

- [ ] No features/APIs used without official documentation link
- [ ] Uses collection `module_utils` (not raw language primitives)
- [ ] Uses language-native libraries/SDKs (not text parsing)
- [ ] No connection-breaking operations (reboots, network changes)
- [ ] No protected/undocumented directory access
- [ ] Main parameters support lists for bulk operations
- [ ] Platform/OS requirements researched and documented
- [ ] CLI uses structured output flags where available
- [ ] Code simplicity check (could this be simpler?)

---

## 🎓 Universal Code Pattern

### Pattern 1: Collection Utilities (Any Language)

```
❌ Wrong - Raw Language Primitives:
[50+ lines of boilerplate using language's standard library]

✅ Right - Collection Utilities:
from ansible.module_utils.[utility] import [function]
result = [function](parameters)
[2-5 lines total]
```

### Pattern 2: Library Over CLI (Any Language)

```
❌ Wrong - Text Parsing:
output = execute_command("[tool] list")
parse output line by line with regex/split
handle encoding, ANSI codes, localization

✅ Right - Native Library:
import [tool-library]
client = [tool-library].Client()
structured_data = client.list()
[Direct access to structured data]
```

### Pattern 3: Structured Output (Any CLI Tool)

```
❌ Wrong - Text Parsing:
output = execute("[tool] command")
parse with awk/sed/regex

✅ Right - JSON Output:
output = execute("[tool] command --json")
data = json.parse(output)
[Structured access]
```

---

## 🎯 Agent Updates (Universal)

### High Priority (Fixes 70% of Issues)

1. **module-worker**: Add mandatory pre-implementation research phase
2. **module-worker**: Check `module_utils/` BEFORE implementing
3. **module-worker**: Add language-agnostic API preference logic
4. **qa-coordinator**: Add universal safety checks

### Medium Priority

5. **platform-prerequisite-specialist**: Research language-appropriate libraries
6. **module-worker**: Default to list parameters
7. **jira-ingestion-specialist**: Extract platform/OS requirements

---

## 📈 Success Metrics (Universal)

**Track for ANY language/platform**:

- **Research depth**: # of WebSearch queries before coding
- **Utility usage**: % using module_utils vs raw primitives
- **API adoption**: % using native libraries vs text parsing  
- **QA pass rate**: Target 90% first-time pass

---

## 🔗 Key Takeaway

**The research pattern is the same regardless of language**:

1. Check collection utilities FIRST
2. Research [language]-native libraries/SDKs
3. Fall back to CLI with structured output
4. Text parsing is LAST RESORT

**Just substitute the appropriate language name in your searches!**

---

**Next Action**: Apply these universal patterns to all agent definitions
