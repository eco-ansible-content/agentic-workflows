# Red Hat Agentic SDLC Alignment Analysis
**Date**: 2026-06-23  
**Project**: agentic-workflows  
**Audience**: Eran Cohen, Agentic SDLC Pilot Teams  
**Purpose**: Gap analysis and roadmap for aligning with Red Hat standards for pilot team publication

---

## Executive Summary

**Current State**: agentic-workflows is a strong **internal productivity tool** with proven automation value (10-50x ROI for Ansible collection development). However, it does not meet Red Hat's agentic SDLC pilot publication standards.

**Key Findings**:
- ✅ **Strengths**: Multi-agent orchestration, autonomous execution, domain expertise, continuous learning
- ❌ **Critical Gaps**: Missing repo scaffolding (Tier 1), no evaluation harness, limited telemetry, missing security documentation
- 🎯 **Recommendation**: Complete Tier 1 & Tier 2 scaffolding + add basic evaluation before proposing for pilot inclusion

**Effort Estimate**: 2-3 weeks for minimal viable alignment (Tier 1 + Tier 2 basics)

---

## Current Project Assessment

### What We Have

**Strong Foundation**:
1. **Multi-agent system** (11 specialized agents) with clear orchestration hierarchy
2. **100% autonomous execution** model aligned with Charter's "Mission Control" vision
3. **Continuous learning** through insights-sync-specialist
4. **Domain-specific intelligence** for Ansible collections
5. **Dual-mode operation** (new build vs enhancement) shows sophisticated harness logic

**Documentation Quality**:
- Comprehensive README, Getting Started, Quick Start guides
- Agent registry with clear responsibilities (AGENTS.md)
- Architecture documentation and examples
- Installation/deployment guides

### What We're Missing (Against Red Hat Standards)

#### Critical (Blocks Pilot Publication)

1. **No Tier 1 Repository Scaffolding** (from `best-practices/repo-scaffolding/`)
   - ❌ No runnable test suite (package.json shows `exit 1`)
   - ❌ No verification commands documented
   - ❌ No lint/type checking infrastructure
   - ❌ No CI quality gates enforcing standards
   - ❌ No top-level CLAUDE.md or AGENTS.md (only in subdirectories)

2. **No Evaluation Framework** (Charter requirement: "Automated Oversight")
   - ❌ No integration with `agent-eval-harness`
   - ❌ No deterministic or LLM-based judges
   - ❌ No cost attribution tracking
   - ❌ No quality metrics across runs
   - Charter: *"We use automated evaluation harnesses to scale oversight"*

3. **Missing Security Documentation** (from `best-practices/THREAT_MODEL_README.md`)
   - ❌ No THREAT_MODEL.md file
   - ❌ No documented security assumptions
   - ❌ No attack surface analysis
   - ❌ Critical for agent systems with external API access (Jira, GitHub)

4. **No Telemetry/Observability** (Scorecard Dimension)
   - ❌ No Phoenix/Ledger/Langfuse integration
   - ❌ No per-run cost tracking
   - ❌ No quality metrics dashboard
   - Scorecard: This would rate **○** (none) on telemetry

#### Important (Needed for "Shared Best Practice" Status)

5. **No Deterministic Package Management** (from `best-practices/deterministic-package-management.md`)
   - Agents install Jira CLI, Ansible, other tools - are versions pinned?
   - Risk: AI-amplified supply chain attacks
   - Charter: *"Reliable agentic systems require clean data and unified testing"*

6. **No Repo Access Hints** (from `best-practices/repo-access-for-agents.md`)
   - Agents access GitHub, GitLab, Jira - access hints missing
   - Convention: Machine-readable auth requirements in pilot files

7. **No DCO/Agent Commit Policy** (from `best-practices/dco-and-agent-commits.md`)
   - How do agent commits get signed?
   - Needed for upstream contribution

#### Nice-to-Have (Advanced Tier)

8. **Limited Multi-Agent Verification**
   - Has code-reviewer agent, but not blind testing pattern
   - See `best-practices/multi-agent-blind-testing.md` - Dev never sees test code

9. **No Skill Overlays**
   - Could benefit from `best-practices/skill-overlays.md` pattern
   - Pre-generate project context for faster agent startup

---

## Harness Layer Scorecard (Hypothetical)

If we assessed agentic-workflows against the June 2026 scorecard:

| Layer | Rating | Evidence | Gap |
|-------|--------|----------|-----|
| **L1 Infrastructure** | ●● | GitHub Actions potential, local execution | No CI for agent runs |
| **L2 Sandbox** | ● | Minimal (user's machine) | No isolation, no OpenShell integration |
| **L3 Agent Harness** | ●● | 11 agents, workflows, learning loop | Missing eval harness, no systemic improvement automation |
| **L4 Runtime** | ●● | Claude Code compatible | Documented but not enforced |
| **L5 Model** | ●● | Opus/Sonnet routing | No cost tracking, no attribution |
| **Telemetry** | ○ | None | No observability framework |
| **Harness Fix Loop** | ● | Learning-evolution-specialist exists | Manual, not automatic |

**Expected Placement**: Below Ecosystem (●●/●/●●●/●●/●●/●/●●) on most dimensions.

**Reason**: Missing foundational scaffolding that all ●●● pilots have (RHEL, Portfolio & Delivery, Red Hat AI Analysis).

---

## Alignment Roadmap

### Tier 1: Do This First (1 Week) - BLOCKS PUBLICATION

**Goal**: Meet minimum scaffolding requirements from `best-practices/repo-scaffolding/getting-started.md`

#### 1.1 - Add Runnable Tests
```bash
# Create test suite
mkdir -p tests
# Tests for:
# - Agent registration validation
# - Plugin manifest validation  
# - verify.sh automated test
# - Basic smoke test for each agent
```

Update package.json:
```json
"scripts": {
  "test": "bash tests/run-all-tests.sh",
  "test:unit": "bash tests/unit-tests.sh",
  "test:integration": "bash tests/integration-tests.sh",
  "verify": "bash verify.sh && npm test"
}
```

#### 1.2 - Create Top-Level AGENTS.md
Move/merge content from `claude/ansible-collection-swarm/AGENTS.md` to root:
- Repository purpose and structure
- How to contribute
- Agent discovery patterns
- Design decisions (why 11 agents? why Opus vs Sonnet?)
- Keep under 150 lines per ETH Zurich research

#### 1.3 - Add Lint Infrastructure
```bash
# Install shellcheck, markdownlint
# Add:
# - .shellcheckrc
# - .markdownlint.json
# - npm run lint script
```

#### 1.4 - Add CI Quality Gates
Create `.github/workflows/quality.yml`:
- Run tests on every PR
- Lint shell scripts
- Validate markdown
- Check plugin manifest schema
- Verify agent definitions

### Tier 2: Security & Evaluation (1 Week) - NEEDED FOR PILOT STATUS

#### 2.1 - Add THREAT_MODEL.md
Following `best-practices/THREAT_MODEL_README.md`:
```markdown
# Threat Model: Agentic Workflows

## Entry Points
- Jira Epic ingestion (external API)
- GitHub/GitLab access (code repositories)
- User-provided test environments
- Agent-to-agent communication

## Assets
- Generated Ansible code
- Test environment credentials
- Jira authentication tokens
- Git repository access

## Threats
1. Malicious Jira Epic → code injection
2. Compromised test environment → credential leak
3. Agent hallucination → broken modules in production
4. Supply chain attack via dependency installation

## Mitigations
...
```

#### 2.2 - Integrate agent-eval-harness
From `opendatahub-io/agent-eval-harness`:
```bash
# Create evaluation suite
mkdir -p evaluations
# Add test cases:
# - Simple Windows module (SCVMM)
# - Complex module (multi-step)
# - Unknown platform (SolarWinds)
# - Enhancement mode test
```

Track:
- Success rate per agent type
- Cost per module generated
- Time to completion
- Quality metrics (lint pass rate, test coverage)

#### 2.3 - Add Basic Telemetry
Minimal observability:
```bash
# Add to lead-architect
# - Log run start/end timestamps
# - Track token usage per phase
# - Record agent invocations
# - Output JSON summary
```

Store in `.agentic-workflows/runs/<run-id>/telemetry.json`

### Tier 3: Best Practices Alignment (1 Week) - POLISH FOR SHARING

#### 3.1 - Deterministic Package Management
Audit all agent tool installations:
- Pin Jira CLI version
- Pin Ansible version  
- Pin gh CLI version
- Add verification checksums
- Document in README

#### 3.2 - Add Repo Access Hints
In documentation, add machine-readable format:
```yaml
# For agents reading this file
repository_access:
  jira:
    platform: jira
    tool: jira-cli
    auth: token
  delivery:
    platform: github
    tool: gh
    auth: oauth
```

#### 3.3 - DCO Policy
Document agent commit signing:
- How are commits attributed?
- When human reviews, human signs DCO
- Document midstream-fork pattern if needed

#### 3.4 - Blind Testing Pattern
Enhance QA-coordinator:
- Separate test generation from module implementation
- Module-worker never sees test code
- Prevents test gaming

### Tier 4: Advanced (Optional) - DIFFERENTIATION

#### 4.1 - Skills Marketplace Integration
Package skills for `prodsec-skills` or `ai-helpers` pattern:
```
skills/
  ansible-collection/
    module-generation.md
    test-generation.md
    ci-validation.md
```

#### 4.2 - Multi-Platform Harness
Abstract beyond Ansible:
- Kubernetes operator swarm
- Terraform module swarm
- Align with "Future Swarms" roadmap

#### 4.3 - Cross-Pilot Learning
Contribute patterns to `wg-agentic-sdlc/best-practices/`:
- "Multi-agent orchestration for infrastructure code"
- "Universal pattern learning for unknown platforms"
- "Continuous learning loops in agent systems"

---

## Comparison: Internal vs Pilot-Ready

| Dimension | Internal Tool (Current) | Pilot-Ready (Target) |
|-----------|------------------------|----------------------|
| **Tests** | verify.sh only | Full test suite in CI |
| **Documentation** | Great README | + AGENTS.md + THREAT_MODEL.md |
| **Evaluation** | Manual | agent-eval-harness integrated |
| **Telemetry** | None | Run metrics, cost tracking |
| **Security** | Undocumented | Threat model, deterministic deps |
| **CI/CD** | None | Quality gates on every PR |
| **Contribution** | Internal use | Clear guidelines, DCO policy |
| **Reusability** | Ansible-specific | Patterns extractable for other domains |

---

## Red Hat Charter Alignment

### Where We Align ✅

| Charter Principle | How We Align |
|-------------------|--------------|
| **Autonomous Execution** | ✅ 100% hands-off after initial questions |
| **Intelligence Harness** | ✅ 11 specialized agents with pattern library |
| **Systemic Remediation** | ✅ learning-evolution-specialist captures insights |
| **Open Source Leadership** | ✅ MIT licensed, public repository |

### Where We Fall Short ❌

| Charter Principle | Gap |
|-------------------|-----|
| **Codifying Judgment** | ❌ No deterministic enforcement (lint rules, hooks) |
| **Automated Oversight** | ❌ No evaluation harness |
| **Addressing Risk** | ❌ No threat model, no security documentation |
| **Radical Transparency** | ❌ No execution traces, no telemetry |
| **Integrity** | ❌ No standardized security/testing agents |

---

## Vision Alignment

### Mission Control Model ✅

**Vision**: *"Engineers define strategic intent; agents drive execution"*

**How we align**:
- ✅ User answers 2-3 questions → agents autonomous
- ✅ Lead architect orchestrates 10 sub-agents
- ✅ System-led escalation (agents retry, degrade gracefully)

### Evaluation & Feedback ❌

**Vision**: *"Automated evaluation harnesses to scale oversight"*

**Gap**:
- ❌ No automated quality measurement
- ❌ No comparison across runs
- ❌ No cost/quality tradeoff tracking

---

## Recommended Path Forward

### Option A: Minimal Viable Pilot Entry (3 weeks)
1. **Week 1**: Tier 1 scaffolding (tests, AGENTS.md, CI)
2. **Week 2**: Tier 2 security (THREAT_MODEL.md, basic eval)
3. **Week 3**: Tier 2 telemetry + documentation polish

**Result**: Qualifies for pilot registry with ●●/●/●●/●●/●/●/● scorecard

### Option B: Strong Pilot Contribution (6 weeks)
1. **Weeks 1-3**: Minimal viable (Option A)
2. **Week 4**: Tier 3 best practices alignment
3. **Weeks 5-6**: Tier 4 skills extraction, cross-pilot learning contribution

**Result**: Qualifies for `best-practices/` contribution with ●●/●●/●●●/●●/●●/●●/●●● scorecard

### Option C: Keep Internal (Current)
Continue as productivity tool, don't publish to pilots.

**Tradeoffs**:
- ✅ No additional work required
- ✅ Proven value for your team
- ❌ Ecosystem can't benefit from patterns
- ❌ No cross-pilot feedback/improvement
- ❌ Misses "Open Source Leadership" Charter goal

---

## Specific Files to Create

Based on wg-agentic-sdlc structure:

### Required
1. `/AGENTS.md` - Top-level agent context (< 150 lines)
2. `/THREAT_MODEL.md` - Security documentation
3. `/tests/` - Test infrastructure
4. `/.github/workflows/quality.yml` - CI gates
5. `/evaluations/` - agent-eval-harness cases
6. `/.agentic-workflows/` - Telemetry output directory

### Recommended
7. `/skills/` - Extractable skills for marketplace
8. `/docs/CONTRIBUTING.md` - AI-first contribution guide
9. `/docs/DCO-POLICY.md` - Agent commit policy
10. `/.shellcheckrc` + `.markdownlint.json` - Lint configs

### Enhanced package.json
```json
{
  "scripts": {
    "test": "bash tests/run-all-tests.sh",
    "test:unit": "bash tests/unit-tests.sh",
    "test:integration": "bash tests/integration-tests.sh",
    "test:eval": "bash evaluations/run-eval-harness.sh",
    "lint": "bash scripts/lint.sh",
    "lint:fix": "bash scripts/lint-fix.sh",
    "verify": "npm run lint && npm test",
    "ci": "npm run verify && npm run test:eval"
  }
}
```

---

## Cost/Benefit Analysis

### Costs (Tier 1 + Tier 2)
- **Engineering Time**: 2-3 weeks
- **Maintenance Burden**: CI failures to debug, eval suite to maintain
- **Documentation Overhead**: Keep AGENTS.md, THREAT_MODEL.md current

### Benefits
1. **Ecosystem Value**: Other teams can adopt/adapt patterns
2. **Quality Improvement**: CI gates catch regressions early
3. **Security Posture**: Documented threats, mitigations
4. **Cross-Team Learning**: Feedback from 14 other pilots
5. **Red Hat Visibility**: Contribution to Charter goals
6. **Career Impact**: Demonstrated open source leadership

### ROI Calculation
If even 2 other Ecosystem teams (Telco, Partners) adopt patterns:
- 3 weeks investment → 6 teams × 10x productivity gain
- Meets Charter: *"Shared Foundation: Agentic Commons"*

---

## Next Steps

### Immediate (This Week)
1. **Decision**: Which option? (A, B, or C)
2. **If A or B**: Create GitHub project board for tracking
3. **Kickoff**: Start with Tier 1.1 (runnable tests)

### Week 1
- [ ] Add test infrastructure (`tests/`)
- [ ] Create top-level AGENTS.md
- [ ] Add lint tooling
- [ ] Set up CI pipeline

### Week 2
- [ ] Write THREAT_MODEL.md
- [ ] Integrate agent-eval-harness basics
- [ ] Add basic telemetry logging

### Week 3
- [ ] Documentation polish
- [ ] Run full evaluation suite
- [ ] Prepare pilot submission PR to wg-agentic-sdlc

### Pilot Submission
Once ready, submit PR to `wg-agentic-sdlc`:
1. Add entry to `pilots/ecosystem.md`
2. Optionally contribute pattern to `best-practices/`
3. Request WG lead review

---

## Questions for Eran

1. **Priority**: Should we pursue pilot publication, or keep as internal tool?
2. **Timeline**: Is 3-week timeline acceptable for minimal viable pilot entry?
3. **Resources**: Can we dedicate focused time for Tier 1 + Tier 2 work?
4. **Scope**: Target Option A (minimal) or Option B (strong contribution)?
5. **Support**: Can we get WG lead review/guidance during implementation?

---

## References

All references from `wg-agentic-sdlc`:

- [Charter](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/Charter.md)
- [Vision](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/Vision.md)
- [AGENTS.md Guidelines](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/AGENTS.md)
- [Repository Scaffolding](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/best-practices/repo-scaffolding/README.md)
- [Threat Model Guide](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/best-practices/THREAT_MODEL_README.md)
- [June 2026 Scorecard](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/assessments/pilot-scorecard-for-leadership-2026-06-04.md)
- [Deterministic Package Management](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/best-practices/deterministic-package-management.md)
- [Multi-Agent Blind Testing](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/best-practices/multi-agent-blind-testing.md)
- [Ecosystem Pilot Entry](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/pilots/ecosystem.md)

---

**Bottom Line**: 

Your project has **exceptional domain value** and **strong architectural foundation**. The gap is not in agent intelligence or automation capability — it's in the **scaffolding, evaluation, and security documentation** that Red Hat requires for shared pilot work.

**3 weeks of focused effort** on Tier 1 + Tier 2 transforms this from "great internal tool" to "pilot-ready contribution."

The question is strategic: **Do we want ecosystem-wide impact, or keep this as Ecosystem Engineering's competitive advantage?**
