# Windows Collection Swarm - Autonomous Agent Army

A multi-agent system for fully autonomous Windows Ansible collection development from Jira Epics.

## Overview

This swarm replaces the single-agent Gemini skill `windows-collection-architect` with a coordinated team of 7 specialized agents that operate with **Extreme Autonomy** according to the Jarvis Framework.

## Architecture

```
                    ┌─────────────────────┐
                    │  Lead Architect     │
                    │  (Orchestrator)     │
                    └──────────┬──────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                  │
     ┌──────▼──────┐    ┌─────▼──────┐    ┌─────▼──────┐
     │   Jira      │    │Foundation  │    │  Release   │
     │ Ingestion   │    │ Specialist │    │ Specialist │
     └─────────────┘    └────────────┘    └────────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
             ┌──────▼──────┐       ┌─────▼──────┐
             │   Module    │       │    QA      │
             │   Workers   │       │Coordinator │
             │ (Parallel)  │       └────────────┘
             └──────┬──────┘              
                    │
             ┌──────▼──────┐
             │  Refactor   │
             │ Specialist  │
             └─────────────┘
```

## The Agent Team

### 1. Lead Architect (`lead-architect.md`)
- **Model**: Claude Opus 4.7
- **Role**: Chief Automation Officer
- **Responsibilities**:
  - Orchestrate end-to-end lifecycle
  - Coordinate all other agents
  - Manage batch processing (3-5 modules per batch)
  - Enforce decennial audit (every 10 modules)
  - Track progress in module backlog
- **Autonomy**: 100% - never asks for permission, self-corrects failures (3 attempts)

### 2. Jira Ingestion Specialist (`jira-ingestion-specialist.md`)
- **Model**: Claude Sonnet 4.5
- **Role**: Requirements Analyst
- **Responsibilities**:
  - Recursive Jira Epic analysis (ANSTRAT → Epics → Stories)
  - Extract all module requirements
  - Generate `docs/plans/module_backlog.md` (Single Source of Truth)
  - Provide flat list of modules with Jira IDs
- **Key Feature**: Non-interactive execution (`PAGER=cat`, `--no-input`)

### 3. Foundation Specialist (`foundation-specialist.md`)
- **Model**: Claude Sonnet 4.5
- **Role**: Infrastructure-as-Code Specialist
- **Responsibilities**:
  - Scaffold collection workspace
  - Copy custom Jarvis templates (NOT `ansible-galaxy init`)
  - Inject baseline assets (Azure Pipelines, inventory, README)
  - Configure `galaxy.yml` with namespace and name
- **Location**: `~/agentic-workflow-collections/<namespace>/<name>/`

### 4. Module Workers (`module-worker.md`)
- **Model**: Claude Sonnet 4.5
- **Role**: Senior PowerShell & Ansible Developers
- **Responsibilities**:
  - Build individual Windows modules
  - Use 5 Pillars of Introspection (Cmdlets, WMI, CIM, .NET, Registry)
  - Create 4-stage integration tests
  - Write complete documentation (DOCUMENTATION, EXAMPLES, RETURN)
- **Concurrency**: 3-5 workers run in parallel per batch
- **Isolation**: Each worker handles exactly 1 module, forbidden from modifying shared files

### 5. QA Coordinator (`qa-coordinator.md`)
- **Model**: Claude Sonnet 4.5
- **Role**: Technical Reviewer & SDET
- **Responsibilities**:
  - Execute 4-stage testing loop:
    1. Initial Run
    2. Idempotency
    3. Check Mode
    4. Error Handling
  - Invoke code-reviewer agent for peer review
  - Apply fixes autonomously
  - Gate module approval (no module proceeds without passing all stages)
- **Execution**: Sequential testing (Windows host limitation)

### 6. Refactor Specialist (`refactor-specialist.md`)
- **Model**: Claude Opus 4.7
- **Role**: Technical Debt Architect
- **Responsibilities**:
  - Analyze completed modules every 10 modules (Decennial Audit)
  - Identify duplicated PowerShell logic
  - Extract common patterns to `plugins/module_utils/`
  - Refactor existing modules to use utilities
  - Run full regression tests
- **Critical**: Pauses all parallel work during refactoring

### 7. Release Specialist (`release-specialist.md`)
- **Model**: Claude Sonnet 4.5
- **Role**: DevOps & Delivery Engineer
- **Responsibilities**:
  - Conduct four-pillar audit (Completeness, Quality, Consistency, Deliverability)
  - Execute git operations (add, commit, push)
  - Verify remote repository state
  - Generate delivery report
- **Trigger**: Only when 100% of backlog is marked `[x] DONE`

## Operational Principles

### Extreme Autonomy
1. **No Permission Seeking**: Agents execute without asking for approval between phases
2. **Self-Correction**: 3 attempts to fix failures before reporting
3. **Technical Decisions**: Autonomous parameter naming, type selection, implementation choices
4. **Zero Brainstorming**: Architecture is pre-defined, agents proceed immediately to execution

### Quality Gates
- **Entry Gate**: Jira ticket must have clear module requirements
- **Build Gate**: Module must pass 4-stage testing loop
- **Review Gate**: Module must pass code-reviewer agent approval
- **Refactor Gate**: Triggered every 10 modules, all work pauses
- **Delivery Gate**: 100% backlog completion + four-pillar audit

### The 5 Pillars of Introspection
Module Workers autonomously choose implementation approach:
1. **PowerShell Cmdlets** (Highest preference)
2. **CIM** (Modern, preferred for Windows Server 2012+)
3. **WMI** (Legacy, when CIM unavailable)
4. **.NET Framework** (Complex operations)
5. **Registry** (Configuration, use sparingly)

### The 4-Stage Testing Loop
Every module must pass:
1. **Initial Run**: Basic functionality works
2. **Idempotency**: Second run shows `changed: false`
3. **Check Mode**: Dry-run reports correctly without changes
4. **Error Handling**: Invalid input fails gracefully

### The Decennial Audit
Every 10 completed modules:
1. Pause all parallel module development
2. Analyze all modules for duplicated logic
3. Extract patterns to `plugins/module_utils/`
4. Refactor completed modules to use utilities
5. Run regression tests (all tests must still pass)
6. Resume module development

### The Four-Pillar Audit (Delivery)
Before git push:
1. **Completeness**: All modules from backlog exist
2. **Quality**: All tests pass, no linting errors
3. **Consistency**: Naming, error handling, documentation uniform
4. **Deliverability**: Collection builds, no sensitive data

## Usage

### Via Claude Code Skill
```bash
/windows-collection-swarm ANSTRAT-12345
```

### Programmatic Invocation
```python
Agent(
    subagent_type="lead-architect",
    description="Build Windows collection from ANSTRAT-12345",
    prompt="""Build complete Windows Ansible collection from Epic ANSTRAT-12345.
    
    Execute full Jarvis Framework lifecycle with extreme autonomy.
    Deploy agents: jira-ingestion → foundation → module-workers (parallel batches) → 
    qa-coordinator → refactor-specialist (every 10) → release-specialist.
    
    Report only on completion or unrecoverable errors."""
)
```

## File Structure

```
~/.claude/agents/windows-collection-swarm/
├── README.md                        # This file
├── lead-architect.md                # Orchestrator agent
├── jira-ingestion-specialist.md     # Epic analysis agent
├── foundation-specialist.md         # Workspace scaffolding agent
├── module-worker.md                 # Module implementation agent
├── qa-coordinator.md                # Testing & review agent
├── refactor-specialist.md           # Code abstraction agent
└── release-specialist.md            # Delivery agent

~/.claude/skills/
└── windows-collection-swarm.md      # Skill that spawns the swarm
```

## Output Structure

The swarm creates collections in:
```
~/agentic-workflow-collections/<namespace>/<name>/
├── .azure-pipelines/                # CI/CD configuration
├── docs/
│   ├── plans/
│   │   └── module_backlog.md        # Single Source of Truth
│   └── module_utils.md              # Utilities documentation
├── plugins/
│   ├── modules/                     # Generated modules
│   │   ├── module_1.ps1
│   │   ├── module_2.ps1
│   │   └── ...
│   └── module_utils/                # Shared utilities (from refactoring)
│       ├── json_handler.psm1
│       ├── sid_lookup.psm1
│       └── ...
├── tests/
│   ├── integration/
│   │   └── targets/
│   │       ├── module_1/
│   │       │   └── tasks/main.yml
│   │       ├── module_2/
│   │       │   └── tasks/main.yml
│   │       └── ...
│   └── inventory.winrm
├── .gitignore
├── .galaxy-ignore
├── azure-pipelines.yml
├── galaxy.yml
└── README.md
```

## Monitoring Progress

### Real-time Progress
Watch the module backlog:
```bash
cat ~/agentic-workflow-collections/<namespace>/<name>/docs/plans/module_backlog.md
```

### Completion Metrics
```bash
# Count completed modules
grep -c '^\- \[x\]' docs/plans/module_backlog.md

# Count total modules
grep -c '^\- \[' docs/plans/module_backlog.md

# Count created modules
ls -1 plugins/modules/*.ps1 | wc -l

# Count test suites
find tests/integration/targets -type d -depth 1 | wc -l
```

### Agent Activity
```bash
# Check last git commit
cd ~/agentic-workflow-collections/<namespace>/<name>
git log -1 --oneline

# Check test results
ansible-test integration --list-targets
```

## Troubleshooting

### Epic Analysis Fails
- **Symptom**: No `docs/plans/module_backlog.md` created
- **Cause**: Jira authentication or invalid Epic key
- **Fix**: Verify Jira credentials, verify Epic key format
- **Agent**: Jira Ingestion Specialist will retry 3 times

### Module Build Fails
- **Symptom**: Module Worker reports failure
- **Cause**: Unclear Jira requirements, technical complexity
- **Fix**: Agent will try 3 alternative approaches (different Pillars)
- **Escalation**: If all 3 fail, Lead Architect receives diagnostic report

### Tests Fail
- **Symptom**: QA Coordinator reports test failure
- **Cause**: Module bug, test environment issue
- **Fix**: QA Coordinator auto-fixes (3 attempts), reruns tests
- **Escalation**: If unfixable, reported to Lead Architect

### Refactoring Breaks Tests
- **Symptom**: Regression tests fail after refactoring
- **Cause**: Utility interface mismatch, behavioral change
- **Fix**: Refactor Specialist rolls back changes for failing modules
- **Prevention**: Regression tests run after every refactor

### Delivery Blocked
- **Symptom**: Release Specialist refuses to proceed
- **Cause**: Four-pillar audit failure (incomplete backlog, failing tests, etc.)
- **Fix**: Release Specialist reports specific failures to Lead Architect
- **Manual**: May require manual intervention to fix blocking issues

## Comparison to Original Skill

| Aspect | Original (Gemini) | New (Swarm) |
|--------|------------------|-------------|
| **Execution** | Single monolithic agent | 7 specialized agents |
| **Parallelization** | Sequential module building | 3-5 modules in parallel |
| **Error Handling** | Single point of failure | Distributed self-correction |
| **Scalability** | Limited by single agent context | Scales with batch size |
| **Specialization** | Generalist approach | Expert agents per domain |
| **Autonomy** | Moderate | Extreme (3 self-correction attempts) |
| **Testing** | Manual trigger | Automated 4-stage loop |
| **Refactoring** | Optional | Mandatory every 10 modules |
| **Code Review** | Optional | Mandatory for all modules |

## Performance Characteristics

### Expected Timeline (30-module Epic)
- **Ingestion**: 2-5 minutes (recursive Epic analysis)
- **Foundation**: 1-2 minutes (scaffolding)
- **Build**: 60-90 minutes (6 batches × 10-15 min/batch)
- **Refactoring**: 15-20 minutes (at module 10, 20, 30)
- **Delivery**: 5-10 minutes (audit + git push)
- **Total**: ~90-120 minutes (1.5-2 hours)

### Bottlenecks
- **Windows Test Host**: Sequential testing (cannot parallelize)
- **Jira API**: Rate limits on recursive queries
- **Code Review**: One review per module (could parallelize in future)

### Optimization Opportunities
- Increase batch size for large Epics (batch_size=5)
- Cache Jira responses for repeated queries
- Pre-warm Windows test host
- Parallelize code reviews (multiple reviewer agents)

## Future Enhancements

### Planned
- [ ] Adaptive batch sizing (auto-adjust based on complexity)
- [ ] Parallel code reviews (multiple reviewer agents)
- [ ] Incremental Epics (add modules to existing collections)
- [ ] Multi-collection support (multiple Epics in parallel)
- [ ] Performance profiling (track agent execution times)

### Under Consideration
- [ ] Agent telemetry (track success rates, failure patterns)
- [ ] Auto-tuning (learn optimal batch sizes, refactor frequency)
- [ ] Collection versioning (semantic versioning automation)
- [ ] Galaxy publishing (auto-publish to Ansible Galaxy)

## License

This agent swarm is part of the Jarvis Framework for Windows Ansible automation.

## Support

For issues or questions:
1. Check agent logs in Claude Code session
2. Review `docs/plans/module_backlog.md` for progress
3. Inspect failing module/test output
4. Report unrecoverable errors to Jarvis Framework maintainers

---

**Built for Extreme Autonomy. Powered by Claude Opus 4.7 & Sonnet 4.5.**
