# Team Installation Guide

Quick guide for your team to install the Ansible Collection Swarm plugin.

## Installation Methods

### Method 1: Git Clone (Recommended)

```bash
# Install
cd ~/.claude/agents
git clone https://github.com/YOUR-USERNAME/ansible-collection-swarm.git

# Verify
cd ansible-collection-swarm
./verify.sh
```

Expected output: `✅ Installation complete and verified! Overall: 25/25 components`

### Method 2: Plugin Registry (Once Published)

```bash
# Private registry
/plugin install ansible-collection-swarm@YOUR-ORG

# Public registry
/plugin install ansible-collection-swarm@claude-plugins-official
```

## Usage

### Quick Invocation

```
/ansible-collection-swarm EPIC-XXX
```

### With Context

```
/ansible-collection-swarm Build collection from EPIC-2345
/ansible-collection-swarm Enhance microsoft.scvmm with modules from EPIC-5678
```

### Via Agent Tool

```javascript
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from Jira Epic EPIC-XXX",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

## What to Expect

### Phase 0: You Answer 2-3 Questions

**Q1: Test Environment**
```
Where should integration tests run?

Examples:
✅ 192.168.1.100, winrm, user: Administrator, pass: P@ss123
✅ ssh://server.lab.local:22, key: ~/.ssh/ansible_rsa
✅ network_cli://10.0.1.1, user: admin, pass: cisco123
✅ local (Azure API), subscription: abc-1234
✅ none (build code-only)
```

**Q2: Delivery Target**
```
Where should the completed collection go?

✅ Local only
✅ https://github.com/myorg/collections.git
```

**Q3: Collection Location** (only if ambiguous)
```
Multiple locations found. Which should I use?

A) Current directory
B) Swarm workspace
C) Custom path
```

### Then Fully Autonomous

The swarm handles everything:
1. Analyzes Jira Epic
2. Creates or enhances collection
3. Implements modules
4. Tests everything
5. Delivers to git or local

**Duration**: 30 minutes (enhancement) to 3 hours (full build)

## Features

✅ **Universal** - Works for ANY platform (Windows, Linux, Cloud, Network, Custom)  
✅ **Intelligent** - Learns unfamiliar platforms through research  
✅ **Dual-Mode** - Full build (new) or enhancement (existing)  
✅ **Autonomous** - 100% hands-off after questions  
✅ **Self-Correcting** - 3 attempts before escalation  
✅ **Smart Detection** - Finds collections in current dir, swarm workspace, etc.

## Documentation

After installation, check:

```bash
cd ~/.claude/agents/ansible-collection-swarm

# Quick start
cat QUICKSTART.md

# Comprehensive guide
cat GETTING-STARTED.md

# Agent list
cat AGENTS.md

# How detection works
cat COLLECTION-DETECTION.md
```

## Troubleshooting

### "Command not found: /ansible-collection-swarm"

**Check**: Plugin installed?
```bash
ls ~/.claude/agents/ansible-collection-swarm/
```

If missing, reinstall using Method 1.

### "Agent not found: ansible-collection-swarm:lead-architect"

**Check**: Verify installation
```bash
cd ~/.claude/agents/ansible-collection-swarm
./verify.sh
```

Should show: `25/25 components`

### "Cannot connect to Jira"

**Check**: Jira credentials configured?
```bash
jira-rh issue EPIC-XXX  # Test manually
```

## Support

- **Documentation**: All `*.md` files in `~/.claude/agents/ansible-collection-swarm/`
- **Issues**: https://github.com/YOUR-USERNAME/ansible-collection-swarm/issues
- **Team Slack**: #ansible-automation channel

## Examples

### Example 1: Build Windows Collection

```bash
/ansible-collection-swarm WINOPS-2345

# You answer:
# Q1: 192.168.50.10, winrm, user: ansible, pass: Test123
# Q2: https://github.com/myorg/collections.git

# Result (2.5 hours later):
✅ Collection: microsoft.scvmm
✅ 15 modules implemented and tested
✅ Pushed to GitHub
✅ CI/CD passing
```

### Example 2: Enhance Existing Collection

```bash
cd ~/projects/ansible-collections/microsoft-scvmm/

/ansible-collection-swarm Add modules from EPIC-5678

# You answer:
# Q1: 192.168.1.100, winrm, user: ansible, pass: Test123
# Q2: https://github.com/myusername/ansible-scvmm.git

# Result (45 minutes later):
✅ Modules: 15 → 18
✅ All tests passing
✅ Ready for PR
```

## Updates

```bash
cd ~/.claude/agents/ansible-collection-swarm
git pull origin main
./verify.sh
```

## Uninstall

```bash
rm -rf ~/.claude/agents/ansible-collection-swarm
```

**Note**: Collections created by the swarm remain in `~/agentic-workflow-collections/`

---

**Version**: 1.0.0  
**Maintainer**: Your Name <your.email@example.com>  
**Repository**: https://github.com/YOUR-USERNAME/ansible-collection-swarm
