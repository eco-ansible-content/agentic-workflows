# Quick Start Guide - Windows Collection Swarm

## One-Command Deployment

```bash
/windows-collection-swarm ANSTRAT-12345
```

Replace `ANSTRAT-12345` with your Jira Epic key.

## What Happens

1. **Jira Analysis** (2-5 min)
   - Recursively analyzes Epic and all sub-tasks
   - Creates module backlog in `docs/plans/module_backlog.md`

2. **Workspace Setup** (1-2 min)
   - Creates `~/agentic-workflow-collections/<namespace>/<name>/`
   - Copies Jarvis templates and baseline files

3. **Module Building** (60-90 min for 30 modules)
   - Builds modules in parallel batches of 3-5
   - Each module tested with 4-stage loop
   - All code peer-reviewed

4. **Refactoring** (15-20 min total)
   - Runs every 10 modules
   - Extracts common code to utilities

5. **Delivery** (5-10 min)
   - Four-pillar audit
   - Git commit and push

## Monitoring Progress

```bash
# Watch the backlog
watch -n 10 "grep -c '\[x\]' ~/agentic-workflow-collections/*/*/docs/plans/module_backlog.md"

# Count modules built
ls ~/agentic-workflow-collections/*/*/plugins/modules/*.ps1 | wc -l

# View git commits
cd ~/agentic-workflow-collections/<namespace>/<name>
git log --oneline
```

## Success Indicators

✅ Module backlog file created
✅ Collection directory scaffolded
✅ Modules appearing in `plugins/modules/`
✅ Tests passing (check test output)
✅ Git commits being made
✅ Final push to remote repository

## Troubleshooting

### Nothing Happens
- Check Jira credentials: `jira-rh epic list <KEY>`
- Verify Epic key format: Should be `PROJECT-NUMBER`

### Modules Not Building
- Check module backlog: `cat docs/plans/module_backlog.md`
- Review agent output in Claude Code session

### Tests Failing
- QA Coordinator auto-fixes (3 attempts)
- If persistent, check Windows host connectivity

### Git Push Fails
- Verify git credentials: `git push origin main`
- Check network connectivity

## Advanced Options

```bash
# Custom namespace and name
/windows-collection-swarm ANSTRAT-12345 namespace=microsoft collection_name=hyperv

# Larger batches (faster, more resource-intensive)
/windows-collection-swarm ANSTRAT-12345 batch_size=5

# Smaller batches (slower, more stable)
/windows-collection-swarm ANSTRAT-12345 batch_size=2
```

## Expected Output Location

```
~/agentic-workflow-collections/<namespace>/<name>/
```

## After Completion

```bash
# Navigate to collection
cd ~/agentic-workflow-collections/<namespace>/<name>

# Verify all modules
ls plugins/modules/

# Run tests locally
ansible-test integration --list-targets

# Build collection
ansible-galaxy collection build

# Publish to Galaxy (manual)
ansible-galaxy collection publish *.tar.gz
```

## Getting Help

1. Check this guide
2. Review `README.md` in the agents directory
3. Inspect agent definitions in `~/.claude/agents/windows-collection-swarm/`
4. Report issues to Jarvis Framework maintainers
