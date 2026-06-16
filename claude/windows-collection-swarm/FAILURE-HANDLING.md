# Prerequisite Installation Failure Handling

## The Question

**"What happens if the agent understands what needs to be installed but fails to do so?"**

## The Answer

The agent has a **comprehensive 3-attempt recovery strategy** with intelligent degraded environment fallback.

## The 3-Attempt Recovery Pattern

Every installation failure gets **3 attempts** before escalation:

```
┌─────────────────────┐
│ Attempt 1: Standard │
│ Try normal install  │
└──────────┬──────────┘
           │ FAIL
           ↓
┌─────────────────────────┐
│ Attempt 2: Alternative  │
│ Different approach      │
└──────────┬──────────────┘
           │ FAIL
           ↓
┌─────────────────────────┐
│ Attempt 3: Workaround   │
│ Minimal/degraded option │
└──────────┬──────────────┘
           │ FAIL
           ↓
┌─────────────────────────┐
│ ESCALATE to User        │
│ With options & impact   │
└─────────────────────────┘
```

## Real-World Examples

### Example 1: SCVMM Installation Fails

**Scenario**: SCVMM installer hangs at "Configuring database" step

#### Attempt 1: Analyze and Retry
```powershell
# Check logs
Select-String -Path "C:\Installers\scvmm_install.log" -Pattern "ERROR"
# Found: "Cannot connect to SQL Server instance"

# Fix: Verify SQL Server is running
Start-Service MSSQLSERVER

# Retry installation
& setup.exe /server /i /f setup.ini
```
**Result**: Still fails (different error)

#### Attempt 2: Alternative Approach
```powershell
# Try different installer version
$alternativeUrl = "https://.../SCVMM2022-RTM.iso"  # Use RTM instead of CU

# Or try manual installation steps:
# 1. Create database manually in SQL
# 2. Run setup pointing to existing database
# 3. Install components separately

Invoke-Sqlcmd -Query "CREATE DATABASE VirtualManagerDB"
& setup.exe /server /i /f setup_existing_db.ini
```
**Result**: Still fails (database configuration issue)

#### Attempt 3: Degraded Environment
```powershell
# Install SCVMM Console only (read-only operations)
& setup.exe /console /i /f setup_console.ini

# Verify console works
Import-Module VirtualMachineManager
# Can use Get-* cmdlets, but not Set-*/New-*
```
**Result**: SUCCESS - Console installed, but limited functionality

#### Escalation to Lead Architect
```json
{
  "status": "partial_success",
  "installed": ["SCVMM Console", "SQL Server", "Hyper-V"],
  "failed": ["SCVMM Server"],
  "module_impact": {
    "total": 15,
    "testable": 8,
    "blocked": 7
  },
  "testable_modules": [
    "scvmm_info (Get-SCVMMServer)",
    "scvmm_host_info (Get-SCVMHost)",
    "scvmm_vm_info (Get-SCVM)"
  ],
  "blocked_modules": [
    "scvmm_host (New-SCVMHost)",
    "scvmm_vm (New-SCVM)",
    "scvmm_library_share (New-SCLibraryShare)"
  ],
  "recommendation": "Proceed with 8 testable modules"
}
```

**Lead Architect Decision**:
- 53% modules testable → **Acceptable degraded environment**
- Continue with read-only SCVMM modules
- Mark write modules as `[SKIP]` in backlog
- Build code for all modules, test only read-only ones

### Example 2: Custom Software Installer Not Found

**Scenario**: "WidgetCorp Tool v2.4" installer missing

#### Attempt 1: Search Common Locations
```powershell
# Check Epic attachments
Get-JiraEpicAttachments -EpicKey "EPIC-123"

# Search network shares
$paths = @(
    "\\fileserver\installers\",
    "\\fileserver\apps\",
    "\\fileserver\software\"
)

foreach ($path in $paths) {
    Get-ChildItem -Path $path -Recurse -Filter "*WidgetCorp*"
}
```
**Result**: Not found

#### Attempt 2: Check Prerequisites Doc for URLs
```markdown
Read prerequisites.md:
"WidgetCorp Tool v2.4 - custom application"
No installer URL provided
```
**Result**: Still not found

#### Attempt 3: Search for Alternative
```
Check if there's a similar tool or trial version available
Search: "WidgetCorp Tool download"
```
**Result**: Requires vendor license, no trial

#### Escalation to User
```
INSTALLATION BLOCKED: WidgetCorp Tool v2.4

Cannot find installer for WidgetCorp Tool v2.4.

Searched:
✗ Epic attachments
✗ \\fileserver\installers\
✗ \\fileserver\apps\
✗ Public downloads (requires license)

REQUIRED: Please provide ONE of:
1. Download URL for WidgetCorp Tool v2.4
2. Network path to installer (e.g., \\share\apps\widgetcorp.msi)
3. Alternative: Can we use different tool for testing?

IMPACT if skipped:
- 5/20 modules cannot be integration tested
- These modules can still be built (code-only)

OPTIONS:
A) Provide installer location → Continue with full environment
B) Skip WidgetCorp modules → Continue with 15/20 modules (75%)
C) Pause build → Wait for installer

Your choice:
```

**User Response Example**: Option B - Skip WidgetCorp modules
**Lead Architect Action**: Mark 5 WidgetCorp modules as `[SKIP]`, proceed with 15 modules

### Example 3: SQL Server Service Won't Start

**Scenario**: SQL installs successfully but service fails to start

#### Attempt 1: Check Dependencies and Logs
```powershell
# Check service dependencies
$service = Get-Service MSSQLSERVER
$dependencies = $service.RequiredServices | Where-Object {$_.Status -ne 'Running'}

# Start dependencies
foreach ($dep in $dependencies) {
    Start-Service $dep.Name
}

# Check Windows Event Log
Get-EventLog -LogName Application -Source MSSQL* -EntryType Error -Newest 5
# Found: "Login failed for user 'NT SERVICE\MSSQLSERVER'"

# Fix: Reset service account
sc.exe config MSSQLSERVER obj= "LocalSystem"

# Retry
Start-Service MSSQLSERVER
```
**Result**: Still fails (different error: port conflict)

#### Attempt 2: Reconfigure Service
```powershell
# Port 1433 already in use
# Solution: Use different port OR stop conflicting service

# Option A: Use different port
# Modify SQL Server to use port 1434
Set-SqlServerPort -Port 1434

# Option B: Stop conflicting service
$conflicting = Get-NetTCPConnection -LocalPort 1433
$process = Get-Process -Id $conflicting.OwningProcess
Stop-Process -Id $process.Id -Force

# Retry
Start-Service MSSQLSERVER
```
**Result**: Still fails (corrupt master database)

#### Attempt 3: Use SQL Server Express LocalDB
```powershell
# Full SQL Server failed, try lightweight alternative
Write-Warning "Switching to SQL Server Express LocalDB"

# Uninstall full SQL Server
C:\Installers\SQLServer.exe /Action=Uninstall /QUIET

# Install LocalDB
choco install sql-server-express-localdb -y

# Verify
sqllocaldb start MSSQLLocalDB
```
**Result**: SUCCESS - LocalDB working

#### Escalation with Alternative
```json
{
  "status": "alternative_installed",
  "requested": "SQL Server 2019 Full",
  "installed": "SQL Server Express LocalDB",
  "impact": {
    "limitations": [
      "No remote connections (local only)",
      "No SQL Server Agent",
      "10 GB database size limit"
    ],
    "module_compatibility": "Most modules will work, except those requiring remote SQL or SQL Agent"
  },
  "modules_affected": {
    "compatible": 18,
    "incompatible": 2,
    "incompatible_modules": [
      "sql_remote_login (requires remote connections)",
      "sql_agent_job (requires SQL Server Agent)"
    ]
  },
  "recommendation": "Proceed with LocalDB for 18/20 modules"
}
```

**Lead Architect Decision**: 90% compatible → Proceed with LocalDB

### Example 4: Insufficient Disk Space

**Scenario**: SCVMM requires 100 GB, only 45 GB free

#### Attempt 1: Clean Up Disk
```powershell
# Check current space
$free = (Get-PSDrive C).Free / 1GB  # 45 GB

# Cleanup tasks
Remove-Item "C:\Windows\Temp\*" -Recurse -Force
Remove-Item "C:\Temp\*" -Recurse -Force
Stop-Service wuauserv
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
Start-Service wuauserv
Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait

# Recheck
$free = (Get-PSDrive C).Free / 1GB  # 52 GB (gained 7 GB)
```
**Result**: Still not enough (need 100 GB)

#### Attempt 2: Use Alternative Drive
```powershell
# Check if D: or E: drive has space
$altDrive = Get-PSDrive | Where-Object {$_.Free/1GB -gt 100} | Select-Object -First 1

if ($altDrive) {
    # Install to D:\ instead
    $installPath = "$($altDrive.Name):\Program Files\SCVMM"
    & setup.exe /server /i /f setup.ini /INSTALLDIR=$installPath
}
```
**Result**: No alternative drives with enough space

#### Attempt 3: Minimal Installation
```powershell
# Install minimal components only
# - Console only (20 GB instead of 100 GB)
# - Skip templates, language packs

& setup.exe /console /i /f setup_minimal.ini
```
**Result**: SUCCESS - Console installed in 22 GB

#### Escalation
```json
{
  "status": "resource_constraint",
  "issue": "Insufficient disk space",
  "required": "100 GB",
  "available": "52 GB",
  "installed": "SCVMM Console (minimal, 22 GB)",
  "options": [
    "Add 50 GB disk space to test server",
    "Use different test server with more space",
    "Continue with minimal SCVMM (console only)"
  ],
  "recommendation": "Continue with minimal installation"
}
```

## Degraded Environment Strategy

When full installation impossible, create a **degraded but functional** environment:

### Principles

1. **Install what you can**: Some components better than none
2. **Document limitations**: Clear impact assessment
3. **Test what's possible**: Maximize testable modules
4. **Offer alternatives**: Suggest workarounds

### Example Degraded Environments

#### SCVMM Failed → Use Hyper-V Direct

**Full Environment** (Failed):
- SCVMM Server
- SQL Server
- Hyper-V

**Degraded Environment** (Working):
- ✅ Hyper-V only
- ✅ SQL Server

**Testing Strategy**:
```markdown
## Working Modules (use Hyper-V cmdlets directly)
- hyperv_vm (New-VM instead of New-SCVM)
- hyperv_switch (New-VMSwitch instead of New-SCVMNetwork)
- sql_database (SQL Server available)

## Blocked Modules (require SCVMM)
- scvmm_host (no SCVMM to manage hosts)
- scvmm_library_share (no SCVMM library)

## Workaround
Build all modules. Test Hyper-V and SQL modules only.
SCVMM modules: Code review only, integration tests skipped.
```

#### Exchange Failed → Use Outlook Cmdlets

**Full Environment** (Failed):
- Exchange Server 2019
- Active Directory

**Degraded Environment** (Working):
- ✅ Active Directory
- ✅ Exchange Management Tools (cmdlets only)

**Testing Strategy**:
```markdown
## Working Modules (use remote Exchange if available)
- exchange_mailbox_info (Get-Mailbox via remote session)
- exchange_database_info (Get-MailboxDatabase via remote)

## Blocked Modules (require local Exchange)
- exchange_transport_rule (needs local server)
- exchange_database (needs local server)

## Workaround
Connect to production Exchange server (read-only) for Get-* cmdlet testing.
Set-*/New-* cmdlets: Code review only.
```

## Lead Architect Decision Tree

When Platform Prerequisite Specialist escalates:

```
┌─────────────────────────┐
│ Prerequisite Failed     │
└────────────┬────────────┘
             │
             ↓
┌─────────────────────────┐
│ Check Module Impact     │
│ (% modules affected)    │
└────────────┬────────────┘
             │
    ┌────────┴────────┐
    │                 │
0-25%           25-50%            50-75%            75-100%
BLOCKED         BLOCKED           BLOCKED           BLOCKED
    │                 │                │                 │
    ↓                 ↓                ↓                 ↓
┌───────┐      ┌──────────┐    ┌───────────┐    ┌──────────┐
│PROCEED│      │PROCEED   │    │ASK USER   │    │PAUSE     │
│Auto   │      │+ Notify  │    │Continue?  │    │+ Ask     │
└───────┘      └──────────┘    └───────────┘    └──────────┘
```

### Decision Matrix

| Modules Blocked | Action | Example |
|-----------------|--------|---------|
| 0-25% | Proceed automatically with degraded environment | "2/10 modules blocked, continue with 8" |
| 25-50% | Proceed but notify user of degradation | "5/10 modules blocked, continuing with 5 (notifying user)" |
| 50-75% | Ask user: Continue degraded OR pause for fix | "7/10 modules blocked. Continue with 3 OR fix environment?" |
| 75-100% | Pause and request user intervention | "9/10 modules blocked. Cannot proceed without fix." |

## User Interaction Examples

### Scenario: Installer Not Found

**Agent Message**:
```
Prerequisite installation requires user input:

Component: WidgetCorp Deployment Tool v2.4
Issue: Installer not found

Searched locations:
✗ Epic attachments
✗ \\fileserver\installers\
✗ \\fileserver\apps\
✗ Public downloads (requires license)

Impact: 5/20 modules cannot be integration tested

Options:
A) Provide installer URL or network path
   → I will download/copy and install
   
B) Skip WidgetCorp modules
   → Continue with 15/20 modules (75%)
   
C) Pause build
   → Wait while you locate installer

Please select A, B, or C:
```

**User Response**: "B"

**Agent Action**: Mark 5 modules as `[SKIP]`, proceed with 15 modules

### Scenario: Resource Constraints

**Agent Message**:
```
Prerequisite installation blocked by resources:

Component: SCVMM 2022
Issue: Insufficient disk space
Required: 100 GB free
Available: 52 GB free

Attempts made:
✓ Attempt 1: Disk cleanup (gained 7 GB, still not enough)
✓ Attempt 2: Check alternative drives (none available)
✓ Attempt 3: Minimal install (SUCCESS - Console only, 22 GB)

Current status: SCVMM Console installed (read-only)

Impact: 7/15 modules cannot write data (Set-*, New-* cmdlets)
Can test: 8/15 modules (Get-* cmdlets)

Options:
A) Continue with SCVMM Console (53% modules testable)
B) Add disk space to server (50 GB needed)
C) Use different test server
D) Abort build

Please select A, B, C, or D:
```

**User Response**: "A - Continue with console"

**Agent Action**: Proceed with degraded environment, mark 7 modules as `[SKIP]`

## Summary

### The 3-Attempt Strategy
1. **Attempt 1**: Standard approach with log analysis
2. **Attempt 2**: Alternative method or configuration
3. **Attempt 3**: Degraded/minimal installation

### Escalation Criteria
- All 3 attempts failed
- User input required (installer location, resource decisions)
- Degraded environment needs approval (if >50% modules affected)

### Degraded Environment
- **Acceptable**: >50% modules testable
- **Document**: Clear limitations and workarounds
- **Test**: Maximize what's possible
- **Skip**: Mark untestable modules clearly

### User Interaction
- **Clear options**: A, B, C format
- **Impact assessment**: X/Y modules affected
- **Recommendations**: What agent suggests
- **Transparency**: Show all 3 attempts made

---

**Result**: Even if installation fails, the agent provides intelligent options and degraded environments to maximize testing coverage!
