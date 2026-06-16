# Publishing Guide - Hyaish Agents Plugin

Guide for publishing the `agentic-workflows` plugin to GitHub and making it installable via `/plugin install`.

## Pre-Publishing Checklist

### 1. Update Author Information

Edit these files:

**`.claude-plugin/plugin.json`**:
```json
{
  "author": {
    "name": "Your Actual Name",
    "email": "your.actual.email@example.com"
  },
  "homepage": "https://github.com/YOUR-USERNAME/agentic-workflows",
  "repository": "https://github.com/YOUR-USERNAME/agentic-workflows"
}
```

**`package.json`**:
```json
{
  "author": "Your Actual Name <your.actual.email@example.com>",
  "repository": {
    "url": "git+https://github.com/YOUR-USERNAME/agentic-workflows.git"
  },
  "bugs": {
    "url": "https://github.com/YOUR-USERNAME/agentic-workflows/issues"
  },
  "homepage": "https://github.com/YOUR-USERNAME/agentic-workflows#readme"
}
```

### 2. Create LICENSE

```bash
cd ~/.claude/agents/agentic-workflows

cat > LICENSE <<'EOF'
MIT License

Copyright (c) 2026 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
```

### 3. Create .gitignore

```bash
cat > .gitignore <<'EOF'
# Node
node_modules/
npm-debug.log*
package-lock.json

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Temporary
*.log
*.tmp
*.bak
ruvector.db
*.rvf
*.rvf.lock

# Test output
.coverage
htmlcov/
EOF
```

## GitHub Publishing

### Step 1: Initialize Git Repository

```bash
cd ~/.claude/agents/agentic-workflows

# Initialize if not already
git init

# Review files
git status

# Add all files
git add .

# Commit
git commit -m "Initial release v1.0.0 - Hyaish Agents Plugin

- Ansible Collection Swarm (Universal) - 11 agents, 5 patterns
- Windows Collection Swarm (Legacy) - 13 agents
- Unified plugin structure
- Complete documentation"
```

### Step 2: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `agentic-workflows`
3. Description: `Intelligent multi-agent swarms for Ansible collection automation`
4. Public or Private (your choice)
5. **Do NOT initialize** with README, .gitignore, or LICENSE (you have them)
6. Click "Create repository"

### Step 3: Push to GitHub

```bash
# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/agentic-workflows.git

# Rename branch to main
git branch -M main

# Push
git push -u origin main

# Tag version
git tag v1.0.0
git push origin v1.0.0
```

### Step 4: Verify on GitHub

Visit: `https://github.com/YOUR-USERNAME/agentic-workflows`

Should see:
- ✅ README.md displayed
- ✅ All directories visible
- ✅ v1.0.0 tag in releases

## Plugin Registry Registration

### Option 1: Private Team Registry

Contact your organization's plugin registry administrator with:

```json
{
  "name": "agentic-workflows",
  "registry": "YOUR-ORG",
  "url": "https://github.com/YOUR-USERNAME/agentic-workflows.git",
  "version": "1.0.0",
  "description": "Intelligent multi-agent swarms for Ansible collection automation",
  "swarms": [
    "ansible-collection-swarm",
    "windows-collection-swarm"
  ]
}
```

After registration, team installs via:
```bash
/plugin install agentic-workflows@YOUR-ORG
```

### Option 2: Public Claude Plugin Registry

1. Fork the official registry: https://github.com/claude-plugins/official-registry
2. Add entry to `plugins/agentic-workflows.json`:

```json
{
  "name": "agentic-workflows",
  "description": "Intelligent multi-agent swarms for Ansible collection automation",
  "version": "1.0.0",
  "author": "Your Name",
  "repository": "https://github.com/YOUR-USERNAME/agentic-workflows",
  "install": "git+https://github.com/YOUR-USERNAME/agentic-workflows.git",
  "keywords": ["ansible", "automation", "multi-agent", "swarm"],
  "swarms": {
    "ansible-collection-swarm": {
      "description": "Universal platform support",
      "agents": 11
    },
    "windows-collection-swarm": {
      "description": "Windows-specific (legacy)",
      "agents": 13
    }
  }
}
```

3. Create pull request
4. Wait for review and approval

After approval, anyone can install:
```bash
/plugin install agentic-workflows@claude-plugins-official
```

## Sharing with Your Team (Without Registry)

### Method 1: Git Clone (Works Now)

Send to team:

```
📦 Hyaish Agents Plugin - Now Available

Install:
  cd ~/.claude/agents
  git clone https://github.com/YOUR-USERNAME/agentic-workflows.git
  cd agentic-workflows
  ./verify.sh

Usage:
  /ansible-collection-swarm EPIC-XXX
  /windows-collection-swarm EPIC-XXX

Documentation:
  cat ~/.claude/agents/agentic-workflows/README.md

Repository:
  https://github.com/YOUR-USERNAME/agentic-workflows
```

### Method 2: Internal Distribution (Air-Gapped)

```bash
# Create tarball
cd ~/.claude/agents
tar -czf agentic-workflows-v1.0.0.tar.gz agentic-workflows/

# Share tarball via internal network/email

# Team installs:
cd ~/.claude/agents
tar -xzf agentic-workflows-v1.0.0.tar.gz
cd agentic-workflows
./verify.sh
```

## Version Updates

### Releasing v1.1.0

```bash
cd ~/.claude/agents/agentic-workflows

# Update version in:
# - package.json
# - .claude-plugin/plugin.json

# Make changes, commit
git add .
git commit -m "Release v1.1.0: Add new features

- Feature 1
- Feature 2
- Bug fixes"

# Tag and push
git tag v1.1.0
git push origin main
git push origin v1.1.0
```

### Team Updates

```bash
cd ~/.claude/agents/agentic-workflows
git pull origin main
./verify.sh
```

## Release Checklist

Before each release:

- [ ] Update version in `package.json`
- [ ] Update version in `.claude-plugin/plugin.json`
- [ ] Update CHANGELOG (if you create one)
- [ ] Run `./verify.sh` - all checks pass
- [ ] Test both swarms with real Epics
- [ ] Commit with descriptive message
- [ ] Tag version: `git tag vX.Y.Z`
- [ ] Push: `git push origin main --tags`
- [ ] Create GitHub Release (optional)
- [ ] Notify team of update

## Continuous Integration (Optional)

### GitHub Actions

Create `.github/workflows/verify.yml`:

```yaml
name: Verify Plugin

on: [push, pull_request]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run verification
        run: ./verify.sh
```

## Documentation Maintenance

Keep these updated:

- `README.md` - Plugin overview
- `INSTALL.md` - Installation instructions
- `ansible-collection-swarm/QUICKSTART.md` - Quick start
- `ansible-collection-swarm/GETTING-STARTED.md` - Comprehensive guide
- Each swarm's README.md

## Support Setup

### GitHub Issues

Enable Issues in repository settings.

Create issue templates:

**.github/ISSUE_TEMPLATE/bug_report.md**
**.github/ISSUE_TEMPLATE/feature_request.md**

### GitHub Discussions

Enable Discussions for:
- Questions
- Show and tell
- Ideas

## Adding New Swarms

To add a third swarm (e.g., `kubernetes-operator-swarm`):

```bash
cd ~/.claude/agents/agentic-workflows

# Create swarm directory
mkdir kubernetes-operator-swarm

# Add swarm files
# - agents/
# - skills/
# - documentation

# Update package.json
# Add to claudePlugin.swarms section

# Update verify.sh
# Add verification for new swarm

# Commit
git add .
git commit -m "Add Kubernetes Operator Swarm"
git tag v1.1.0
git push origin main --tags
```

Usage:
```
/kubernetes-operator-swarm EPIC-XXX
```

Namespace:
```
agentic-workflows/kubernetes-operator-swarm:AGENT-NAME
```

## Analytics (Optional)

Track usage:
- GitHub Stars
- Clone count
- Issue activity
- Download stats (if published to npm)

## License

MIT License - Ensure LICENSE file is present and correct.

## Support

After publishing:
- Monitor GitHub Issues
- Respond to questions in Discussions
- Keep documentation updated
- Release bug fixes promptly
- Communicate breaking changes clearly

---

**Ready to publish?** Follow the steps above and share with your team! 🚀
