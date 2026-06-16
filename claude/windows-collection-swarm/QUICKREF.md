# Windows Collection Swarm - Quick Reference Card

One-page reference for daily use.

## 🚀 Invoke Swarm

```
Agent(
  subagent_type: "lead-architect",
  description: "Build Windows collection from EPIC-123",
  prompt: """Build complete Windows collection from Jira Epic EPIC-123.
  Execute full lifecycle with extreme autonomy. Report only on completion."""
)
```

Replace `EPIC-123` with your Jira Epic key.

## 📁 Directory Locations

```
Swarm:         ~/.claude/agents/windows-collection-swarm/
Collections:   ~/agentic-workflow-collections/<namespace>/<name>/
Backlog:       ~/agentic-workflow-collections/<namespace>/<name>/docs/plans/module_backlog.md
```

## 🔍 Monitor Progress

```bash
# Watch backlog progress
watch -n 10 "grep -c '\[x\]' ~/agentic-workflow-collections/*/*/docs/plans/module_backlog.md"

# Count modules created
ls ~/agentic-workflow-collections/*/*/plugins/modules/ | wc -l

# View git history
cd ~/agentic-workflow-collections/<namespace>/<name> && git log --oneline
```

## 📊 Workflow Stages

1. **Ingestion** (2-5 min) → Creates module backlog
2. **Foundation** (1-2 min) → Scaffolds collection
3. **Build** (60-90 min) → Parallel module creation
4. **QA** (per batch) → 4-stage testing
5. **Refactor** (every 10 modules) → Extract utilities
6. **Delivery** (5-10 min) → Git commit & push

## 🎯 The 7 Agents

| Agent | Role | Model | Trigger |
|-------|------|-------|---------|
| Lead Architect | Orchestrator | Opus | Always first |
| Jira Ingestion | Requirements | Sonnet | Phase 1 |
| Foundation | Scaffolding | Sonnet | Phase 2 |
| Module Workers | Implementation | Sonnet | Parallel (3-5) |
| QA Coordinator | Testing | Sonnet | After each batch |
| Refactor Specialist | Abstraction | Opus | Every 10 modules |
| Release Specialist | Delivery | Sonnet | 100% complete |

## 🧪 The 4-Stage Test Loop

Every module must pass:

1. **Initial Run** - Basic functionality works
2. **Idempotency** - Second run shows no changes
3. **Check Mode** - Dry-run reports correctly
4. **Error Handling** - Fails gracefully on invalid input

## 🛠️ The 5 Pillars

Implementation preference order:

1. **Cmdlets** ⭐⭐⭐⭐⭐ - Use if available
2. **CIM** ⭐⭐⭐⭐ - Modern systems (2012+)
3. **WMI** ⭐⭐⭐ - Legacy fallback
4. **.NET** ⭐⭐⭐ - Complex operations
5. **Registry** ⭐⭐ - Configuration only

## 🔧 Common Commands

```bash
# Verify swarm integrity
~/.claude/agents/windows-collection-swarm/verify-swarm.sh

# Test WinRM connectivity
ansible -i tests/inventory.winrm windows -m win_ping

# Test Jira access
jira-rh epic list EPIC-123 --no-input

# Build collection manually
cd ~/agentic-workflow-collections/<namespace>/<name>
ansible-galaxy collection build

# Run integration tests
ansible-test integration --python 3.9
```

## 📝 Key Files

```
agents/invoke-swarm.md              # Invocation template
agents/QUICKSTART.md                # Quick start guide
resources/5-pillars-guide.md        # Implementation guide
resources/4-stage-testing-guide.md  # Testing guide
templates/collection_template/      # Collection structure
examples/module_example_*.ps1       # Reference modules
```

## ⚙️ Configuration

```bash
# Update Windows test hosts
vim ~/.claude/agents/windows-collection-swarm/templates/collection_template/tests/inventory.winrm

# Change batch size (2-5)
vim ~/.claude/agents/windows-collection-swarm/agents/lead-architect.md
# Find: "Batch Size: 3"

# Customize collection template
cd ~/.claude/agents/windows-collection-swarm/templates/collection_template/
# Edit: galaxy.yml, README.md, azure-pipelines.yml
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Swarm not found | Run `ls ~/.claude/agents/windows-collection-swarm/` |
| Templates missing | Run `verify-swarm.sh` |
| Jira auth fails | Run `jira-rh configure` |
| Tests fail | Check `ansible -m win_ping` |
| Git push fails | Verify remote: `git remote -v` |

## 📦 Export/Import

```bash
# Export
cd ~/.claude/agents
tar -czf swarm.tar.gz windows-collection-swarm/

# Import
tar -xzf swarm.tar.gz -C ~/.claude/agents/

# Verify
~/.claude/agents/windows-collection-swarm/verify-swarm.sh
```

## 📈 Performance Tuning

| Epic Size | Batch Size | Expected Time |
|-----------|------------|---------------|
| Small (5-10) | 2 | 30-45 min |
| Medium (10-30) | 3 | 90-120 min |
| Large (30-50) | 5 | 150-200 min |

## ✅ Pre-Flight Checklist

Before invoking swarm:

- [ ] Swarm verified (`verify-swarm.sh`)
- [ ] Windows hosts in inventory
- [ ] WinRM connectivity tested
- [ ] Jira access configured
- [ ] Git repo created
- [ ] Small Epic for testing

## 🎓 Documentation Links

- Main: `README.md`
- Install: `DEPLOYMENT.md`
- Files: `MANIFEST.md`
- Summary: `SUMMARY.md`
- This: `QUICKREF.md`

## 💡 Pro Tips

- Start with small Epics (5-10 modules)
- Monitor backlog file for real-time progress
- Batch size 3 is optimal for most Epics
- Refactoring runs automatically (every 10 modules)
- All agents self-correct (3 attempts)
- Zero manual intervention required

---

**Print this page for daily reference!**
