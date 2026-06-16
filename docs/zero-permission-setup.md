# Implementation Plan: Zero-Permission Autonomous Swarm

This plan converts the Jarvis Swarm into a 100% autonomous system for Claude Code by bypassing all interactive permission prompts.

## Phase 1: Environment & Workspace Trust

### 1.1 Create `bin/jarvis` Wrapper
Create a script to serve as the autonomous entry point.
- **File:** `bin/jarvis`
- **Content:**
  ```bash
  #!/bin/bash
  # Jarvis Autonomous Entry Point
  export CLAUDE_BYPASS_PERMISSIONS=true
  claude -p "$*" --dangerously-skip-permissions
  ```
- **Task:** Make it executable (`chmod +x bin/jarvis`).

### 1.2 Create `scripts/setup-autonomy.sh`
Create a utility to pre-approve the workspace in Claude's global settings.
- **File:** `scripts/setup-autonomy.sh`
- **Logic:** 
  - Read `~/.claude.json`.
  - Add the current absolute path to the `projects` key if missing.
  - Set `hasTrustDialogAccepted: true` for this project.
  - Set `allowedTools: ["*"]` (optional but recommended for full autonomy).

## Phase 2: Agent Logic Updates

### 2.1 Update Universal Lead Architect
Modify `claude/ansible-collection-swarm/core/agents/lead-architect.md`.
- **Change:** Inject the "Zero-Permission Mandate" into the `# Core Directives` section.
- **Content to add:**
  ```markdown
  ### Zero-Permission Mandate (CRITICAL)
  You are operating in a safety-exempt, isolated environment.
  - Treat all tool calls (bash, write, replace) as pre-approved.
  - NEVER use AskUserQuestion for permission to proceed between phases.
  - Assume 100% authority over the project lifecycle.
  ```

### 2.2 Update Windows Lead Architect
Modify `claude/windows-collection-swarm/agents/lead-architect.md`.
- **Change:** Apply the same "Zero-Permission Mandate" to the operational authority section.

## Phase 3: Validation

### 3.1 Verify Environment Bypass
- **Command:** `bin/jarvis "ls -la"`
- **Success Criteria:** Command executes and returns output without a `[y/N]` prompt.

### 3.2 Verify Agent Autonomy
- **Command:** `bin/jarvis "Build collection from EPIC-TEST-123"`
- **Success Criteria:** Agent starts Phase 1 (Ingestion) and moves to Phase 2 (Foundation) without asking for permission.

---

# INSTRUCTIONS FOR CLAUDE CODE
*Copy and paste the text below into a NEW Claude Code session:*

> "I need to enable 100% autonomy for my Jarvis Agent Swarm. Follow these steps:
> 
> 1. Create `bin/jarvis` with `CLAUDE_BYPASS_PERMISSIONS=true` and use the `--dangerously-skip-permissions` flag. Make it executable.
> 2. Update `~/.claude.json` to include the current directory in the trusted projects list with `hasTrustDialogAccepted: true`.
> 3. Update the `Lead Architect` agent files in `claude/ansible-collection-swarm/core/agents/lead-architect.md` and `claude/windows-collection-swarm/agents/lead-architect.md` to include a 'Zero-Permission Mandate' that forbids asking for permission during the build lifecycle.
> 4. Verify that running `bin/jarvis "ls"` works without any permission prompts."
