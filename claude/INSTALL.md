# Installation Guide - Hyaish Agents

Quick installation guide for the unified `agentic-workflows` plugin containing multiple swarms.

## Prerequisites

Before installing the plugin, ensure you have these CLI tools:

### Required Tools

**1. jira-rh or jira-cli** - Jira CLI for Epic reading
```bash
# Option 1: jira-rh (recommended - faster)
npm install -g jira-rh

# Option 2: jira-cli
brew install jira-cli  # Mac
# Or: https://github.com/ankitpokhrel/jira-cli

# Configure (one time)
jira-rh config  # Follow prompts for Jira URL + credentials
```

**2. gh** - GitHub CLI for automated PR creation
```bash
# Install
brew install gh          # Mac
sudo apt install gh      # Linux
# Or: https://cli.github.com/

# Authenticate (one time)
gh auth login
```

**3. git** - Standard git CLI
```bash
# Usually pre-installed
git --version

# If not:
brew install git         # Mac
sudo apt install git     # Linux
```

### Optional Tools

**ansible** - For local testing and validation
```bash
pip install ansible
```

**ansible-galaxy** - Usually comes with Ansible
```bash
ansible-galaxy --version
```

---

## For Your Team

### One-Line Install

```bash
cd ~/.claude/agents && git clone https://github.com/eco-ansible-content/agentic-workflows.git && ln -s agentic-workflows/claude agentic-workflows-plugin && cd agentic-workflows/claude && ./verify.sh
```

### Step-by-Step Install

```bash
# 1. Navigate to Claude agents directory
cd ~/.claude/agents

# 2. Clone the plugin
git clone https://github.com/eco-ansible-content/agentic-workflows.git

# 3. Create symlink for Claude to find the plugin
ln -s agentic-workflows/claude agentic-workflows-plugin

# 4. Verify installation
cd agentic-workflows/claude
./verify.sh
```

**Repository Structure**:
- `agentic-workflows/` - Git repository root (contains README.md, LICENSE)
- `agentic-workflows/claude/` - Actual Claude plugin files (agents, skills, etc.)
- `~/.claude/agents/agentic-workflows-plugin/` - Symlink that Claude Code uses

Expected output:
```
✅ Plugin ready to use!
Plugin infrastructure: 3/3
Ansible Collection Swarm: 17/17
Windows Collection Swarm: 14
```

### Via Plugin Registry (Future)

Once published to a plugin registry:

```bash
/plugin install agentic-workflows@eco-ansible-content
```

## What You Get

After installation, you have access to:

### 📦 Ansible Collection Swarm (Universal)

**Command**: `/ansible-collection-swarm EPIC-XXX`

**Namespace**: `agentic-workflows/ansible-collection-swarm:AGENT-NAME`

**11 Agents**:
- lead-architect
- jira-ingestion-specialist  
- foundation-specialist
- enhancement-specialist
- platform-prerequisite-specialist
- module-worker
- qa-coordinator
- refactor-specialist
- release-specialist
- ci-validation-specialist
- learning-evolution-specialist

**5 Patterns**:
- rest-api-pattern
- cli-based-pattern
- config-file-pattern
- database-pattern
- soap-api-pattern

### 📦 Windows Collection Swarm (Legacy)

**Command**: `/windows-collection-swarm EPIC-XXX`

**Namespace**: `agentic-workflows/windows-collection-swarm:AGENT-NAME`

**13 Agents**: Windows-specific implementation

## Usage

### Universal Swarm (Recommended)

```bash
# Slash command (easiest)
/ansible-collection-swarm EPIC-2345

# Agent tool
Agent({
  description: "Build collection",
  prompt: "Build collection from EPIC-2345",
  subagent_type: "agentic-workflows/ansible-collection-swarm:lead-architect"
})

# Enhance existing collection
/ansible-collection-swarm Enhance microsoft.scvmm from EPIC-5678
```

### Windows Swarm (Legacy)

```bash
# For Windows-only projects
/windows-collection-swarm EPIC-2345

# Agent tool
Agent({
  description: "Build Windows collection",
  prompt: "Build collection from EPIC-2345",
  subagent_type: "agentic-workflows/windows-collection-swarm:lead-architect"
})
```

## Directory Structure After Installation

```
~/.claude/agents/agentic-workflows/
├── .claude-plugin/
│   └── plugin.json                      # Plugin manifest
├── package.json                          # NPM + Claude metadata
├── README.md                             # Plugin overview
├── INSTALL.md                            # This file
├── verify.sh                             # Verification script
│
├── ansible-collection-swarm/             # Universal swarm
│   ├── core/agents/                      # 11 agents
│   ├── knowledge/patterns/               # 5 patterns
│   ├── skills/                           # Slash command
│   └── [documentation]
│
└── windows-collection-swarm/             # Legacy swarm
    ├── agents/                           # 13 agents
    └── [documentation]
```

## Verification

```bash
cd ~/.claude/agents/agentic-workflows
./verify.sh
```

Should show:
- ✅ Plugin infrastructure: 3/3
- ✅ Ansible Collection Swarm: 17/17
- ✅ Windows Collection Swarm: [count]

## Documentation

### Plugin Level

- `README.md` - Plugin overview and swarm comparison
- `INSTALL.md` - This file
- `PUBLISH.md` - Publishing guide (for maintainers)

### Universal Swarm

- `ansible-collection-swarm/QUICKSTART.md` - Quick start guide
- `ansible-collection-swarm/GETTING-STARTED.md` - Comprehensive guide
- `ansible-collection-swarm/README.md` - Architecture
- `ansible-collection-swarm/AGENTS.md` - Agent registry
- `ansible-collection-swarm/COLLECTION-DETECTION.md` - Enhancement mode

### Windows Swarm

- `windows-collection-swarm/README.md` - Overview
- `windows-collection-swarm/QUICKREF.md` - Quick reference

## Updates

```bash
cd ~/.claude/agents/agentic-workflows
git pull origin main
./verify.sh
```

## Troubleshooting

### "Command not found: /ansible-collection-swarm"

**Check**: Is plugin directory correct?
```bash
ls ~/.claude/agents/agentic-workflows/ansible-collection-swarm/skills/
```

Should see: `ansible-collection-swarm.md`

### "Agent not found"

**Check**: Using correct namespace?
```javascript
// ✅ Correct
subagent_type: "agentic-workflows/ansible-collection-swarm:lead-architect"

// ❌ Wrong
subagent_type: "ansible-collection-swarm:lead-architect"  // Missing agentic-workflows/
```

### Verification Fails

```bash
# Reinstall
cd ~/.claude/agents
rm -rf agentic-workflows
git clone https://github.com/eco-ansible-content/agentic-workflows.git
cd agentic-workflows
./verify.sh
```

## Uninstall

```bash
rm -rf ~/.claude/agents/agentic-workflows
```

**Note**: Collections created by the swarms remain in `~/agentic-workflow-collections/`

## Requirements

- **Claude Code** (CLI, desktop, or web)
- **Jira** access (for Epic reading)
- **Test environment** (optional - can build code-only)
- **Git repository** (optional - can deliver locally)

## Support

- **Issues**: https://github.com/eco-ansible-content/agentic-workflows/issues
- **Discussions**: https://github.com/eco-ansible-content/agentic-workflows/discussions
- **Documentation**: See swarm-specific READMEs

---

**Quick Start**: Run `/ansible-collection-swarm EPIC-XXX` to build your first collection!
