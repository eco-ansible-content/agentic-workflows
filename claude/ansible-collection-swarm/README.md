# Universal Ansible Collection Swarm

**Intelligence-based multi-agent system for building ANY Ansible collection autonomously.**

## What Makes This Universal

❌ **NOT template-based**: No hardcoded platforms (Windows, Azure, Cisco, etc.)  
✅ **Intelligence-based**: Understands characteristics, learns patterns, adapts to ANY platform  
✅ **Works for platforms that don't exist yet**: Researches, learns, implements

## Core Principle

**Characteristics over classifications.**

Instead of asking "Is this Windows, Azure, or Cisco?" the swarm asks:
- What are we automating?
- How does it work? (API, CLI, config files)
- What language/SDK is used?
- How do we test it?
- What prerequisites are needed?

## Architecture

```
ansible-collection-swarm/
├── core/                          # Universal framework (platform-agnostic)
│   ├── agents/                    # 10 intelligent agents
│   └── templates/                 # Generic collection structure
│
├── knowledge/                     # Pattern library (NOT platform templates)
│   ├── patterns/                  # Reusable implementation patterns
│   └── examples/                  # Generic reference implementations
│
├── resources/                     # Guides and documentation
└── docs/                          # Learning database, lessons learned
```

## The 10 Agents

### 1. Lead Architect (Opus)
**Role**: Chief orchestrator, 9-phase lifecycle manager  
**Autonomy**: 100% (never asks permission after context gathering)  
**NEW**: Asks 2 critical questions upfront:
  1. Where should tests run? (test environment details)
  2. Where should results go? (local or git repository)

### 2. Jira Ingestion Specialist (Opus)
**Role**: Epic analyst, extracts characteristics (not platform names)  
**Intelligence**: Reads natural language, infers dependencies, understands context  
**Output**: Module backlog + prerequisites (characteristics-based)

### 3. Foundation Specialist (Sonnet)
**Role**: Workspace scaffolder  
**Output**: Generic collection structure (works for any platform)

### 4. Platform Prerequisite Specialist (Opus)
**Role**: Environment setup engineer  
**Intelligence**: Reads prerequisites, researches installation, adapts to ANY platform  
**Strategy**: 3-attempt recovery, degraded environments, resume capability

### 5. Module Worker (Sonnet)
**Role**: Module implementer  
**Intelligence**: Researches platform APIs, finds similar patterns, adapts implementation  
**Pattern library**: REST API, CLI-based, config files, databases, etc.  
**Parallel**: 3-5 workers per batch

### 6. QA Coordinator (Sonnet)
**Role**: Testing orchestrator  
**Intelligence**: Adapts test strategy based on platform characteristics  
**Output**: Test results, blocked modules tracking

### 7. Refactor Specialist (Opus)
**Role**: Technical debt manager  
**Trigger**: Every 10 modules  
**Output**: Shared utilities, regression tests

### 8. Release Specialist (Sonnet)
**Role**: Delivery engineer  
**Responsibility**: Four-pillar audit, local commit, optional git push  
**Context-aware**: Uses delivery target from Phase 0

### 9. CI/CD Validation Specialist (Opus)
**Role**: Pipeline monitor & fixer  
**Strategy**: Fix-amend-push cycle until all checks green  
**Autonomy**: Can force push to temp repository

### 10. Learning & Evolution Specialist (Opus)
**Role**: Continuous improvement engine  
**Trigger**: Failures, successes, periodic reviews  
**Output**: Updated agents, improved patterns, lessons learned database  
**Impact**: Swarm gets smarter over time

## Usage

### Basic Invocation

```bash
# From Claude Code
Agent({
  description: "Build Ansible collection from Epic",
  prompt: "Build collection from Jira Epic WINOPS-2345"
})
```

### What Happens

**Phase 0: Context Gathering** (NEW)
- Lead Architect asks: "Where should tests run?"
- Lead Architect asks: "Where should results go?"
- Creates `project_context.yml` with your environment

**Phase 1-9**: Automatic execution
1. Ingestion → Understand requirements
2. Foundation → Scaffold workspace
3. Prerequisites → Setup environment (using your test host)
4. Build → Implement modules (parallel batches)
5. QA → Test modules (against your test environment)
6. Refactor → Extract utilities
7. Delivery → Commit and optionally push (to your git repo)
8. CI/CD → Fix pipeline failures autonomously
9. Learning → Capture knowledge for next build

## Example: SolarWinds Collection (Never Seen Before)

**User**: "Build collection for SolarWinds Orion EPIC-9999"

**Swarm asks**:
- Test environment? → `192.168.1.50, winrm, user: admin, pass: Solar123!`
- Delivery target? → `https://github.com/myorg/ansible-collections.git`

**Swarm intelligence**:
1. Research: "What is SolarWinds Orion?" → Network monitoring platform
2. Research: "How to automate SolarWinds?" → REST API (SWIS)
3. Pattern match: Similar to other REST API platforms
4. Implement: Using REST API pattern (GET-compare-PUT)
5. Test: Against 192.168.1.50 test server
6. Deliver: Push to GitHub repo

✅ **Works despite never being coded for SolarWinds!**

## Platform Examples (All Supported via Intelligence)

### Windows Platforms
- SCVMM, Hyper-V, IIS, SQL Server, Active Directory
- Pattern: PowerShell cmdlets, WinRM connection
- Auto-detected: Keywords like "PowerShell", "WMI", "CIM"

### Cloud Platforms
- Azure, AWS, GCP, VMware
- Pattern: REST API, SDK (Python), local execution
- Auto-detected: Keywords like "API", "SDK", "subscription"

### Network Platforms
- Cisco, Juniper, Arista, F5
- Pattern: network_cli, NETCONF, REST API
- Auto-detected: Keywords like "VLAN", "IOS", "switch"

### Linux Platforms
- systemd, package managers, firewall
- Pattern: Shell commands, SSH connection
- Auto-detected: Keywords like "systemd", "apt", "yum"

### Custom Applications
- ANY third-party software with automation interface
- Pattern: Discovered via research (API, CLI, config files)
- Auto-detected: Research platform documentation

## Pattern Library

Instead of platform-specific guides, the swarm uses **generic patterns**:

### REST API Pattern
**Applies to**: Azure, AWS, SolarWinds, Jira, ServiceNow, Splunk, etc.
```python
# GET current state
current = api_client.get(resource_id)
# Compare with desired
if current != desired:
    # PUT changes
    api_client.update(resource_id, desired)
    changed = True
```

### CLI-Based Pattern
**Applies to**: Cisco, Linux, Windows PowerShell, etc.
```python
# Run check command
current = connection.run(check_command)
# Parse output
parsed = parse(current)
# Apply if needed
if needs_change(parsed, desired):
    connection.run(apply_command)
    changed = True
```

### Config File Pattern
**Applies to**: Kubernetes, Docker, Terraform, etc.
```python
# Read config file
current = read_file(path)
# Compare
if current != desired:
    # Write new config
    write_file(path, desired)
    changed = True
```

## Learning Database

**Cross-platform lessons** tagged by characteristics:

```markdown
Lesson #045: Installer Timeout Detection
- Applies to: ANY software installation
- Platforms: Windows, Linux, network firmware, etc.

Lesson #067: API Rate Limiting
- Applies to: ANY REST/SOAP API
- Platforms: Azure, AWS, SolarWinds, Jira, etc.
```

SQL lesson helps PostgreSQL. Azure auth lesson helps AWS. Cisco idempotency lesson helps Windows.

## Success Criteria

The swarm is truly universal when:

✅ Can build collection for platform that doesn't exist yet  
✅ No "if platform == X" logic anywhere  
✅ Agents learn from research, not templates  
✅ Patterns apply across platforms  
✅ Adding new platform = zero code changes  
✅ Learning database benefits all future builds

## Test Case

**Challenge**: "Build collection for FrobNozzle FluxManager 2030 (manages quantum flux via gRPC API)"

**Expected**: Swarm should:
1. Research: "What is gRPC?" → RPC framework
2. Find: grpcio Python library
3. Pattern: Similar to REST API (but binary protocol)
4. Implement: Using adapted API pattern
5. ✅ **Success** - despite never seeing "FrobNozzle" before

## Key Files

### Core Agents
- `core/agents/lead-architect.md` - Orchestrator with context gathering
- `core/agents/jira-ingestion-specialist.md` - Characteristic extractor
- `core/agents/platform-prerequisite-specialist.md` - Intelligent installer
- `core/agents/module-worker.md` - Pattern-based implementer
- `core/agents/qa-coordinator.md` - Adaptive tester
- `core/agents/learning-evolution-specialist.md` - Continuous improver

### Pattern Library
- `knowledge/patterns/rest-api-pattern.md` - Generic REST pattern
- `knowledge/patterns/cli-based-pattern.md` - Generic CLI pattern
- `knowledge/patterns/config-file-pattern.md` - Generic config pattern

### Resources
- `resources/project-context-examples.md` - Test environment examples
- `resources/pattern-recognition-guide.md` - How to recognize patterns

### Documentation
- `docs/lessons_learned.md` - Cross-platform learning database

## Comparison: Windows Swarm vs Universal Swarm

| Aspect | Windows Swarm | Universal Swarm |
|--------|---------------|-----------------|
| **Platforms** | Windows only | ANY platform |
| **Approach** | Template-based | Intelligence-based |
| **New platform** | Code changes needed | Works automatically |
| **Learning** | Windows-specific | Cross-platform |
| **Context** | Assumes WinRM | Asks user |
| **Delivery** | Fixed git repo | User choice |
| **Flexibility** | Low | Infinite |

## Getting Started

1. **Invoke Lead Architect** with Jira Epic key
2. **Answer 2 questions**:
   - Test environment details (IP, connection, credentials)
   - Delivery target (local or git URL)
3. **Wait for completion** - swarm handles everything autonomously
4. **Review results** - collection ready to use

## Next Steps

- [Deployment Guide](DEPLOYMENT.md) - How to install and configure
- [Architecture Details](ARCHITECTURE.md) - Deep dive into intelligence design
- [Pattern Library](knowledge/patterns/README.md) - Available patterns
- [Examples](knowledge/examples/README.md) - Reference implementations

---

**Version**: 2.0.0 (Universal Intelligence)  
**Created**: 2026-05-27  
**Autonomy Level**: Extreme (3 self-correction attempts)  
**Platforms Supported**: Infinite (learns any platform)
