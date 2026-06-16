# Installation Guide

The Universal Ansible Collection Swarm is already installed if you can see this file in `~/.claude/agents/ansible-collection-swarm/`!

## Verify Installation

```bash
# Check swarm directory exists
ls ~/.claude/agents/ansible-collection-swarm/

# List available agents
ls ~/.claude/agents/ansible-collection-swarm/core/agents/
```

Expected output:
```
ci-validation-specialist.md
enhancement-specialist.md
foundation-specialist.md
jira-ingestion-specialist.md
lead-architect.md
learning-evolution-specialist.md
module-worker.md
platform-prerequisite-specialist.md
qa-coordinator.md
refactor-specialist.md
release-specialist.md
```

## Usage Methods

### Method 1: Agent Tool (Recommended - from Claude Code)

```javascript
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from Jira Epic EPIC-XXX",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

**Note**: The `ansible-collection-swarm:` prefix tells Claude Code to look in `~/.claude/agents/ansible-collection-swarm/core/agents/`

### Method 2: Direct File Path

```bash
claude-code --agent ~/.claude/agents/ansible-collection-swarm/core/agents/lead-architect.md \
  "Build collection from EPIC-XXX"
```

### Method 3: From Current Directory

```bash
cd ~/.claude/agents/ansible-collection-swarm
claude-code --agent core/agents/lead-architect.md "Build collection from EPIC-XXX"
```

## Installation for Others

If you want to share this swarm with others or install it on a different machine:

### Option 1: Git Clone (Recommended)

```bash
# Clone to Claude agents directory
cd ~/.claude/agents
git clone <your-repo-url> ansible-collection-swarm

# Verify
ls ansible-collection-swarm/core/agents/
```

### Option 2: Manual Download

```bash
# Create directory
mkdir -p ~/.claude/agents/ansible-collection-swarm

# Copy files
cp -r /path/to/swarm/* ~/.claude/agents/ansible-collection-swarm/

# Verify
ls ~/.claude/agents/ansible-collection-swarm/core/agents/
```

### Option 3: Symlink from Development Directory

If you're developing the swarm elsewhere and want to link it:

```bash
# Remove existing directory (if present)
rm -rf ~/.claude/agents/ansible-collection-swarm

# Create symlink to your development directory
ln -s /path/to/your/dev/ansible-collection-swarm ~/.claude/agents/ansible-collection-swarm

# Verify symlink
ls -la ~/.claude/agents/ | grep ansible-collection-swarm
```

## Publishing to Claude Plugin Marketplace (Future)

To make this installable like Superpowers:

### 1. Create Plugin Manifest

Create `~/.claude/agents/ansible-collection-swarm/plugin.json`:

```json
{
  "name": "ansible-collection-swarm",
  "version": "1.0.0",
  "description": "Universal Ansible Collection Swarm - Build ANY collection intelligently",
  "author": "Your Name",
  "agents": {
    "lead-architect": "core/agents/lead-architect.md",
    "jira-ingestion-specialist": "core/agents/jira-ingestion-specialist.md",
    "foundation-specialist": "core/agents/foundation-specialist.md",
    "enhancement-specialist": "core/agents/enhancement-specialist.md",
    "platform-prerequisite-specialist": "core/agents/platform-prerequisite-specialist.md",
    "module-worker": "core/agents/module-worker.md",
    "qa-coordinator": "core/agents/qa-coordinator.md",
    "refactor-specialist": "core/agents/refactor-specialist.md",
    "release-specialist": "core/agents/release-specialist.md",
    "ci-validation-specialist": "core/agents/ci-validation-specialist.md",
    "learning-evolution-specialist": "core/agents/learning-evolution-specialist.md"
  },
  "patterns": {
    "rest-api": "knowledge/patterns/rest-api-pattern.md",
    "cli-based": "knowledge/patterns/cli-based-pattern.md",
    "config-file": "knowledge/patterns/config-file-pattern.md",
    "database": "knowledge/patterns/database-pattern.md",
    "soap-api": "knowledge/patterns/soap-api-pattern.md"
  },
  "repository": "https://github.com/your-username/ansible-collection-swarm",
  "license": "MIT"
}
```

### 2. Publish to GitHub

```bash
cd ~/.claude/agents/ansible-collection-swarm
git init
git add .
git commit -m "Initial release v1.0.0"
git tag v1.0.0
git remote add origin https://github.com/your-username/ansible-collection-swarm.git
git push -u origin main --tags
```

### 3. Users Install Via

```bash
# Future: Once published to marketplace
claude-code plugin install ansible-collection-swarm

# Current: Via git clone
cd ~/.claude/agents
git clone https://github.com/your-username/ansible-collection-swarm.git
```

## Updating the Swarm

### If Installed via Git

```bash
cd ~/.claude/agents/ansible-collection-swarm
git pull origin main
```

### If Installed Manually

Re-download and overwrite files, or use the install script.

## Troubleshooting

### "Agent not found" Error

**Check 1**: Verify swarm directory exists
```bash
ls ~/.claude/agents/ansible-collection-swarm/core/agents/
```

**Check 2**: Verify agent file exists
```bash
ls ~/.claude/agents/ansible-collection-swarm/core/agents/lead-architect.md
```

**Check 3**: Use correct namespace
```javascript
// ✅ Correct
subagent_type: "ansible-collection-swarm:lead-architect"

// ❌ Wrong
subagent_type: "lead-architect"  // Missing namespace
```

### "Permission denied" Error

Make agent files readable:
```bash
chmod -R 755 ~/.claude/agents/ansible-collection-swarm/
```

### Symlink Issues

If using symlink and having issues:
```bash
# Check symlink
ls -la ~/.claude/agents/ | grep ansible

# Recreate symlink
rm ~/.claude/agents/ansible-collection-swarm
ln -s /path/to/actual/location ~/.claude/agents/ansible-collection-swarm
```

## Uninstallation

```bash
# Remove swarm
rm -rf ~/.claude/agents/ansible-collection-swarm

# If using symlink
unlink ~/.claude/agents/ansible-collection-swarm
```

**Note**: This does NOT remove collections created by the swarm (in `~/agentic-workflow-collections/`)

## Directory Structure After Installation

```
~/.claude/agents/ansible-collection-swarm/
├── INSTALLATION.md          # This file
├── README.md               # Architecture overview
├── QUICKSTART.md           # Quick start guide
├── GETTING-STARTED.md      # Comprehensive guide
├── AGENTS.md              # Agent registry
├── core/
│   ├── agents/            # 11 agent definitions
│   └── templates/         # Collection templates
├── knowledge/
│   ├── patterns/          # 5 generic patterns
│   └── examples/          # Code examples
└── resources/
    └── *.md              # Guides and references
```

## Next Steps

1. **Read**: `QUICKSTART.md` for quick start
2. **Test**: Build a collection from a real Epic
3. **Learn**: Review `GETTING-STARTED.md` for all features
4. **Customize**: Modify agents in `core/agents/` if needed

## Support

- **Documentation**: See all `*.md` files in swarm directory
- **Agent Details**: Check `AGENTS.md` for complete registry
- **Patterns**: Review `knowledge/patterns/` for implementation patterns
- **Examples**: Check `resources/` for usage examples

---

**Current Location**: `~/.claude/agents/ansible-collection-swarm/`  
**Version**: 1.0.0  
**Status**: ✅ Ready to use
