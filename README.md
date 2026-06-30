# Agentic Workflows

**Unified Claude Code plugin containing intelligent agent swarms for automation across platforms**

Build Ansible collections, Kubernetes operators, Terraform modules, and more with 100% autonomous AI-powered multi-agent systems.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 What is This?

A collection of intelligent agent swarms that autonomously build, enhance, and maintain infrastructure code. Each swarm is a specialized multi-agent system designed for specific automation tasks.

**Key Features**:
- ✅ **100% Autonomous** - Answer 2-3 questions, then fully hands-off
- ✅ **Universal Platform Support** - Learns ANY platform through research, not templates
- ✅ **Multi-Mode Operation** - Create new or enhance existing projects
- ✅ **Self-Correcting** - 3-attempt recovery, degraded environment support
- ✅ **Continuous Learning** - Gets smarter with each use

## 📦 Available Swarms

### Ansible Collection Swarm (Universal)

**Build ANY Ansible collection from Jira Tasks, Epics, or ANSTRATs**

Works for platforms you've never heard of! Windows, Linux, Cloud APIs, Network devices, Custom applications - learns through intelligent research.

**Flexible scope**:
- **Single Task** → Build one module
- **Epic** → Build all modules in the Epic
- **ANSTRAT** → Build all modules across all Epics

- **11 Specialized Agents** - Orchestrated by Lead Architect
- **5 Generic Patterns** - Adapt to any platform
- **Dual Mode** - Full Build (new collections) or Enhancement (existing)
- **Smart Detection** - Works in cloned repos, finds collections anywhere

**Documentation**: [claude/ansible-collection-swarm/](claude/ansible-collection-swarm/)

---

### Windows Collection Swarm (Legacy)

**Windows-specific Ansible collection builder**

Template-based approach for Windows Server environments (SCVMM, Hyper-V, Exchange).

- **13 Specialized Agents**
- **Proven Patterns** - Battle-tested for Windows environments
- **Status**: Maintained but not actively developed

**Note**: Use Universal Swarm for new Windows projects - it works for Windows AND everything else!

**Documentation**: [claude/windows-collection-swarm/](claude/windows-collection-swarm/)

---

### Future Swarms (Planned)

- **Kubernetes Operator Swarm** - Build K8s operators
- **Terraform Module Swarm** - Build Terraform modules  
- **API Integration Swarm** - Build API clients
- **Documentation Swarm** - Generate comprehensive docs
- **Testing Swarm** - Create test suites

## 🚀 Quick Start

### Installation

**Plugin Marketplace** (Recommended):
```bash
# Step 1: Add marketplace (one time)
/plugin marketplace add eco-ansible-content/agentic-workflows

# Step 2: Install plugin
/plugin install agentic-workflows@agentic-workflows
```

Then restart Claude Code. That's it! ✅

**Alternative - Manual Script** (if marketplace doesn't work):
```bash
cd ~/.claude/agents && \
git clone https://github.com/eco-ansible-content/agentic-workflows.git && \
cd agentic-workflows && \
bash install.sh
```

**Note**: Marketplace installation is simpler and more reliable. Use the manual script only for troubleshooting.

See [docs/marketplace.md](docs/marketplace.md) for details on plugin marketplace setup.

### Updating

**Via Marketplace** (Recommended):
```bash
/plugin update agentic-workflows@agentic-workflows
```

Then restart Claude Code.

**Alternative - Manual Script:**
```bash
cd ~/.claude/agents/agentic-workflows && git pull origin main && bash install.sh
```

### Uninstalling

**Via Marketplace:**
```bash
/plugin uninstall agentic-workflows@agentic-workflows
```

**Or via uninstall script:**
```bash
cd ~/.claude/agents/agentic-workflows && bash uninstall.sh
```

Then restart Claude Code.

### Usage

**Slash Command** (Recommended):
```bash
# Universal swarm - works for ANY platform, any scope
/ansible-collection-swarm TASK-XXX      # Single module
/ansible-collection-swarm EPIC-XXX      # All modules in Epic
/ansible-collection-swarm ANSTRAT-XXX   # All modules across all Epics

# Windows swarm - legacy
/windows-collection-swarm EPIC-XXX
```

**Agent Tool**:
```javascript
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from Jira ticket TASK-1234",  // or EPIC-XXX or ANSTRAT-XXX
  subagent_type: "agentic-workflows/ansible-collection-swarm:lead-architect"
})
```

## 📖 Documentation

- **[Getting Started](GETTING-STARTED.md)** - Start here! Build your first collection in 10 minutes
- **[Installation Guide](claude/INSTALL.md)** - Detailed installation options
- **[Quick Start (Universal Swarm)](claude/ansible-collection-swarm/QUICKSTART.md)** - 5-minute quick reference
- **[Comprehensive Guide](claude/ansible-collection-swarm/GETTING-STARTED.md)** - Deep dive into all features
- **[Publishing Guide](claude/PUBLISH.md)** - How to publish this plugin

## 🎓 Real-World Examples

### Example 1: Build Windows SCVMM Collection

```bash
/ansible-collection-swarm WINOPS-2345

# You answer:
# Q1: Test environment? → 192.168.50.10, winrm, user: ansible, pass: Test123
# Q2: Delivery? → https://github.com/myorg/collections.git

# Result (2.5 hours later):
✅ Collection: microsoft.scvmm
✅ 15 modules implemented and tested
✅ Pushed to GitHub
✅ CI/CD passing
```

### Example 2: Build Single Module

```bash
/ansible-collection-swarm WINOPS-1234

# Single task ticket for one module
# Result (30 minutes later):
✅ Module: scvmm_vm_snapshot
✅ Tests passing
✅ Pushed to GitHub
```

### Example 3: Enhance Existing Collection

```bash
cd ~/projects/ansible-collections/microsoft-scvmm/
/ansible-collection-swarm Add modules from EPIC-5678

# Auto-detects: You're in a cloned repo
# Result (45 minutes later):
✅ Modules: 15 → 18
✅ All tests passing (new + regression)
✅ Ready for PR
```

### Example 4: Unknown Platform (SolarWinds)

```bash
/ansible-collection-swarm EPIC-7890  # "Build SolarWinds Orion collection"

# Swarm researches: "What is SolarWinds Orion?"
# Discovers: REST API (SWIS)
# Result (1.8 hours later):
✅ Collection: solarwinds.orion  
✅ 8 modules implemented
✅ Pattern learned for future use
```

## 🏗️ Architecture

### Universal Swarm (24 Agents Total)

**Ansible Collection Swarm** (11 agents):
- `lead-architect` - Chief orchestrator
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

**Windows Collection Swarm** (13 agents):
- Windows-specific implementation

### Patterns

5 generic patterns that work for ANY platform:
- REST API Pattern
- CLI-based Pattern
- Config File Pattern
- Database Pattern
- SOAP API Pattern

## 💡 Why Use This?

### Before Hyaish Agents
- 2-3 weeks per collection (manual development)
- Platform-specific templates required
- Manual testing, debugging, delivery
- Inconsistent code quality
- No learning between projects

### After Hyaish Agents
- 30 minutes - 3 hours (fully automated)
- Works for ANY platform (learns automatically)
- Autonomous testing, self-correction, delivery
- Consistent patterns, peer review
- Continuous learning across projects

**ROI**: 10-50x faster

## 🔧 Requirements

### Required

- **Claude Code** (CLI, desktop, or web)
- **jira-rh** or **jira-cli** - Jira CLI tool for reading Epics
  - Install: `npm install -g jira-rh` or `brew install jira-cli`
  - Used by: jira-ingestion-specialist (fast Epic reading)
- **gh** - GitHub CLI for automated PR creation
  - Install: `brew install gh` (Mac) or `apt install gh` (Linux)
  - Auth: `gh auth login`
  - Used by: release-specialist (enhancement mode - auto-creates PRs)
- **git** - Standard git CLI (usually pre-installed)

### Optional

- **Test environment** (can build code-only without testing)
- **Git repository** (can deliver locally without remote push)
- **Ansible** (for local testing and validation)

## 📊 Verification

```bash
cd ~/.claude/agents/agentic-workflows/claude
./verify.sh
```

Expected:
```
✅ Plugin ready to use!
Plugin infrastructure: 3/3
Ansible Collection Swarm: 17/17
Windows Collection Swarm: 14
```

## 🤝 Contributing

Contributions welcome! To add a new swarm:

1. Create swarm directory: `claude/your-swarm-name/`
2. Add agents, patterns, documentation
3. Update `claude/package.json` and `claude/verify.sh`
4. Submit pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## 📝 License

MIT License - See [LICENSE](LICENSE)

## 👥 Author

**Hen Yaish**

- GitHub: [@eco-ansible-content](https://github.com/eco-ansible-content)
- Organization: Red Hat

## 🌟 Support

- **Issues**: [GitHub Issues](https://github.com/eco-ansible-content/agentic-workflows/issues)
- **Discussions**: [GitHub Discussions](https://github.com/eco-ansible-content/agentic-workflows/discussions)
- **Documentation**: See `claude/` directory

## 📈 Roadmap

- [x] Ansible Collection Swarm (Universal)
- [x] Windows Collection Swarm (Legacy)
- [ ] Kubernetes Operator Swarm
- [ ] Terraform Module Swarm
- [ ] API Integration Swarm
- [ ] Documentation Swarm
- [ ] Testing Swarm

## ⭐ Star History

If you find this useful, please star the repository!

---

**Quick Links**:
- [Getting Started](GETTING-STARTED.md) ⭐ **Start here!**
- [Installation](claude/INSTALL.md)
- [Quick Start](claude/ansible-collection-swarm/QUICKSTART.md)
- [Documentation](claude/)

**Current Version**: 0.0.2 (Beta - Not Production Ready)
