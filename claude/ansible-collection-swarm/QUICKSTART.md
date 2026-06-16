# Universal Ansible Collection Swarm - Quick Start

## Prerequisites

Ensure these CLI tools are installed:

**Required**:
- `jira-rh` or `jira-cli` - For reading Jira Epics
  ```bash
  npm install -g jira-rh && jira-rh config
  ```
- `gh` - GitHub CLI for automated PRs
  ```bash
  brew install gh && gh auth login
  ```
- `git` - Standard git CLI (usually pre-installed)

**Optional**:
- `ansible` - For local testing
  ```bash
  pip install ansible
  ```

**Check installation**:
```bash
jira-rh --version  # or: jira version
gh --version
git --version
```

---

## One-Command Build

```bash
# From Claude Code, invoke Lead Architect
Agent({
  description: "Build Ansible collection from Epic",
  prompt: "Build collection from Jira Epic WINOPS-2345"
})
```

## What Happens

### Phase 0: Smart Detection + Context Questions

**First**: Lead Architect auto-detects if collection already exists (checks 4 locations)

**Then**: You'll be asked 2-3 questions

**Question 1: Test Environment**
```
Where should integration tests run?
Provide: IP/hostname, connection method, credentials

Examples:
✅ 192.168.1.100, winrm, user: Administrator, pass: P@ss123
✅ ssh://test-server.lab.local:22, key: ~/.ssh/ansible_rsa
✅ network_cli://10.0.1.1, user: admin, pass: cisco123
✅ local (Azure API), subscription: abc-1234
```

**Question 2: Delivery Target**
```
Where should the completed collection go?

Options:
A) Local only (~/agentic-workflow-collections/...)
B) Git repository (provide URL)

Examples:
✅ Local only
✅ https://github.com/myorg/ansible-collections.git
```

**Question 3: Collection Location** (ONLY if ambiguous/multiple locations detected)
```
Collection found in multiple locations. Which should I use?

Options:
A) Current directory (you're working in a cloned repo)
B) Swarm workspace (~/agentic-workflow-collections/...)
C) Custom path (specify your own location)

Example scenarios when asked:
⚠️ Collection installed via ansible-galaxy (read-only location)
⚠️ Collection exists in multiple places
⚠️ Current directory has different collection
```

### Then Everything Happens Automatically

**If NEW collection** (Full Build - Phases 1-9):
1. **Ingestion** → Analyzes Epic, extracts characteristics
2. **Foundation** → Creates collection structure
3. **Prerequisites** → Installs software on your test environment
4. **Build** → Implements all modules (parallel batches)
5. **QA** → Tests against your test environment
6. **Refactor** → Extracts shared code
7. **Delivery** → Commits locally or pushes to your git repo
8. **CI/CD** → Fixes pipeline failures (if git delivery)
9. **Learning** → Captures knowledge for next time

**If EXISTING collection** (Enhancement Mode):
1. ~~Ingestion~~ **SKIP** (backlog exists)
2. ~~Foundation~~ **SKIP** (structure exists)
3. **Enhancement** → Analyzes existing patterns, adds new modules
4. **QA** → Tests new modules + regression tests existing ones
5. **Delivery** → Incremental commit/push
6. **CI/CD** → Validates changes (if git delivery)
7. **Learning** → Captures knowledge

**Duration**: Full Build: 2-3 hours | Enhancement: 30-60 minutes

## Real Examples

### Example 1: Windows SCVMM Collection

**Input**:
```
Epic: WINOPS-2345
Test env: 192.168.50.10, winrm, user: ansible_test, pass: Test123!
Delivery: https://github.com/myorg/ansible-collections.git
```

**Output**:
```
✅ Collection: microsoft.scvmm
✅ 15 modules implemented and tested
✅ Pushed to: https://github.com/myorg/ansible-collections.git
✅ CI/CD: All checks passing
✅ Duration: 2.5 hours
```

### Example 2: Azure Collection (No Test Environment)

**Input**:
```
Epic: CLOUD-789
Test env: "I don't have Azure subscription yet"
Delivery: Local only
```

**Output**:
```
✅ Collection: azure.compute
✅ 10 modules implemented (CODE ONLY)
⚠️ 0 modules tested (no environment)
📋 blocked_modules.md created for resume capability
✅ Location: ~/agentic-workflow-collections/azure/compute/
```

### Example 3: SolarWinds Collection (Unknown Platform)

**Input**:
```
Epic: MON-456 "Build SolarWinds Orion automation"
Test env: local (SolarWinds API), server: 10.0.1.50
Delivery: git@gitlab.company.com:ansible/collections.git
```

**Swarm behavior**:
- Researches: "What is SolarWinds Orion?"
- Discovers: REST API (SWIS), Python SDK available
- Learns: Similar to other REST API platforms
- Implements: Using REST API pattern
- Tests: Against 10.0.1.50 API
- Delivers: To GitLab

**Output**:
```
✅ Collection: solarwinds.orion
✅ 8 modules implemented and tested
✅ Pushed to: git@gitlab.company.com:ansible/collections.git
✅ Pattern learned: REST API (SWIS) - added to knowledge base
```

### Example 4: Developer Working in Cloned Repo (Enhancement)

**Setup**:
```bash
# Developer has forked and cloned
$ cd ~/projects/ansible-collections/microsoft-scvmm/
$ git remote -v
origin  https://github.com/myusername/ansible-scvmm.git (fetch)
upstream https://github.com/microsoft/ansible-scvmm.git (fetch)

$ ls
galaxy.yml  plugins/  tests/  README.md
```

**Input**:
```
User: "Add network management modules from EPIC-5678"
Test env: 192.168.1.100, winrm, user: ansible, pass: Test123
Delivery: https://github.com/myusername/ansible-scvmm.git
```

**Swarm Detection**:
```
🔍 Scanning for existing collection...
✅ EXISTING COLLECTION DETECTED
📦 Collection: microsoft.scvmm
📁 Location: /Users/dev/projects/ansible-collections/microsoft-scvmm (current directory)
🔍 Detection method: current_directory
🔧 Mode: ENHANCEMENT (add new modules)
💡 Working in place - your cloned repo

No Question 3 needed - clear single match
```

**Swarm Behavior**:
1. Analyzes existing 15 modules to extract patterns
2. Reads EPIC-5678 for new network modules
3. Implements 3 new modules matching existing style
4. Runs integration tests on new modules
5. Runs regression tests on all 15 existing modules
6. Git commit with changes
7. Ready for developer to review and push PR

**Output**:
```
✅ Collection enhanced: microsoft.scvmm
✅ Modules: 15 → 18
✅ New modules: scvmm_network, scvmm_virtual_network, scvmm_network_adapter
✅ All tests passing (new + regression)
✅ Committed to: current branch (ready for PR)
✅ Duration: 42 minutes

Next steps:
  git push origin HEAD
  Create PR to upstream
```

**Developer benefits**:
- No file copying between locations
- Works directly in your fork
- Preserves git history
- Ready to create PR immediately
- All existing functionality tested (regression)

## Resume from Blocked Modules

If environment was unavailable during initial build:

**Later** (after fixing environment):
```bash
# Navigate to collection
cd ~/agentic-workflow-collections/microsoft/scvmm/

# Check blocked modules
cat docs/plans/blocked_modules.md

# Resume testing (manual or via script)
ansible-test integration scvmm_host --python 3.9

# If passes, update backlog
# Mark [!] → [x] in module_backlog.md
```

## Key Features

### ✅ Universal Platform Support
- Windows, Linux, Azure, AWS, Cisco, VMware, custom apps
- Works for platforms that don't exist yet
- Learns patterns, doesn't use templates

### ✅ Context-Aware
- Uses YOUR test environment
- Delivers to YOUR chosen location
- Adapts to YOUR environment

### ✅ Intelligent
- Researches unfamiliar platforms
- Infers dependencies
- Learns from failures
- Gets smarter over time

### ✅ Resilient
- 3-attempt self-correction
- Degraded environment support
- Resume capability for blocked modules
- Continuous learning system

## Troubleshooting

### "Cannot reach test environment"

**Check**:
- Is host reachable? `ping 192.168.1.100`
- Is service running? (WinRM, SSH, etc.)
- Are credentials correct?
- Firewall blocking?

**Solution**: Fix connectivity, then re-run from Phase 3 (Prerequisites)

### "Git push failed"

**Check**:
- Git credentials configured?
- Repository accessible? `git ls-remote <url>`
- Branch exists?

**Solution**: Configure git auth, then Lead Architect will retry

### "Some modules blocked"

**This is normal** if test environment partially unavailable.

**Action**:
1. Review `docs/plans/blocked_modules.md`
2. Fix environment issues
3. Resume testing for blocked modules
4. Update backlog when tests pass

## Advanced Usage

### Custom Branch

When asked for delivery target:
```
https://github.com/myorg/ansible-collections.git:feature/my-branch
```

### Multiple Test Hosts

When asked for test environment:
```
Cluster: 192.168.1.10-12, winrm, user: ansible, pass: Test123
```

### Air-Gapped Environment

- Select: Local only delivery
- Manually transfer collection later
- No git operations required

## What Gets Created

```
~/agentic-workflow-collections/<namespace>/<name>/
├── galaxy.yml                     # Collection metadata
├── README.md                      # Collection documentation
├── plugins/
│   ├── modules/                   # All implemented modules
│   └── module_utils/              # Shared utilities (if refactored)
├── tests/
│   ├── integration/               # Integration tests
│   └── inventory.*                # Test inventory (your environment)
├── docs/
│   └── plans/
│       ├── module_backlog.md      # Progress tracking
│       ├── prerequisites.md       # Platform characteristics
│       ├── project_context.yml    # YOUR environment config
│       └── blocked_modules.md     # Resume capability (if needed)
└── .git/                          # Git repository (if delivered to git)
```

## Next Steps

1. **Try it**: Pick a simple Epic, invoke Lead Architect
2. **Answer 2 questions**: Test environment + Delivery target
3. **Wait**: Swarm handles everything autonomously
4. **Review**: Check generated collection
5. **Learn**: Swarm captured knowledge for next time

---

**Duration**: 30 minutes - 3 hours (depends on platform complexity)  
**Autonomy**: 100% (after answering 2 questions)  
**Platforms**: Infinite (learns any platform)
