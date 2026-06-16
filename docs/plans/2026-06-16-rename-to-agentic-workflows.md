# Rename agentic-workflows to agentic-workflows Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Clone the new empty repository and rename all references from agentic-workflows to agentic-workflows, ensuring no traces of the old name remain.

**Architecture:** Fresh clone of new repo → copy all files → systematic rename of all references → verify completeness

**Tech Stack:** Git, Bash, find/grep for text replacement

---

## Task 1: Clone New Repository

**Files:**
- Create: `/Users/hyaish/Documents/Git/agentic-workflows/` (new directory)

**Step 1: Clone the empty repository**

```bash
cd /Users/hyaish/Documents/Git
git clone git@github.com:eco-ansible-content/agentic-workflows.git
```

Expected: New directory created, initialized with empty git repo

**Step 2: Verify clone**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
git remote -v
```

Expected output:
```
origin	git@github.com:eco-ansible-content/agentic-workflows.git (fetch)
origin	git@github.com:eco-ansible-content/agentic-workflows.git (push)
```

---

## Task 2: Copy All Files from Old Repository

**Files:**
- Source: `/Users/hyaish/Documents/Git/agentic-workflows/`
- Destination: `/Users/hyaish/Documents/Git/agentic-workflows/`

**Step 1: Copy all files excluding .git directory**

```bash
cd /Users/hyaish/Documents/Git
rsync -av --exclude='.git' --exclude='ruvector.db' agentic-workflows/ agentic-workflows/
```

Expected: All files copied to new directory

**Step 2: Verify copy**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
ls -la
```

Expected: All files present except .git (which should be the new repo's .git)

---

## Task 3: Rename Package Name in package.json

**Files:**
- Modify: `/Users/hyaish/Documents/Git/agentic-workflows/claude/package.json`

**Step 1: Update package.json**

Replace:
```json
{
  "name": "@hyaish/agents",
  "version": "1.0.0",
  "description": "Hyaish Agent Swarms - Unified plugin containing multiple intelligent agent swarms for automation",
```

With:
```json
{
  "name": "@eco-ansible-content/agentic-workflows",
  "version": "1.0.0",
  "description": "Agentic Workflows - Autonomous multi-agent workflows for building Ansible collections",
```

**Step 2: Update repository URLs in package.json**

Replace:
```json
  "repository": {
    "type": "git",
    "url": "git+https://github.com/eco-ansible-content/agentic-workflows.git"
  },
```

With:
```json
  "repository": {
    "type": "git",
    "url": "git+https://github.com/eco-ansible-content/agentic-workflows.git"
  },
```

**Step 3: Update bugs and homepage URLs**

Replace:
```json
  "bugs": {
    "url": "https://github.com/eco-ansible-content/agentic-workflows/issues"
  },
  "homepage": "https://github.com/eco-ansible-content/agentic-workflows#readme",
```

With:
```json
  "bugs": {
    "url": "https://github.com/eco-ansible-content/agentic-workflows/issues"
  },
  "homepage": "https://github.com/eco-ansible-content/agentic-workflows#readme",
```

**Step 4: Update claudePlugin name**

Replace:
```json
  "claudePlugin": {
    "name": "agentic-workflows",
```

With:
```json
  "claudePlugin": {
    "name": "agentic-workflows",
```

**Step 5: Verify package.json**

```bash
cat /Users/hyaish/Documents/Git/agentic-workflows/claude/package.json | grep -E "name|url|homepage|bugs"
```

Expected: No occurrences of "agentic-workflows" or "eco-ansible-content/agentic-workflows"

---

## Task 4: Update Marketplace Manifest

**Files:**
- Modify: `/Users/hyaish/Documents/Git/agentic-workflows/.claude-marketplace/manifest.json`

**Step 1: Read current manifest**

```bash
cat /Users/hyaish/Documents/Git/agentic-workflows/.claude-marketplace/manifest.json
```

**Step 2: Replace all agentic-workflows references**

Use find and replace:
- `agentic-workflows` → `agentic-workflows`
- `eco-ansible-content/agentic-workflows` → `eco-ansible-content/agentic-workflows`
- `Hyaish` → `Eco Ansible Content` (in author/org fields)

**Step 3: Verify manifest**

```bash
cat /Users/hyaish/Documents/Git/agentic-workflows/.claude-marketplace/manifest.json | grep -i hyaish
```

Expected: No output (no hyaish references)

---

## Task 5: Update All Markdown Documentation Files

**Files:**
- Modify: `README.md`
- Modify: `GETTING-STARTED.md`
- Modify: `CONTRIBUTING.md`
- Modify: `RELEASE-ANNOUNCEMENT.md`
- Modify: All files in `docs/`
- Modify: All files in `claude/`
- Modify: All files in `insights/`

**Step 1: Global find and replace - Repository name**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
find . -type f \( -name "*.md" -o -name "*.txt" \) -not -path "./.git/*" -exec sed -i '' 's/agentic-workflows/agentic-workflows/g' {} +
```

**Step 2: Global find and replace - GitHub org/user**

```bash
find . -type f \( -name "*.md" -o -name "*.txt" \) -not -path "./.git/*" -exec sed -i '' 's/Yaish25491\/agentic-workflows/eco-ansible-content\/agentic-workflows/g' {} +
find . -type f \( -name "*.md" -o -name "*.txt" \) -not -path "./.git/*" -exec sed -i '' 's/hyaish\/agentic-workflows/eco-ansible-content\/agentic-workflows/g' {} +
```

**Step 3: Update title in README.md**

Replace first line:
```markdown
# Hyaish Agents
```

With:
```markdown
# Agentic Workflows
```

**Step 4: Update plugin namespace references**

```bash
find . -type f \( -name "*.md" -o -name "*.txt" \) -not -path "./.git/*" -exec sed -i '' 's/agentic-workflows@eco-ansible-content/agentic-workflows@eco-ansible-content/g' {} +
find . -type f \( -name "*.md" -o -name "*.txt" \) -not -path "./.git/*" -exec sed -i '' 's/hyaish\/agentic-workflows/eco-ansible-content\/agentic-workflows/g' {} +
```

**Step 5: Verify no hyaish references remain**

```bash
grep -r "hyaish" . --exclude-dir=.git --exclude-dir=ruvector.db --exclude="*.db" | grep -v "Hen Yaish"
```

Expected: Only references to "Hen Yaish" (author name) should remain

---

## Task 6: Update Installation Script

**Files:**
- Modify: `/Users/hyaish/Documents/Git/agentic-workflows/install.sh`

**Step 1: Update plugin link variable**

Replace:
```bash
PLUGIN_LINK="$CLAUDE_AGENTS_DIR/agentic-workflows-plugin"
```

With:
```bash
PLUGIN_LINK="$CLAUDE_AGENTS_DIR/agentic-workflows-plugin"
```

**Step 2: Update plugin cache path**

Replace:
```bash
PLUGIN_CACHE="$HOME/.claude/plugins/cache/local/agentic-workflows/1.0.0"
```

With:
```bash
PLUGIN_CACHE="$HOME/.claude/plugins/cache/local/agentic-workflows/1.0.0"
```

**Step 3: Update Python marketplace registration**

Replace:
```python
    # Add agentic-workflows marketplace pointing to repo directory
    if 'agentic-workflows' not in data:
        data['agentic-workflows'] = {
```

With:
```python
    # Add agentic-workflows marketplace pointing to repo directory
    if 'agentic-workflows' not in data:
        data['agentic-workflows'] = {
```

**Step 4: Update plugin installation reference**

Replace:
```python
    # Add or update agentic-workflows plugin
    if 'agentic-workflows@agentic-workflows' not in data.get('plugins', {}):
        data['plugins']['agentic-workflows@agentic-workflows'] = [{
```

With:
```python
    # Add or update agentic-workflows plugin
    if 'agentic-workflows@agentic-workflows' not in data.get('plugins', {}):
        data['plugins']['agentic-workflows@agentic-workflows'] = [{
```

**Step 5: Verify install.sh**

```bash
cat /Users/hyaish/Documents/Git/agentic-workflows/install.sh | grep -i hyaish
```

Expected: No output (no hyaish references except possibly in comments about old name)

---

## Task 7: Update Agent Definition Files

**Files:**
- Modify: All `.md` files in `claude/ansible-collection-swarm/core/agents/`
- Modify: All `.md` files in `claude/windows-collection-swarm/agents/`

**Step 1: Find all agent definition files**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
find claude -name "*.md" -path "*/agents/*"
```

**Step 2: Replace namespace in agent definitions**

```bash
find claude -name "*.md" -path "*/agents/*" -exec sed -i '' 's/agentic-workflows:/agentic-workflows:/g' {} +
```

**Step 3: Verify agent files**

```bash
grep -r "agentic-workflows:" claude/
```

Expected: No output

---

## Task 8: Update Skill Files

**Files:**
- Modify: `claude/ansible-collection-swarm/skills/ansible-collection-swarm.md`
- Modify: Any other skill files

**Step 1: Find all skill files**

```bash
find claude -name "*.md" -path "*/skills/*"
```

**Step 2: Replace references in skill files**

```bash
find claude -name "*.md" -path "*/skills/*" -exec sed -i '' 's/agentic-workflows/agentic-workflows/g' {} +
```

**Step 3: Verify skill files**

```bash
grep -r "agentic-workflows" claude/*/skills/
```

Expected: No output

---

## Task 9: Update Any Remaining Configuration Files

**Files:**
- Check: `.claude-plugin/`
- Check: Any JSON files

**Step 1: Find all JSON files**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
find . -name "*.json" -not -path "./.git/*"
```

**Step 2: Search for hyaish references in JSON**

```bash
find . -name "*.json" -not -path "./.git/*" -exec grep -l "hyaish" {} +
```

**Step 3: Replace in any found files**

For each file found, replace:
- `agentic-workflows` → `agentic-workflows`
- `eco-ansible-content/agentic-workflows` → `eco-ansible-content/agentic-workflows`
- `@hyaish` → `@eco-ansible-content`

---

## Task 10: Final Verification

**Step 1: Comprehensive search for agentic-workflows**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
grep -r "agentic-workflows" . --exclude-dir=.git --exclude-dir=ruvector.db --exclude="*.db"
```

Expected: No output

**Step 2: Comprehensive search for hyaish (excluding author name)**

```bash
grep -r "hyaish" . --exclude-dir=.git --exclude-dir=ruvector.db --exclude="*.db" | grep -v "Hen Yaish" | grep -v "hyaish@example.com"
```

Expected: No output (only author name/email should remain)

**Step 3: Search for old GitHub URLs**

```bash
grep -r "Yaish25491" . --exclude-dir=.git
```

Expected: No output

**Step 4: Verify plugin name in package.json**

```bash
cat claude/package.json | jq '.claudePlugin.name'
```

Expected: `"agentic-workflows"`

---

## Task 11: Initial Git Commit

**Step 1: Check git status**

```bash
cd /Users/hyaish/Documents/Git/agentic-workflows
git status
```

**Step 2: Add all files**

```bash
git add .
```

**Step 3: Create initial commit**

```bash
git commit -m "feat: initial commit - rename from agentic-workflows to agentic-workflows

- Renamed all references from agentic-workflows to agentic-workflows
- Updated GitHub org from Yaish25491/hyaish to eco-ansible-content
- Updated package namespace from @hyaish to @eco-ansible-content
- Updated all documentation, installation scripts, and configuration files
- No traces of old name remain (except author attribution)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

**Step 4: Push to new repository**

```bash
git push -u origin main
```

Expected: All files pushed to eco-ansible-content/agentic-workflows

---

## Task 12: Update Team Message

**Files:**
- Modify or Delete: `team-message.txt`

**Step 1: Update team-message.txt with new instructions**

Replace content with:
```
Quick Install:
cd ~/.claude/agents && git clone git@github.com:eco-ansible-content/agentic-workflows.git && bash agentic-workflows/install.sh

**Repository**: eco-ansible-content/agentic-workflows
**Link**: https://github.com/eco-ansible-content/agentic-workflows
```

Or delete the file if it's no longer needed.

---

## Post-Implementation Checklist

After completing all tasks:

- [ ] No references to "agentic-workflows" remain (except in git history)
- [ ] No references to "Yaish25491" or "eco-ansible-content/agentic-workflows" remain
- [ ] Package name is `@eco-ansible-content/agentic-workflows`
- [ ] All GitHub URLs point to `eco-ansible-content/agentic-workflows`
- [ ] Plugin namespace is `agentic-workflows`
- [ ] Initial commit pushed to new repository
- [ ] Installation script references correct paths
- [ ] README title is "Agentic Workflows"
- [ ] Author attribution to "Hen Yaish" remains intact

---

## Execution Notes

- DRY: Use sed/find for bulk replacements rather than manual edits
- YAGNI: Don't add new features, just rename
- Frequent commits: Commit after each major task group
- Test after each task: Verify replacements worked as expected
