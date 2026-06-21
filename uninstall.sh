#!/bin/bash
# Uninstall script for Agentic Workflows plugin

set -e

echo "🗑️  Uninstalling Agentic Workflows Plugin"
echo "========================================"
echo ""

# Remove plugin cache
PLUGIN_CACHE="$HOME/.claude/plugins/cache/local/agentic-workflows"
if [ -d "$PLUGIN_CACHE" ]; then
  rm -rf "$PLUGIN_CACHE"
  echo "✅ Removed plugin cache: $PLUGIN_CACHE"
else
  echo "⏭️  Plugin cache not found (already removed)"
fi

# Remove symlink
PLUGIN_LINK="$HOME/.claude/agents/agentic-workflows-plugin"
if [ -L "$PLUGIN_LINK" ]; then
  rm "$PLUGIN_LINK"
  echo "✅ Removed symlink: $PLUGIN_LINK"
else
  echo "⏭️  Symlink not found (already removed)"
fi

# Remove from installed_plugins.json
python3 << 'CLEANUP_SCRIPT'
import json
import os

registry_file = os.path.expanduser("~/.claude/plugins/installed_plugins.json")

if os.path.exists(registry_file):
    try:
        with open(registry_file, 'r') as f:
            data = json.load(f)

        if 'plugins' in data and 'agentic-workflows@agentic-workflows' in data['plugins']:
            del data['plugins']['agentic-workflows@agentic-workflows']
            with open(registry_file, 'w') as f:
                json.dump(data, f, indent=2)
            print("✅ Removed from installed plugins registry")
        else:
            print("⏭️  Not found in registry (already removed)")
    except Exception as e:
        print(f"⚠️  Could not update registry: {e}")
else:
    print("⏭️  Registry file not found")
CLEANUP_SCRIPT

# Remove from known_marketplaces.json (if exists)
python3 << 'CLEANUP_MARKETPLACE'
import json
import os

marketplace_file = os.path.expanduser("~/.claude/plugins/known_marketplaces.json")

if os.path.exists(marketplace_file):
    try:
        with open(marketplace_file, 'r') as f:
            data = json.load(f)

        if 'agentic-workflows' in data:
            del data['agentic-workflows']
            with open(marketplace_file, 'w') as f:
                json.dump(data, f, indent=4)
            print("✅ Removed from marketplaces")
        else:
            print("⏭️  Not found in marketplaces (already removed)")
    except Exception as e:
        print(f"⚠️  Could not update marketplaces: {e}")
else:
    print("⏭️  Marketplaces file not found")
CLEANUP_MARKETPLACE

echo ""
echo "✨ Uninstall complete!"
echo ""
echo "To complete the uninstall:"
echo "  1. Restart Claude Code"
echo "  2. The agentic-workflows agents will no longer appear"
echo ""
echo "To reinstall later:"
echo "  cd $(dirname "$0")"
echo "  bash install.sh"
echo ""
