# Installation Options - Like Superpowers

Your team can install Hyaish Agents using **the same methods as Superpowers**!

## 📦 Installation Methods (Choose One)

### Method 1: One-Line Install (Easiest - Available Now)

```bash
cd ~/.claude/agents && git clone https://github.com/eco-ansible-content/agentic-workflows.git && bash agentic-workflows/install.sh
```

**What it does**:
1. Clones repository
2. Creates symlink: `agentic-workflows-plugin` → `agentic-workflows/claude/`
3. Runs verification
4. Shows usage examples

**Best for**: Teams that want to start using it immediately

---

### Method 2: Plugin Marketplace (Like Superpowers - After Setup)

Just like Superpowers uses `/plugin install superpowers@claude-plugins-official`, your team can use:

**Step 1**: Add marketplace (one time)
```bash
/plugin marketplace add eco-ansible-content/agentic-workflows
```

**Step 2**: Install plugin
```bash
/plugin install agentic-workflows@eco-ansible-content
```

**Best for**: Teams that want the Superpowers-style experience

---

### Method 3: Manual Install (Most Control)

```bash
cd ~/.claude/agents
git clone https://github.com/eco-ansible-content/agentic-workflows.git
ln -s agentic-workflows/claude agentic-workflows-plugin
cd agentic-workflows/claude
./verify.sh
```

**Best for**: Developers who want full control

---

## 🎯 Comparison to Superpowers

| Feature | Superpowers | Hyaish Agents |
|---------|-------------|---------------|
| **Official Registry** | `/plugin install superpowers@claude-plugins-official` | Available after marketplace submission |
| **Personal Marketplace** | `/plugin marketplace add obra/superpowers-marketplace`<br>`/plugin install superpowers@superpowers-marketplace` | `/plugin marketplace add eco-ansible-content/agentic-workflows`<br>`/plugin install agentic-workflows@eco-ansible-content` |
| **Manual Install** | `git clone` + setup | `git clone` + `bash install.sh` |
| **Slash Commands** | `/tdd`, `/brainstorming`, etc. | `/ansible-collection-swarm`, `/windows-collection-swarm` |
| **Agent Access** | `superpowers:code-reviewer` | `agentic-workflows/ansible-collection-swarm:lead-architect` |

---

## 🔄 Migration Path

### Phase 1: Launch (Now)

**Your team installs via**:
```bash
cd ~/.claude/agents && git clone https://github.com/eco-ansible-content/agentic-workflows.git && bash agentic-workflows/install.sh
```

**Usage**:
```bash
/ansible-collection-swarm EPIC-XXX
```

---

### Phase 2: Personal Marketplace (Optional - This Week)

**You create**: `hyaish/hyaish-marketplace` repository

**Your team installs via**:
```bash
/plugin marketplace add eco-ansible-content/agentic-workflows
/plugin install agentic-workflows@eco-ansible-content
```

**Usage** (same):
```bash
/ansible-collection-swarm EPIC-XXX
```

---

### Phase 3: Official Registry (Future - After Validation)

**You submit**: To official Claude plugins registry

**Your team installs via**:
```bash
/plugin install agentic-workflows@claude-plugins-official
```

**Usage** (same):
```bash
/ansible-collection-swarm EPIC-XXX
```

---

## 📝 What You Need to Do

### Today (Push to GitHub)

```bash
cd ~/.claude/agents/agentic-workflows
git add .
git commit -m "Initial release v1.0.0"
git tag v1.0.0
git push -u origin main
git push origin v1.0.0
```

**Result**: Method 1 (one-line install) works immediately!

---

### This Week (Optional - Personal Marketplace)

**Create marketplace repository**:
1. Create new repo: `hyaish/hyaish-marketplace`
2. Add structure:
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
     "installPath": "agentic-workflows-plugin"
   }
   ```

4. Push to GitHub

**Result**: Method 2 (plugin marketplace) works!

---

### Later (Optional - Official Registry)

**Submit to official registry**:
1. Wait for official registry URL (from Anthropic/Claude)
2. Fork the registry
3. Add your plugin
4. Create pull request
5. Wait for approval

**Result**: Method 3 (official single-command) works!

---

## ✅ Current Status

**Ready Now**:
- ✅ Repository structure complete
- ✅ Installation script ready
- ✅ Marketplace manifest included (`.claude-marketplace/manifest.json`)
- ✅ All documentation complete

**Works After Push**:
- ✅ One-line install (Method 1)
- ✅ Manual install (Method 3)

**Works After Marketplace Setup**:
- ⏳ Plugin marketplace install (Method 2) - requires creating marketplace repo

**Works After Official Approval**:
- ⏳ Official registry install - requires submission and approval

---

## 🎁 Recommendation

**Start with Method 1** (one-line install):
```bash
cd ~/.claude/agents && git clone https://github.com/eco-ansible-content/agentic-workflows.git && bash agentic-workflows/install.sh
```

**Why**:
- ✅ Works immediately after GitHub push
- ✅ Simple for team
- ✅ No additional setup needed
- ✅ Can migrate to marketplace later

**Later**, if desired:
- Create personal marketplace (2-command install like Superpowers)
- Submit to official registry (1-command install)

---

## 📚 See Also

- **MARKETPLACE.md** - Detailed marketplace setup guide
- **PUSH-GUIDE.md** - GitHub publishing instructions
- **README.md** - Installation methods shown to users

---

**Bottom line**: Your plugin is **just as installable as Superpowers**, with multiple methods available! 🚀
