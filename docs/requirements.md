# Requirements - Hyaish Agents

Complete list of tools and dependencies required to run Hyaish Agents swarms.

## Required CLI Tools

### 1. jira-rh or jira-cli

**Purpose**: Fast Jira Epic reading for autonomous operation

**Used by**: `jira-ingestion-specialist` agent

**Install**:

```bash
# Option 1: jira-rh (recommended - faster)
npm install -g jira-rh

# Configure
jira-rh config
# Provide: Jira URL, email, API token

# Test
jira-rh issue EPIC-2345
```

```bash
# Option 2: jira-cli
brew install jira-cli              # Mac
sudo snap install jira-cli         # Linux

# Or from source: https://github.com/ankitpokhrel/jira-cli

# Configure
jira init

# Test
jira issue view EPIC-2345
```

**Why required**: The swarm reads Jira Epics autonomously instead of asking you 50 questions. Without this tool, the agents can't read Epic details.

---

### 2. gh (GitHub CLI)

**Purpose**: Automated Pull Request creation for enhancement mode

**Used by**: `release-specialist` agent (enhancement mode only)

**Install**:

```bash
# Mac
brew install gh

# Linux
sudo apt install gh          # Debian/Ubuntu
sudo dnf install gh          # Fedora/RHEL

# Or: https://cli.github.com/
```

**Authenticate**:

```bash
gh auth login
# Follow prompts to authenticate with GitHub
```

**Test**:

```bash
gh --version
gh auth status
```

**Why required**: When enhancing existing collections, the swarm automatically creates Pull Requests for code review. Without `gh`, it falls back to manual PR creation (you have to create PR yourself).

**Fallback**: If `gh` not installed, the swarm outputs manual PR creation instructions. Not required for new projects (full build mode).

---

### 3. git

**Purpose**: Standard git operations (commit, push, branch)

**Used by**: `release-specialist` agent (both modes)

**Install**:

```bash
# Usually pre-installed, but if needed:

# Mac
brew install git

# Linux
sudo apt install git         # Debian/Ubuntu
sudo dnf install git         # Fedora/RHEL
```

**Configure**:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Test**:

```bash
git --version
git config --list
```

**Why required**: All git operations (commit, push, branch, etc.) use standard git CLI.

---

## Optional Tools

### ansible

**Purpose**: Local testing and validation of generated collections

**Install**:

```bash
pip install ansible

# Or with pipx (isolated)
pipx install ansible
```

**Test**:

```bash
ansible --version
ansible-galaxy --version
```

**Why optional**: The swarm can generate collections without testing them. If you provide a test environment, it will run integration tests using Ansible.

---

### ansible-galaxy

**Purpose**: Building and validating Ansible collections

**Install**: Usually comes with Ansible

**Test**:

```bash
ansible-galaxy --version
ansible-galaxy collection build --help
```

**Why optional**: Only needed if you want to manually build/validate collections locally.

---

## Environment Requirements

### Claude Code

**Install**:
- CLI: `npm install -g @anthropic/claude-code`
- Desktop: Download from https://claude.ai/code
- Web: https://claude.ai/code

**Test**:
```bash
claude --version
```

---

### Jira Access

**Required**:
- Jira instance URL (cloud or self-hosted)
- API token or credentials
- Access to Epic you want to build from

**Setup**:
```bash
# Configure jira-rh
jira-rh config
# Provide:
#   - Jira URL: https://your-company.atlassian.net
#   - Email: your.email@company.com
#   - API Token: (generate at https://id.atlassian.com/manage-profile/security/api-tokens)

# Or configure jira-cli
jira init
```

**Test**:
```bash
jira-rh issue EPIC-2345
# Should display Epic details
```

---

### Test Environment (Optional)

**For Windows modules**:
- Windows Server with WinRM enabled
- Test credentials (username/password or certificate)
- Example: `192.168.50.10, winrm, user: Administrator, pass: P@ss123`

**For Linux modules**:
- Linux server with SSH enabled
- SSH key or password
- Example: `ssh://test-server.lab.local:22, key: ~/.ssh/ansible_rsa`

**For Network modules**:
- Network device or simulator (GNS3, EVE-NG, CML)
- CLI access (SSH or telnet)
- Example: `network_cli://10.0.1.1, user: admin, pass: cisco123`

**For Cloud modules**:
- Cloud subscription (Azure, AWS, GCP)
- API credentials or service principal
- Example: `local (Azure API), subscription: abc-1234`

**For API-based modules**:
- No physical environment needed
- Can build code-only without testing
- Example: `local (no tests)`

---

### Git Repository (Optional)

**For delivery**:
- Git repository URL for pushing completed collections
- Write access to the repository
- Example: `https://github.com/myorg/ansible-collections.git`

**For enhancement mode**:
- Fork of the collection repository
- Fork remote configured: `git remote add fork <your-fork-url>`
- Example fork: `https://github.com/yourusername/ansible-collections.git`

**For local delivery**:
- No git repository needed
- Collection delivered to `~/agentic-workflow-collections/`

---

## Installation Check

### Manual Check

Run these commands to verify all tools are installed:

```bash
# Required tools
git --version                     # Should show version
jira-rh --version                 # Or: jira version
gh --version                      # Should show version

# Optional tools
ansible --version                 # May not be installed
ansible-galaxy --version          # May not be installed

# Authentication status
gh auth status                    # Should show logged in
jira-rh issue EPIC-XXX            # Should fetch an Epic
```

### Automated Check

The `install.sh` script checks prerequisites automatically:

```bash
bash install.sh

# Output:
# 🔍 Checking prerequisites...
# ✅ All prerequisites installed:
#   • git: git version 2.42.0
#   • jira-rh: installed
#   • gh: gh version 2.86.0
```

If any tools are missing:

```bash
# Output:
# ❌ Missing required tools:
#   • jira-rh OR jira-cli
#   • gh
#
# Installation instructions:
# [shows commands for missing tools]
```

---

## Platform-Specific Notes

### macOS

All tools available via Homebrew:

```bash
brew install git gh
npm install -g jira-rh
pip3 install ansible
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install git gh
npm install -g jira-rh           # Requires Node.js
pip3 install ansible
```

### Linux (Fedora/RHEL)

```bash
sudo dnf install git gh
npm install -g jira-rh           # Requires Node.js
pip3 install ansible
```

### Windows (WSL recommended)

Run in Windows Subsystem for Linux (WSL) using Linux instructions above.

Alternatively:
- Install Git for Windows
- Install GitHub CLI for Windows
- Use npm on Windows for jira-rh
- Install Python + Ansible on Windows

---

## Troubleshooting

### "command not found: jira-rh"

**Problem**: jira-rh not installed or not in PATH

**Solution**:
```bash
# Install
npm install -g jira-rh

# If npm not found, install Node.js first
brew install node              # Mac
sudo apt install nodejs npm    # Linux

# Verify PATH
echo $PATH | grep npm
```

### "gh: command not found"

**Problem**: GitHub CLI not installed

**Solution**:
```bash
brew install gh                # Mac
sudo apt install gh            # Linux
```

### "gh auth status" shows not logged in

**Problem**: GitHub CLI not authenticated

**Solution**:
```bash
gh auth login
# Choose: GitHub.com
# Choose: HTTPS or SSH
# Follow browser authentication
```

### "jira-rh: unauthorized"

**Problem**: Jira credentials not configured or invalid

**Solution**:
```bash
jira-rh config
# Re-enter: Jira URL, email, API token
# Generate new API token: https://id.atlassian.com/manage-profile/security/api-tokens
```

### Install script fails with "Missing required tools"

**Problem**: Prerequisites not installed

**Solution**: Follow the installation instructions shown by the script for each missing tool.

---

## Version Requirements

**Minimum versions**:
- git: 2.23+ (for `git restore`, `git switch`)
- gh: 2.0+ (for `gh pr create`)
- jira-rh: any version (or jira-cli 1.0+)
- Node.js: 14+ (if using jira-rh)
- Python: 3.8+ (if using Ansible)
- Ansible: 2.10+ (if running tests)

**Check versions**:
```bash
git --version
gh --version
node --version            # For jira-rh
python3 --version         # For Ansible
ansible --version         # If installed
```

---

## Summary

**Absolute minimum** to run the swarm:
1. Claude Code
2. git
3. jira-rh (or jira-cli)
4. gh
5. Jira access (configured)

**For full experience** (testing + delivery):
6. Test environment (Windows/Linux/Network/Cloud)
7. Git repository (for remote delivery)
8. Ansible (for local testing)

**Total setup time**: ~10 minutes (assuming you have Jira access)
