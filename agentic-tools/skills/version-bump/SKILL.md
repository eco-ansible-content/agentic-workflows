---
name: version-bump
description: Use when releasing or bumping the version of a plugin in this repo (agentic-workflows or agentic-tools), or after changing/adding/removing a skill or agent so the marketplace detects it. Points to every version field that must change and warns which files to leave alone.
---

# Version Bump

## Overview

Skills and agents do **not** carry their own version. A `SKILL.md` frontmatter has only `name` and `description`; agent `.md` files have no version either. **Versioning happens at the plugin level.** When you change, add, or remove a skill/agent, you bump the version of the plugin that ships it — and the marketplace only re-fetches a plugin when its version changes.

This repo publishes **two plugins**. Each plugin's version is duplicated across several manifest files, and it appears **again** in the root marketplace. If you miss one copy, the marketplace and the installed plugin disagree.

## Which plugin owns what

| Plugin | Source dir | Ships |
|--------|-----------|-------|
| `agentic-workflows` | `./claude` | `ansible-collection-swarm`, `windows-collection-swarm` swarms + their agents/skills |
| `agentic-tools` | `./agentic-tools` | `ansible-epic-analysis`, `ansible-module-audit`, `version-bump` skills |

**Step 1 — identify the owning plugin.** Find which source dir contains the skill/agent you changed (`claude/...` → `agentic-workflows`; `agentic-tools/...` → `agentic-tools`). Bump **that** plugin's version. Bump both only if you changed content in both.

## Files to change per plugin

Every version string for a plugin must move together (same SemVer number).

### `agentic-workflows` (currently sourced from `./claude`)

| File | Field(s) |
|------|----------|
| `claude/package.json` | `.version` **and** `.claudePlugin.version` |
| `claude/.claude-plugin/plugin.json` | `.version` |
| `claude/.claude-plugin/marketplace.json` | top-level `.version` **and** the `agentic-workflows` entry in `.plugins[]` |
| `.claude-plugin/marketplace.json` (repo root) | the `agentic-workflows` entry in `.plugins[]` |

→ 6 version occurrences across 4 files.

### `agentic-tools` (currently sourced from `./agentic-tools`)

| File | Field(s) |
|------|----------|
| `agentic-tools/package.json` | `.version` **and** `.claudePlugin.version` |
| `agentic-tools/.claude-plugin/plugin.json` | `.version` |
| `agentic-tools/.claude-plugin/marketplace.json` | top-level `.version` **and** the `agentic-tools` entry in `.plugins[]` |
| `.claude-plugin/marketplace.json` (repo root) | the `agentic-tools` entry in `.plugins[]` |

→ 6 version occurrences across 4 files.

## When a skill/agent is added or removed

Also update the plugin's **skills/agents map** in its `package.json` so the manifest matches what's on disk:

- `agentic-tools/package.json` → `.claudePlugin.skills` (path per skill, e.g. `"version-bump": "skills/version-bump/SKILL.md"`)
- `claude/package.json` → `.claudePlugin.swarms.<swarm>.agents` / `.skill`

Then bump the version (above) so the marketplace picks up the change. Adding, removing, or renaming a skill/agent is a user-facing change and **always** needs a bump.

## Do NOT touch

These carry versions but are **not** part of plugin release versioning:

- `claude/ansible-collection-swarm/**` and `claude/windows-collection-swarm/**` templates (e.g. `ansible-collection-swarm/package.json` at `1.0.0`, `"Your Name"`) — these are scaffolding templates copied into generated collections, not this repo's plugins.
- `.claude-flow/policy/state.json`, `.claude-marketplace/manifest.json` — generated/state files.

## Verify

Before committing, confirm the plugin's version is consistent everywhere and nothing stale remains:

```bash
# Show every version field so you can eyeball consistency
grep -rn '"version"' --include="*.json" .claude-plugin agentic-tools claude \
  | grep -v -E 'ansible-collection-swarm|windows-collection-swarm'
```

Every line for the bumped plugin must show the **new** number; the other plugin and the templates must be unchanged.

## SemVer

Follow SemVer: patch for fixes/skill edits, minor for new skills/agents/features, major for breaking changes. If several changes stack on one unreleased branch, roll them into a **single** bump — don't bump once per change.

## Common mistakes

- Bumping `plugin.json` but forgetting the **root** `.claude-plugin/marketplace.json` entry → marketplace never sees the new version.
- Changing the top-level `version` in a nested `marketplace.json` but not the matching `.plugins[]` entry (or vice-versa).
- Editing `package.json` `.version` but missing the second copy at `.claudePlugin.version`.
- Adding a skill but not registering it in `package.json`'s skills map.
- Bumping the wrong plugin — check the source dir first.
