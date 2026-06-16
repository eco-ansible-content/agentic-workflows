---
name: insights-sync
description: Syncs learned patterns from production runs into agent definitions
---

# Insights Sync Skill

Reads accumulated insights from `/insights/` and updates agent definitions with learned patterns.

## Usage

```
/insights-sync
```

## What It Does

1. **Reads** insights from production runs (`/insights/quick-reference.log` and detailed markdown files)
2. **Categorizes** insights by target agent (platform → module-worker, pattern → enhancement-specialist, etc.)
3. **Updates** agent definitions with "Learned Patterns" sections
4. **Reinstalls** the plugin so updates take effect
5. **Reports** summary of what was updated

## When to Use

- ✅ After multiple production runs have accumulated insights
- ✅ Before starting a new project
- ✅ Periodically (weekly/monthly) to keep agents current
- ✅ After significant learnings you want propagated

## When NOT to Use

- ❌ During an active build run
- ❌ When no new insights exist
- ❌ As part of automated workflows (it's manual maintenance)

## Output

Updated agent files with new "Learned Patterns" sections:
- `ansible-collection-swarm-module-worker.md`
- `ansible-collection-swarm-enhancement-specialist.md`
- `ansible-collection-swarm-release-specialist.md`
- `ansible-collection-swarm-ci-validation-specialist.md`
- `ansible-collection-swarm-refactor-specialist.md`

## Implementation

This skill spawns the `insights-sync-specialist` agent:

```javascript
Agent({
  description: "Sync insights to agents",
  prompt: "Read all insights from ~/Documents/Git/agentic-workflows/insights/ and update agent definitions with learned patterns. Categorize insights by type (Platform→module-worker, Pattern→enhancement-specialist, Operational→release-specialist). Add 'Learned Patterns' sections to agents. Reinstall plugin when complete.",
  subagent_type: "agentic-workflows/ansible-collection-swarm:insights-sync-specialist"
})
```

## Example Session

```
User: /insights-sync

Agent: 📚 Reading insights from: ~/Documents/Git/agentic-workflows/insights/
   Found 14 quick-reference insights
   Platform insights: 1 files
   Pattern insights: 2 files  
   Operational insights: 1 files

🔍 Analyzing insights for agent updates...

📋 Agents to update:
   - module-worker: 6 insights
   - enhancement-specialist: 8 insights
   - release-specialist: 4 insights
   - ci-validation-specialist: 3 insights
   - refactor-specialist: 2 insights

✏️  Updating agent definitions...
   📝 Updating: module-worker (✅ 6 patterns added)
   📝 Updating: enhancement-specialist (✅ 8 patterns added)
   📝 Updating: release-specialist (✅ 4 patterns added)
   📝 Updating: ci-validation-specialist (✅ 3 patterns added)
   📝 Updating: refactor-specialist (✅ 2 patterns added)

🔄 Reinstalling plugin with updated agents...

✅ Plugin reinstalled successfully!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   INSIGHTS SYNC COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Summary:
   Total insights processed: 14
   Agents updated: 5
   
✅ Agents are now equipped with latest learned patterns!
✅ Next build run will benefit from these insights automatically.
```

## Architecture

```
Production Run
     ↓
learning-evolution-specialist (writes insights)
     ↓
insights/
  ├── quick-reference.log
  ├── platform-insights/
  ├── pattern-insights/
  └── operational-insights/
     ↓
/insights-sync (user invokes manually)
     ↓
insights-sync-specialist (reads & applies)
     ↓
Updated Agent Definitions
     ↓
Plugin Reinstall
     ↓
Future Runs Benefit
```

## Notes

- **Idempotent**: Safe to run multiple times
- **No context needed**: Operates on files only
- **Automatic categorization**: Knows which agents need which insights
- **Preserves manual edits**: Only adds to "Learned Patterns" section
