# Windows Collection Swarm - Portable Autonomous Agent Army

A fully self-contained, portable multi-agent system for building Windows Ansible collections from Jira Epics.

## ✨ Key Features

- **100% Self-Contained**: All resources, templates, and documentation embedded
- **Fully Portable**: Copy-paste between users/platforms, works immediately
- **Zero External Dependencies**: No need to reference outside files or skills
- **Extreme Autonomy**: Agents operate without permission-seeking
- **Parallel Execution**: 3-5 modules built simultaneously

## 📁 Directory Structure

```
~/.claude/agents/windows-collection-swarm/
├── README.md                    # This file
├── DEPLOYMENT.md                # How to deploy/install the swarm
├── agents/                      # Agent definitions
│   ├── lead-architect.md
│   ├── jira-ingestion-specialist.md
│   ├── foundation-specialist.md
│   ├── module-worker.md
│   ├── qa-coordinator.md
│   ├── refactor-specialist.md
│   ├── release-specialist.md
│   ├── invoke-swarm.md         # Direct invocation template
│   └── QUICKSTART.md           # Quick start guide
├── templates/                   # Collection templates
│   └── collection_template/
│       ├── galaxy.yml
│       ├── README.md
│       ├── azure-pipelines.yml
│       ├── .gitignore
│       ├── .azure-pipelines/
│       ├── docs/plans/
│       ├── plugins/
│       └── tests/
├── resources/                   # Guides and documentation
│   ├── 5-pillars-guide.md      # Implementation guide
│   └── 4-stage-testing-guide.md # Testing guide
├── examples/                    # Example modules and tests
│   ├── module_example_cmdlet.ps1
│   ├── module_example_cim.ps1
│   ├── module_example_registry.ps1
│   └── test_example_4stage.yml
└── docs/                        # Additional documentation
```

## 🚀 Quick Start

### 1. Deploy the Swarm

```bash
# Copy this entire directory to target machine
cp -r windows-collection-swarm ~/.claude/agents/

# Or clone if in version control
git clone <repo> ~/.claude/agents/windows-collection-swarm
```

### 2. Invoke the Lead Architect

```bash
# Read the invocation template
cat ~/.claude/agents/windows-collection-swarm/agents/invoke-swarm.md

# Copy the Agent(...) call and replace <EPIC_KEY> with your Jira Epic
# Example: ANSTRAT-12345
```

### 3. Monitor Progress

```bash
# Watch the backlog
watch -n 10 "grep -c '\[x\]' ~/agentic-workflow-collections/*/*/docs/plans/module_backlog.md"

# View created modules
ls ~/agentic-workflow-collections/*/*/plugins/modules/
```

## 🏗️ Architecture

```
                    Lead Architect
                    (Orchestrator)
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    Jira Ingestion  Foundation      Release
    Specialist      Specialist      Specialist
                         │
                    ┌────┴────┐
              Module        QA           Refactor
              Workers    Coordinator    Specialist
            (3-5 parallel)
```

### The 8 Agents

1. **Lead Architect**: Orchestrates entire lifecycle
2. **Jira Ingestion Specialist**: Recursive Epic analysis + prerequisite detection
3. **Foundation Specialist**: Workspace scaffolding
4. **Platform Prerequisite Specialist**: Installs required platforms (SCVMM, SQL, Hyper-V, etc.) ← NEW
5. **Module Workers**: Parallel module implementation
6. **QA Coordinator**: 4-stage testing + peer review
7. **Refactor Specialist**: Extract utilities every 10 modules
8. **Release Specialist**: Four-pillar audit + git push

## 📦 Self-Contained Resources

Everything an agent needs is embedded:

### Templates
- `templates/collection_template/`: Complete Ansible collection structure
- Includes: galaxy.yml, README.md, azure-pipelines.yml, inventory.winrm

### Guides
- `resources/5-pillars-guide.md`: Implementation decision tree
- `resources/4-stage-testing-guide.md`: Testing requirements

### Examples
- `examples/module_example_*.ps1`: Reference implementations
- `examples/test_example_4stage.yml`: Test template

## 🔄 Workflow

```
User Invokes Lead Architect with Epic Key
         ↓
Jira Ingestion → Builds Module Backlog + Detects Prerequisites
         ↓
Foundation → Scaffolds Collection
         ↓
Platform Prerequisites → Installs SCVMM/SQL/Hyper-V (60-90 min) ← NEW
         ↓
┌────────────────────────────┐
│   Build Loop               │
│                            │
│   Batch Modules (3-5)      │
│         ↓                  │
│   Module Workers (Parallel)│
│         ↓                  │
│   QA Coordinator           │
│         ↓                  │
│   Every 10 Modules:        │
│   Refactor Specialist      │
└────────────────────────────┘
         ↓
Release Specialist → Git Push
         ↓
Complete Collection Delivered
```

## 🎯 Success Criteria

- All modules from Epic implemented
- All tests passing (4-stage loop)
- All code peer-reviewed
- Common code extracted to utilities
- Collection pushed to git
- Zero manual interventions required

## 📋 Requirements

### On the User's System
- Claude Code (CLI, Desktop, or IDE extension)
- Jira access (for `jira-rh` tool)
- Git repository at `~/agentic-workflow-collections/`
- WinRM-accessible Windows test hosts

### In the Swarm (Included)
- Agent definitions
- Collection templates
- Implementation guides
- Example modules
- Test templates

## 🔧 Customization

### Change Batch Size
Edit `agents/lead-architect.md`, find "Batch Size: 3" and change to desired value (2-5).

### Update Test Inventory
Edit `templates/collection_template/tests/inventory.winrm` with your Windows hosts.

### Modify Collection Template
Edit files in `templates/collection_template/` - all collections will use your changes.

## 📤 Portability

### Export for Sharing
```bash
# Create portable archive
tar -czf windows-collection-swarm.tar.gz \
  -C ~/.claude/agents \
  windows-collection-swarm

# Share the .tar.gz file
```

### Import on New System
```bash
# Extract to agents directory
tar -xzf windows-collection-swarm.tar.gz \
  -C ~/.claude/agents/

# Verify structure
ls ~/.claude/agents/windows-collection-swarm/
```

### Version Control
```bash
# Initialize git in swarm directory
cd ~/.claude/agents/windows-collection-swarm
git init
git add .
git commit -m "Initial swarm configuration"

# Push to remote
git remote add origin <your-repo>
git push -u origin main

# Clone on other systems
git clone <your-repo> ~/.claude/agents/windows-collection-swarm
```

## 🐛 Troubleshooting

### Swarm Won't Start
- Verify all agent files exist in `agents/`
- Check templates exist in `templates/collection_template/`
- Ensure resources exist in `resources/`

### Templates Not Found
```bash
# Verify template structure
ls ~/.claude/agents/windows-collection-swarm/templates/collection_template/
```

### Agents Reference Missing Files
- All internal paths use `~/.claude/agents/windows-collection-swarm/`
- Never reference external paths
- If error mentions missing file, check swarm directory structure

### Tests Fail
- Verify `tests/inventory.winrm` has correct Windows host IPs
- Check WinRM connectivity: `ansible -i tests/inventory.winrm windows -m win_ping`

## 🔐 Security

### Credentials in Templates
- Default `tests/inventory.winrm` contains example credentials
- **CRITICAL**: Replace with your credentials or use Ansible Vault
- Never commit real credentials to version control

### Safe Sharing
Before sharing:
1. Remove credentials from `templates/collection_template/tests/inventory.winrm`
2. Check for sensitive data in examples
3. Review `.gitignore` excludes sensitive files

## 📊 Performance

### Expected Timeline (30-module Epic)
- Ingestion: 2-5 minutes
- Foundation: 1-2 minutes
- Build: 60-90 minutes (6 batches)
- Refactoring: 15-20 minutes (3 times)
- Delivery: 5-10 minutes
- **Total: ~90-120 minutes**

### Optimization
- Increase batch size (edit lead-architect.md)
- Pre-warm Windows test hosts
- Use local Jira cache

## 🆘 Support

### Self-Help
1. Read `agents/QUICKSTART.md`
2. Check `DEPLOYMENT.md`
3. Review agent definitions in `agents/`
4. Inspect resources in `resources/`

### Issues
- Check agent logs in Claude Code session
- Review module backlog: `docs/plans/module_backlog.md`
- Verify swarm directory structure is complete

## 🧪 Testing the Swarm

### Verify Swarm Integrity
```bash
#!/bin/bash
SWARM="$HOME/.claude/agents/windows-collection-swarm"

# Check agents
for agent in lead-architect jira-ingestion-specialist foundation-specialist \
             module-worker qa-coordinator refactor-specialist release-specialist; do
  if [ ! -f "$SWARM/agents/$agent.md" ]; then
    echo "❌ Missing agent: $agent"
  else
    echo "✓ Found agent: $agent"
  fi
done

# Check templates
if [ ! -d "$SWARM/templates/collection_template" ]; then
  echo "❌ Missing collection template"
else
  echo "✓ Found collection template"
fi

# Check resources
for resource in 5-pillars-guide.md 4-stage-testing-guide.md; do
  if [ ! -f "$SWARM/resources/$resource" ]; then
    echo "❌ Missing resource: $resource"
  else
    echo "✓ Found resource: $resource"
  fi
done

# Check examples
if [ -z "$(ls -A $SWARM/examples/*.ps1 2>/dev/null)" ]; then
  echo "❌ Missing example modules"
else
  echo "✓ Found example modules"
fi

echo ""
echo "Swarm integrity check complete!"
```

## 📜 License

Part of the Jarvis Framework for Windows Ansible automation.

## 🎓 Learning Resources

- **5 Pillars Guide**: `resources/5-pillars-guide.md`
- **Testing Guide**: `resources/4-stage-testing-guide.md`
- **Example Modules**: `examples/module_example_*.ps1`
- **Test Examples**: `examples/test_example_4stage.yml`

---

**Built for Extreme Autonomy. Fully Portable. Completely Self-Contained.**

Ready to deploy? See `DEPLOYMENT.md` for detailed setup instructions.
