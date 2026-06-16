---
name: ansible-collection-swarm
description: Build or enhance Ansible collections from Jira Epics - intelligent, autonomous, universal
---

# Universal Ansible Collection Swarm

Autonomous multi-agent system that builds **ANY** Ansible collection from Jira Epics.

## 🚨 EXECUTION MODE: DIRECT AGENT INVOCATION

**DO NOT use Skill() tool or load external skills (ruflo-swarm, etc.)**

**REQUIRED**: Invoke lead-architect agent directly:

```javascript
Agent({
  description: "Build Ansible collection from Epic",
  prompt: "Build collection from Jira Epic <EPIC-KEY>. Args: <user-provided-args>",
  subagent_type: "agentic-workflows/ansible-collection-swarm:lead-architect"
})
```

**Why**: External skills add unnecessary overhead and permission prompts. Direct agent invocation is clean and autonomous.

---

## ⚙️ IMPORTANT: Permission Settings for Autonomous Operation

Claude Code will prompt for bash command permissions. **To enable true autonomy:**

**When prompted "Do you want to proceed?":**
```
› 1. Yes
  2. Yes, and don't ask again for: <command>  ← SELECT THIS!
  3. No
```

**Always select option 2** for these command types:
- `jira --version` → "Yes, and don't ask again for: jira *"
- `git` commands → "Yes, and don't ask again for: git *"  
- `find` commands → "Yes, and don't ask again for: find *"
- `which` commands → "Yes, and don't ask again for: which *"

**After 3-4 prompts** (selecting option 2 each time), the swarm will run fully autonomous with zero interruptions.

**Alternative**: If you have permission settings in Claude Code, set to "auto-approve" for bash commands.

## Quick Invocation

```
/ansible-collection-swarm EPIC-XXX
```

Or with more context:

```
/ansible-collection-swarm Build collection from EPIC-2345
/ansible-collection-swarm Enhance microsoft.scvmm with modules from EPIC-5678
/ansible-collection-swarm Add modules to existing collection at ~/projects/my-collection
```

## What Happens

When you invoke this skill, the **Lead Architect** agent is deployed to orchestrate the entire build process.

### Phase 0: Context Gathering (You answer 2-3 questions)

**Question 1: Test Environment**
```
Where should integration tests run?

Examples:
✅ 192.168.1.100, winrm, user: Administrator, pass: P@ss123
✅ ssh://test-server.lab.local:22, key: ~/.ssh/ansible_rsa
✅ network_cli://10.0.1.1, user: admin, pass: cisco123
✅ local (Azure API), subscription: abc-1234
✅ none (build code-only, skip tests)
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

**Question 3: Collection Location** (ONLY if enhancement mode detected but ambiguous)
```
Collection found in multiple locations. Which should I use?

Options:
A) Current directory (you're working in a cloned repo)
B) Swarm workspace (~/agentic-workflow-collections/...)
C) Custom path (specify your own location)
```

### Autonomous Execution (No further input needed)

**If NEW collection** (Full Build - 2-3 hours):
1. **Ingestion** → Analyzes Epic, extracts platform characteristics
2. **Foundation** → Creates collection structure
3. **Prerequisites** → Installs software on your test environment
4. **Build** → Implements all modules (parallel batches)
5. **QA** → Tests against your test environment
6. **Refactor** → Extracts shared code every 10 modules
7. **Delivery** → Commits locally or pushes to git
8. **CI/CD** → Fixes pipeline failures (if git delivery)
9. **Learning** → Captures knowledge for future builds

**If EXISTING collection** (Enhancement - 30-60 minutes):
1. Auto-detects collection location (current dir, swarm workspace, etc.)
2. Analyzes existing patterns from current modules
3. Implements new modules matching existing style
4. Runs regression tests (existing + new modules)
5. Incremental commit/push
6. CI/CD validation
7. Knowledge capture

## Intelligence Features

### Universal Platform Support
- ✅ Windows (PowerShell, WinRM)
- ✅ Linux (Python, SSH)
- ✅ Network devices (CLI)
- ✅ Cloud APIs (Azure, AWS, GCP)
- ✅ Custom applications (any API)
- ✅ **Platforms that don't exist yet!**

### How It Works

**NOT template-based** - The swarm:
1. **Researches** unfamiliar platforms
2. **Extracts characteristics** (REST API? PowerShell cmdlets? Network CLI?)
3. **Matches patterns** (5 generic patterns work everywhere)
4. **Adapts implementation** to your specific platform
5. **Learns** from each build to improve

### Multi-Location Detection (Enhancement Mode)

The swarm intelligently finds existing collections in:
1. **Current directory** (you're in a cloned repo)
2. **Swarm workspace** (`~/agentic-workflow-collections/<namespace>/<name>/`)
3. **Ansible collections path** (`~/.ansible/collections/...`)
4. **Custom path** (you specify in prompt)

**No manual file copying needed** - works in place!

### Self-Correction

- **3-attempt recovery** for any failure
- **Degraded environments** supported (partial test capability)
- **Resume capability** for blocked modules
- Only escalates if truly stuck

## Examples

### Example 1: New Windows Collection

```
User: /ansible-collection-swarm WINOPS-2345

System:
✅ Epic: WINOPS-2345 (SCVMM management modules)
🔍 Phase 0: NEW COLLECTION detected

Q1: Test environment?
User: 192.168.50.10, winrm, user: ansible, pass: Test123

Q2: Delivery target?
User: https://github.com/myorg/collections.git

[2.5 hours later]

Result:
✅ Collection: microsoft.scvmm
✅ 15 modules implemented and tested
✅ Pushed to: https://github.com/myorg/collections.git
✅ CI/CD: All checks passing
✅ Duration: 2h 28min
```

### Example 2: Enhance Existing Collection (Developer in Cloned Repo)

```
Developer setup:
$ cd ~/projects/ansible-collections/microsoft-scvmm/
$ git remote -v
origin  https://github.com/myusername/ansible-scvmm.git

User: /ansible-collection-swarm Add modules from EPIC-5678

System:
🔍 Scanning for existing collection...
✅ EXISTING COLLECTION DETECTED
📦 Collection: microsoft.scvmm
📁 Location: /Users/dev/projects/ansible-collections/microsoft-scvmm (current directory)
🔧 Mode: ENHANCEMENT

Q1: Test environment?
User: 192.168.1.100, winrm, user: ansible, pass: Test123

Q2: Delivery target?
User: https://github.com/myusername/ansible-scvmm.git

[No Q3 asked - clear single location match]

[45 minutes later]

Result:
✅ Collection enhanced: microsoft.scvmm
✅ Modules: 15 → 18
✅ New: scvmm_network, scvmm_virtual_network, scvmm_network_adapter
✅ All tests passing (new + regression)
✅ Committed to: current branch (ready for PR)
✅ Duration: 42 minutes

Next steps:
  git push origin HEAD
  Create PR to upstream
```

### Example 3: Unknown Platform (SolarWinds)

```
User: /ansible-collection-swarm MON-456 "Build SolarWinds Orion automation"

System:
✅ Epic: MON-456 (SolarWinds Orion monitoring)
🔍 Researching: "What is SolarWinds Orion?"
✅ Discovered: REST API (SWIS), Python SDK available
✅ Pattern matched: REST API pattern

Q1: Test environment?
User: local (SolarWinds API), server: 10.0.1.50

Q2: Delivery target?
User: git@gitlab.company.com:ansible/collections.git

[1.8 hours later]

Result:
✅ Collection: solarwinds.orion
✅ 8 modules implemented and tested
✅ Pushed to: git@gitlab.company.com:ansible/collections.git
✅ Pattern learned: REST API (SWIS) - added to knowledge base
✅ Duration: 1h 47min
```

## Direct Agent Access

If you need more control, invoke agents directly:

```javascript
// Via Agent tool
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from Jira Epic EPIC-XXX",
  subagent_type: "ansible-collection-swarm:lead-architect"
})

// Other agents (typically invoked by lead-architect)
Agent({
  description: "Enhance existing collection",
  subagent_type: "ansible-collection-swarm:enhancement-specialist",
  prompt: "Add modules from EPIC-5678 to existing collection at ~/projects/scvmm/"
})
```

## Available Agents

All agents namespaced as `ansible-collection-swarm:AGENT-NAME`:

- `lead-architect` - Chief orchestrator (primary entry point)
- `jira-ingestion-specialist` - Epic analyzer
- `foundation-specialist` - Workspace scaffolder
- `enhancement-specialist` - Collection enhancer
- `platform-prerequisite-specialist` - Environment setup
- `module-worker` - Module implementer
- `qa-coordinator` - Testing coordinator
- `refactor-specialist` - Code optimizer
- `release-specialist` - Delivery coordinator
- `ci-validation-specialist` - Pipeline monitor
- `learning-evolution-specialist` - Knowledge capture

## Patterns Available

5 generic patterns that work for ANY platform:

- `rest-api-pattern` - HTTP REST APIs
- `cli-based-pattern` - PowerShell cmdlets, shell commands, network CLI
- `config-file-pattern` - Configuration file management
- `database-pattern` - SQL/NoSQL operations
- `soap-api-pattern` - SOAP/WSDL APIs

## Success Criteria

- ✅ 100% autonomous after context questions
- ✅ Works for platforms you've never heard of
- ✅ Handles both new builds and enhancements
- ✅ Intelligent multi-location detection
- ✅ Self-correcting (3 attempts before escalation)
- ✅ Learns and improves over time

## Troubleshooting

### "Cannot find Epic"

**Check**: Jira credentials configured?
```bash
jira-rh issue EPIC-XXX  # Test manually
```

### "Cannot connect to test environment"

**Check**:
- Is host reachable? `ping <host>`
- Is service running? (WinRM, SSH)
- Are credentials correct?

### "Some modules blocked"

**Normal** if test environment partially unavailable.
- Review `docs/plans/blocked_modules.md`
- Fix environment issues
- Resume testing later

## Output Location

**New collections**:
```
~/agentic-workflow-collections/<namespace>/<name>/
```

**Enhanced collections**:
```
Wherever detected (current dir, swarm workspace, or custom path)
```

## Documentation

After using, check:
- `~/.claude/agents/ansible-collection-swarm/QUICKSTART.md`
- `~/.claude/agents/ansible-collection-swarm/GETTING-STARTED.md`
- `~/.claude/agents/ansible-collection-swarm/COLLECTION-DETECTION.md`

## Requirements

- **Jira** access (for Epic reading)
- **Test environment** (optional - can build code-only)
- **Git** repository (optional - can deliver locally)

---

**Version**: 1.0.0  
**Plugin**: ansible-collection-swarm  
**Primary Agent**: ansible-collection-swarm:lead-architect
