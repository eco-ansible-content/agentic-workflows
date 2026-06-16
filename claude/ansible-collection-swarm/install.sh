#!/bin/bash
# Universal Ansible Collection Swarm - Installation Script
# Makes agents available in Claude Code's agent library

set -e

SWARM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$HOME/.claude/agents"

echo "🚀 Installing Universal Ansible Collection Swarm"
echo "================================================"
echo ""
echo "📁 Swarm location: $SWARM_DIR"
echo "📁 Agents directory: $AGENTS_DIR"
echo ""

# Verify we're in the right directory
if [ ! -f "$SWARM_DIR/README.md" ]; then
  echo "❌ Error: Not in the ansible-collection-swarm directory"
  echo "   Run this script from: ~/.claude/agents/ansible-collection-swarm/"
  exit 1
fi

# Check if already installed via symlink
if [ -L "$AGENTS_DIR/ansible-collection-swarm" ]; then
  echo "✅ Swarm already installed (symlink exists)"
  echo ""

  # Verify symlink points to correct location
  LINK_TARGET=$(readlink "$AGENTS_DIR/ansible-collection-swarm")
  if [ "$LINK_TARGET" = "$SWARM_DIR" ]; then
    echo "✅ Symlink correctly points to: $SWARM_DIR"
  else
    echo "⚠️  Symlink points to different location: $LINK_TARGET"
    echo "   Expected: $SWARM_DIR"
    echo ""
    read -p "Remove and recreate symlink? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm "$AGENTS_DIR/ansible-collection-swarm"
      ln -s "$SWARM_DIR" "$AGENTS_DIR/ansible-collection-swarm"
      echo "✅ Symlink updated"
    fi
  fi
elif [ -d "$AGENTS_DIR/ansible-collection-swarm" ] && [ ! -L "$AGENTS_DIR/ansible-collection-swarm" ]; then
  echo "⚠️  Directory exists but is not a symlink"
  echo "   Location: $AGENTS_DIR/ansible-collection-swarm"
  echo ""
  echo "Options:"
  echo "  1. Backup and replace with symlink (recommended)"
  echo "  2. Keep existing directory"
  echo ""
  read -p "Choose option (1/2): " -n 1 -r
  echo
  if [[ $REPLY = "1" ]]; then
    BACKUP_DIR="$AGENTS_DIR/ansible-collection-swarm.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$AGENTS_DIR/ansible-collection-swarm" "$BACKUP_DIR"
    ln -s "$SWARM_DIR" "$AGENTS_DIR/ansible-collection-swarm"
    echo "✅ Backed up to: $BACKUP_DIR"
    echo "✅ Symlink created"
  else
    echo "ℹ️  Keeping existing directory - no changes made"
  fi
else
  # Create symlink
  ln -s "$SWARM_DIR" "$AGENTS_DIR/ansible-collection-swarm"
  echo "✅ Symlink created: $AGENTS_DIR/ansible-collection-swarm -> $SWARM_DIR"
fi

echo ""
echo "📋 Verifying installation..."
echo ""

# Verify agents are accessible
AGENTS=(
  "lead-architect"
  "jira-ingestion-specialist"
  "foundation-specialist"
  "enhancement-specialist"
  "platform-prerequisite-specialist"
  "module-worker"
  "qa-coordinator"
  "refactor-specialist"
  "release-specialist"
  "ci-validation-specialist"
  "learning-evolution-specialist"
)

FOUND_COUNT=0
for agent in "${AGENTS[@]}"; do
  if [ -f "$SWARM_DIR/core/agents/$agent.md" ]; then
    echo "  ✅ $agent"
    ((FOUND_COUNT++))
  else
    echo "  ❌ $agent (missing)"
  fi
done

echo ""
echo "Found $FOUND_COUNT/${#AGENTS[@]} agents"
echo ""

if [ $FOUND_COUNT -eq ${#AGENTS[@]} ]; then
  echo "✅ Installation successful!"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📚 How to Use"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Option 1: Via Agent tool (from Claude Code)"
  echo "  Agent({"
  echo "    description: \"Build collection\","
  echo "    prompt: \"Build collection from Jira Epic EPIC-XXX\","
  echo "    subagent_type: \"ansible-collection-swarm:lead-architect\""
  echo "  })"
  echo ""
  echo "Option 2: Direct invocation"
  echo "  claude-code --agent ~/.claude/agents/ansible-collection-swarm/core/agents/lead-architect.md \\"
  echo "    \"Build collection from EPIC-XXX\""
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📖 Documentation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "  Quick Start:  cat $SWARM_DIR/QUICKSTART.md"
  echo "  Full Guide:   cat $SWARM_DIR/GETTING-STARTED.md"
  echo "  Detection:    cat $SWARM_DIR/COLLECTION-DETECTION.md"
  echo "  README:       cat $SWARM_DIR/README.md"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
else
  echo "⚠️  Installation incomplete - some agents are missing"
  echo "   Check the swarm directory: $SWARM_DIR"
fi
