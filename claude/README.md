# Hyaish Agent Swarms

Unified plugin containing intelligent multi-agent swarms for automation.

## Available Swarms

### 🎯 Ansible Collection Swarm (Universal)

**Description**: Build **ANY** Ansible collection from Jira Epics - works for platforms you've never heard of!

**Invocation**:
```
/ansible-collection-swarm EPIC-XXX
```

**Agent Namespace**: `agentic-workflows/ansible-collection-swarm:AGENT-NAME`

**Capabilities**:
- ✅ **Universal Platform Support** - Windows, Linux, Cloud, Network, Custom apps, unknown platforms
- ✅ **Intelligence-Based** - Learns platforms through research, not templates
- ✅ **Dual-Mode** - Full Build (new collections) or Enhancement (existing collections)
- ✅ **Multi-Location Detection** - Works in cloned repos, swarm workspace, anywhere
- ✅ **100% Autonomous** - After answering 2-3 questions, fully hands-off
- ✅ **Self-Correcting** - 3-attempt recovery, degraded environment support
- ✅ **Continuous Learning** - Gets smarter with each build

**Documentation**: `ansible-collection-swarm/README.md`

---

### 🪟 Windows Collection Swarm (Legacy)

**Description**: Windows-specific collection builder (predecessor to universal swarm)

**Invocation**:
```
/windows-collection-swarm EPIC-XXX
```

**Agent Namespace**: `agentic-workflows/windows-collection-swarm:AGENT-NAME`

**Capabilities**:
- ✅ Windows-focused automation
- ✅ Template-based approach
- ✅ SCVMM, Hyper-V, Exchange support

**Status**: Legacy - Use `ansible-collection-swarm` for new projects

**Documentation**: `windows-collection-swarm/README.md`

---

## Installation

### For Your Team

```bash
cd ~/.claude/agents
git clone https://github.com/eco-ansible-content/agentic-workflows.git
cd agentic-workflows
./verify.sh
```

### Via Plugin Registry (Once Published)

```bash
/plugin install agentic-workflows@eco-ansible-content
```

## Quick Start

### Universal Swarm (Recommended)

```bash
# Build any collection
/ansible-collection-swarm EPIC-XXX

# Enhance existing collection
/ansible-collection-swarm Enhance microsoft.scvmm from EPIC-5678
```

### Via Agent Tool

```javascript
// Universal swarm
Agent({
  description: "Build collection",
  prompt: "Build collection from EPIC-XXX",
  subagent_type: "agentic-workflows/ansible-collection-swarm:lead-architect"
})

// Windows swarm (legacy)
Agent({
  description: "Build Windows collection",
  prompt: "Build collection from EPIC-XXX",
  subagent_type: "agentic-workflows/windows-collection-swarm:lead-architect"
})
```

## Plugin Structure

```
agentic-workflows/
├── .claude-plugin/
│   └── plugin.json                    # Plugin manifest
├── package.json                        # NPM package + Claude metadata
├── README.md                           # This file
├── LICENSE                             # MIT license
├── verify.sh                           # Verification script
│
├── ansible-collection-swarm/           # Universal swarm
│   ├── core/
│   │   ├── agents/                     # 11 intelligent agents
│   │   └── templates/                  # Collection templates
│   ├── knowledge/
│   │   ├── patterns/                   # 5 generic patterns
│   │   └── examples/                   # Code examples
│   ├── resources/                      # Guides and references
│   ├── skills/
│   │   └── ansible-collection-swarm.md # Main skill
│   └── [documentation files]
│
└── windows-collection-swarm/           # Legacy Windows swarm
    ├── agents/
    ├── examples/
    ├── resources/
    └── [documentation files]
```

## Agent Namespacing

All agents are namespaced as: `agentic-workflows/SWARM-NAME:AGENT-NAME`

### Universal Swarm Agents

- `agentic-workflows/ansible-collection-swarm:lead-architect`
- `agentic-workflows/ansible-collection-swarm:jira-ingestion-specialist`
- `agentic-workflows/ansible-collection-swarm:foundation-specialist`
- `agentic-workflows/ansible-collection-swarm:enhancement-specialist`
- `agentic-workflows/ansible-collection-swarm:platform-prerequisite-specialist`
- `agentic-workflows/ansible-collection-swarm:module-worker`
- `agentic-workflows/ansible-collection-swarm:qa-coordinator`
- `agentic-workflows/ansible-collection-swarm:refactor-specialist`
- `agentic-workflows/ansible-collection-swarm:release-specialist`
- `agentic-workflows/ansible-collection-swarm:ci-validation-specialist`
- `agentic-workflows/ansible-collection-swarm:learning-evolution-specialist`

### Windows Swarm Agents (Legacy)

- `agentic-workflows/windows-collection-swarm:lead-architect`

## What You Get

### Ansible Collection Swarm (Universal)

**Input**: Jira Epic key  
**Output**: Complete, tested Ansible collection

**Platforms Supported**: Infinite (learns any platform)

**Examples**:
- Windows (SCVMM, Hyper-V, Exchange)
- Linux (systemd, Apache, MySQL)
- Network (Cisco, Arista, Juniper)
- Cloud (Azure, AWS, GCP)
- Monitoring (SolarWinds, Datadog)
- Custom applications
- **Platforms that don't exist yet!**

**Time Savings**: 10-50x faster than manual development

**Quality**: Consistent patterns, comprehensive testing, peer review

### Windows Collection Swarm (Legacy)

**Input**: Jira Epic key  
**Output**: Windows-focused Ansible collection

**Platforms Supported**: Windows Server environments

**Status**: Maintained but not actively developed (use universal swarm)

## Future Swarms

The `agentic-workflows` plugin is designed to grow. Future swarms might include:

- **Kubernetes Operator Swarm** - Build K8s operators
- **Terraform Module Swarm** - Build Terraform modules
- **API Integration Swarm** - Build API clients
- **Documentation Swarm** - Generate comprehensive docs
- **Testing Swarm** - Create test suites

All will follow the same pattern:
```
agentic-workflows/NEW-SWARM-NAME:AGENT-NAME
```

## Documentation

### Universal Swarm

- **Quick Start**: `ansible-collection-swarm/QUICKSTART.md`
- **Getting Started**: `ansible-collection-swarm/GETTING-STARTED.md`
- **Architecture**: `ansible-collection-swarm/README.md`
- **Agent Registry**: `ansible-collection-swarm/AGENTS.md`
- **Collection Detection**: `ansible-collection-swarm/COLLECTION-DETECTION.md`

### Windows Swarm

- **README**: `windows-collection-swarm/README.md`
- **Quick Reference**: `windows-collection-swarm/QUICKREF.md`

## Requirements

- **Claude Code** (CLI, desktop, or web)
- **Jira** access (for Epic reading)
- **Test environment** (optional - can build code-only)
- **Git repository** (optional - can deliver locally)

## Verification

```bash
cd ~/.claude/agents/agentic-workflows
./verify.sh
```

Expected output:
```
✅ Plugin verified!
✅ Ansible Collection Swarm: 25/25 components
✅ Windows Collection Swarm: [count] components
```

## Updates

```bash
cd ~/.claude/agents/agentic-workflows
git pull origin main
./verify.sh
```

## Publishing

See `PUBLISH.md` for instructions on:
- Publishing to GitHub
- Registering with plugin registry
- Sharing with your team
- Version management

## Support

- **Issues**: https://github.com/eco-ansible-content/agentic-workflows/issues
- **Discussions**: https://github.com/eco-ansible-content/agentic-workflows/discussions
- **Documentation**: See swarm-specific READMEs

## License

MIT License - See LICENSE file

## Author

Hyaish <hyaish@redhat.com>

## Version

Current version: 1.0.0

---

**Recommended**: Start with the Universal Ansible Collection Swarm for all new projects. It works for any platform!
