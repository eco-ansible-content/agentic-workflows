# Getting Started with Universal Ansible Collection Swarm

## Quick Start

### Test the System (3 Commands)

```bash
# 1. Navigate to your workspace
cd ~/.claude/agents/ansible-collection-swarm

# 2. Invoke the Lead Architect with your Jira Epic
# Replace EPIC-XXX with your actual Epic key
claude-code --agent core/agents/lead-architect.md "Build collection from EPIC-XXX"

# 3. Answer the two context questions:
#    Q1: Test environment details
#    Q2: Delivery destination (local or git URL)
```

That's it! The system handles everything else autonomously.

---

## Example Usage Scenarios

### Scenario 1: Brand New Collection (Windows SCVMM)

**Command**:
```bash
claude-code --agent core/agents/lead-architect.md "Build collection from EPIC-2345"
```

**You'll be asked**:
1. **Test environment?** 
   - Answer: `192.168.50.10, winrm, user: Administrator, password: P@ssw0rd`

2. **Delivery destination?**
   - Answer: `https://github.com/myorg/ansible-collections.git`

**What happens automatically**:
- Ingestion Phase: Reads Epic, extracts characteristics
- Foundation Phase: Creates `~/agentic-workflow-collections/microsoft/scvmm/`
- Prerequisites Phase: Installs SCVMM on 192.168.50.10
- Build Phase: Implements all modules
- QA Phase: Tests against 192.168.50.10
- Delivery Phase: Pushes to GitHub
- CI/CD Phase: Monitors and fixes pipeline
- Learning Phase: Captures knowledge

**Duration**: 2-3 hours (for 15 modules)

---

### Scenario 2: Enhance Existing Collection

**Command**:
```bash
claude-code --agent core/agents/lead-architect.md "Add modules from EPIC-5678 to microsoft.scvmm"
```

**You'll be asked** (same questions as Scenario 1)

**What happens automatically**:
- Detects existing collection at `~/agentic-workflow-collections/microsoft/scvmm/`
- Reads Epic for new modules only
- Analyzes existing modules to extract patterns
- Implements new modules matching existing style
- Runs regression tests (existing + new modules)
- Incremental commit to git

**Duration**: 30-60 minutes (for 3 new modules)

**Key difference**: Skips Foundation and Prerequisites, preserves existing functionality

---

### Scenario 3: Unknown Platform (SolarWinds Orion)

**Command**:
```bash
claude-code --agent core/agents/lead-architect.md "Build collection from EPIC-9999"
```

**Epic content**: "Manage SolarWinds Orion network monitoring"

**You'll be asked**:
1. **Test environment?**
   - Answer: `local (Azure API), subscription: abcd-1234` (SolarWinds is REST API)

2. **Delivery destination?**
   - Answer: `local` (keep on filesystem only)

**What happens automatically**:
- Ingestion Phase: Researches "What is SolarWinds Orion?"
- Discovers: REST API-based platform
- Matches: REST API pattern (GET-compare-PUT)
- Prerequisites: No installation (API-based)
- Build: Python modules using requests library
- Tests: Against local API endpoint
- Delivery: Keeps in `~/agentic-workflow-collections/solarwinds/orion/`

**Duration**: 1-2 hours

**Intelligence**: System learns SolarWinds from scratch, no template needed!

---

## Understanding the Two Questions

### Question 1: Test Environment Details

**Purpose**: Where should integration tests run?

**Expected formats**:
```
# Windows (WinRM)
192.168.50.10, winrm, user: Administrator, password: P@ssw0rd

# Linux (SSH)
ssh://test-linux.lab.local:22, key: ~/.ssh/ansible_rsa

# Network devices (CLI)
network_cli://10.0.1.1, user: admin, password: cisco123

# Cloud APIs (local execution)
local (Azure API), subscription: abcd-1234

# VMware
vcenter.lab.local, httpapi, user: admin@vsphere.local, pass: VMware123
```

**If you don't have a test environment**:
- Answer: `none`
- System will: Build code-only, mark tests as blocked
- You get: Modules with `[!] CODE COMPLETE, TESTS BLOCKED` status

### Question 2: Delivery Destination

**Purpose**: Where should the final collection go?

**Options**:

**Option A: Local only**
```
local
```
- Collection stays in: `~/agentic-workflow-collections/<namespace>/<name>/`
- No git push
- Use when: Testing, air-gapped environments, private work

**Option B: Git repository**
```
https://github.com/myorg/ansible-collections.git
```
- Collection pushed to: Specified repository
- CI/CD validation runs
- Use when: Team collaboration, production, CI/CD

---

## What Runs Automatically (After Questions)

### Full Build Mode (New Collection)

1. **Ingestion Phase** (5-10 min)
   - Reads Jira Epic
   - Extracts platform characteristics
   - Creates module backlog
   - Researches unfamiliar platforms

2. **Foundation Phase** (2-5 min)
   - Creates collection structure
   - Populates galaxy.yml
   - Initializes git repository

3. **Prerequisites Phase** (30-90 min)
   - Installs required software on test environment
   - 3-attempt recovery strategy
   - Creates degraded environment if needed

4. **Build Phase** (60-120 min)
   - Implements modules in parallel batches
   - Matches platform characteristics to patterns
   - Follows best practices

5. **QA Phase** (30-60 min)
   - Tests each module (adaptive strategy)
   - Peer review by code-reviewer agent
   - Fixes failures autonomously

6. **Refactor Phase** (every 10 modules)
   - Extracts common utilities
   - Regression tests

7. **Delivery Phase** (5-10 min)
   - Four-pillar audit
   - Commits to git
   - Pushes to repository (if git delivery)

8. **CI/CD Phase** (if git delivery)
   - Monitors GitHub workflows
   - Fixes failures
   - Amend-push cycle

9. **Learning Phase** (10-15 min)
   - Captures lessons learned
   - Updates agent knowledge
   - Tags by characteristics

### Enhancement Mode (Existing Collection)

1. ~~Ingestion~~ **SKIP**
2. ~~Foundation~~ **SKIP**
3. **Enhancement Phase** (20-40 min)
   - Analyzes existing collection
   - Implements new modules matching patterns
   - Regression tests existing modules
4. ~~Prerequisites~~ **CONDITIONAL** (only if new)
5. ~~Build~~ **HANDLED IN ENHANCEMENT**
6. ~~QA~~ **HANDLED IN ENHANCEMENT**
7. **Delivery Phase** (same as full build)
8. **CI/CD Phase** (same as full build)
9. **Learning Phase** (same as full build)

---

## Monitoring Progress

### During Execution

The Lead Architect updates `docs/plans/module_backlog.md`:

```markdown
## Module Backlog

- [x] scvmm_host - DONE (5 min)
- [x] scvmm_vm - DONE (7 min)
- [~] scvmm_cloud - IN PROGRESS
- [ ] scvmm_network - TODO
- [!] scvmm_storage - CODE COMPLETE, TESTS BLOCKED (degraded env)
```

**Status indicators**:
- `[ ]` TODO
- `[~]` IN PROGRESS
- `[x]` DONE
- `[!]` CODE COMPLETE, TESTS BLOCKED

### After Completion

Check the JSON summary:

```json
{
  "status": "completed",
  "collection": {
    "namespace": "microsoft",
    "name": "scvmm",
    "version": "1.0.0"
  },
  "statistics": {
    "total_modules": 15,
    "completed_modules": 15,
    "lines_of_code": 4200
  },
  "delivery": {
    "target": "git",
    "location": "https://github.com/myorg/collections.git",
    "commit_sha": "abc123...",
    "ci_status": "passing"
  },
  "duration": {
    "total_minutes": 142
  }
}
```

---

## Troubleshooting

### "Cannot connect to test environment"

**Cause**: Network issue or wrong credentials

**Fix**:
1. Test manually: `Test-WSMan -ComputerName <host>` (Windows) or `ssh <host>` (Linux)
2. Verify credentials in your answer to Question 1
3. Check firewall rules

### "Prerequisite installation failed after 3 attempts"

**Cause**: Software not found or installation error

**Options**:
- **A**: Provide installer URL/path, system retries
- **B**: Accept degraded environment (partial functionality)
- **C**: Manual installation, resume build

**System will prompt you** for choice

### "Module tests failing repeatedly"

**Cause**: Environment issue or platform quirk

**What happens**:
- QA Coordinator attempts 3 fixes
- If unfixable: Escalates to Learning Specialist
- Learning Specialist captures knowledge
- Future builds avoid same issue

---

## Real-World Examples

### Example 1: Microsoft SCVMM (Windows)

```bash
Epic: SCVMM-2345
Modules: 15 (scvmm_host, scvmm_vm, scvmm_cloud, ...)
Platform: Windows Server + PowerShell
Test env: 192.168.1.50, winrm
Delivery: https://github.com/myorg/collections.git

Result:
✅ 15 modules implemented
✅ All tests passing
✅ Pushed to GitHub
✅ CI/CD passing
⏱️ Duration: 2.5 hours
```

### Example 2: SolarWinds Orion (API)

```bash
Epic: SOLARWINDS-9999
Modules: 8 (orion_node, orion_interface, orion_alert, ...)
Platform: REST API (Python)
Test env: local (API)
Delivery: local

Result:
✅ 8 modules implemented
✅ All tests passing (against API)
✅ Kept in ~/agentic-workflow-collections/solarwinds/orion/
⏱️ Duration: 1.8 hours
```

### Example 3: Enhancement (Add 3 Modules)

```bash
Epic: SCVMM-5678
Existing: 15 modules
New: 3 modules (scvmm_network, scvmm_template, scvmm_service_template)
Test env: Same as before
Delivery: Same repo

Result:
✅ 3 new modules (matching existing patterns)
✅ 15 existing modules regression tested
✅ Incremental commit pushed
⏱️ Duration: 45 minutes
```

---

## Next Steps After Collection Built

### Option 1: Use Collection Locally

```bash
# Install collection
ansible-galaxy collection install ~/agentic-workflow-collections/microsoft/scvmm/

# Use in playbook
---
- hosts: windows
  collections:
    - microsoft.scvmm
  tasks:
    - name: Manage Hyper-V host
      scvmm_host:
        name: hyperv01.domain.com
        vmm_server: scvmm.domain.com
        state: present
```

### Option 2: Publish to Galaxy

```bash
cd ~/agentic-workflow-collections/microsoft/scvmm/
ansible-galaxy collection build
ansible-galaxy collection publish microsoft-scvmm-1.0.0.tar.gz --api-key <key>
```

### Option 3: Continue Enhancing

```bash
# Add more modules from new Epic
claude-code --agent core/agents/lead-architect.md "Add modules from EPIC-7890 to microsoft.scvmm"
```

---

## Tips for Success

1. **Prepare test environment before starting**
   - Verify connectivity
   - Have credentials ready
   - Test manually first

2. **Start small for first run**
   - Use Epic with 5-10 modules
   - Validate approach
   - Scale up after success

3. **Let system run autonomously**
   - After answering 2 questions, hands-off
   - System self-corrects (3 attempts per failure)
   - Only escalates if truly stuck

4. **Review learning output**
   - Check `docs/lessons_learned.md`
   - See what system discovered
   - Informs future builds

5. **Use enhancement mode for iterations**
   - Don't rebuild entire collection
   - Add modules incrementally
   - Preserves existing work

---

## System Capabilities

### Works for ANY Platform

- ✅ Windows (PowerShell, WinRM)
- ✅ Linux (Python, SSH)
- ✅ Network devices (CLI)
- ✅ Cloud APIs (Azure, AWS, GCP)
- ✅ Custom applications (any API)
- ✅ Platforms that don't exist yet!

### Intelligence Features

- **Characteristic extraction**: Understands "how it works" not "what it is"
- **Pattern matching**: 5 generic patterns apply everywhere
- **Adaptive testing**: Strategy based on platform
- **Research capability**: Learns unfamiliar platforms
- **3-attempt recovery**: Self-corrects failures
- **Degraded environments**: Partial success acceptable
- **Cross-platform learning**: Lessons apply universally

### Zero Assumptions

- No hardcoded platforms
- No template-based approach
- No environment assumptions
- Asks for context upfront
- Adapts to your environment

---

## Ready to Test?

Choose your scenario:

**New Collection**:
```bash
claude-code --agent core/agents/lead-architect.md "Build collection from EPIC-XXX"
```

**Enhance Existing**:
```bash
claude-code --agent core/agents/lead-architect.md "Add modules from EPIC-YYY to namespace.name"
```

**The system will guide you through the rest!**
