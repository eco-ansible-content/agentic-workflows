# Hyaish Agents - Plugin Marketplace Setup

To make Hyaish Agents installable via `/plugin install` (like Superpowers), you need to publish it to a plugin marketplace.

## Installation Methods

### Method 1: Official Claude Plugins Marketplace (Recommended)

**Once approved by Claude team**:
```bash
/plugin install agentic-workflows@claude-plugins-official
```

This is the best user experience - single command, no setup required.

**To get approved**:
1. Push to GitHub: `https://github.com/eco-ansible-content/agentic-workflows`
2. Submit to official registry (instructions below)
3. Wait for review and approval

---

### Method 2: Personal Marketplace (Available Now)

Users add your marketplace once, then install plugins from it:

**Step 1**: User adds your marketplace
```bash
/plugin marketplace add eco-ansible-content/agentic-workflows
```

**Step 2**: User installs the plugin
```bash
/plugin install agentic-workflows@eco-ansible-content
```

**This works immediately** after you push to GitHub!

---

### Method 3: Manual Installation (Always Available)

```bash
cd ~/.claude/agents
git clone https://github.com/eco-ansible-content/agentic-workflows.git
bash agentic-workflows/install.sh
```

## How to Publish

### Option A: Submit to Official Claude Plugins Registry

This gives users the **best experience** - single-command install like Superpowers.

**Steps**:

1. **Push to GitHub** (you're ready for this):
   ```bash
   git add .
   git commit -m "Initial release v1.0.0"
   git tag v1.0.0
   git push -u origin main
   git push origin v1.0.0
   ```

2. **Submit to official registry**:
   - Go to: https://github.com/anthropics/claude-plugins-registry (or wherever official registry is)
   - Fork the repository
   - Add your plugin to the registry:
   
   **File**: `plugins/agentic-workflows.json`
   ```json
   {
     "name": "agentic-workflows",
     "version": "1.0.0",
     "description": "Intelligent multi-agent swarms for automation",
     "repository": "https://github.com/eco-ansible-content/agentic-workflows",
     "pluginDirectory": "claude",
     "installPath": "agentic-workflows-plugin",
     "author": "Hyaish",
     "license": "MIT",
     "features": {
       "swarms": ["ansible-collection-swarm", "windows-collection-swarm"],
       "agents": 24,
       "slashCommands": ["/ansible-collection-swarm", "/windows-collection-swarm"]
     }
   }
   ```
   
   - Create pull request
   - Wait for approval

3. **After approval**, users install with:
   ```bash
   /plugin install agentic-workflows@claude-plugins-official
   ```

---

### Option B: Create Your Own Marketplace (Like Superpowers)

Superpowers has its own marketplace at `obra/superpowers-marketplace`. You can do the same!

**Steps**:

1. **Create marketplace repository**:
   ```bash
   # Create new GitHub repo: hyaish/hyaish-marketplace
   ```

2. **Add marketplace structure**:
   ```
   hyaish-marketplace/
   ├── README.md
   └── plugins/
       └── agentic-workflows.json
   ```

3. **plugins/agentic-workflows.json**:
   ```json
   {
     "name": "agentic-workflows",
     "version": "1.0.0",
     "description": "Intelligent multi-agent swarms for automation",
     "repository": "https://github.com/eco-ansible-content/agentic-workflows",
     "pluginDirectory": "claude",
     "installPath": "agentic-workflows-plugin",
     "author": "Hyaish",
     "license": "MIT"
   }
   ```

4. **Users add marketplace**:
   ```bash
   /plugin marketplace add hyaish/hyaish-marketplace
   ```

5. **Users install plugin**:
   ```bash
   /plugin install agentic-workflows@eco-ansible-content
   ```

**Pros**:
- ✅ Full control over your marketplace
- ✅ Can publish updates immediately
- ✅ No approval process needed

**Cons**:
- ❌ Users need 2 commands (add marketplace + install)
- ❌ Less discoverable than official registry

---

## Comparison: Installation Methods

### Superpowers (Official Registry)

```bash
# Single command - best UX
/plugin install superpowers@claude-plugins-official
```

### Your Plugin (After Official Approval)

```bash
# Same single command experience
/plugin install agentic-workflows@claude-plugins-official
```

### Your Plugin (Personal Marketplace - Available Now)

```bash
# Two commands - but works immediately
/plugin marketplace add eco-ansible-content/agentic-workflows
/plugin install agentic-workflows@eco-ansible-content
```

### Your Plugin (Manual - Always Available)

```bash
# Traditional git clone
cd ~/.claude/agents
git clone https://github.com/eco-ansible-content/agentic-workflows.git
bash agentic-workflows/install.sh
```

---

## Recommended Approach

**Phase 1: Launch** (Do this now)
1. Push to GitHub
2. Team uses manual install OR personal marketplace
3. Get feedback, iterate

**Phase 2: Official** (After validation)
1. Submit to official Claude plugins registry
2. Get approved
3. Team updates to single-command install

This approach lets you:
- ✅ Launch immediately
- ✅ Get user feedback
- ✅ Prove value before official submission
- ✅ Have easier approval process (proven plugin)

---

## Current Status

**Ready for**: 
- ✅ Manual installation (works now)
- ✅ Personal marketplace (after GitHub push)

**Pending**:
- ⏳ Official registry submission (your choice when)
- ⏳ Official approval (external review)

**Recommended**:
1. Push to GitHub today
2. Share with team via manual install
3. Create personal marketplace if desired
4. Submit to official registry after proving value

---

## Files Included for Marketplace

Your repository already has the right structure:

- ✅ `.claude-marketplace/manifest.json` - Marketplace metadata
- ✅ `claude/.claude-plugin/plugin.json` - Plugin manifest
- ✅ `claude/package.json` - NPM package metadata
- ✅ `install.sh` - Installation script
- ✅ `README.md` - Clear documentation

This supports all installation methods!

---

## Next Steps

**Immediate** (today):
```bash
# Push to GitHub
git add .
git commit -m "Initial release v1.0.0"
git tag v1.0.0
git push -u origin main
git push origin v1.0.0

# Share with team
# Manual install: They run install.sh
```

**Short-term** (this week):
```bash
# Optional: Create personal marketplace
# Create hyaish/hyaish-marketplace repository
# Add plugin JSON
# Team can use /plugin install
```

**Long-term** (when ready):
```bash
# Submit to official Claude registry
# Get approved
# Team updates to single command
```

---

**You're ready to push and share with your team!** 🚀
