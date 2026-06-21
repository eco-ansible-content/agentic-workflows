# First-Time Installation Guide

Quick guide for installing Agentic Workflows for the first time.

## ⚡ Quick Install (Recommended)

**Copy and paste this one line:**

```bash
cd ~/.claude/agents && git clone https://github.com/eco-ansible-content/agentic-workflows.git && bash agentic-workflows/install.sh
```

**Then restart Claude Code.**

That's it! The agents will appear in **Agents → Library → Plugin agents**.

---

## 📦 What Gets Installed?

- **Plugin cache:** `~/.claude/plugins/cache/local/agentic-workflows/1.0.0/`
- **Symlink:** `~/.claude/agents/agentic-workflows-plugin`
- **Registry entry:** Added to `~/.claude/plugins/installed_plugins.json`
- **24 agents:** All `agentic-workflows:*` agents registered

---

## ✅ Verify Installation

After restarting Claude Code:

1. Open **Agents → Library** tab
2. Look for **"Plugin agents"** section
3. You should see agents like:
   - `agentic-workflows:ansible-collection-swarm-lead-architect`
   - `agentic-workflows:ansible-collection-swarm-module-worker`
   - ... (24 total)

---

## 🔧 Alternative: Add as Marketplace

If you want to browse the plugin in the marketplace:

```bash
# In Claude Code, run:
/plugin marketplace add eco-ansible-content/agentic-workflows

# Then install:
/plugin install agentic-workflows@eco-ansible-content
```

**Note:** The marketplace method may not work on all Claude Code versions. Use the one-line install if you encounter issues.

---

## 🗑️ Uninstall

```bash
cd ~/.claude/agents/agentic-workflows
bash uninstall.sh
```

Then restart Claude Code.

---

## 🚀 Using the Agents

**Via Slash Command:**
```bash
/ansible-collection-swarm EPIC-XXX
```

**Via Agent Tool:**
```javascript
Agent({
  description: "Build Ansible collection",
  subagent_type: "agentic-workflows/ansible-collection-swarm:lead-architect",
  prompt: "Build collection from Jira Epic EPIC-2345"
})
```

---

## ❓ Troubleshooting

**Problem:** Agents don't appear after install

**Solutions:**
1. Make sure you **restarted Claude Code** (fully quit and relaunch)
2. Check the symlink exists: `ls -la ~/.claude/agents/agentic-workflows-plugin`
3. Reinstall:
   ```bash
   cd ~/.claude/agents/agentic-workflows
   bash uninstall.sh
   bash install.sh
   ```
4. Restart Claude Code again

**Problem:** Installation script fails

**Check:**
- Git is installed: `git --version`
- GitHub CLI is installed: `gh --version`
- Jira CLI is installed: `jira-rh --version` or `jira version`

Install missing tools, then run `bash install.sh` again.

---

## 📖 Full Documentation

See [README.md](README.md) for complete documentation.
