# Windows Collection Swarm - Complete Manifest

This document lists all files in the swarm and their purpose. Use for verification and troubleshooting.

## Version

- **Swarm Version**: 1.0.0
- **Created**: 2026-05-27
- **Target Platform**: Claude Code (all platforms)
- **Autonomy Level**: Extreme (3 self-correction attempts)

## Directory Structure

```
~/.claude/agents/windows-collection-swarm/
├── README.md                           # Main documentation
├── DEPLOYMENT.md                       # Installation and setup guide
├── MANIFEST.md                         # This file
├── agents/                             # Agent definitions (7 agents)
│   ├── lead-architect.md               # Orchestrator agent (Opus)
│   ├── jira-ingestion-specialist.md    # Epic analysis agent (Sonnet)
│   ├── foundation-specialist.md        # Scaffolding agent (Sonnet)
│   ├── module-worker.md                # Implementation agent (Sonnet, parallel)
│   ├── qa-coordinator.md               # Testing agent (Sonnet)
│   ├── refactor-specialist.md          # Refactoring agent (Opus)
│   ├── release-specialist.md           # Delivery agent (Sonnet)
│   ├── invoke-swarm.md                 # Invocation template
│   ├── QUICKSTART.md                   # Quick start guide
│   └── README.md                       # Agents documentation
├── templates/                          # Collection templates
│   └── collection_template/            # Ansible collection structure
│       ├── galaxy.yml                  # Collection metadata (with placeholders)
│       ├── README.md                   # Collection documentation (with placeholders)
│       ├── azure-pipelines.yml         # CI/CD configuration
│       ├── .gitignore                  # Git ignore rules
│       ├── .azure-pipelines/           # CI/CD templates
│       │   └── matrix.yml              # Test matrix configuration
│       ├── docs/                       # Documentation directory
│       │   └── plans/                  # Planning directory (populated at runtime)
│       ├── plugins/                    # Ansible plugins
│       │   ├── modules/                # Module directory (populated at runtime)
│       │   └── module_utils/           # Shared utilities (populated at runtime)
│       └── tests/                      # Testing infrastructure
│           ├── integration/            # Integration tests
│           │   └── targets/            # Test targets (populated at runtime)
│           └── inventory.winrm         # WinRM inventory for Windows hosts
├── resources/                          # Guides and documentation
│   ├── 5-pillars-guide.md              # Implementation decision guide
│   └── 4-stage-testing-guide.md        # Testing requirements guide
├── examples/                           # Example modules and tests
│   ├── module_example_cmdlet.ps1       # Pillar 1: PowerShell Cmdlets example
│   ├── module_example_cim.ps1          # Pillar 3: CIM example
│   ├── module_example_registry.ps1     # Pillar 5: Registry example
│   └── test_example_4stage.yml         # 4-stage test template
└── docs/                               # Additional documentation (optional)
```

## File Inventory

### Root Documentation (4 files)
- `README.md` - Main overview and quick reference
- `DEPLOYMENT.md` - Complete installation guide
- `MANIFEST.md` - This file listing
- (Future) `CHANGELOG.md` - Version history

### Agents (13 files)
All located in `agents/`:

1. **lead-architect.md**
   - Purpose: Chief Automation Officer, orchestrates entire 9-phase lifecycle
   - Model: Opus 4.7
   - Autonomy: 100% (never asks permission)
   - Responsibilities: Phase management, batch coordination, audit enforcement, learning triggers

2. **jira-ingestion-specialist.md**
   - Purpose: Requirements Analyst, natural language Epic analysis
   - Model: Opus 4.7 (requires reasoning)
   - Input: Jira Epic key
   - Output: `docs/plans/module_backlog.md` + `docs/plans/prerequisites.md`
   - Intelligence: Understands context, infers dependencies

3. **foundation-specialist.md**
   - Purpose: Infrastructure Specialist, workspace scaffolding
   - Model: Sonnet 4.5
   - Input: Namespace, collection name
   - Output: Complete collection directory structure

4. **platform-prerequisite-specialist.md**
   - Purpose: Environment Setup Engineer, intelligent installation
   - Model: Opus 4.7 (requires decision-making)
   - Input: `prerequisites.md` (natural language)
   - Capabilities: 3-attempt recovery, degraded environments, any Windows platform
   - Output: Installed environment or `blocked_modules.md`

5. **module-worker.md**
   - Purpose: Module Developer, implements individual modules
   - Model: Sonnet 4.5
   - Concurrency: 3-5 workers in parallel per batch
   - Guides: Uses 5-pillars-guide.md and 4-stage-testing-guide.md

6. **qa-coordinator.md**
   - Purpose: Quality Assurance, testing and review
   - Model: Sonnet 4.5
   - Responsibility: 4-stage testing loop enforcement, blocked modules tracking
   - Gates: No module proceeds without all stages passing
   - Output: Test results + `blocked_modules.md` (if environment issues)

7. **refactor-specialist.md**
   - Purpose: Technical Debt Architect, code abstraction
   - Model: Opus 4.7
   - Trigger: Every 10 completed modules
   - Output: Utilities in `plugins/module_utils/`

8. **release-specialist.md**
   - Purpose: Deployment Engineer, dual repository delivery
   - Model: Sonnet 4.5
   - Responsibility: Four-pillar audit, internal git push, external temp repo push
   - Trigger: 100% backlog completion
   - Output: Collection in both repos

9. **ci-validation-specialist.md**
   - Purpose: Pipeline Monitor & Fixer, autonomous CI/CD validation
   - Model: Opus 4.7 (requires debugging intelligence)
   - Responsibility: Monitor GitHub workflows + Azure Pipelines, fix failures
   - Strategy: Fix-amend-push cycle until all checks green
   - Autonomy: Can force push to temp repository

10. **learning-evolution-specialist.md**
    - Purpose: Continuous Improvement Engine, swarm intelligence evolution
    - Model: Opus 4.7 (requires analysis and reasoning)
    - Trigger: Failures (3 attempts exhausted), successes, periodic review
    - Responsibility: Root cause analysis, agent updates, documentation enhancement
    - Output: `docs/lessons_learned.md`, updated agents, improved guides
    - Impact: Swarm gets smarter over time

11. **invoke-swarm.md**
    - Purpose: Template for direct agent invocation
    - Usage: Copy Agent(...) call, replace Epic key
    - No code execution, just documentation

12. **QUICKSTART.md**
    - Purpose: Quick reference for using the swarm
    - Audience: End users
    - Content: One-command deployment examples

13. **README.md** (agents subdirectory)
    - Purpose: Agent system overview
    - Content: Architecture diagrams, agent coordination

### Templates (7 files)
Located in `templates/collection_template/`:

1. **galaxy.yml**
   - Purpose: Collection metadata
   - Placeholders: NAMESPACE_PLACEHOLDER, NAME_PLACEHOLDER
   - Required: Must be updated by Foundation Specialist

2. **README.md**
   - Purpose: Collection documentation
   - Placeholders: NAMESPACE_PLACEHOLDER, NAME_PLACEHOLDER
   - Content: Installation, usage, requirements

3. **azure-pipelines.yml**
   - Purpose: Main CI/CD pipeline
   - Stages: Sanity tests, integration tests
   - Platform: Azure DevOps

4. **.gitignore**
   - Purpose: Git ignore rules
   - Excludes: *.pyc, __pycache__, .pytest_cache, etc.

5. **.azure-pipelines/matrix.yml**
   - Purpose: Test matrix configuration
   - Versions: Python, Windows, Ansible versions

6. **tests/inventory.winrm**
   - Purpose: WinRM inventory for integration tests
   - Contents: Example Windows hosts (MUST be customized)
   - Security: Contains credentials (customize before use)

7. **Directory structure files**
   - Empty `.gitkeep` files in: docs/plans, plugins/modules, plugins/module_utils, tests/integration/targets

### Resources (5 files)
Located in `resources/`:

1. **5-pillars-guide.md**
   - Purpose: Implementation decision guide
   - Content: Decision tree, patterns, examples for choosing implementation approach
   - Used by: Module Workers
   - Topics: Cmdlets, WMI, CIM, .NET, Registry

2. **4-stage-testing-guide.md**
   - Purpose: Testing requirements documentation
   - Content: Complete testing loop specification
   - Used by: Module Workers, QA Coordinator
   - Stages: Initial Run, Idempotency, Check Mode, Error Handling

3. **platform-installation-guide.md**
   - Purpose: General installation patterns for Windows platforms
   - Content: Reference patterns (not templates) for common platforms
   - Used by: Platform Prerequisite Specialist
   - Platforms: SCVMM, Hyper-V, SQL Server, IIS, AD, DNS, DHCP, etc.

4. **blocked-modules-tracking.md**
   - Purpose: System for tracking untestable modules with resume capability
   - Content: Manifest format, resume scripts, workflow integration
   - Used by: QA Coordinator, users fixing environment
   - Enables: Progressive testing, 100% coverage when environment fixed

5. **FAILURE-HANDLING.md**
   - Purpose: 3-attempt recovery strategy and degraded environment handling
   - Content: Real-world examples, decision trees, user interaction patterns
   - Used by: All agents (reference for failure handling)
   - Covers: Installation failures, resource constraints, unknown software

### Examples (4 files)
Located in `examples/`:

1. **module_example_cmdlet.ps1**
   - Purpose: Reference implementation using PowerShell Cmdlets (Pillar 1)
   - Demonstrates: Idempotency, check mode, error handling
   - Lines: ~70

2. **module_example_cim.ps1**
   - Purpose: Reference implementation using CIM (Pillar 3)
   - Demonstrates: System information queries
   - Lines: ~60

3. **module_example_registry.ps1**
   - Purpose: Reference implementation using Registry (Pillar 5)
   - Demonstrates: Registry operations, idempotency
   - Lines: ~80

4. **test_example_4stage.yml**
   - Purpose: 4-stage test template
   - Demonstrates: All 4 testing stages with assertions
   - Lines: ~120

## File Sizes

Approximate sizes:
- Total swarm: ~800 KB
- Agents: ~350 KB (10 agent definition files)
- Templates: ~50 KB
- Resources: ~250 KB (5 comprehensive guides)
- Examples: ~20 KB (4 reference files)
- Documentation: ~230 KB (README, DEPLOYMENT, MANIFEST, lessons_learned_template)

## Dependencies

### External Tools Required
- `jira-rh` - Jira CLI tool (for Epic analysis)
- `git` - Version control
- `ansible-test` - Testing framework
- `ansible-galaxy` - Collection management

### Claude Code Requirements
- Agent spawning capability
- File I/O operations
- Bash command execution
- Background task support

### No External File References
- ✅ All templates self-contained
- ✅ All guides self-contained
- ✅ All examples self-contained
- ✅ No references to files outside swarm directory

## Verification Checklist

Use this checklist to verify swarm integrity:

### Critical Files (Must Exist)
- [ ] `README.md`
- [ ] `DEPLOYMENT.md`
- [ ] `agents/lead-architect.md`
- [ ] `agents/jira-ingestion-specialist.md`
- [ ] `agents/foundation-specialist.md`
- [ ] `agents/module-worker.md`
- [ ] `agents/qa-coordinator.md`
- [ ] `agents/refactor-specialist.md`
- [ ] `agents/release-specialist.md`
- [ ] `templates/collection_template/galaxy.yml`
- [ ] `templates/collection_template/tests/inventory.winrm`
- [ ] `resources/5-pillars-guide.md`
- [ ] `resources/4-stage-testing-guide.md`

### Example Files (Should Exist)
- [ ] At least 3 PowerShell examples in `examples/`
- [ ] At least 1 YAML test example in `examples/`

### Template Completeness
- [ ] `galaxy.yml` contains NAMESPACE_PLACEHOLDER
- [ ] `galaxy.yml` contains NAME_PLACEHOLDER
- [ ] `README.md` contains placeholders
- [ ] `.gitignore` includes Python artifacts
- [ ] `tests/inventory.winrm` has [windows] group

### Self-Contained Paths
- [ ] No references to `/Users/hyaish/.gemini/`
- [ ] All paths use `~/.claude/agents/windows-collection-swarm/`
- [ ] No external skill activations
- [ ] All agent prompts reference internal resources

## Customization Points

Users can customize these without breaking the swarm:

### Safe to Modify
- `templates/collection_template/tests/inventory.winrm` - Your Windows hosts
- `templates/collection_template/README.md` - Collection description
- `templates/collection_template/galaxy.yml` - Metadata (except placeholders)
- `agents/lead-architect.md` - Batch size parameter

### Modify with Caution
- Agent prompts in `agents/*.md` - Behavior changes
- Test matrix in `templates/collection_template/.azure-pipelines/matrix.yml`

### Do Not Modify
- `resources/*.md` - Core guides referenced by agents
- `examples/*.ps1` - Reference implementations
- Directory structure - Agents expect specific paths

## Portable Archive Creation

To create a portable archive:

```bash
cd ~/.claude/agents
tar -czf windows-collection-swarm-v1.0.0.tar.gz \
  --exclude='.git' \
  --exclude='.DS_Store' \
  windows-collection-swarm/

# Verify archive
tar -tzf windows-collection-swarm-v1.0.0.tar.gz | head -20
```

## Version History

### v2.0.0 (2026-05-27)
- **10 agent definitions** (added Platform Prerequisites, CI/CD Validation, Learning & Evolution)
- Complete 9-phase lifecycle (Ingestion → Foundation → Prerequisites → Build → QA → Refactor → Delivery → CI/CD → Learning)
- **5 comprehensive guides** (5 Pillars, 4 Stage Testing, Platform Installation, Blocked Modules, Failure Handling)
- **Flexible intelligence**: Natural language understanding, works for ANY Windows project
- **3-attempt recovery** with degraded environment strategy
- **Resume testing capability** for blocked modules
- **External repository push** to temp repo for CI/CD validation
- **Continuous learning** system that improves agents over time
- **Full self-containment** - zero external file dependencies
- Lessons learned database template

### v1.0.0 (2026-05-27 - superseded)
- Initial release
- 7 agent definitions
- Complete template library
- 2 comprehensive guides
- 4 example implementations

## Troubleshooting

### Missing Files
If verification fails, check:
1. Archive extraction completed fully
2. File permissions are correct (755 for dirs, 644 for files)
3. Symlinks (if any) are valid

### Broken Paths
If agents can't find resources:
1. Verify `~/.claude/agents/windows-collection-swarm/` exists
2. Check `resources/` and `templates/` subdirectories
3. Look for typos in file names

### Template Issues
If Foundation Specialist fails:
1. Verify `templates/collection_template/galaxy.yml` exists
2. Check for PLACEHOLDER strings in galaxy.yml
3. Ensure `tests/inventory.winrm` exists

## Contact & Support

For issues with the swarm:
1. Check `DEPLOYMENT.md` for troubleshooting
2. Verify all files exist per this manifest
3. Review agent logs in Claude Code
4. Check generated `docs/plans/module_backlog.md`

---

**Manifest Version**: 1.0.0  
**Last Updated**: 2026-05-27  
**Total Files**: 27 core files + template structure  
**Total Size**: ~500 KB  
**Portability**: 100% self-contained
