# Getting Started with Hyaish Agents

Welcome! This guide will help you install and use Hyaish Agents to build your first Ansible collection in under 10 minutes.

## Prerequisites

Before you begin, make sure you have:

1. **Claude Code** installed (CLI, desktop app, or web)
2. **jira-rh** or **jira-cli** for reading Jira Epics:
   ```bash
   npm install -g jira-rh
   # OR
   brew install jira-cli
   ```

3. **GitHub CLI** (for automated PR creation):
   ```bash
   brew install gh         # macOS
   # OR
   sudo apt install gh     # Linux
   
   # Then authenticate:
   gh auth login
   ```

4. **Git** (usually pre-installed)

## Installation

### One-Line Install (Recommended)

```bash
cd ~/.claude/agents && git clone https://github.com/eco-ansible-content/agentic-workflows.git && bash agentic-workflows/install.sh
```

The installer will:
- ✅ Check prerequisites
- ✅ Install the plugin to `~/.claude/plugins/cache/local/agentic-workflows/`
- ✅ Configure zero-permission autonomy
- ✅ Register agents and skills
- ✅ Verify installation

### Verify Installation

```bash
cd ~/.claude/agents/agentic-workflows
bash install.sh
```

Expected output:
```
✅ Plugin ready to use!
Plugin infrastructure: 3/3
Ansible Collection Swarm: 17/17
```

## Your First Collection (5 Minutes)

### Scenario: Build an Ansible Collection from a Jira Epic

**Prerequisites**:
- A Jira Epic with module specifications (e.g., `EPIC-2345`)
- A test environment (Windows/Linux server) OR build code-only
- A Git repository URL (optional - can deliver locally)

### Step 1: Invoke the Swarm

In Claude Code, run:

```bash
/ansible-collection-swarm EPIC-2345
```

### Step 2: Answer 2-3 Questions

The swarm will ask you:

**Q1: Test Environment?**
```
Example answers:
- "192.168.50.10, winrm, user: ansible, pass: Test123"
- "localhost, ssh, user: ansible"
- "None - code-only build"
```

**Q2: Delivery Target?**
```
Example answers:
- "https://github.com/myorg/collections.git"
- "local" (no remote push)
```

**Q3: Collection Location?** (Only if enhancing existing collection)
```
Example: "/Users/me/projects/ansible-collections/my-collection"
```

### Step 3: Sit Back and Watch

The swarm will:
1. ✅ Read the Jira Epic
2. ✅ Extract platform characteristics
3. ✅ Research patterns for the platform
4. ✅ Build the collection structure
5. ✅ Implement all modules
6. ✅ Run integration tests
7. ✅ Create PR (if enhancing existing collection)
8. ✅ Deliver to Git repository

**Time**: 30 minutes - 3 hours (depending on collection size)

## Usage Modes

### Mode 1: Full Build (New Collection)

Build a brand new collection from scratch:

```bash
/ansible-collection-swarm WINOPS-2345
```

**Result**:
- New collection created in `~/agentic-workflow-collections/`
- All modules implemented and tested
- Ready to push to Git

### Mode 2: Enhancement (Existing Collection)

Add modules to an existing collection:

```bash
cd ~/projects/ansible-collections/microsoft-scvmm/
/ansible-collection-swarm "Add modules from EPIC-5678"
```

**Result**:
- New modules added to existing collection
- All tests passing (new + regression)
- PR created automatically
- Fork-PR workflow with CI validation

## What Happens During a Build?

The swarm executes **11 specialized agents** in phases:

```
Phase 0: Context Gathering
  → Lead Architect asks you questions

Phase 1: Ingestion
  → Jira Ingestion Specialist reads Epic
  → Extracts platform characteristics (NOT platform name)

Phase 2: Foundation (Full Build only)
  → Foundation Specialist creates collection structure

Phase 3: Enhancement (Enhancement mode)
  → Enhancement Specialist adds modules to existing collection

Phase 4: Prerequisites
  → Platform Prerequisite Specialist sets up environment

Phase 5: Module Implementation
  → Module Worker implements each module (parallel)
  → Researches platform, finds patterns, adapts code

Phase 6: Testing
  → QA Coordinator runs integration tests
  → 4-stage testing (check mode, present, idempotency, absent)

Phase 7: Refactoring (every 10 modules)
  → Refactor Specialist extracts utilities

Phase 8: Delivery
  → Release Specialist creates PR or pushes to Git

Phase 9: CI Validation (Fork-PR mode)
  → CI Validation Specialist monitors and fixes CI failures

Phase 10: Learning
  → Learning Evolution Specialist captures insights
```

## Common Scenarios

### Scenario 1: Unknown Platform

**Question**: "What if the swarm has never seen my platform before?"

**Answer**: It researches! The swarm learns ANY platform through:
1. Web research (documentation, API specs)
2. Pattern recognition (REST API? CLI? Config files?)
3. Adaptation (uses generic patterns, customizes for your platform)

**Example**:
```bash
/ansible-collection-swarm "Build SolarWinds Orion collection from SOLAR-123"
```

The swarm will:
- Research: "What is SolarWinds Orion?"
- Discover: REST API (SWIS protocol)
- Apply: REST API pattern
- Implement: All modules using discovered API

### Scenario 2: Enhancement with CI Failures

**Question**: "What if my PR fails CI checks?"

**Answer**: The CI Validation Specialist automatically:
1. Monitors PR checks via GitHub API
2. Extracts build logs from Azure Pipelines
3. Analyzes failures
4. Creates focused fixes
5. Pushes as separate commits
6. Repeats until all green

**No manual intervention needed!**

### Scenario 3: No Test Environment

**Question**: "Can I build without a test environment?"

**Answer**: Yes! The swarm will:
- Build all code
- Skip integration tests
- Deliver code-only collection
- You can test later manually

Just answer "None" when asked for test environment.

## Troubleshooting

### Installation Issues

**Problem**: Plugin not found after install

**Solution**:
```bash
# Reinstall
cd ~/.claude/agents/agentic-workflows
bash install.sh

# Verify
ls -la ~/.claude/plugins/cache/local/agentic-workflows/
```

**Problem**: Prerequisites missing

**Solution**:
```bash
# Install jira-rh
npm install -g jira-rh

# Install gh
brew install gh
gh auth login

# Verify
jira-rh --version
gh --version
```

### Runtime Issues

**Problem**: Swarm doesn't find my cloned collection

**Solution**: Make sure you're IN the collection directory:
```bash
cd ~/projects/ansible-collections/my-collection/
/ansible-collection-swarm "Add modules from EPIC-123"
```

**Problem**: Test environment connection fails

**Solution**: Test connectivity manually first:
```bash
ansible all -i "192.168.50.10," -m win_ping -e ansible_user=ansible -e ansible_password=Test123 -e ansible_connection=winrm
```

## Next Steps

- **Read detailed guide**: [claude/ansible-collection-swarm/GETTING-STARTED.md](claude/ansible-collection-swarm/GETTING-STARTED.md)
- **Understand workflows**: [docs/git-workflows.md](docs/git-workflows.md)
- **Marketplace setup**: [docs/marketplace.md](docs/marketplace.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)

## Support

- **Issues**: [GitHub Issues](https://github.com/eco-ansible-content/agentic-workflows/issues)
- **Discussions**: [GitHub Discussions](https://github.com/eco-ansible-content/agentic-workflows/discussions)

---

**Ready to build your first collection?**

```bash
/ansible-collection-swarm YOUR-EPIC-KEY
```

Let the swarm do the work! ✨
