# Universal Ansible Collection Swarm - Agent Registry

This file lists all available agents in the swarm for discoverability.

## Installation

From the `ansible-collection-swarm` directory:
```bash
./install.sh
```

Or manually create symlink:
```bash
ln -s ~/.claude/agents/ansible-collection-swarm ~/.claude/agents/ansible-collection-swarm
```

## Available Agents

### Core Orchestrator

#### lead-architect
- **Path**: `core/agents/lead-architect.md`
- **Model**: opus
- **Description**: Chief Automation Officer for Universal Ansible Collections - orchestrates end-to-end lifecycle with context gathering
- **Usage**: Primary entry point for building or enhancing collections
- **Invocation**:
  ```
  Agent({
    description: "Build Ansible collection",
    prompt: "Build collection from Jira Epic EPIC-XXX",
    subagent_type: "ansible-collection-swarm:lead-architect"
  })
  ```

### Specialized Agents (Invoked by Lead Architect)

#### jira-ingestion-specialist
- **Path**: `core/agents/jira-ingestion-specialist.md`
- **Model**: sonnet
- **Description**: Epic analyzer - extracts platform characteristics and module requirements through research
- **Called by**: Lead Architect (Phase 1)

#### foundation-specialist
- **Path**: `core/agents/foundation-specialist.md`
- **Model**: sonnet
- **Description**: Workspace scaffolder - creates universal collection structure for any platform
- **Called by**: Lead Architect (Phase 2 - Full Build only)

#### enhancement-specialist
- **Path**: `core/agents/enhancement-specialist.md`
- **Model**: opus
- **Description**: Collection enhancer - adds new modules to existing collections intelligently
- **Called by**: Lead Architect (Phase 3 - Enhancement mode only)

#### platform-prerequisite-specialist
- **Path**: `core/agents/platform-prerequisite-specialist.md`
- **Model**: opus
- **Description**: Environment setup engineer - intelligently installs ANY platform through research and adaptation
- **Called by**: Lead Architect (Phase 3 - Full Build or conditional Enhancement)

#### module-worker
- **Path**: `core/agents/module-worker.md`
- **Model**: sonnet
- **Description**: Pattern-based module implementer - researches and adapts to any platform
- **Called by**: Lead Architect (Phase 4 - parallel batches)

#### qa-coordinator
- **Path**: `core/agents/qa-coordinator.md`
- **Model**: sonnet
- **Description**: Adaptive testing coordinator - validates modules with platform-specific strategies
- **Called by**: Lead Architect (Phase 5)

#### refactor-specialist
- **Path**: `core/agents/refactor-specialist.md`
- **Model**: sonnet
- **Description**: Code optimization specialist - extracts utilities and reduces duplication
- **Called by**: Lead Architect (Phase 6 - every 10 modules)

#### release-specialist
- **Path**: `core/agents/release-specialist.md`
- **Model**: sonnet
- **Description**: Delivery coordinator - finalizes and publishes collections
- **Called by**: Lead Architect (Phase 7)

#### ci-validation-specialist
- **Path**: `core/agents/ci-validation-specialist.md`
- **Model**: sonnet
- **Description**: Pipeline monitor - fixes CI/CD failures autonomously
- **Called by**: Lead Architect (Phase 8 - if git delivery)

#### learning-evolution-specialist
- **Path**: `core/agents/learning-evolution-specialist.md`
- **Model**: opus
- **Description**: Knowledge capture specialist - learns from successes and failures
- **Called by**: Lead Architect (Phase 9)

## Agent Naming Convention

To invoke agents from this swarm, use the namespace format:

```javascript
Agent({
  description: "Task description",
  prompt: "Detailed instructions",
  subagent_type: "ansible-collection-swarm:AGENT-NAME"
})
```

Examples:
- `ansible-collection-swarm:lead-architect` - Primary orchestrator
- `ansible-collection-swarm:module-worker` - Module implementation
- `ansible-collection-swarm:enhancement-specialist` - Enhance existing collection

## Agent Models

| Agent | Model | Reasoning |
|-------|-------|-----------|
| lead-architect | opus | Strategic orchestration, complex decision-making |
| jira-ingestion-specialist | sonnet | Efficient data processing |
| foundation-specialist | sonnet | Template generation |
| enhancement-specialist | opus | Pattern analysis, regression testing strategy |
| platform-prerequisite-specialist | opus | Research-heavy, problem-solving |
| module-worker | sonnet | Code generation |
| qa-coordinator | sonnet | Test execution, validation |
| refactor-specialist | sonnet | Code analysis, refactoring |
| release-specialist | sonnet | Structured audit, delivery |
| ci-validation-specialist | sonnet | CI/CD monitoring, fixes |
| learning-evolution-specialist | opus | Knowledge synthesis, learning |

**Opus** (4 agents): Strategic, research-heavy, complex decision-making  
**Sonnet** (7 agents): Execution, implementation, efficient processing

## Quick Reference

### Build New Collection
```bash
# Primary agent
Agent({
  description: "Build collection from Epic",
  prompt: "Build collection from Jira Epic WINOPS-2345",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

### Enhance Existing Collection
```bash
# Same agent, auto-detects enhancement mode
Agent({
  description: "Add modules to collection",
  prompt: "Add modules from EPIC-5678 to microsoft.scvmm",
  subagent_type: "ansible-collection-swarm:lead-architect"
})
```

### Direct File Invocation
```bash
# If not using Agent tool
claude-code --agent ~/.claude/agents/ansible-collection-swarm/core/agents/lead-architect.md \
  "Build collection from EPIC-XXX"
```

## Agent Dependencies

```
lead-architect (orchestrator)
  ├─ jira-ingestion-specialist (Phase 1)
  ├─ foundation-specialist (Phase 2 - full build)
  ├─ enhancement-specialist (Phase 2 - enhancement)
  ├─ platform-prerequisite-specialist (Phase 3)
  ├─ module-worker (Phase 4 - parallel)
  │   └─ code-reviewer (peer review)
  ├─ qa-coordinator (Phase 5)
  ├─ refactor-specialist (Phase 6)
  ├─ release-specialist (Phase 7)
  ├─ ci-validation-specialist (Phase 8)
  └─ learning-evolution-specialist (Phase 9)
```

## Documentation

- **README.md** - Architecture overview
- **QUICKSTART.md** - Quick start guide
- **GETTING-STARTED.md** - Comprehensive usage guide
- **COLLECTION-DETECTION.md** - Multi-location detection system
- **ENHANCEMENT-DETECTION-SUMMARY.md** - Enhancement mode reference
- **MANIFEST.md** - Complete file listing
- **DEPLOYMENT.md** - Installation and deployment
- **STATUS.md** - Build status and features
- **FINAL-SUMMARY.md** - Complete system summary

## Support

For issues or questions:
1. Check documentation in swarm directory
2. Review agent definitions in `core/agents/`
3. Check pattern library in `knowledge/patterns/`
4. Review examples in `resources/`

## Version

Current version: 1.0.0  
Last updated: 2026-05-28
