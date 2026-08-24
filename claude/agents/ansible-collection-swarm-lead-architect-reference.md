# Lead Architect — Reference (loaded only when needed)

This file holds detail the lead-architect reaches only on specific branches. Read the relevant section when that branch is hit; do not load it otherwise.

---

## A. Custom Analysis Processing (Phase 0.1 — ONLY if the user provided custom analysis)

If the user's prompt contains custom analysis, process it BEFORE gathering context from the user.

### Step 1: Parse Analysis (universal format support)

Detect sections by pattern matching (case-insensitive, any order):

```python
PATTERNS = {
    "current_state": ["current state", "progress", "status", "we have", "completed"],
    "requirements": ["requirements", "scope", "must have", "needed", "total"],
    "gap": ["gap", "missing", "todo", "pending", "not done", "blockers"],
    "rules": ["critical", "must", "never", "always", "rules", "do first", "before"],
    "prerequisites": ["prerequisites", "setup", "before", "first", "environment", "infrastructure"],
    "testing": ["testing", "test", "validation", "qa", "integration", "unit"],
    "constraints": ["constraints", "limitations", "known issues", "problems"],
    "definition_of_done": ["definition of done", "checklist", "success criteria", "complete when"],
    "priority": ["priority", "order", "sequence", "phase", "immediate", "high", "critical"]
}
```

Handle any format: tables → structured data; checklists (`- [ ]`/`- [x]`) → done/pending; numbered lists → sequential steps; bullets → action items; headers → sections; emphasis/`code` → important items; keywords CRITICAL/MUST/NEVER/ALWAYS/DO FIRST → high-priority rules; freeform → sentences with keywords.

### Step 2: Create `docs/plans/PROJECT_BRIEF.md` (path is load-bearing)

Auto-generate with these headings, each populated from the parsed analysis:
Header (Ticket ID, Source, Generated ISO timestamp, Status) · Analysis Summary · Current State (+ progress metrics, e.g. "8/97 modules") · Requirements (total scope / must-have) · Gap Analysis (+ blockers) · Critical Implementation Rules (Mandatory MUST / Forbidden NEVER / Patterns ALWAYS) · Prerequisites & Environment Setup (order by priority + env requirements) · Testing Requirements (connection details, test variables, special requirements) · Known Constraints · Definition of Done (checklist) · Custom Execution Steps (each with `phase`, suggested `agent`, details) · Additional Context (unmatched content, verbatim) · Integration with Standard Workflow (map custom modifications onto: Ingestion → Foundation → Prerequisites → Build → QA → Refactor → Release → CI → Learning).

### Step 3: Update `docs/plans/project_context.yml`

Add: `analysis` (`provided`, `source`, `timestamp`, `brief_file: docs/plans/PROJECT_BRIEF.md`) and `custom_execution` (`has_prerequisites`+`prerequisite_count`, `has_custom_rules`+`critical_rules_count`, `has_custom_qa`, `unfamiliar_steps[]` each with `step`,`phase`,`agent`,`priority`).

### Step 4: Log summary

```
📋 Custom analysis processed:
   ✅ Created: docs/plans/PROJECT_BRIEF.md
   📊 Extracted: [N] rules, [N] prerequisites, [N] constraints
   🔧 Custom steps: [N] unfamiliar operations identified
   All agents will follow PROJECT_BRIEF.md instructions.
```

All agents then follow `PROJECT_BRIEF.md`.

---

## B. Prerequisite Failure Handling (ONLY when platform-prerequisite-specialist escalates)

Quick decision table:

| Outcome | Action |
|---------|--------|
| Full Success | All prerequisites installed → proceed to Build |
| Partial Success | Degraded env → proceed with subset (accept if >50% testable) |
| Failure | Cannot install → user decision (retry/skip/abort) |
| No test environment | Skip Prerequisites → mark all tests blocked |

### Scenario 1: Full failure ("Cannot install X after 3 attempts")
- Is X critical for all modules? YES → PAUSE, ask user. NO → document, continue without X.
- Module impact: <25% affected → continue automatically; 25–50% → continue but notify; 50–75% → ask user (continue or pause); >75% → PAUSE, request intervention.

### Scenario 2: Partial success (degraded environment)
Accept if >50% testable. Update backlog (testable `[ ] TODO`, blocked `[!] CODE COMPLETE, TESTS BLOCKED`), proceed to Build with testable modules, create `blocked_modules.md` for resume, report "Building X/Y modules in degraded environment".

### Scenario 3: User input required (e.g. "Cannot find installer for custom software")
PAUSE and present options: (A) provide installer URL/network path, (B) skip affected modules, (C) abort. Wait for response, resume accordingly.

On any escalation, trigger the Learning Specialist to capture installation knowledge.
