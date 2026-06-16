#!/bin/bash
# Verify Universal Ansible Collection Swarm Installation

SWARM_DIR="$HOME/.claude/agents/ansible-collection-swarm"

echo "🔍 Verifying Universal Ansible Collection Swarm"
echo "================================================"
echo ""

# Check if directory exists
if [ ! -d "$SWARM_DIR" ]; then
  echo "❌ Swarm not found at: $SWARM_DIR"
  echo ""
  echo "To install:"
  echo "  1. Clone or copy to: $SWARM_DIR"
  echo "  2. Run this script again"
  exit 1
fi

echo "✅ Swarm directory found: $SWARM_DIR"
echo ""

# Check agents
echo "📋 Checking agents..."
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

FOUND_AGENTS=0
for agent in "${AGENTS[@]}"; do
  if [ -f "$SWARM_DIR/core/agents/$agent.md" ]; then
    echo "  ✅ $agent"
    ((FOUND_AGENTS++))
  else
    echo "  ❌ $agent (missing)"
  fi
done

echo ""
echo "Agents: $FOUND_AGENTS/${#AGENTS[@]}"
echo ""

# Check patterns
echo "📋 Checking patterns..."
PATTERNS=(
  "rest-api-pattern"
  "cli-based-pattern"
  "config-file-pattern"
  "database-pattern"
  "soap-api-pattern"
)

FOUND_PATTERNS=0
for pattern in "${PATTERNS[@]}"; do
  if [ -f "$SWARM_DIR/knowledge/patterns/$pattern.md" ]; then
    echo "  ✅ $pattern"
    ((FOUND_PATTERNS++))
  else
    echo "  ❌ $pattern (missing)"
  fi
done

echo ""
echo "Patterns: $FOUND_PATTERNS/${#PATTERNS[@]}"
echo ""

# Check documentation
echo "📋 Checking documentation..."
DOCS=(
  "README.md"
  "QUICKSTART.md"
  "GETTING-STARTED.md"
  "COLLECTION-DETECTION.md"
  "AGENTS.md"
  "INSTALLATION.md"
)

FOUND_DOCS=0
for doc in "${DOCS[@]}"; do
  if [ -f "$SWARM_DIR/$doc" ]; then
    echo "  ✅ $doc"
    ((FOUND_DOCS++))
  else
    echo "  ❌ $doc (missing)"
  fi
done

echo ""
echo "Documentation: $FOUND_DOCS/${#DOCS[@]}"
echo ""

# Check plugin files
echo "📋 Checking plugin files..."
PLUGIN_FILES=(
  ".claude-plugin/plugin.json"
  "package.json"
  "skills/ansible-collection-swarm.md"
)

FOUND_PLUGIN=0
for file in "${PLUGIN_FILES[@]}"; do
  if [ -f "$SWARM_DIR/$file" ]; then
    echo "  ✅ $file"
    ((FOUND_PLUGIN++))
  else
    echo "  ❌ $file (missing)"
  fi
done

echo ""
echo "Plugin files: $FOUND_PLUGIN/${#PLUGIN_FILES[@]}"
echo ""

# Overall status
TOTAL_EXPECTED=$((${#AGENTS[@]} + ${#PATTERNS[@]} + ${#DOCS[@]} + ${#PLUGIN_FILES[@]}))
TOTAL_FOUND=$((FOUND_AGENTS + FOUND_PATTERNS + FOUND_DOCS + FOUND_PLUGIN))

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Overall: $TOTAL_FOUND/$TOTAL_EXPECTED components"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $TOTAL_FOUND -eq $TOTAL_EXPECTED ]; then
  echo "✅ Installation complete and verified!"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Usage Examples"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "1. Via Agent tool (from Claude Code):"
  echo ""
  echo "   Agent({"
  echo "     description: \"Build collection\","
  echo "     prompt: \"Build collection from Jira Epic EPIC-XXX\","
  echo "     subagent_type: \"ansible-collection-swarm:lead-architect\""
  echo "   })"
  echo ""
  echo "2. Direct file path:"
  echo ""
  echo "   claude-code --agent $SWARM_DIR/core/agents/lead-architect.md \\"
  echo "     \"Build collection from EPIC-XXX\""
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Documentation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "  Quick Start:  cat $SWARM_DIR/QUICKSTART.md"
  echo "  Full Guide:   cat $SWARM_DIR/GETTING-STARTED.md"
  echo "  Agent List:   cat $SWARM_DIR/AGENTS.md"
  echo "  Installation: cat $SWARM_DIR/INSTALLATION.md"
  echo ""
else
  echo "⚠️  Installation incomplete"
  echo "   Missing $((TOTAL_EXPECTED - TOTAL_FOUND)) components"
  echo ""
  echo "   Please reinstall or check the swarm directory"
fi
