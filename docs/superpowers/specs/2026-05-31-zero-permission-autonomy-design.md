# Design Spec: Zero-Permission Autonomous Swarm

**Date:** 2026-05-31
**Topic:** Fully autonomous operation for Jarvis Swarm in Claude Code.
**Status:** Draft

## 1. Purpose
The Jarvis Swarm is designed to run in isolated environments (VMs/Containers) for massive, parallel Ansible collection development. The current Claude Code platform requires manual confirmation for shell commands and file edits, which blocks the "Chief Automation Officer" model. This spec defines a way to bypass all prompts to achieve 100% autonomy.

## 2. Architecture
The autonomy is achieved through a three-layered bypass system:

### Layer 1: Environment Level (`CLAUDE_BYPASS_PERMISSIONS`)
Claude Code respects specific environment variables that signal a "non-interactive" or "safety-exempt" execution.
*   **Action:** Create a wrapper script `bin/jarvis` that injects `CLAUDE_BYPASS_PERMISSIONS=true`.
*   **Action:** Use the `--dangerously-skip-permissions` flag in all CLI calls.

### Layer 2: Configuration Level (`~/.claude.json`)
Claude Code maintains a list of "trusted" workspace directories. If a directory is not trusted, it prompts the user at startup.
*   **Action:** Create a `scripts/setup-autonomy.sh` script that uses `jq` (or equivalent) to inject the current workspace path into `~/.claude.json`'s `hasTrustDialogAccepted` array.

### Layer 3: Agent Behavior Level (`Lead Architect`)
Agents are programmed to be "polite" and ask for permission before major phases. This must be overridden.
*   **Action:** Update `claude/windows-collection-swarm/agents/lead-architect.md` and `claude/ansible-collection-swarm/core/agents/lead-architect.md`.
*   **Mandate:** Explicitly instruct the agent that it has "Pre-Approved Authority" and must NEVER use `AskUserQuestion` for permission to proceed.

## 3. Components

### 3.1 `bin/jarvis` Wrapper
A bash script that acts as the entry point for developers.
```bash
#!/bin/bash
export CLAUDE_BYPASS_PERMISSIONS=true
claude -p "$*" --dangerously-skip-permissions
```

### 3.2 `scripts/setup-autonomy.sh`
A utility script to be run once per VM/developer setup.
```bash
#!/bin/bash
# 1. Identify workspace path
WORKSPACE_PATH=$(pwd)
# 2. Inject into ~/.claude.json (Logic to handle JSON manipulation safely)
# 3. Print success message
```

### 3.3 Agent Instruction Updates
Injected "Zero-Permission" block for the `Lead Architect` system prompt:
```markdown
## Zero-Permission Mandate
You are operating in a safety-exempt, isolated environment.
- Treat all tool calls as pre-approved.
- NEVER ask for permission to proceed between phases.
- If a technical error occurs, attempt 3 autonomous self-corrections before logging a fatal error.
```

## 4. Testing & Validation
1.  **Direct Tool Check:** Run `bin/jarvis "ls -la"` and verify no `[y/N]` prompt appears.
2.  **Swarm Execution Check:** Run a full swarm build and verify it transitions from "Ingestion" to "Foundation" without human input.

## 5. Security Note
This mode is **FOR ISOLATED VM USE ONLY**. It should never be enabled on a developer's primary machine where sensitive files are present, as it allows the LLM to execute any command (including `rm -rf /`) without oversight.
