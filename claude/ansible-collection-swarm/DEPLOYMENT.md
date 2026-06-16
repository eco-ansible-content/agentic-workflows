# Universal Ansible Collection Swarm - Deployment Guide

## Installation

### Extract Swarm

```bash
cd ~/.claude/agents
# Archive should extract to ansible-collection-swarm/
```

### Verify Structure

```bash
ls ~/.claude/agents/ansible-collection-swarm/

# Expected:
# README.md
# QUICKSTART.md
# core/ (agents + templates)
# knowledge/ (patterns + examples)
# resources/ (guides)
# docs/ (lessons learned)
```

## Prerequisites

- Claude Code (CLI, desktop, or web)
- jira-rh (Jira CLI tool)
- git
- ansible-test
- ansible-galaxy

## Usage

### 1. Invoke Lead Architect

```bash
Agent({
  description: "Build Ansible collection",
  prompt: "Build collection from EPIC-2345"
})
```

### 2. Answer Questions

**Question 1**: Test environment  
**Question 2**: Delivery target

### 3. Wait for Completion

Swarm handles Phases 0-9 automatically.

## Troubleshooting

**"Cannot find agent"**: Verify path `~/.claude/agents/ansible-collection-swarm/core/agents/`

**"Missing templates"**: Check `core/templates/collection_template/`

**"Connection failed"**: Verify test environment reachable

## Support

See QUICKSTART.md for examples and common scenarios.

---

**Version**: 2.0.0  
**Architecture**: Intelligence-based (universal)
