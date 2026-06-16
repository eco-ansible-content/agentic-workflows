#!/bin/bash
# Quick installation script for Agentic Workflows Claude Code plugin

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
PLUGIN_LINK="$CLAUDE_AGENTS_DIR/agentic-workflows-plugin"

echo "🚀 Installing Agentic Workflows Plugin"
echo "=================================="
echo ""
echo "📁 Repository: $REPO_DIR"
echo "📁 Claude agents directory: $CLAUDE_AGENTS_DIR"
echo ""

# Check prerequisites
echo "🔍 Checking prerequisites..."
echo ""

MISSING_TOOLS=()

# Check git (required)
if ! command -v git &> /dev/null; then
  MISSING_TOOLS+=("git")
fi

# Check jira CLI (jira-rh or jira-cli)
if ! command -v jira-rh &> /dev/null && ! command -v jira &> /dev/null; then
  MISSING_TOOLS+=("jira-rh OR jira-cli")
fi

# Check gh (GitHub CLI)
if ! command -v gh &> /dev/null; then
  MISSING_TOOLS+=("gh")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
  echo "❌ Missing required tools:"
  echo ""
  for tool in "${MISSING_TOOLS[@]}"; do
    echo "  • $tool"
  done
  echo ""
  echo "Installation instructions:"
  echo ""

  if [[ " ${MISSING_TOOLS[@]} " =~ " git " ]]; then
    echo "  git:"
    echo "    brew install git              # Mac"
    echo "    sudo apt install git          # Linux"
    echo ""
  fi

  if [[ " ${MISSING_TOOLS[@]} " =~ " jira-rh OR jira-cli " ]]; then
    echo "  jira-rh (recommended - faster):"
    echo "    npm install -g jira-rh"
    echo "    jira-rh config                # Configure after install"
    echo ""
    echo "  OR jira-cli:"
    echo "    brew install jira-cli         # Mac"
    echo "    https://github.com/ankitpokhrel/jira-cli"
    echo ""
  fi

  if [[ " ${MISSING_TOOLS[@]} " =~ " gh " ]]; then
    echo "  gh (GitHub CLI):"
    echo "    brew install gh               # Mac"
    echo "    sudo apt install gh           # Linux"
    echo "    gh auth login                 # Authenticate after install"
    echo ""
  fi

  echo "After installing missing tools, run this script again."
  exit 1
fi

echo "✅ All prerequisites installed:"
if command -v jira-rh &> /dev/null; then
  echo "  • git: $(git --version | head -1)"
  echo "  • jira-rh: $(jira-rh --version 2>/dev/null || echo 'installed')"
  echo "  • gh: $(gh --version | head -1)"
elif command -v jira &> /dev/null; then
  echo "  • git: $(git --version | head -1)"
  echo "  • jira-cli: $(jira version 2>/dev/null || echo 'installed')"
  echo "  • gh: $(gh --version | head -1)"
fi
echo ""

# Check if Claude agents directory exists
if [ ! -d "$CLAUDE_AGENTS_DIR" ]; then
  echo "❌ Claude agents directory not found: $CLAUDE_AGENTS_DIR"
  echo ""
  echo "Are you sure Claude Code is installed?"
  exit 1
fi

# Check for old hyaish-agents plugin (optional cleanup for upgrade)
echo "🧹 Checking for old plugin installation..."
OLD_PLUGIN_CACHE="$HOME/.claude/plugins/cache/local/hyaish-agents"
OLD_PLUGIN_LINK="$CLAUDE_AGENTS_DIR/hyaish-agents-plugin"

if [ -d "$OLD_PLUGIN_CACHE" ] || [ -L "$OLD_PLUGIN_LINK" ]; then
  echo ""
  echo "⚠️  Found old 'hyaish-agents' plugin installation"
  echo ""
  echo "   This will cause duplicate agents in Claude Code's agent library"
  echo "   (both 'hyaish-agents:*' and 'agentic-workflows:*' will appear)"
  echo ""
  echo "   Recommended: Remove old plugin to avoid confusion"
  echo ""
  read -p "   Remove old 'hyaish-agents' plugin? (y/n) " -n 1 -r
  echo
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Remove old cache directory
    if [ -d "$OLD_PLUGIN_CACHE" ]; then
      rm -rf "$OLD_PLUGIN_CACHE"
      echo "   ✅ Removed old plugin cache"
    fi

    # Remove old symlink
    if [ -L "$OLD_PLUGIN_LINK" ]; then
      rm "$OLD_PLUGIN_LINK"
      echo "   ✅ Removed old plugin symlink"
    fi

    # Clean up registry entries
    python3 << 'CLEANUP_SCRIPT'
import json
import os

registry_file = os.path.expanduser("~/.claude/plugins/installed_plugins.json")
marketplace_file = os.path.expanduser("~/.claude/plugins/known_marketplaces.json")

# Clean up installed_plugins.json
if os.path.exists(registry_file):
    try:
        with open(registry_file, 'r') as f:
            data = json.load(f)

        if 'plugins' in data and 'hyaish-agents@hyaish-agents' in data['plugins']:
            del data['plugins']['hyaish-agents@hyaish-agents']
            with open(registry_file, 'w') as f:
                json.dump(data, f, indent=2)
            print("   ✅ Removed old plugin from registry")
    except Exception as e:
        print(f"   ⚠️  Could not clean registry: {e}")

# Clean up known_marketplaces.json
if os.path.exists(marketplace_file):
    try:
        with open(marketplace_file, 'r') as f:
            data = json.load(f)

        if 'hyaish-agents' in data:
            del data['hyaish-agents']
            with open(marketplace_file, 'w') as f:
                json.dump(data, f, indent=2)
            print("   ✅ Removed old marketplace entry")
    except Exception as e:
        print(f"   ⚠️  Could not clean marketplace: {e}")
CLEANUP_SCRIPT

    echo "   ✨ Upgrade cleanup complete"
    echo ""
  else
    echo "   ⏭️  Skipped - old plugin will remain installed"
    echo "   Note: You may see duplicate agents in Claude Code"
    echo ""
  fi
else
  echo "   ✅ No old plugin found - clean install"
  echo ""
fi

# Check if symlink already exists
if [ -L "$PLUGIN_LINK" ]; then
  CURRENT_TARGET=$(readlink "$PLUGIN_LINK")
  echo "⚠️  Symlink already exists:"
  echo "   $PLUGIN_LINK -> $CURRENT_TARGET"
  echo ""
  read -p "Remove and recreate? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm "$PLUGIN_LINK"
    echo "   Removed existing symlink"
  else
    echo "   Skipping symlink creation"
    echo ""
    echo "To manually update:"
    echo "  rm $PLUGIN_LINK"
    echo "  ln -s $REPO_DIR/claude $PLUGIN_LINK"
    exit 0
  fi
elif [ -e "$PLUGIN_LINK" ]; then
  echo "❌ Path exists but is not a symlink: $PLUGIN_LINK"
  echo ""
  echo "Please remove or rename it manually, then run this script again"
  exit 1
fi

# Create plugin cache directory (Claude Code plugin standard location)
PLUGIN_CACHE="$HOME/.claude/plugins/cache/local/agentic-workflows/1.0.0"
mkdir -p "$PLUGIN_CACHE"

# Copy plugin files to cache (including hidden files)
echo "📦 Installing plugin to cache..."
(cd "$REPO_DIR/claude" && cp -r . "$PLUGIN_CACHE/")
echo "✅ Plugin installed: $PLUGIN_CACHE"
echo ""

# Create legacy symlink for backwards compatibility
ln -s "$PLUGIN_CACHE" "$PLUGIN_LINK"
echo "✅ Created legacy symlink: $PLUGIN_LINK -> $PLUGIN_CACHE"
echo ""

# Configure permissions for autonomous operation
SETTINGS_FILE="$HOME/.claude/settings.local.json"
echo "🔧 Configuring autonomous permissions..."

# Backup existing settings if they exist
if [ -f "$SETTINGS_FILE" ]; then
  cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup-$(date +%Y%m%d-%H%M%S)"
  echo "   Backed up existing settings"
fi

# Create or update settings with autonomous permissions
python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

settings_file = os.path.expanduser("~/.claude/settings.local.json")

# Read existing settings or create new
if os.path.exists(settings_file):
    try:
        with open(settings_file, 'r') as f:
            data = json.load(f)
    except json.JSONDecodeError:
        data = {}
else:
    data = {}

# Ensure permissions structure exists
if 'permissions' not in data:
    data['permissions'] = {}
if 'allow' not in data['permissions']:
    data['permissions']['allow'] = []

# Add autonomous permissions (avoid duplicates)
autonomous_perms = [
    "Bash(*)",
    "WebSearch",
    "WebFetch",
    "Read",
    "Write",
    "Edit",
    "Agent",
    "Skill"
]

for perm in autonomous_perms:
    if perm not in data['permissions']['allow']:
        data['permissions']['allow'].append(perm)

# Write back
with open(settings_file, 'w') as f:
    json.dump(data, f, indent=2)

print("✅ Configured zero-permission autonomy (merged with existing settings)")
PYTHON_SCRIPT

echo "   All bash commands and tools pre-approved for autonomous operation"
echo ""

# Register marketplace in Claude Code
MARKETPLACE_FILE="$HOME/.claude/plugins/known_marketplaces.json"
echo "📝 Registering marketplace..."

if [ -f "$MARKETPLACE_FILE" ]; then
  # Backup marketplace file
  cp "$MARKETPLACE_FILE" "$MARKETPLACE_FILE.backup-$(date +%Y%m%d-%H%M%S)"

  # Use Python to add marketplace entry
  python3 << PYTHON_SCRIPT
import json
import sys
import os
from datetime import datetime

marketplace_file = os.path.expanduser("$MARKETPLACE_FILE")
repo_dir = "$REPO_DIR"

try:
    with open(marketplace_file, 'r') as f:
        data = json.load(f)

    # Add agentic-workflows marketplace pointing to repo directory
    if 'agentic-workflows' not in data:
        data['agentic-workflows'] = {
            'source': {
                'source': 'directory',
                'path': repo_dir
            },
            'installLocation': repo_dir,
            'lastUpdated': datetime.now().isoformat() + 'Z'
        }

        with open(marketplace_file, 'w') as f:
            json.dump(data, f, indent=2)

        print("✅ Marketplace registered")
    else:
        print("✅ Marketplace already registered")
except Exception as e:
    print(f"⚠️  Could not register marketplace: {e}")
    sys.exit(1)  # Exit with error code
PYTHON_SCRIPT
else
  echo "⚠️  Marketplace file not found"
fi
echo ""

# Register plugin in Claude Code's installed plugins registry
REGISTRY_FILE="$HOME/.claude/plugins/installed_plugins.json"
echo "📝 Registering plugin..."

if [ -f "$REGISTRY_FILE" ]; then
  # Backup registry
  cp "$REGISTRY_FILE" "$REGISTRY_FILE.backup-$(date +%Y%m%d-%H%M%S)"

  # Use Python to update JSON (safer than manual editing)
  python3 << PYTHON_SCRIPT
import json
import sys
import os
from datetime import datetime

registry_file = os.path.expanduser("$REGISTRY_FILE")
plugin_cache = "$PLUGIN_CACHE"

try:
    with open(registry_file, 'r') as f:
        data = json.load(f)

    # Add or update agentic-workflows plugin
    if 'agentic-workflows@agentic-workflows' not in data.get('plugins', {}):
        if 'plugins' not in data:
            data['plugins'] = {}

        data['plugins']['agentic-workflows@agentic-workflows'] = [{
            'scope': 'user',
            'installPath': plugin_cache,
            'version': '1.0.0',
            'installedAt': datetime.now().isoformat() + 'Z',
            'lastUpdated': datetime.now().isoformat() + 'Z'
        }]

        with open(registry_file, 'w') as f:
            json.dump(data, f, indent=2)

        print("✅ Plugin registered in Claude Code")
    else:
        print("✅ Plugin already registered")
except Exception as e:
    print(f"⚠️  Could not register plugin: {e}")
    sys.exit(1)  # Exit with error code
PYTHON_SCRIPT
else
  echo "⚠️  Registry file not found - plugin installed but not registered"
  echo "   You may need to restart Claude Code for discovery"
fi
echo ""

# Verify installation
echo "🔍 Verifying installation..."
echo ""

if [ -f "$REPO_DIR/claude/verify.sh" ]; then
  cd "$REPO_DIR/claude"
  bash verify.sh
else
  echo "⚠️  Verification script not found"
  echo ""
  echo "Manual verification:"
  echo "  cd $REPO_DIR/claude"
  echo "  ./verify.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Test the plugin:"
echo "   /ansible-collection-swarm --help"
echo ""
echo "2. Build your first collection:"
echo "   /ansible-collection-swarm EPIC-XXX"
echo ""
echo "3. Read documentation:"
echo "   cat $REPO_DIR/README.md"
echo "   cat $REPO_DIR/claude/ansible-collection-swarm/QUICKSTART.md"
echo ""
