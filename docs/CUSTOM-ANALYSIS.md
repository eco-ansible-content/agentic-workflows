# Custom Analysis Feature

**NEW in v0.0.3**: Paste your pre-analysis directly when invoking the swarm!

## Overview

For complex projects where you've already done investigation, you can provide custom analysis directly in chat. The Lead Architect will:

1. Parse your analysis (ANY format)
2. Create `docs/plans/PROJECT_BRIEF.md` with structured content
3. All agents automatically follow your custom instructions
4. Unfamiliar steps are executed automatically

## How to Use

### Basic Usage

```bash
/ansible-collection-swarm EPIC-XXX

[Paste your analysis here]

This can include:
- Gap analysis (current state vs required)
- Critical implementation rules  
- Environment prerequisites
- Testing requirements
- Known constraints
- Execution order
- Definition of done
- ANY other context
```

### What Formats Work?

**ALL formats work!** The parser is universal:

- ✅ **Tables** (Markdown tables)
- ✅ **Checklists** (`- [ ]` / `- [x]`)
- ✅ **Numbered lists** (1., 2., 3.)
- ✅ **Bullet lists** (-, *)
- ✅ **Headers** (`##`, `###`)
- ✅ **Emphasis** (`**bold**`, `*italic*`, `` `code` ``)
- ✅ **Keywords** (CRITICAL, MUST, NEVER, ALWAYS)
- ✅ **Freeform text**

---

## Real Examples

### Example 1: SCVMM Gap Analysis

```bash
/ansible-collection-swarm ANSTRAT-2120

## Current State
- Have: 8/97 modules (VM lifecycle only)
- Missing: Templates, Networks, Storage, RBAC (89 modules)

## Critical Rules
1. MUST populate SCVMM fabric BEFORE writing new modules
2. NEVER use mocks - test against live SCVMM 2022
3. Unit tests >80% coverage required (currently 0%)
4. Use ansible.windows >= 2.0.0

## Environment Prerequisites (DO FIRST)

Priority 1:
- Clean up 13 leftover VMs (free 6GB RAM)
- Create Logical Network
- Create VM Template
- Register second host in SCVMM

Priority 2:
- Configure storage classification
- Add VM network

## Testing
Connection: WinRM to 10.46.109.1
Variables: scvmm_server=WIN-5UL8TNLBCNF.scvmm.local
macOS: export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

## Definition of Done
- [ ] 97/97 modules implemented
- [ ] Unit test coverage >80%
- [ ] Integration tests passing on live SCVMM
- [ ] Certified for Automation Hub
```

**What happens**:
1. Lead Architect creates `docs/plans/PROJECT_BRIEF.md`
2. Platform-prerequisite-specialist sees "DO FIRST" → Cleans VMs, creates network/template BEFORE coding
3. Module-worker sees "NEVER use mocks" → Uses live SCVMM for all tests
4. QA-coordinator sees ">80% coverage" → Enforces unit test requirement
5. Release-specialist sees "Certified for Automation Hub" → Adds certification step

---

### Example 2: Simple Bullets

```bash
/ansible-collection-swarm EPIC-456

Current:
- Have module A (basic)
- Missing module B, C

Rules:
- Always use Python SDK instead of CLI parsing
- Test against real API, not mocks
- Do environment setup before coding

Environment:
- API endpoint: https://api.example.com
- Auth: Bearer token in env var
```

**What happens**:
1. Module-worker sees "Always use Python SDK" → Researches SDK, never parses CLI
2. QA-coordinator sees "real API, not mocks" → Skips mock strategy
3. Platform-prerequisite-specialist sees "Do environment setup" → Runs setup phase first

---

### Example 3: Freeform Text

```bash
/ansible-collection-swarm TASK-789

I analyzed the SolarWinds platform and found we need to use the SWIS REST API
instead of parsing PowerShell output. The environment needs cleanup first - 
there are 10 old test nodes consuming RAM. Critical: never allow node reboots 
during module execution because it breaks the monitoring.

Also, the API requires a special certificate that's documented at:
https://docs.solarwinds.com/cert-setup

Test environment: SWIS API at 192.168.1.100:17778
```

**What happens**:
1. Lead Architect parses freeform text, extracts:
   - Rule: "Use SWIS REST API, not PowerShell parsing"
   - Prerequisite: "Cleanup 10 old test nodes"
   - Safety rule: "Never allow node reboots"
   - Environment: API endpoint + cert requirement
2. Creates PROJECT_BRIEF.md with structured sections
3. All agents follow these custom rules

---

## What Gets Extracted?

The parser looks for these patterns (in ANY order, ANY format):

### 1. Current State
**Keywords**: "current state", "progress", "status", "we have", "completed"

**Example**:
```
Current: 8/97 modules
Progress: VM lifecycle done
```

### 2. Requirements
**Keywords**: "requirements", "scope", "must have", "needed", "total"

**Example**:
```
Required: 97 total modules
Scope: Templates, Networks, Storage
```

### 3. Gap Analysis
**Keywords**: "gap", "missing", "todo", "pending", "blockers"

**Example**:
```
Missing: 89 modules
Gap: Templates, Networks, Storage
TODO: Add unit tests
```

### 4. Critical Rules
**Keywords**: "critical", "must", "never", "always", "rules", "do first", "before"

**Example**:
```
MUST populate fabric BEFORE coding
NEVER use mocks
ALWAYS use SDK instead of CLI
```

### 5. Prerequisites
**Keywords**: "prerequisites", "setup", "before", "first", "environment"

**Example**:
```
Before starting:
1. Clean up VMs
2. Create network
3. Register host

Priority 1: Cleanup
Priority 2: Setup
```

### 6. Testing
**Keywords**: "testing", "test", "validation", "qa", "integration", "unit"

**Example**:
```
Test environment: 10.46.109.1
Connection: WinRM
Coverage: >80% required
```

### 7. Constraints
**Keywords**: "constraints", "limitations", "known issues", "problems"

**Example**:
```
Limitations: macOS fork safety
Known issue: Fabric resets on reboot
```

### 8. Definition of Done
**Keywords**: "definition of done", "checklist", "success criteria", "complete when"

**Example**:
```
Complete when:
- [ ] 97/97 modules
- [ ] Tests passing
- [ ] Certified
```

### 9. Priority/Order
**Keywords**: "priority", "order", "sequence", "phase", "immediate", "high"

**Example**:
```
Priority 1: Cleanup
Priority 2: Setup
Immediate: Fix security issue
```

---

## How Agents Use Custom Instructions

### Module Worker
**Reads**:
- Critical Implementation Rules → MUST/NEVER/ALWAYS patterns
- Testing Requirements → Special configurations
- Known Constraints → Limitations

**Applies**:
- "ALWAYS use SDK" → Never parses CLI
- "NEVER allow reboots" → Adds safety checks
- "Use library X" → Researches that specific library

### QA Coordinator
**Reads**:
- Testing Requirements → Coverage, connection details
- Definition of Done → Success criteria
- Known Constraints → Test environment limitations

**Applies**:
- ">80% coverage" → Enforces unit test requirement
- "Test against live API" → Skips mock strategy
- "Connection: WinRM to X" → Uses that host

### Platform Prerequisite Specialist
**Reads**:
- Prerequisites & Environment Setup → Execution order
- Critical Rules → Rules affecting environment
- Custom Execution Steps → Unfamiliar operations

**Applies**:
- "DO FIRST: Cleanup VMs" → Runs cleanup before coding
- "Priority 1: X, Priority 2: Y" → Follows that order
- "Create network, template, host" → Executes those steps

### Release Specialist
**Reads**:
- Definition of Done → Final checklist
- Testing Requirements → Validation steps
- Custom Execution Steps → Additional delivery operations

**Applies**:
- "Certified for Automation Hub" → Adds certification step
- "Coverage >80%" → Adds coverage check to audit
- Custom checklist → Validates each item

---

## Custom Rules vs Generic Patterns

**Key Principle**: Custom rules OVERRIDE generic patterns.

### Override Examples

**Generic Pattern**: "Use collection utilities if available, otherwise SDK"
**Custom Rule**: "ALWAYS use Microsoft.WinGet.Client PowerShell module"
**Result**: Module-worker uses that specific module, doesn't check collection utilities

---

**Generic Pattern**: "Test using available environment (mock or live)"
**Custom Rule**: "NEVER use mocks - test against live SCVMM"
**Result**: QA-coordinator skips mock strategy entirely

---

**Generic Pattern**: "Install prerequisites in discovered order"
**Custom Rule**: "Priority 1: Cleanup, Priority 2: Setup"
**Result**: Platform-prerequisite-specialist follows that specific order

---

## Unfamiliar Steps

If your analysis includes steps NOT part of the standard workflow, agents will:

1. **Detect** the unfamiliar step
2. **Research** how to execute it
3. **Integrate** it into the workflow
4. **Execute** it automatically

### Standard Workflow Steps
- Read Jira ticket
- Create collection scaffold
- Install prerequisites
- Implement modules
- Run tests
- Optimize code
- Push to Git
- Validate CI
- Capture learnings

### Example Unfamiliar Steps

**Analysis says**: "Populate SCVMM fabric with Logical Network, VM Template, Host"

**What happens**:
1. Lead Architect identifies this as unfamiliar (not in standard workflow)
2. Adds to PROJECT_BRIEF.md under "Custom Execution Steps"
3. Assigns to platform-prerequisite-specialist (before module build)
4. Specialist researches: "How to create SCVMM Logical Network"
5. Executes: PowerShell commands to populate fabric
6. Continues with standard workflow

---

## PROJECT_BRIEF.md Structure

The auto-generated file contains:

```markdown
# Project Brief: EPIC-XXX

**Source**: User-provided analysis
**Generated**: 2026-07-02T10:30:00Z
**Status**: Active

## Analysis Summary
[1-2 paragraph summary]

## Current State
[Structured extraction of what exists]

## Requirements
[Structured extraction of what's needed]

## Gap Analysis
[What's missing]

## Critical Implementation Rules
**Mandatory**:
1. [MUST rules]

**Forbidden**:
1. [NEVER rules]

**Patterns to follow**:
1. [ALWAYS rules]

## Prerequisites & Environment Setup
**Execution order**:
Priority 1:
- [Step 1]

## Testing Requirements
[Connection, coverage, special configs]

## Known Constraints
[Limitations]

## Definition of Done
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Custom Execution Steps
[Unfamiliar operations detected]

## Additional Context
[Anything else from analysis]

## Integration with Standard Workflow
[How custom steps fit into phases]
```

---

## Tips for Best Results

### 1. Be Specific with Rules
❌ **Vague**: "Use the right library"
✅ **Specific**: "ALWAYS use Microsoft.WinGet.Client PowerShell module"

### 2. Use Priority Indicators
❌ **Unclear**: "Setup environment"
✅ **Clear**: "Priority 1: Cleanup VMs, Priority 2: Create network"

### 3. Include Context
❌ **Missing context**: "Don't use mocks"
✅ **With context**: "NEVER use mocks - we got burned last quarter when mocked tests passed but prod failed"

### 4. Specify Metrics
❌ **Vague**: "Good test coverage"
✅ **Specific**: "Unit test coverage >80%"

### 5. Link to Docs
❌ **Assumed**: "Use the API"
✅ **Verified**: "Use SWIS REST API - https://docs.solarwinds.com/swis-api"

---

## Without Custom Analysis

If you DON'T provide analysis:

```bash
/ansible-collection-swarm EPIC-XXX
```

**Standard workflow**:
1. Lead Architect asks 2-3 context questions
2. Uses generic patterns
3. Agents follow standard workflow
4. No PROJECT_BRIEF.md created

**This still works perfectly!** Custom analysis is optional for when you have specific requirements.

---

## FAQ

### Q: What if my analysis is wrong?

**A**: Agents verify claims before executing. If your analysis says "Use library X" but library X doesn't exist, agents will:
1. Research library X
2. Discover it doesn't exist
3. Find the correct alternative
4. Log the discrepancy

### Q: Can I mix formats?

**A**: Yes! Tables + bullets + freeform text all work together:

```
| Current | Required | Gap |
|---------|----------|-----|
| 8       | 97       | 89  |

Critical rules:
- NEVER use mocks
- ALWAYS test live

I also found that the environment needs cleanup first because
there are 10 old VMs consuming RAM.
```

### Q: What if I forget a section?

**A**: Only provide what you know! Missing sections use generic patterns:

```
/ansible-collection-swarm EPIC-XXX

Current: 8/97 modules
Missing: 89 modules

Rules:
- Use live SCVMM
- Coverage >80%
```

**Result**: Agents use your 2 rules + generic patterns for everything else.

### Q: Can I update PROJECT_BRIEF.md during the run?

**A**: Yes! Edit `docs/plans/PROJECT_BRIEF.md` and agents will read the updated version.

### Q: Do I HAVE to use this feature?

**A**: No! It's completely optional. Standard workflow still works:

```bash
/ansible-collection-swarm EPIC-XXX
# Answer 2-3 questions, done!
```

Custom analysis is for **complex projects** where you've already done investigation.

---

## Version History

- **v0.0.3** (2026-07-02): Custom analysis feature added
- **v0.0.2** (2026-06-15): Universal PR review learnings
- **v0.0.1** (2026-06-10): Initial beta release
