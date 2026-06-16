# Direct Swarm Invocation

Use this to directly invoke the Lead Architect agent with a Jira Epic, bypassing the skill wrapper.

## Direct Invocation

Copy this Agent call and replace `<EPIC_KEY>` with your Jira Epic:

```
Agent(
  subagent_type: "lead-architect",
  description: "Build Windows collection from <EPIC_KEY>",
  prompt: """Build a complete Windows Ansible collection from Jira Epic <EPIC_KEY>.

Configuration:
- Epic Key: <EPIC_KEY>
- Namespace: auto-detect from Epic
- Collection Name: auto-detect from Epic
- Batch Size: 3 modules per batch

Execute the full Jarvis Framework lifecycle with extreme autonomy:

Phase 1: Ingestion
- Spawn jira-ingestion-specialist agent
- Provide Epic key: <EPIC_KEY>
- Wait for module backlog generation in docs/plans/module_backlog.md

Phase 2: Foundation
- Spawn foundation-specialist agent
- Provide namespace and collection name from Epic analysis
- Wait for workspace scaffolding at ~/agentic-workflow-collections/<namespace>/<name>/

Phase 3: Build Loop (Repeat until backlog 100% complete)
- Group uncompleted modules into batches of 3
- For each batch:
  a. Spawn 3 module-worker agents in parallel
  b. Assign 1 module per worker from backlog
  c. Wait for all workers to complete
  d. Spawn qa-coordinator agent
  e. Wait for QA to approve batch (4-stage loop + peer review)
  f. Mark batch as [x] DONE in backlog
  g. Every 10 modules: Spawn refactor-specialist, wait for refactor completion

Phase 4: Delivery
- When 100% of backlog marked [x] DONE:
  a. Spawn release-specialist agent
  b. Wait for four-pillar audit completion
  c. Wait for git commit and push
  d. Report final collection location and statistics

Autonomy Rules (CRITICAL):
- NEVER ask for permission between phases - proceed automatically
- Self-correct failures with 3 attempts before reporting
- Make ALL technical decisions autonomously (parameter names, types, implementation)
- Skip ALL brainstorming/design phases - architecture is pre-defined
- Report ONLY on final completion or unrecoverable errors after 3 attempts

Agent Definitions Location:
All agents are defined in: ~/.claude/agents/windows-collection-swarm/

Agent Spawning:
Use the Agent tool to spawn sub-agents:
- jira-ingestion-specialist
- foundation-specialist
- module-worker (spawn multiple in parallel for batches)
- qa-coordinator
- refactor-specialist
- release-specialist

Begin execution immediately. Do not wait for user confirmation."""
)
```

## Example Usage

For Epic ANSTRAT-12345:

```
Agent(
  subagent_type: "lead-architect",
  description: "Build Windows collection from ANSTRAT-12345",
  prompt: """Build a complete Windows Ansible collection from Jira Epic ANSTRAT-12345.

Configuration:
- Epic Key: ANSTRAT-12345
- Namespace: auto-detect from Epic
- Collection Name: auto-detect from Epic
- Batch Size: 3 modules per batch

[... rest of prompt as above ...]"""
)
```

## Custom Configuration

### Custom Namespace and Name
```
Configuration:
- Epic Key: ANSTRAT-12345
- Namespace: microsoft
- Collection Name: scvmm
- Batch Size: 3
```

### Larger Batches
```
Configuration:
- Epic Key: ANSTRAT-12345
- Namespace: auto-detect from Epic
- Collection Name: auto-detect from Epic
- Batch Size: 5 modules per batch
```

### Smaller Batches (More Stable)
```
Configuration:
- Epic Key: ANSTRAT-12345
- Namespace: auto-detect from Epic
- Collection Name: auto-detect from Epic
- Batch Size: 2 modules per batch
```

## Monitoring

The Lead Architect will report progress at these milestones:
- Backlog generation complete
- Workspace scaffolding complete
- Each batch completion (modules X-Y done)
- Each refactoring milestone (every 10 modules)
- Final delivery complete

## Output

Final output will include:
- Collection path: `~/agentic-workflow-collections/<namespace>/<name>/`
- Git commit SHA
- Total modules built
- Total tests created
- Total utilities extracted
- Delivery timestamp
