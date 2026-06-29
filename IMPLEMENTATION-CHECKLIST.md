# Red Hat Agentic SDLC Alignment - Implementation Checklist

**Project**: agentic-workflows  
**Target**: Minimal Viable Pilot Entry (Option A - 3 weeks)  
**Tracker**: Copy to GitHub Project Board or GitLab Issues

---

## Week 1: Tier 1 Repository Scaffolding

### 1.1 Test Infrastructure (Day 1-2)

- [ ] **Create test directory structure**
  ```bash
  mkdir -p tests/{unit,integration,fixtures}
  mkdir -p tests/fixtures/{manifests,agents,skills}
  ```

- [ ] **Write unit tests** (`tests/unit/`)
  - [ ] `test-plugin-manifest.sh` - Validate plugin.json schema
  - [ ] `test-agent-registration.sh` - Verify all agents in AGENTS.md exist
  - [ ] `test-skill-format.sh` - Validate skill metadata
  - [ ] `test-verify-script.sh` - Ensure verify.sh runs successfully

- [ ] **Write integration tests** (`tests/integration/`)
  - [ ] `test-agent-invocation.sh` - Smoke test for lead-architect
  - [ ] `test-enhancement-mode.sh` - Basic enhancement detection
  - [ ] `test-pattern-loading.sh` - Verify patterns load correctly

- [ ] **Create test runner** (`tests/run-all-tests.sh`)
  ```bash
  #!/bin/bash
  set -e
  echo "Running unit tests..."
  bash tests/unit/*.sh
  echo "Running integration tests..."
  bash tests/integration/*.sh
  echo "✅ All tests passed"
  ```

- [ ] **Update package.json scripts**
  ```json
  "scripts": {
    "test": "bash tests/run-all-tests.sh",
    "test:unit": "bash tests/unit/run.sh",
    "test:integration": "bash tests/integration/run.sh",
    "verify": "bash verify.sh && npm test"
  }
  ```

### 1.2 Top-Level AGENTS.md (Day 2-3)

- [ ] **Create `/AGENTS.md`** (under 150 lines per ETH Zurich guidance)
  - [ ] Repository purpose and design philosophy
  - [ ] How agents discover each other
  - [ ] Why 11 agents? (orchestration rationale)
  - [ ] Why Opus vs Sonnet assignments?
  - [ ] How to contribute new agents
  - [ ] How to test changes locally
  - [ ] Link to detailed docs in `claude/`

- [ ] **Design decisions to document**
  - [ ] Multi-agent orchestration pattern
  - [ ] Universal platform support approach
  - [ ] Pattern-based adaptation vs templates
  - [ ] Learning loop mechanism
  - [ ] Enhancement detection strategy

- [ ] **Update subdirectory AGENTS.md files**
  - [ ] `claude/ansible-collection-swarm/AGENTS.md` - Link to root
  - [ ] Remove duplicate content, keep swarm-specific details

### 1.3 Lint Infrastructure (Day 3)

- [ ] **Install lint tools**
  ```bash
  npm install -D shellcheck
  npm install -D markdownlint-cli
  ```

- [ ] **Create lint configs**
  - [ ] `.shellcheckrc` - Shell script linting rules
    ```
    # Exclude specific checks if needed
    disable=SC2312  # Example: consider pipefail
    ```
  - [ ] `.markdownlint.json` - Markdown style rules
    ```json
    {
      "default": true,
      "MD013": false,
      "MD033": false
    }
    ```

- [ ] **Create lint script** (`scripts/lint.sh`)
  ```bash
  #!/bin/bash
  echo "Linting shell scripts..."
  find . -name "*.sh" -exec shellcheck {} \;
  echo "Linting markdown..."
  markdownlint '**/*.md' --ignore node_modules
  ```

- [ ] **Add lint script to package.json**
  ```json
  "scripts": {
    "lint": "bash scripts/lint.sh",
    "lint:fix": "markdownlint '**/*.md' --fix --ignore node_modules"
  }
  ```

- [ ] **Run and fix lint errors**
  - [ ] Fix shell script issues found by shellcheck
  - [ ] Fix markdown issues found by markdownlint
  - [ ] Document exceptions in configs

### 1.4 CI Quality Gates (Day 4-5)

- [ ] **Create GitHub Actions workflow** (`.github/workflows/quality.yml`)
  ```yaml
  name: Quality Gates
  
  on:
    pull_request:
      branches: [ main ]
    push:
      branches: [ main ]
  
  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        - name: Setup Node
          uses: actions/setup-node@v3
          with:
            node-version: '18'
        - name: Install dependencies
          run: npm ci
        - name: Run tests
          run: npm test
        - name: Run lint
          run: npm run lint
        - name: Verify plugin
          run: npm run verify
  ```

- [ ] **Add status badge to README.md**
  ```markdown
  [![Quality Gates](https://github.com/eco-ansible-content/agentic-workflows/workflows/Quality%20Gates/badge.svg)](https://github.com/eco-ansible-content/agentic-workflows/actions)
  ```

- [ ] **Configure branch protection**
  - [ ] Require "Quality Gates" check to pass
  - [ ] Require at least 1 review
  - [ ] Enable automatic merge conflict detection

- [ ] **Test CI pipeline**
  - [ ] Create test PR with intentional failure
  - [ ] Verify CI catches it
  - [ ] Fix and verify CI passes

---

## Week 2: Tier 2 Security & Evaluation

### 2.1 Threat Model (Day 6-7)

- [ ] **Create `/THREAT_MODEL.md`** (following wg-agentic-sdlc template)

  **Entry Points**:
  - [ ] Document Jira Epic ingestion attack surface
  - [ ] Document GitHub/GitLab access risks
  - [ ] Document test environment credential handling
  - [ ] Document agent-to-agent communication

  **Assets**:
  - [ ] Generated Ansible code
  - [ ] Test environment credentials
  - [ ] Jira authentication tokens
  - [ ] Git repository access tokens
  - [ ] Learning insights database

  **Threats** (prioritized):
  - [ ] T1: Malicious Jira Epic → code injection in modules
  - [ ] T2: Compromised test environment → credential leakage
  - [ ] T3: Agent hallucination → broken code in production
  - [ ] T4: Supply chain attack via tool installation (jira-cli, gh, ansible)
  - [ ] T5: Secrets in learning insights
  - [ ] T6: Unvalidated external API responses

  **Mitigations**:
  - [ ] M1: Input validation on Jira Epic fields
  - [ ] M2: Credential isolation per run
  - [ ] M3: Code review gate before delivery
  - [ ] M4: Pinned versions with checksums (see 2.4)
  - [ ] M5: Secrets filter in insights-sync
  - [ ] M6: Schema validation for external APIs

- [ ] **Security testing**
  - [ ] Add test for malicious Jira input
  - [ ] Add test for credential isolation
  - [ ] Document manual security review checklist

### 2.2 Evaluation Framework (Day 8-9)

- [ ] **Install agent-eval-harness**
  ```bash
  npm install -D @opendatahub-io/agent-eval-harness
  ```

- [ ] **Create evaluation directory** (`evaluations/`)
  ```
  evaluations/
    ├── README.md
    ├── test-cases/
    │   ├── simple-windows-module.yml
    │   ├── complex-multi-step-module.yml
    │   ├── unknown-platform.yml
    │   └── enhancement-mode.yml
    ├── run-eval-harness.sh
    └── results/
        └── .gitkeep
  ```

- [ ] **Write test cases** (`evaluations/test-cases/`)
  - [ ] **simple-windows-module.yml**: SCVMM VM creation
    - Input: Jira Epic ID (mocked)
    - Expected: Single module with basic CRUD
    - Judge: Module runs, lint passes, tests pass
  
  - [ ] **complex-multi-step-module.yml**: Multi-dependency module
    - Input: Complex Epic with prerequisites
    - Expected: Multiple modules with dependencies
    - Judge: All modules work together
  
  - [ ] **unknown-platform.yml**: Platform not in training data
    - Input: Generic API-based platform
    - Expected: REST pattern adaptation
    - Judge: Modules use correct pattern
  
  - [ ] **enhancement-mode.yml**: Add to existing collection
    - Input: Existing collection + new Epic
    - Expected: New modules + regression tests pass
    - Judge: Old modules still work

- [ ] **Create eval runner** (`evaluations/run-eval-harness.sh`)
  ```bash
  #!/bin/bash
  # Runs all evaluation test cases
  # Outputs JSON results to evaluations/results/
  ```

- [ ] **Define success metrics**
  - [ ] Module generation success rate (target: >90%)
  - [ ] Test pass rate (target: >95%)
  - [ ] Lint pass rate (target: 100%)
  - [ ] Cost per module (baseline to track)
  - [ ] Time to completion (baseline to track)

- [ ] **Add eval to CI** (optional for minimal viable)
  - [ ] Run eval on weekly schedule
  - [ ] Report results to dashboard

### 2.3 Basic Telemetry (Day 9-10)

- [ ] **Create telemetry directory structure**
  ```bash
  mkdir -p .agentic-workflows/runs
  echo ".agentic-workflows/" >> .gitignore
  ```

- [ ] **Add telemetry to lead-architect**
  - [ ] Log run start timestamp
  - [ ] Log each phase start/end
  - [ ] Track agent invocations (type, model, duration)
  - [ ] Track token usage per phase (if available)
  - [ ] Log run completion status (success/failure)
  - [ ] Output to `.agentic-workflows/runs/<run-id>/telemetry.json`

- [ ] **Telemetry JSON schema**
  ```json
  {
    "run_id": "uuid",
    "started_at": "ISO8601",
    "completed_at": "ISO8601",
    "status": "success|failure|partial",
    "mode": "full-build|enhancement",
    "epic_id": "EPIC-XXX",
    "platform": "detected-platform",
    "phases": [
      {
        "phase": "jira-ingestion",
        "agent": "jira-ingestion-specialist",
        "model": "sonnet",
        "started_at": "ISO8601",
        "completed_at": "ISO8601",
        "tokens_used": 12345,
        "status": "success"
      }
    ],
    "summary": {
      "total_duration_seconds": 4500,
      "total_tokens": 150000,
      "modules_generated": 15,
      "tests_passed": 14,
      "tests_failed": 1
    }
  }
  ```

- [ ] **Add telemetry summary command**
  ```bash
  # scripts/telemetry-summary.sh
  # Aggregates all runs, shows:
  # - Total runs
  # - Success rate
  # - Average duration
  # - Average cost (if token costs known)
  # - Most common platforms
  ```

---

## Week 3: Documentation & Polish

### 3.1 Documentation Updates (Day 11-12)

- [ ] **Update README.md**
  - [ ] Add "Red Hat Agentic SDLC Pilot" section
  - [ ] Link to wg-agentic-sdlc
  - [ ] Add quality gates badge
  - [ ] Add security section referencing THREAT_MODEL.md
  - [ ] Add evaluation results summary

- [ ] **Create CONTRIBUTING.md** (`docs/CONTRIBUTING.md`)
  - [ ] AI-first contribution guidelines
  - [ ] How to run tests locally
  - [ ] How to add new agents
  - [ ] Code review expectations
  - [ ] CI/CD pipeline description

- [ ] **Create DCO-POLICY.md** (`docs/DCO-POLICY.md`)
  - [ ] Agent commit attribution policy
  - [ ] When human signs DCO (interactive use)
  - [ ] When autonomous agents don't sign
  - [ ] Midstream-fork pattern (if needed)

- [ ] **Update agent documentation**
  - [ ] Ensure all agents reference THREAT_MODEL.md
  - [ ] Add "Security Considerations" to each agent
  - [ ] Document validation steps in each agent

### 3.2 Deterministic Dependencies (Day 12-13)

- [ ] **Audit tool installations**
  - [ ] Find all `npm install`, `pip install`, `brew install` in agents
  - [ ] Find all `git clone` operations
  - [ ] Find all curl downloads

- [ ] **Pin versions** (update agent definitions)
  - [ ] `jira-cli` → specific version
  - [ ] `gh` CLI → specific version
  - [ ] `ansible` → specific version
  - [ ] Python packages → requirements.txt with hashes
  - [ ] Node packages → package-lock.json committed

- [ ] **Add verification**
  - [ ] Checksum validation for downloaded binaries
  - [ ] Signature verification where available
  - [ ] Document fallback behavior on verification failure

- [ ] **Create installation guide** (`docs/DEPENDENCIES.md`)
  ```markdown
  # Required Dependencies
  
  ## Jira CLI
  - Version: 2.3.0
  - Install: npm install -g jira-cli@2.3.0
  - Checksum: sha256:...
  
  ## GitHub CLI
  - Version: 2.50.0
  - Install: brew install gh@2.50.0
  - Verification: gh --version
  ```

### 3.3 Repo Access Hints (Day 13)

- [ ] **Add access metadata to README.md**
  ```yaml
  # For AI agents reading this file
  repository_access:
    jira:
      platform: jira-server
      tool: jira-cli
      auth: token
      docs: https://internal.jira.example.com
    
    github:
      platform: github
      tool: gh
      auth: oauth
      docs: https://github.com/eco-ansible-content
    
    gitlab:
      platform: gitlab
      tool: glab
      auth: token
      docs: https://gitlab.cee.redhat.com
  ```

- [ ] **Document in AGENTS.md**
  - [ ] Where credentials are stored
  - [ ] How agents authenticate
  - [ ] What permissions are needed

### 3.4 Final Testing & Validation (Day 14-15)

- [ ] **End-to-end test**
  - [ ] Fresh clone of repository
  - [ ] Run installation
  - [ ] Run full test suite
  - [ ] Run evaluation harness
  - [ ] Generate sample collection
  - [ ] Verify telemetry output

- [ ] **Documentation review**
  - [ ] All links work
  - [ ] All commands tested
  - [ ] No sensitive data in examples
  - [ ] Markdown lint passes

- [ ] **Security review**
  - [ ] THREAT_MODEL.md complete
  - [ ] No credentials in code
  - [ ] Dependencies pinned
  - [ ] Input validation documented

- [ ] **CI/CD validation**
  - [ ] All workflows passing
  - [ ] Branch protection configured
  - [ ] Quality gates enforced

---

## Pilot Submission (Week 4)

### 4.1 Prepare Submission

- [ ] **Fork wg-agentic-sdlc**
  ```bash
  cd ~/Documents/Git
  git clone git@gitlab.cee.redhat.com:global-engineering/wg-agentic-sdlc.git
  cd wg-agentic-sdlc
  git checkout -b add-agentic-workflows-pilot
  ```

- [ ] **Update pilots/ecosystem.md**
  - [ ] Add new repository entry:
    ```markdown
    | [eco-ansible-content/agentic-workflows](https://github.com/eco-ansible-content/agentic-workflows) | Multi-agent swarm for autonomous Ansible collection development with universal platform support |
    ```

- [ ] **Optionally add to demos/** (if have demo video)
  - [ ] Create `demos/ecosystem-agentic-workflows.md`
  - [ ] Link to demo video
  - [ ] 1-2 sentence description

### 4.2 Submit Merge Request

- [ ] **Commit changes**
  ```bash
  git add pilots/ecosystem.md
  git commit -m "Add agentic-workflows to Ecosystem pilot

  Multi-agent swarm for autonomous Ansible collection development.
  Supports universal platform learning, dual-mode operation,
  and continuous learning loops.

  Repository: https://github.com/eco-ansible-content/agentic-workflows
  SME: Hen Yaish"
  ```

- [ ] **Push and create MR**
  ```bash
  git push origin add-agentic-workflows-pilot
  # Open merge request in GitLab UI
  ```

- [ ] **MR description template**
  ```markdown
  ## Add agentic-workflows to Ecosystem Pilot
  
  **Repository**: https://github.com/eco-ansible-content/agentic-workflows
  **Type**: Multi-agent orchestration for infrastructure code
  **Harness Layer Focus**: L3 (Agent Harness), L4 (Runtime)
  
  ### What This Adds
  - 11-agent swarm for Ansible collection development
  - Universal platform support via pattern learning
  - Dual-mode: full build + enhancement
  - Continuous learning system
  
  ### Alignment Completed
  - [x] Tier 1 repository scaffolding (tests, AGENTS.md, CI)
  - [x] THREAT_MODEL.md security documentation
  - [x] agent-eval-harness integration
  - [x] Basic telemetry
  - [x] Deterministic dependency management
  
  ### WG Lead Review Requested
  @ecohen @iheim - Please review for inclusion in Ecosystem pilot
  
  cc: @wg-leads (per CODEOWNERS for pilots/)
  ```

### 4.3 Respond to Feedback

- [ ] **Address review comments**
  - [ ] Update documentation as requested
  - [ ] Fix any identified gaps
  - [ ] Re-run tests/evals if needed

- [ ] **Get approval**
  - [ ] WG lead approval
  - [ ] Ecosystem org lead approval
  - [ ] Merge when approved

---

## Optional: Best Practices Contribution

If pursuing Option B (strong contribution), add these:

### Extract Reusable Patterns

- [ ] **Create best-practices/ entry** (in wg-agentic-sdlc fork)
  - [ ] `best-practices/multi-agent-orchestration.md`
  - [ ] Document lead-architect pattern
  - [ ] Document parallel agent batching
  - [ ] Document learning loop pattern
  - [ ] Credit agentic-workflows as validation

- [ ] **Create skills/** (extractable from agents)
  - [ ] `skills/ansible-collection-generation/`
  - [ ] `skills/platform-research/`
  - [ ] `skills/test-generation/`

---

## Success Criteria

### Week 1 Complete
- [ ] ✅ Tests run successfully in CI
- [ ] ✅ Lint passes with zero errors
- [ ] ✅ Top-level AGENTS.md under 150 lines
- [ ] ✅ CI quality gates enforcing standards

### Week 2 Complete
- [ ] ✅ THREAT_MODEL.md documents all entry points
- [ ] ✅ Evaluation harness runs 4+ test cases
- [ ] ✅ Telemetry captures run metrics
- [ ] ✅ Dependencies pinned with verification

### Week 3 Complete
- [ ] ✅ Documentation comprehensive and accurate
- [ ] ✅ Fresh install works end-to-end
- [ ] ✅ Security review complete
- [ ] ✅ Ready for pilot submission

### Pilot Accepted
- [ ] ✅ Entry in pilots/ecosystem.md merged
- [ ] ✅ Repository meets Red Hat standards
- [ ] ✅ Other pilots can reference/learn from it

---

## Maintenance After Acceptance

### Ongoing (Per WG Best Practices)

- [ ] **Keep AGENTS.md current**
  - [ ] Update when adding/changing agents
  - [ ] Update when design decisions change
  - [ ] Review quarterly

- [ ] **Run evaluations regularly**
  - [ ] Weekly automated eval runs
  - [ ] Track metrics over time
  - [ ] Report regressions

- [ ] **Update THREAT_MODEL.md**
  - [ ] When adding new integrations
  - [ ] When changing authentication
  - [ ] After security incidents

- [ ] **Contribute learnings**
  - [ ] Share insights in wg-agentic-sdlc meetings
  - [ ] Update best-practices/ with discoveries
  - [ ] Help other pilots adopting patterns

---

## Tracking

Copy this checklist to:
- [ ] GitHub Project Board (recommended)
- [ ] GitLab Issues (if using GitLab)
- [ ] Jira Epic (if using Jira)

Assign tasks to team members, set deadlines, track progress.

---

## Questions / Blockers

Document blockers here as they arise:

1. **Blocker**: ___________
   - **Impact**: ___________
   - **Resolution**: ___________
   - **Owner**: ___________

2. **Blocker**: ___________
   - **Impact**: ___________
   - **Resolution**: ___________
   - **Owner**: ___________

---

## Resources

- **Analysis Document**: [RED-HAT-ALIGNMENT-ANALYSIS.md](RED-HAT-ALIGNMENT-ANALYSIS.md)
- **WG Repository**: https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc
- **Scorecard**: [pilot-scorecard-for-leadership-2026-06-04.md](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/assessments/pilot-scorecard-for-leadership-2026-06-04.md)
- **Charter**: [Charter.md](https://gitlab.cee.redhat.com/global-engineering/wg-agentic-sdlc/-/blob/main/Charter.md)
- **Contact**: Eran Cohen (@ecohen), Itamar Heim (@iheim)

---

**Last Updated**: 2026-06-23  
**Status**: Ready to start  
**Estimated Completion**: 3 weeks (Week 1-3)
