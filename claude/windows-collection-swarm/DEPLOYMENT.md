# Windows Collection Swarm - Deployment Guide

Complete guide for deploying the portable agent swarm across users and platforms.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Verification](#verification)
4. [Configuration](#configuration)
5. [First Run](#first-run)
6. [Cross-Platform Deployment](#cross-platform-deployment)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software
- **Claude Code**: CLI, Desktop App, or IDE Extension
  - Minimum version: (check latest)
  - Platform: macOS, Linux, or Windows with WSL

- **Git**: For collection repository management
  - `git --version` should work

- **Jira Access**: MCP tool or CLI
  - `jira-rh` command must be available
  - Authentication configured

### Required Access
- **Jira**: Read access to target Epics
- **Git Repository**: Write access to `~/agentic-workflow-collections/`
- **Windows Test Hosts**: WinRM access for integration testing

### System Requirements
- **Disk Space**: ~500MB for swarm + generated collections
- **Memory**: 4GB+ recommended for parallel agents
- **Network**: Access to Jira and Windows hosts

## Installation

### Method 1: Direct Copy (Same Machine)

If swarm is already on your machine:

```bash
# Copy to Claude agents directory
cp -r /path/to/windows-collection-swarm ~/.claude/agents/

# Verify installation
ls ~/.claude/agents/windows-collection-swarm/
```

### Method 2: Archive Transfer (Between Machines)

On source machine:
```bash
# Create portable archive
cd ~/.claude/agents
tar -czf windows-collection-swarm.tar.gz windows-collection-swarm/

# Transfer the .tar.gz file to target machine
```

On target machine:
```bash
# Create agents directory if doesn't exist
mkdir -p ~/.claude/agents

# Extract swarm
tar -xzf windows-collection-swarm.tar.gz -C ~/.claude/agents/

# Verify extraction
ls ~/.claude/agents/windows-collection-swarm/
```

### Method 3: Git Clone (Version Controlled)

If swarm is in version control:

```bash
# Clone to agents directory
git clone <swarm-repo-url> ~/.claude/agents/windows-collection-swarm

# Or with specific branch
git clone -b <branch> <swarm-repo-url> ~/.claude/agents/windows-collection-swarm

# Verify clone
cd ~/.claude/agents/windows-collection-swarm
git status
```

### Method 4: From Scratch (Building Swarm)

If you have the swarm files but no directory structure:

```bash
# Create base structure
mkdir -p ~/.claude/agents/windows-collection-swarm/{agents,templates,resources,examples,docs}

# Copy agent definitions
cp *.md ~/.claude/agents/windows-collection-swarm/agents/

# Copy templates
cp -r templates/* ~/.claude/agents/windows-collection-swarm/templates/

# Copy resources
cp -r resources/* ~/.claude/agents/windows-collection-swarm/resources/

# Copy examples
cp examples/* ~/.claude/agents/windows-collection-swarm/examples/

# Verify structure
tree ~/.claude/agents/windows-collection-swarm/
```

## Verification

### Quick Verification Script

```bash
#!/bin/bash
SWARM="$HOME/.claude/agents/windows-collection-swarm"

echo "=== Windows Collection Swarm Verification ==="
echo ""

# Check base directory
if [ ! -d "$SWARM" ]; then
  echo "❌ FAIL: Swarm directory not found at $SWARM"
  exit 1
else
  echo "✓ Swarm directory exists"
fi

# Check agents
echo ""
echo "Checking agents..."
AGENTS=(
  "lead-architect"
  "jira-ingestion-specialist"
  "foundation-specialist"
  "module-worker"
  "qa-coordinator"
  "refactor-specialist"
  "release-specialist"
)

for agent in "${AGENTS[@]}"; do
  if [ -f "$SWARM/agents/$agent.md" ]; then
    echo "  ✓ $agent"
  else
    echo "  ❌ MISSING: $agent"
  fi
done

# Check templates
echo ""
echo "Checking templates..."
if [ -d "$SWARM/templates/collection_template" ]; then
  echo "  ✓ Collection template directory"
  
  TEMPLATE_FILES=(
    "galaxy.yml"
    "README.md"
    "azure-pipelines.yml"
    ".gitignore"
    "tests/inventory.winrm"
  )
  
  for file in "${TEMPLATE_FILES[@]}"; do
    if [ -f "$SWARM/templates/collection_template/$file" ]; then
      echo "    ✓ $file"
    else
      echo "    ❌ MISSING: $file"
    fi
  done
else
  echo "  ❌ FAIL: Collection template directory not found"
fi

# Check resources
echo ""
echo "Checking resources..."
RESOURCES=(
  "5-pillars-guide.md"
  "4-stage-testing-guide.md"
)

for resource in "${RESOURCES[@]}"; do
  if [ -f "$SWARM/resources/$resource" ]; then
    echo "  ✓ $resource"
  else
    echo "  ❌ MISSING: $resource"
  fi
done

# Check examples
echo ""
echo "Checking examples..."
EXAMPLE_COUNT=$(ls -1 "$SWARM/examples/"*.{ps1,yml} 2>/dev/null | wc -l)
if [ "$EXAMPLE_COUNT" -ge 4 ]; then
  echo "  ✓ Found $EXAMPLE_COUNT example files"
else
  echo "  ⚠ WARNING: Only $EXAMPLE_COUNT examples found (expected at least 4)"
fi

echo ""
echo "=== Verification Complete ==="
```

Save as `verify_swarm.sh`, make executable (`chmod +x verify_swarm.sh`), and run.

### Manual Verification

```bash
# Check directory structure
tree -L 2 ~/.claude/agents/windows-collection-swarm/

# Expected output:
# windows-collection-swarm/
# ├── README.md
# ├── DEPLOYMENT.md
# ├── agents/
# │   ├── lead-architect.md
# │   ├── jira-ingestion-specialist.md
# │   ├── foundation-specialist.md
# │   ├── module-worker.md
# │   ├── qa-coordinator.md
# │   ├── refactor-specialist.md
# │   ├── release-specialist.md
# │   ├── invoke-swarm.md
# │   └── QUICKSTART.md
# ├── templates/
# │   └── collection_template/
# ├── resources/
# │   ├── 5-pillars-guide.md
# │   └── 4-stage-testing-guide.md
# ├── examples/
# │   ├── module_example_cmdlet.ps1
# │   ├── module_example_cim.ps1
# │   ├── module_example_registry.ps1
# │   └── test_example_4stage.yml
# └── docs/
```

## Configuration

### 1. Update Test Inventory

Edit the Windows test hosts:

```bash
# Edit inventory template
vim ~/.claude/agents/windows-collection-swarm/templates/collection_template/tests/inventory.winrm
```

Replace example IPs and credentials with your Windows hosts:

```ini
[windows]
your_host ansible_host=YOUR_IP

[windows:vars]
ansible_user=YOUR_USER
ansible_password=YOUR_PASSWORD
ansible_connection=winrm
ansible_winrm_transport=ntlm
ansible_winrm_server_cert_validation=ignore
```

**IMPORTANT**: This file will be copied to all generated collections.

### 2. Configure Jira Access

Ensure `jira-rh` tool is configured:

```bash
# Test Jira access
jira-rh epic list <TEST_EPIC_KEY> --no-input

# If fails, configure authentication
jira-rh configure
```

### 3. Set Up Git Repository

Create the collection repository:

```bash
# Create repository directory
mkdir -p ~/agentic-workflow-collections

# Initialize git
cd ~/agentic-workflow-collections
git init

# Optional: Add remote
git remote add origin <your-git-repo>

# Verify
git status
```

### 4. Customize Batch Size (Optional)

Edit the Lead Architect configuration:

```bash
vim ~/.claude/agents/windows-collection-swarm/agents/lead-architect.md
```

Find "Batch Size: 3" and change to desired value (2-5).

## First Run

### Test with Small Epic

Start with a small Epic (5-10 modules) to verify swarm operation:

1. **Open Claude Code**

2. **Read invocation template**:
   ```
   cat ~/.claude/agents/windows-collection-swarm/agents/invoke-swarm.md
   ```

3. **Copy the Agent call** and replace `<EPIC_KEY>` with your test Epic

4. **Execute** the Agent call in Claude Code

5. **Monitor progress**:
   ```bash
   # Watch backlog creation
   watch -n 5 "cat ~/agentic-workflow-collections/*/*/docs/plans/module_backlog.md"
   
   # Monitor module creation
   watch -n 10 "ls -1 ~/agentic-workflow-collections/*/*/plugins/modules/ | wc -l"
   ```

### Expected Output

You should see:
1. Jira Ingestion creates module backlog
2. Foundation scaffolds collection directory
3. Module Workers start building in parallel
4. QA Coordinator tests each batch
5. Refactor Specialist runs at 10-module milestone
6. Release Specialist delivers final collection

### First Run Checklist

- [ ] Module backlog created in `docs/plans/module_backlog.md`
- [ ] Collection scaffolded at `~/agentic-workflow-collections/<namespace>/<name>/`
- [ ] Modules appearing in `plugins/modules/`
- [ ] Tests passing (check QA Coordinator output)
- [ ] Git commits being made
- [ ] Final push to repository

## Cross-Platform Deployment

### macOS

```bash
# Standard installation
cp -r windows-collection-swarm ~/.claude/agents/

# Or use curl if downloading
curl -L <download-url> | tar -xz -C ~/.claude/agents/
```

### Linux

```bash
# Same as macOS
cp -r windows-collection-swarm ~/.claude/agents/

# Ensure permissions
chmod -R 755 ~/.claude/agents/windows-collection-swarm/
```

### Windows (WSL)

```bash
# In WSL terminal
cp -r windows-collection-swarm ~/.claude/agents/

# Or from PowerShell, copy to WSL home
# Copy-Item -Recurse windows-collection-swarm \\wsl$\Ubuntu\home\$USER\.claude\agents\
```

### Path Differences

The swarm uses `~/.claude/agents/windows-collection-swarm/` which resolves to:

- **macOS**: `/Users/<username>/.claude/agents/windows-collection-swarm/`
- **Linux**: `/home/<username>/.claude/agents/windows-collection-swarm/`
- **Windows WSL**: `/home/<username>/.claude/agents/windows-collection-swarm/`

All internal paths are relative to `~`, so no changes needed.

## Troubleshooting

### Swarm Directory Not Found

```bash
# Check if directory exists
ls ~/.claude/agents/

# If not, create it
mkdir -p ~/.claude/agents/

# Re-run installation
```

### Agent Files Missing

```bash
# Check agents directory
ls ~/.claude/agents/windows-collection-swarm/agents/

# If empty or missing files, re-extract/copy
tar -xzf windows-collection-swarm.tar.gz -C ~/.claude/agents/ --overwrite
```

### Templates Not Found During Scaffolding

```bash
# Verify templates exist
ls ~/.claude/agents/windows-collection-swarm/templates/collection_template/

# Check galaxy.yml exists
cat ~/.claude/agents/windows-collection-swarm/templates/collection_template/galaxy.yml

# If missing, re-install swarm
```

### Jira Authentication Fails

```bash
# Test Jira access
jira-rh whoami

# Reconfigure if needed
jira-rh configure

# Test specific Epic
PAGER=cat jira-rh epic list <EPIC_KEY> --no-input
```

### WinRM Connection Fails

```bash
# Test WinRM connectivity
ansible -i tests/inventory.winrm windows -m win_ping

# Check Windows host allows WinRM
# On Windows host, run in PowerShell as Admin:
# Enable-PSRemoting -Force
# Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
```

### Permission Denied Errors

```bash
# Fix permissions on swarm
chmod -R 755 ~/.claude/agents/windows-collection-swarm/

# Fix permissions on git repository
chmod -R 755 ~/agentic-workflow-collections/
```

### Git Push Fails

```bash
# Check git remote
cd ~/agentic-workflow-collections/<namespace>/<name>
git remote -v

# Add remote if missing
git remote add origin <your-repo-url>

# Check authentication
git fetch origin

# Force push if needed (CAUTION)
git push -f origin main
```

## Multi-User Deployment

### Shared Network Location

```bash
# Install to shared location
SHARED_SWARM="/mnt/shared/claude-agents/windows-collection-swarm"
cp -r windows-collection-swarm "$SHARED_SWARM"

# Each user symlinks
ln -s "$SHARED_SWARM" ~/.claude/agents/windows-collection-swarm
```

### Team Repository

```bash
# Initialize git in swarm (on source)
cd ~/.claude/agents/windows-collection-swarm
git init
git add .
git commit -m "Initial swarm setup"
git remote add origin <team-repo>
git push -u origin main

# Other team members clone
git clone <team-repo> ~/.claude/agents/windows-collection-swarm

# Pull updates
cd ~/.claude/agents/windows-collection-swarm
git pull
```

### Custom Configurations Per User

```bash
# User-specific inventory (don't commit)
echo "tests/inventory.winrm" >> .gitignore

# Each user maintains their own inventory
cp tests/inventory.winrm tests/inventory.winrm.template
# Edit tests/inventory.winrm with your hosts
```

## Updating the Swarm

### Pull Updates from Git

```bash
cd ~/.claude/agents/windows-collection-swarm
git pull origin main
```

### Manual Update

```bash
# Backup current swarm
cp -r ~/.claude/agents/windows-collection-swarm \
      ~/.claude/agents/windows-collection-swarm.backup

# Copy new version
cp -r /path/to/new/windows-collection-swarm ~/.claude/agents/

# Restore custom configurations
cp ~/.claude/agents/windows-collection-swarm.backup/templates/collection_template/tests/inventory.winrm \
   ~/.claude/agents/windows-collection-swarm/templates/collection_template/tests/inventory.winrm
```

## Uninstallation

```bash
# Remove swarm
rm -rf ~/.claude/agents/windows-collection-swarm

# Optional: Remove generated collections
rm -rf ~/agentic-workflow-collections
```

## Next Steps

After successful deployment:

1. **Read the Quick Start**: `agents/QUICKSTART.md`
2. **Review Agent Definitions**: Browse `agents/*.md`
3. **Study the Guides**: Read `resources/*.md`
4. **Try a Test Run**: Use small Epic to validate
5. **Customize Templates**: Edit `templates/collection_template/`

---

**Deployment complete? Run your first swarm with `agents/invoke-swarm.md`!**
