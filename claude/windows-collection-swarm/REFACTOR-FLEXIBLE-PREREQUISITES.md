# Refactor: Flexible, Intelligent Prerequisite Handling

## Problem with Original Approach

**I was too literal** - I created rigid, template-based agents that only worked for predefined platforms (SCVMM, Hyper-V, SQL Server).

**Your actual need**: Agents that **think like human engineers** and can handle **ANY Windows project**, not just the examples I gave.

## Solution: Human-Like Intelligence

### Before (Rigid)

**Jira Ingestion**:
```python
if module_name.startswith("scvmm_"):
    platform = "SCVMM"  # Pattern matching only
    use_template("scvmm_prerequisites.yml")
```

**Platform Prerequisite**:
```python
if platform == "SCVMM":
    run_template("scvmm_install.sh")  # Fixed script
else:
    error("Unknown platform")
```

### After (Flexible)

**Jira Ingestion**:
```
Read Epic description like a human:
"This collection manages Exchange Server 2019..."

Understand: Needs Exchange Server
Extract: Version 2019, requires AD, needs .NET 4.8
Write: Natural language prerequisites document
```

**Platform Prerequisite**:
```
Read prerequisites.md like a human:
"Exchange Server 2019 required, needs Active Directory..."

Research: How to install Exchange? (silent install, dependencies)
Plan: AD first, then .NET, then Exchange
Execute: Install each component intelligently
Verify: Exchange services running, AD integrated
```

## What Changed

### 1. Jira Ingestion Specialist (COMPLETELY REWRITTEN)

**Old Behavior**: Pattern matching
- Looks for `scvmm_*` → outputs `scvmm_prerequisites.yml`
- Rigid YAML templates
- Only works for predefined platforms

**New Behavior**: Natural language understanding
- **Reads Epic descriptions** like a human engineer would
- **Understands context**: "Why is this software needed?"
- **Infers dependencies**: "SCVMM needs SQL" even if not explicit
- **Outputs Markdown**: Readable prerequisites.md, not rigid YAML

**Example**:

Input (Epic):
```
"Build modules to manage WidgetCorp's custom deployment tool. 
Tool requires IIS frontend, custom Windows service backend, 
and PostgreSQL database."
```

Old agent: ❌ "Unknown platform 'WidgetCorp'"

New agent: ✅
```markdown
# Prerequisites for WidgetCorp Deployment Tool Collection

## Primary Platform
**WidgetCorp Deployment Tool** (custom application)
- Not a standard Microsoft platform
- Components: IIS + Custom Service + PostgreSQL

## Required Software

### Internet Information Services (IIS)
- Why needed: Hosts tool's web frontend
- Version: IIS 10.0+ (Windows Server 2019)

### PostgreSQL Database
- Why needed: Application database backend
- Version: Check WidgetCorp documentation

### WidgetCorp Custom Service
- Installation: Installer location needed
- Check Epic for installer URL or deployment guide

## Notes
- Custom application - requires installer from vendor
- May need WidgetCorp team for deployment documentation
```

### 2. Platform Prerequisite Specialist (COMPLETELY REWRITTEN)

**Old Behavior**: Template execution
- Loads `scvmm_prerequisites.yml`
- Runs predefined install script
- Only works for templates

**New Behavior**: Intelligent installation
- **Reads prerequisites.md** like an engineer's notes
- **Researches**: How to install each component
- **Adapts**: Figures out installation method per software
- **Handles unknowns**: Asks for help when needed

**Capabilities**:

1. **Windows Features** (automatic):
   ```
   Sees: "DNS Server role required"
   Understands: Windows Feature
   Executes: Install-WindowsFeature DNS
   ```

2. **Microsoft Products** (researched):
   ```
   Sees: "SQL Server 2019 required"
   Researches: Download URL, silent install parameters
   Executes: Download → Silent install → Verify
   ```

3. **Custom Software** (requests info):
   ```
   Sees: "WidgetCorp Tool v2.4 required"
   Checks: Epic for installer URL
   If not found: Asks "Where is the WidgetCorp installer?"
   ```

4. **Dependencies** (inferred):
   ```
   Sees: "SCVMM required"
   Knows: SCVMM needs SQL Server and Hyper-V
   Adds: SQL and Hyper-V to install plan automatically
   ```

### 3. No More Rigid Templates

**Removed**:
- ❌ `scvmm_prerequisites.yml` (rigid template)
- ❌ `hyperv_prerequisites.yml` (rigid template)
- ❌ Pattern-only detection

**Replaced with**:
- ✅ Natural language prerequisites.md
- ✅ Intelligent reading and understanding
- ✅ Adaptive installation strategies

**Reference materials** (kept):
- ✅ `platform-installation-guide.md` - General patterns, examples
- Used as **reference**, not **templates**

## Real-World Examples

### Example 1: SCVMM Collection

**Epic Description**:
```
"Ansible modules for System Center Virtual Machine Manager 2022. 
Manage Hyper-V hosts, VMs, and library resources."
```

**What Jira Ingestion Does**:
```markdown
# Prerequisites for SCVMM Management Collection

## Overview
Collection manages SCVMM 2022 resources (hosts, VMs, libraries).
Requires functional SCVMM environment.

## Primary Platform
**System Center Virtual Machine Manager 2022**
- Core platform being managed
- All modules interact with SCVMM

## Required Software

### SCVMM 2022
- Why needed: Platform being managed
- Dependencies: SQL Server backend, Hyper-V role

### SQL Server 2019+
- Why needed: SCVMM requires SQL backend
- Configuration: Default instance sufficient

### Hyper-V
- Why needed: SCVMM requires Hyper-V role
- Note: Server will reboot during installation

## Test Environment
- 1 Windows Server with SCVMM + SQL + Hyper-V
- At least 1 Hyper-V host added to SCVMM
- Library share configured
```

**What Platform Prerequisite Does**:
1. Reads prerequisites.md
2. Understands: Need SQL → Hyper-V → SCVMM (order matters)
3. Installs SQL Server (researches silent install)
4. Installs Hyper-V (knows it's Windows Feature)
5. Reboots server
6. Installs SCVMM (researches ISO mount + setup)
7. Configures: Adds localhost as Hyper-V host
8. Verifies: SCVMM console accessible, hosts present

### Example 2: Custom Application

**Epic Description**:
```
"Modules for deploying Acme Corp's WidgetManager application. 
App is .NET 4.8 application with SQL Server Express backend. 
Installer: \\acmeshare\apps\WidgetManager_v5.2.msi"
```

**What Jira Ingestion Does**:
```markdown
# Prerequisites for WidgetManager Deployment Collection

## Overview
Custom application deployment collection for Acme Corp's WidgetManager.

## Primary Platform
**WidgetManager v5.2** (Acme Corp custom application)
- .NET application with SQL backend

## Required Software

### .NET Framework 4.8
- Why needed: Application runtime requirement

### SQL Server Express
- Why needed: Application database backend
- Version: 2019 or later sufficient

### WidgetManager Application v5.2
- Installer location: \\acmeshare\apps\WidgetManager_v5.2.msi
- Type: MSI installer
- Vendor: Acme Corp

## Test Environment
- Windows Server 2019+
- .NET Framework 4.8
- SQL Server Express
- WidgetManager installed and configured
```

**What Platform Prerequisite Does**:
1. Reads prerequisites.md
2. Installs .NET Framework 4.8 (Windows Feature)
3. Installs SQL Server Express (downloads from Microsoft)
4. Finds WidgetManager installer at `\\acmeshare\apps\WidgetManager_v5.2.msi`
5. Copies MSI to test host
6. Runs: `msiexec /i WidgetManager_v5.2.msi /qn`
7. Verifies: Application installed, service running

### Example 3: Unknown Software

**Epic Description**:
```
"Modules for managing SuperSecure VPN Gateway v3.0 configurations."
```

**What Jira Ingestion Does**:
```markdown
# Prerequisites for SuperSecure VPN Gateway Collection

## Primary Platform
**SuperSecure VPN Gateway v3.0** (third-party appliance software)

## Required Software

### SuperSecure VPN Gateway v3.0
- Why needed: Platform being managed
- Installation: Unknown - needs documentation

## Needs Manual Review
- Installer location for SuperSecure VPN Gateway unknown
- Check Epic for vendor documentation or installer URL
- May need to contact SuperSecure support for deployment guide
```

**What Platform Prerequisite Does**:
1. Reads prerequisites.md
2. Sees "Installation: Unknown"
3. Checks Epic for installer URLs (none found)
4. Asks user:
   ```
   Cannot find installer for "SuperSecure VPN Gateway v3.0".
   
   Please provide:
   1. Download URL or network path to installer
   2. Installation documentation link
   3. Silent install parameters (if applicable)
   
   Or: Skip this prerequisite if already installed on test host.
   ```

## Key Principles

### 1. Read Like a Human
- Don't just match patterns
- Understand context and purpose
- Infer implicit requirements

### 2. Research Like a Human
- For known software: Use common knowledge
- For custom software: Look for documentation
- For unknowns: Ask for help

### 3. Adapt to ANY Project
- No hardcoded platforms
- No rigid templates
- Natural language throughout

### 4. Be Intelligent, Not Scripted
- Make decisions based on context
- Handle edge cases gracefully
- Know when to ask for help

## Files Modified

**Completely Rewritten** (2):
1. `agents/jira-ingestion-specialist.md`
   - Now uses Opus (needs reasoning)
   - Reads natural language
   - Outputs Markdown, not YAML

2. `agents/platform-prerequisite-specialist.md`
   - Reads Markdown prerequisites
   - Intelligent installation strategy
   - Handles ANY software type

**Updated** (1):
3. `agents/lead-architect.md`
   - Phase 3 now uses flexible prerequisites
   - No template assumptions

**Documentation** (1):
4. `REFACTOR-FLEXIBLE-PREREQUISITES.md` - This file

**Removed Rigid Templates**:
- `examples/prerequisites/scvmm_prerequisites.yml` - Too rigid
- `examples/prerequisites/hyperv_prerequisites.yml` - Too rigid

**Kept as Reference** (1):
- `resources/platform-installation-guide.md`
  - Contains general patterns and examples
  - Used for research, not as templates

## Agent Intelligence Comparison

| Aspect | Old (Rigid) | New (Flexible) |
|--------|-------------|----------------|
| **Epic Analysis** | Pattern matching | Natural language understanding |
| **Output Format** | YAML templates | Markdown (human-readable) |
| **Platform Support** | 3-4 predefined | ANY Windows platform |
| **Installation** | Run template script | Research and adapt |
| **Custom Software** | Not supported | Requests installer info |
| **Dependencies** | Manual YAML | Automatic inference |
| **Unknowns** | Fails | Asks for clarification |

## Success Metrics

The refactored agents can now handle:

✅ **Standard Platforms**: SCVMM, Exchange, SQL, Hyper-V, IIS, etc.  
✅ **Custom Applications**: Company-specific software  
✅ **Mixed Environments**: IIS + Custom Service + SQL  
✅ **Unknown Software**: Asks for documentation/installers  
✅ **Implicit Dependencies**: Infers SQL needed for SCVMM  
✅ **Version Flexibility**: Adapts to any version mentioned  
✅ **Natural Language**: Reads and writes like a human

## Example Full Workflow

**Epic**: "Build modules for CompanyX's CloudSync application (IIS + Service + MongoDB)"

**Phase 1: Jira Ingestion** (reads Epic)
→ Output: prerequisites.md with IIS, Custom Service, MongoDB

**Phase 2: Foundation** (scaffolds workspace)
→ Output: Collection structure

**Phase 3: Platform Prerequisites** (installs intelligently)
1. Installs IIS (Windows Feature)
2. Downloads MongoDB (researches official download)
3. Asks: "Where is CloudSync service installer?"
4. User provides: `\\share\installers\CloudSync.msi`
5. Installs CloudSync from network share
6. Verifies: All services running

**Phase 4-7**: Build, QA, Refactor, Deliver

**Result**: ✅ Works for ANY project, not just examples

---

**This is what you wanted**: Agents that think and adapt, not follow templates!
