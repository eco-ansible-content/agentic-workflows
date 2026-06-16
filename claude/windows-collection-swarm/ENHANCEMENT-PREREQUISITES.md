# Enhancement: Platform Prerequisite Installation

## Overview

Major enhancement to the Windows Collection Swarm adding automated platform prerequisite detection and installation.

## Problem Statement

**Original Issue**: Agents cannot test SCVMM modules if SCVMM isn't installed on the Windows test server. The same applies to Hyper-V, SQL Server, IIS, and other platforms.

**Example**: Testing `scvmm_host` module requires:
- SCVMM 2022 installed
- SQL Server 2019+ backend
- Hyper-V role enabled
- Configured library shares
- Test data available

Without these prerequisites, integration tests fail even if the module code is perfect.

## Solution

Added a new **Platform Prerequisite Specialist** agent that:
1. Detects required platforms from module names and Epic descriptions
2. Installs all necessary software, services, and configurations
3. Verifies platform health before proceeding to module testing

## What Was Added

### 1. New Agent: Platform Prerequisite Specialist

**Location**: `agents/platform-prerequisite-specialist.md`

**Model**: Opus 4.7 (requires strategic decision-making for complex installations)

**Responsibilities**:
- Parse prerequisite manifest from Jira Ingestion
- Install OS features (Hyper-V, IIS, etc.)
- Download and install software (SCVMM, SQL Server, etc.)
- Configure services and databases
- Create test data
- Run health checks to verify environment readiness

**Access Methods**:
- Primary: WinRM (PowerShell Remoting)
- Secondary: SSH (for file transfers)
- Both assumed to be pre-configured

**Capabilities**:
- Silent/unattended installations
- Dependency resolution (SQL before SCVMM)
- Parallel installation of independent platforms
- Retry logic (3 attempts per installation)
- Comprehensive verification

### 2. Enhanced Agent: Jira Ingestion Specialist

**Added Capabilities**:
- **Pattern-Based Detection**: Analyzes module names
  - `scvmm_*` → SCVMM required
  - `hyperv_*` → Hyper-V required
  - `sql_*` → SQL Server required
  - etc.

- **Epic Description Parsing**: Extracts explicit requirements
  - Keywords: "requires", "needs", "depends on"
  - Versions: "SQL Server 2019", "SCVMM 2022"

- **Dependency Inference**: Auto-adds platform dependencies
  - SCVMM detected → add SQL Server, Hyper-V, ADK

**New Output**: Creates `docs/plans/prerequisites.yml` with complete installation manifest

### 3. New Resource: Platform Installation Guide

**Location**: `resources/platform-installation-guide.md`

**Contents**:
- Installation procedures for 9 common platforms:
  - SCVMM (System Center VMM)
  - Hyper-V
  - SQL Server
  - IIS
  - Active Directory Domain Services
  - DNS Server
  - DHCP Server
  - Failover Clustering
  - WSUS

- Silent installation scripts
- Service verification templates
- Download with retry patterns
- Troubleshooting guides
- Installation time estimates

### 4. Prerequisite Manifest Examples

**Location**: `examples/prerequisites/`

**Files**:
- `scvmm_prerequisites.yml` - Complete SCVMM setup (120 min)
- `hyperv_prerequisites.yml` - Hyper-V setup (15 min)

**Format**:
```yaml
platform:
  name: "SCVMM"
  version_required: "2022"

prerequisites:
  os_features:      # Windows Features to install
  software:         # MSIs, ISOs to install
  services:         # Services to configure
  databases:        # Databases to create
  configurations:   # Settings to apply
  test_data:        # Sample data to create

verification:
  health_checks:    # Commands to verify readiness
```

### 5. Updated Workflow: Lead Architect

**New Phase 3**: Prerequisite Installation

```
Phase 1: Ingestion → Module Backlog + Prerequisites Manifest
Phase 2: Foundation → Workspace Scaffolding
Phase 3: Prerequisites → Platform Installation ← NEW
Phase 4: Build → Module Development
Phase 5: QA → Testing
Phase 6: Refactor → Utilities
Phase 7: Delivery → Git Push
```

**Critical Addition**: Build phase BLOCKED until prerequisites verified.

## Workflow Enhancement

### Before (Missing Prerequisites)

```
1. Jira Ingestion → Module list
2. Foundation → Workspace
3. Build Modules → ❌ Tests fail (SCVMM not installed)
4. Manual intervention required
```

### After (Automated Prerequisites)

```
1. Jira Ingestion → Module list + Prerequisites detected
2. Foundation → Workspace
3. Prerequisites → Install SCVMM, SQL, Hyper-V (60-90 min)
4. Build Modules → ✅ Tests pass (environment ready)
5. QA → Verification
6. Delivery → Git push
```

## Example: SCVMM Collection

### Detected Requirements
```yaml
detected_platform: "SCVMM"
detection_confidence: "high"

modules_analyzed:
  - scvmm_host
  - scvmm_vm
  - scvmm_library_share
  - scvmm_virtual_network

prerequisites:
  software:
    - SQL Server 2019
    - Windows ADK
    - SCVMM 2022
  
  os_features:
    - Hyper-V
    - RSAT-Clustering
  
  estimated_install_time: "90 minutes"
```

### Installation Sequence
1. **Install SQL Server** (20 min)
   - Download installer
   - Silent installation
   - Configure TCP/IP
   - Verify connection

2. **Install Windows ADK** (10 min)
   - Download installer
   - Silent installation
   - Verify deployment tools

3. **Install Hyper-V** (5 min + reboot)
   - Install-WindowsFeature
   - Reboot server
   - Create virtual switch

4. **Install SCVMM** (60 min)
   - Create SQL database
   - Mount ISO
   - Run unattended setup
   - Configure VMM server
   - Add Hyper-V host
   - Create library share

5. **Verify Environment** (5 min)
   - Test SCVMM cmdlets
   - Verify SQL connection
   - Check Hyper-V hosts
   - Validate library shares

**Total**: ~100 minutes fully automated

## Agent Count

**Before**: 7 agents
**After**: 8 agents

New total: **8 Specialized Agents**

1. Lead Architect (Opus)
2. Jira Ingestion Specialist (Sonnet) - Enhanced
3. Foundation Specialist (Sonnet)
4. **Platform Prerequisite Specialist (Opus)** ← NEW
5. Module Workers (Sonnet, parallel)
6. QA Coordinator (Sonnet)
7. Refactor Specialist (Opus)
8. Release Specialist (Sonnet)

## Installation Capabilities

### Platforms Supported
- SCVMM 2022
- Hyper-V
- SQL Server 2019/2022
- IIS
- Active Directory Domain Services
- DNS Server
- DHCP Server
- Failover Clustering
- WSUS

### Installation Methods
- Windows Features (`Install-WindowsFeature`)
- MSI packages (silent install)
- ISO mounting and setup
- PowerShell script execution
- SQL database creation
- Service configuration

### Verification Methods
- Service status checks
- PowerShell cmdlet tests
- SQL queries
- Health check commands
- Custom verification scripts

## Error Handling

### 3-Attempt Strategy
1. **Attempt 1**: Retry with verbose logging
2. **Attempt 2**: Try alternative installation method
3. **Attempt 3**: Manual intervention prompt

### Failure Scenarios
- **Installation hangs**: Timeout, check logs, retry
- **Service won't start**: Check dependencies, restart
- **Download fails**: Retry with exponential backoff
- **Verification fails**: Wait, retry, check event logs

## Performance Impact

### Timeline Changes (30-module SCVMM Epic)

**Before**:
- Ingestion: 2-5 min
- Foundation: 1-2 min
- Build: 60-90 min
- **TOTAL: ~90-120 min** ← Assumes SCVMM pre-installed

**After**:
- Ingestion: 2-5 min (now detects prerequisites)
- Foundation: 1-2 min
- **Prerequisites: 60-90 min** ← NEW PHASE
- Build: 60-90 min (tests now pass)
- **TOTAL: ~150-210 min** (2.5-3.5 hours)

**One-time cost**: Prerequisites installed once per test environment, not per collection.

### Optimization
- Parallel platform installation (when independent)
- Cached installers (download once)
- Reusable test environments
- Snapshot/restore for quick reset

## Security Considerations

### Credentials
- Uses credentials from `tests/inventory.winrm`
- Requires Administrator privileges
- Supports both WinRM and SSH

### Network Access
- Test host requires internet for downloads
- Can use internal mirror/repository
- Download URLs configurable

### Sensitive Data
- SQL SA password configurable
- No hardcoded credentials
- Supports secure credential storage

## Files Modified/Added

### New Files (5)
1. `agents/platform-prerequisite-specialist.md` - New agent
2. `resources/platform-installation-guide.md` - Installation procedures
3. `examples/prerequisites/scvmm_prerequisites.yml` - SCVMM manifest
4. `examples/prerequisites/hyperv_prerequisites.yml` - Hyper-V manifest
5. `ENHANCEMENT-PREREQUISITES.md` - This file

### Modified Files (2)
1. `agents/jira-ingestion-specialist.md` - Added prerequisite detection
2. `agents/lead-architect.md` - Added Phase 3 (Prerequisites)

## Usage Example

### Invoking with Prerequisites

```
Agent(
  subagent_type: "lead-architect",
  description: "Build SCVMM collection from EPIC-123",
  prompt: """Build complete Windows Ansible collection from Epic EPIC-123.

  Execute full lifecycle including automated prerequisite installation:
  1. Detect prerequisites from module names
  2. Install SCVMM, SQL Server, Hyper-V on test host
  3. Verify environment readiness
  4. Build and test modules
  5. Deliver to git

  Test host: 10.46.109.224 (WinRM enabled, Administrator access)
  
  Operate with extreme autonomy. Report only on completion."""
)
```

### Monitoring Prerequisites

```bash
# Watch prerequisite installation
cat ~/agentic-workflow-collections/*/docs/plans/prerequisites.yml

# Check installation log
tail -f ~/agentic-workflow-collections/*/docs/plans/prerequisite_verification.log

# Monitor services
ssh admin@10.46.109.224 "Get-Service SCVMM Service"
```

## Benefits

### For Users
- **Zero Manual Setup**: No need to pre-install platforms
- **Repeatable**: Automated setup is consistent
- **Self-Documenting**: Prerequisites captured in manifest
- **Time-Saving**: Parallel installation where possible

### For Quality
- **Correct Environment**: Tests run in verified environment
- **No False Failures**: Tests fail only if code is wrong, not environment
- **Comprehensive Verification**: Health checks ensure readiness

### For Autonomy
- **True End-to-End**: From Jira Epic to delivered collection, no manual steps
- **Platform Agnostic**: Works for any Windows platform
- **Intelligent Detection**: Infers requirements from module names

## Future Enhancements

### Possible Additions
- [ ] Snapshot test environment after setup (for quick reset)
- [ ] Support for clustered/HA environments
- [ ] Docker/container-based prerequisites (where applicable)
- [ ] Prerequisite caching/repository
- [ ] Multi-host installations (SCVMM cluster)
- [ ] Cost estimation (Azure/AWS instance requirements)

### Platform Support Expansion
- [ ] Exchange Server
- [ ] SharePoint Server
- [ ] Configuration Manager (SCCM/MECM)
- [ ] Operations Manager (SCOM)
- [ ] Data Protection Manager (DPM)

## Testing the Enhancement

### Verify Swarm Includes Enhancements

```bash
# Check new agent exists
ls ~/.claude/agents/windows-collection-swarm/agents/platform-prerequisite-specialist.md

# Check new resources
ls ~/.claude/agents/windows-collection-swarm/resources/platform-installation-guide.md

# Check examples
ls ~/.claude/agents/windows-collection-swarm/examples/prerequisites/
```

### Test Prerequisite Detection

Use a small SCVMM Epic to verify:
1. Jira Ingestion detects SCVMM from module names
2. Prerequisites manifest created
3. Platform Prerequisite Specialist runs
4. SCVMM installation completes
5. Health checks pass
6. Module testing proceeds

---

**Enhancement Complete**: Swarm now handles platform prerequisites autonomously!

**Version**: 1.1.0  
**Enhancement Date**: 2026-05-27  
**Impact**: Critical - enables true end-to-end automation for platform-dependent collections
