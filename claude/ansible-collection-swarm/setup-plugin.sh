#!/bin/bash
# Setup script for publishing Ansible Collection Swarm as a Claude Code plugin

set -e

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Setting up Ansible Collection Swarm Plugin"
echo "=============================================="
echo ""
echo "📁 Plugin directory: $PLUGIN_DIR"
echo ""

# Check required files
echo "📋 Checking required files..."
REQUIRED_FILES=(
  ".claude-plugin/plugin.json"
  "package.json"
  "skills/ansible-collection-swarm.md"
  "README.md"
  "LICENSE"
)

MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$PLUGIN_DIR/$file" ]; then
    echo "  ✅ $file"
  else
    echo "  ❌ $file (missing)"
    ((MISSING++))
  fi
done

if [ $MISSING -gt 0 ]; then
  echo ""
  echo "⚠️  Missing $MISSING required files"

  # Offer to create LICENSE
  if [ ! -f "$PLUGIN_DIR/LICENSE" ]; then
    echo ""
    read -p "Create MIT LICENSE file? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      cat > "$PLUGIN_DIR/LICENSE" <<'EOF'
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
      echo "  ✅ LICENSE created"
    fi
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Configuration Checklist"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Update these placeholders before publishing:"
echo ""
echo "1. package.json:"
echo "   - YOUR-ORG → your-organization-name"
echo "   - YOUR-USERNAME → your-github-username"
echo "   - Your Name → your-name"
echo "   - your.email@example.com → your-email"
echo ""
echo "2. .claude-plugin/plugin.json:"
echo "   - YOUR-USERNAME → your-github-username"
echo "   - Your Name → your-name"
echo "   - your.email@example.com → your-email"
echo ""
echo "3. LICENSE:"
echo "   - Your Name → your-name"
echo ""

read -p "Have you updated all placeholders? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  echo "⚠️  Please update placeholders before continuing"
  echo ""
  echo "Edit these files:"
  echo "  - $PLUGIN_DIR/package.json"
  echo "  - $PLUGIN_DIR/.claude-plugin/plugin.json"
  echo "  - $PLUGIN_DIR/LICENSE"
  echo ""
  echo "Then run this script again"
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Git Repository Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if git repo exists
if [ ! -d "$PLUGIN_DIR/.git" ]; then
  echo "Initializing git repository..."
  cd "$PLUGIN_DIR"
  git init
  echo "  ✅ Git repository initialized"
else
  echo "  ✅ Git repository already exists"
fi

# Create .gitignore if missing
if [ ! -f "$PLUGIN_DIR/.gitignore" ]; then
  cat > "$PLUGIN_DIR/.gitignore" <<'EOF'
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

# Test
*.log
.coverage

# Temporary
*.tmp
*.bak
ruvector.db
EOF
  echo "  ✅ .gitignore created"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Review and commit files:"
echo "   cd $PLUGIN_DIR"
echo "   git add ."
echo "   git commit -m \"Initial release v1.0.0\""
echo "   git tag v1.0.0"
echo ""
echo "2. Create GitHub repository:"
echo "   - Go to: https://github.com/new"
echo "   - Repository name: ansible-collection-swarm"
echo "   - Public or Private (your choice)"
echo "   - Do NOT initialize with README (you have one)"
echo ""
echo "3. Push to GitHub:"
echo "   git remote add origin https://github.com/YOUR-USERNAME/ansible-collection-swarm.git"
echo "   git branch -M main"
echo "   git push -u origin main --tags"
echo ""
echo "4. Install for testing:"
echo "   (Already installed at: $PLUGIN_DIR)"
echo "   Test with: /ansible-collection-swarm --help"
echo ""
echo "5. Share with team:"
echo "   cd ~/.claude/agents"
echo "   git clone https://github.com/YOUR-USERNAME/ansible-collection-swarm.git"
echo ""
echo "6. Register plugin (optional):"
echo "   - Private registry: Contact your team's registry admin"
echo "   - Public registry: Submit PR to claude-plugins/official-registry"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Setup complete!"
echo ""
