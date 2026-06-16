# Ansible Collection Swarm - Claude Code Plugin

Universal multi-agent system that builds **ANY** Ansible collection intelligently from Jira Epics.

## Installation

### For Your Team (Private Registry)

```bash
/plugin install ansible-collection-swarm@YOUR-ORG
```

### For Public Use (Once Published)

```bash
/plugin install ansible-collection-swarm@claude-plugins-official
```

### Manual Install (Development/Testing)

```bash
cd ~/.claude/agents
git clone https://github.com/YOUR-USERNAME/ansible-collection-swarm.git
```

## Quick Start

```
/ansible-collection-swarm EPIC-XXX
```

That's it! The swarm handles everything autonomously.

## What It Does

### Universal Platform Support

Works for **ANY** platform through intelligence and research, not templates:

- ✅ Windows (PowerShell, WinRM)
- ✅ Linux (Python, SSH)
- ✅ Network devices (Cisco, Arista, Juniper)
- ✅ Cloud APIs (Azure, AWS, GCP)
- ✅ Monitoring (SolarWinds, Datadog, New Relic)
- ✅ VMware, Hyper-V, KVM
- ✅ Custom applications
- ✅ **Platforms that don't exist yet!**

### Intelligent Operation

The swarm:
1. **Researches** unfamiliar platforms
2. **Extracts characteristics** (API type, connection method, authentication)
3. **Matches patterns** (5 generic patterns apply everywhere)
4. **Adapts implementation** to your specific environment
5. **Self-corrects** failures (3 attempts before escalation)
6. **Learns continuously** to improve future builds

### Dual-Mode Operation

**Full Build** (New Collection - 2-3 hours):
- Analyzes Jira Epic
- Creates collection structure
- Installs prerequisites
- Implements all modules
- Tests everything
- Delivers to git or local

**Enhancement** (Existing Collection - 30-60 minutes):
- Auto-detects collection location
- Analyzes existing patterns
- Implements new modules matching style
- Regression tests all modules
- Incremental commit

## Usage

### Simple Invocation

```
/ansible-collection-swarm EPIC-2345
```

### With Context

```
/ansible-collection-swarm Build collection from EPIC-2345
/ansible-collection-swarm Enhance microsoft.scvmm with modules from EPIC-5678
/ansible-collection-swarm Add modules to collection at ~/projects/my-collection
```

### Via Agent Tool

```javascript
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from Jira Epic EPIC-XXX",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

## What You'll Be Asked

### Question 1: Test Environment

```
Where should integration tests run?

Examples:
✅ 192.168.1.100, winrm, user: Administrator, pass: P@ss123
✅ ssh://test-server.lab.local:22, key: ~/.ssh/ansible_rsa
✅ network_cli://10.0.1.1, user: admin, pass: cisco123
✅ local (Azure API), subscription: abc-1234
✅ none (build code-only, skip tests)
```

### Question 2: Delivery Target

```
Where should the completed collection go?

Options:
A) Local only (~/agentic-workflow-collections/...)
B) Git repository (provide URL)

Examples:
✅ Local only
✅ https://github.com/myorg/ansible-collections.git
```

### Question 3: Collection Location (ONLY if ambiguous)

```
Collection found in multiple locations. Which should I use?

Options:
A) Current directory (you're working in a cloned repo)
B) Swarm workspace (~/agentic-workflow-collections/...)
C) Custom path (specify your own location)
```

## Features

### Intelligence-Based (Not Template-Based)

- Learns platforms through research
- Extracts characteristics over classifications
- Adapts patterns to ANY platform
- Works for platforms it's never seen

### Multi-Location Detection

Automatically finds existing collections in:
- Current directory (cloned repos)
- Swarm workspace
- Ansible collections path
- Custom locations

**No manual file copying!**

### 100% Autonomous

After answering 2-3 questions:
- Fully hands-off
- Self-corrects failures (3 attempts)
- Only escalates if truly stuck
- Provides detailed progress tracking

### Continuous Learning

- Captures lessons from every build
- Tags knowledge by characteristics
- Applies learnings across all platforms
- Gets smarter over time

## Available Agents

All namespaced as `ansible-collection-swarm:AGENT-NAME`:

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

## Examples

### Example 1: Windows SCVMM (New Collection)

```bash
/ansible-collection-swarm WINOPS-2345

# Answers:
# Q1: 192.168.50.10, winrm, user: ansible, pass: Test123
# Q2: https://github.com/myorg/collections.git

# Result (2.5 hours later):
✅ Collection: microsoft.scvmm
✅ 15 modules implemented and tested
✅ Pushed to: https://github.com/myorg/collections.git
✅ CI/CD: All checks passing
```

### Example 2: Enhancement (Developer in Cloned Repo)

```bash
cd ~/projects/ansible-collections/microsoft-scvmm/

/ansible-collection-swarm Add modules from EPIC-5678

# Answers:
# Q1: 192.168.1.100, winrm, user: ansible, pass: Test123
# Q2: https://github.com/myusername/ansible-scvmm.git
# (No Q3 - auto-detected current directory)

# Result (45 minutes later):
✅ Collection enhanced: microsoft.scvmm
✅ Modules: 15 → 18
✅ All tests passing (new + regression)
✅ Ready for PR
```

### Example 3: Unknown Platform (SolarWinds)

```bash
/ansible-collection-swarm MON-456 "Build SolarWinds Orion automation"

# Swarm researches:
🔍 "What is SolarWinds Orion?"
✅ Discovered: REST API (SWIS)
✅ Pattern matched: REST API pattern

# Answers:
# Q1: local (SolarWinds API), server: 10.0.1.50
# Q2: git@gitlab.company.com:ansible/collections.git

# Result (1.8 hours later):
✅ Collection: solarwinds.orion
✅ 8 modules implemented and tested
✅ Pattern learned and saved
```

## Output

**New collections**:
```
~/agentic-workflow-collections/<namespace>/<name>/
```

**Enhanced collections**:
```
Wherever detected (current dir, swarm workspace, or custom path)
```

## Requirements

- Claude Code (CLI, desktop, or web)
- Jira access (for Epic reading)
- Test environment (optional - can build code-only)
- Git repository (optional - can deliver locally)

## Documentation

Full documentation available at:
- `QUICKSTART.md` - Quick start guide
- `GETTING-STARTED.md` - Comprehensive usage
- `COLLECTION-DETECTION.md` - Multi-location detection
- `AGENTS.md` - Complete agent registry
- `README.md` - Architecture overview

## Publishing This Plugin

### Step 1: Prepare Repository

```bash
cd ~/.claude/agents/ansible-collection-swarm

# Update placeholders in package.json and plugin.json
# Replace:
#   YOUR-USERNAME → your-github-username
#   YOUR-ORG → your-organization
#   Your Name → your-name
#   your.email@example.com → your-email

# Initialize git
git init
git add .
git commit -m "Initial release v1.0.0"
git tag v1.0.0
```

### Step 2: Publish to GitHub

```bash
# Create repository on GitHub, then:
git remote add origin https://github.com/YOUR-USERNAME/ansible-collection-swarm.git
git branch -M main
git push -u origin main --tags
```

### Step 3: Register Plugin

**Option A: Private Registry (For Your Team)**

Contact your team's plugin registry administrator to add:
```json
{
  "name": "ansible-collection-swarm",
  "registry": "YOUR-ORG",
  "url": "https://github.com/YOUR-USERNAME/ansible-collection-swarm.git",
  "version": "1.0.0"
}
```

**Option B: Public Registry (Submit to Claude Plugins Official)**

1. Fork https://github.com/claude-plugins/official-registry
2. Add entry to `plugins.json`
3. Create pull request
4. Wait for review and approval

### Step 4: Team Installation

Once registered, your team installs via:

```bash
# Private registry
/plugin install ansible-collection-swarm@YOUR-ORG

# Public registry (if approved)
/plugin install ansible-collection-swarm@claude-plugins-official
```

## Support

- **Issues**: https://github.com/YOUR-USERNAME/ansible-collection-swarm/issues
- **Discussions**: https://github.com/YOUR-USERNAME/ansible-collection-swarm/discussions
- **Documentation**: See all `*.md` files in plugin directory

## License

MIT License - See LICENSE file

## Author

Your Name <your.email@example.com>

## Version

Current version: 1.0.0
