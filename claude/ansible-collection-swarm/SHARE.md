# Share & Install Guide

## For Users: Installing the Swarm

### Quick Install (Recommended)

```bash
# 1. Clone to Claude agents directory
cd ~/.claude/agents
git clone <your-repo-url> ansible-collection-swarm

# 2. Verify installation
cd ansible-collection-swarm
./verify.sh
```

Expected output:
```
✅ Installation complete and verified!
Overall: 22/22 components
```

### Manual Install

```bash
# 1. Create directory
mkdir -p ~/.claude/agents/ansible-collection-swarm

# 2. Download and extract files to that directory
# (or copy from source)

# 3. Verify
cd ~/.claude/agents/ansible-collection-swarm
./verify.sh
```

### Verify It Works

From Claude Code, test the agent:

```javascript
Agent({
  description: "Test swarm installation",
  prompt: "List all available agents in the swarm",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

---

## For Developers: Sharing the Swarm

### Option 1: GitHub Repository (Recommended)

**Setup**:
```bash
cd ~/.claude/agents/ansible-collection-swarm

# Initialize git (if not already)
git init

# Add files
git add .

# Commit
git commit -m "Initial release: Universal Ansible Collection Swarm v1.0.0"

# Create repository on GitHub, then:
git remote add origin https://github.com/YOUR-USERNAME/ansible-collection-swarm.git
git branch -M main
git push -u origin main

# Tag version
git tag v1.0.0
git push origin v1.0.0
```

**Share with users**:
```bash
# Users install via:
cd ~/.claude/agents
git clone https://github.com/YOUR-USERNAME/ansible-collection-swarm.git
cd ansible-collection-swarm
./verify.sh
```

---

### Option 2: Tarball

**Create archive**:
```bash
cd ~/.claude/agents
tar -czf ansible-collection-swarm-v1.0.0.tar.gz ansible-collection-swarm/
```

**Share with users**:
```bash
# Users install via:
cd ~/.claude/agents
curl -L https://your-site.com/ansible-collection-swarm-v1.0.0.tar.gz | tar xz
cd ansible-collection-swarm
./verify.sh
```

---

### Option 3: Direct Copy

**For local/internal sharing**:
```bash
# Copy to shared location
cp -r ~/.claude/agents/ansible-collection-swarm /shared/location/

# Users install via:
cp -r /shared/location/ansible-collection-swarm ~/.claude/agents/
cd ~/.claude/agents/ansible-collection-swarm
./verify.sh
```

---

## Directory Structure (What Gets Installed)

```
~/.claude/agents/ansible-collection-swarm/
├── README.md                      # Architecture overview
├── QUICKSTART.md                  # Quick start guide
├── GETTING-STARTED.md             # Comprehensive guide
├── INSTALLATION.md                # Installation instructions
├── AGENTS.md                      # Agent registry
├── COLLECTION-DETECTION.md        # Detection system docs
├── ENHANCEMENT-DETECTION-SUMMARY.md  # Enhancement mode docs
├── MANIFEST.md                    # File listing
├── STATUS.md                      # System status
├── FINAL-SUMMARY.md               # Complete summary
├── verify.sh                      # Verification script
├── install.sh                     # Installation helper
├── core/
│   ├── agents/                    # 11 agent definitions (.md)
│   │   ├── lead-architect.md
│   │   ├── jira-ingestion-specialist.md
│   │   ├── foundation-specialist.md
│   │   ├── enhancement-specialist.md
│   │   ├── platform-prerequisite-specialist.md
│   │   ├── module-worker.md
│   │   ├── qa-coordinator.md
│   │   ├── refactor-specialist.md
│   │   ├── release-specialist.md
│   │   ├── ci-validation-specialist.md
│   │   └── learning-evolution-specialist.md
│   └── templates/                 # Collection templates
│       └── collection_template/
├── knowledge/
│   ├── patterns/                  # 5 generic patterns
│   │   ├── rest-api-pattern.md
│   │   ├── cli-based-pattern.md
│   │   ├── config-file-pattern.md
│   │   ├── database-pattern.md
│   │   └── soap-api-pattern.md
│   └── examples/                  # Code examples (.py, .yml)
├── resources/                     # Guides and references
│   ├── characteristic-extraction.md
│   ├── pattern-recognition-guide.md
│   └── project-context-examples.md
└── docs/
    └── lessons_learned.md         # Learning database template
```

**Total**: ~40 files, ~250KB

---

## Usage After Installation

### Method 1: Agent Tool (From Claude Code)

```javascript
// Build new collection
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from Jira Epic EPIC-2345",
  subagent_type: "ansible-collection-swarm:lead-architect"
})

// Enhance existing collection
Agent({
  description: "Add modules to collection",
  prompt: "Add modules from EPIC-5678 to microsoft.scvmm",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

### Method 2: Direct Command

```bash
claude-code --agent ~/.claude/agents/ansible-collection-swarm/core/agents/lead-architect.md \
  "Build collection from EPIC-XXX"
```

---

## Documentation

After installation, read:

1. **QUICKSTART.md** - Get started in 5 minutes
2. **GETTING-STARTED.md** - Comprehensive usage guide
3. **AGENTS.md** - Complete agent registry
4. **COLLECTION-DETECTION.md** - How enhancement detection works

---

## For Package Maintainers

### Creating a Plugin Package (Future)

**plugin.json**:
```json
{
  "name": "ansible-collection-swarm",
  "version": "1.0.0",
  "description": "Universal Ansible Collection Swarm - Build ANY collection intelligently",
  "author": "Your Name",
  "repository": "https://github.com/your-username/ansible-collection-swarm",
  "license": "MIT",
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
  }
}
```

---

## Support

**For installers**:
- Run `./verify.sh` to check installation
- Read `INSTALLATION.md` for troubleshooting
- Check `AGENTS.md` for agent list

**For users**:
- Read `QUICKSTART.md` for quick start
- Read `GETTING-STARTED.md` for full guide
- Check `COLLECTION-DETECTION.md` for enhancement mode

---

## Updates

### For Git Installation

```bash
cd ~/.claude/agents/ansible-collection-swarm
git pull origin main
./verify.sh
```

### For Manual Installation

Re-download and overwrite files, then verify:
```bash
./verify.sh
```

---

## Uninstall

```bash
# Remove swarm
rm -rf ~/.claude/agents/ansible-collection-swarm

# Collections created by the swarm remain at:
# ~/agentic-workflow-collections/
```

---

## Requirements

- **Claude Code** (CLI, desktop, or web)
- **Jira** access (for Epic reading)
- **Test environment** (optional - can build code-only)
- **Git** repository (optional - can deliver locally)

---

## Features

✅ **Universal Platform Support** - Windows, Linux, Azure, AWS, Cisco, VMware, custom apps, unknown platforms  
✅ **Intelligence-Based** - Learns patterns, doesn't use templates  
✅ **Dual-Mode** - Full Build (new) or Enhancement (existing)  
✅ **Multi-Location Detection** - Works with cloned repos, swarm workspace, ansible_collections  
✅ **Context-Aware** - Uses YOUR test environment and delivery target  
✅ **100% Autonomous** - After 2-3 questions, fully hands-off  
✅ **Self-Correcting** - 3-attempt recovery strategy  
✅ **Continuous Learning** - Gets smarter over time  

---

**Version**: 1.0.0  
**License**: MIT  
**Repository**: <your-repo-url>
