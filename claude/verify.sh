#!/bin/bash
# Verify Agentic Workflows Plugin Installation

PLUGIN_DIR="$HOME/.claude/agents/agentic-workflows-plugin"

echo "🔍 Verifying Agentic Workflows Plugin"
echo "=================================="
echo ""

# Check if symlink or directory exists
if [ ! -e "$PLUGIN_DIR" ]; then
  echo "❌ Plugin not found at: $PLUGIN_DIR"
  echo ""
  echo "To install:"
  echo "  git clone https://github.com/eco-ansible-content/agentic-workflows.git /path/to/your/location"
  echo "  cd /path/to/your/location/agentic-workflows"
  echo "  bash install.sh"
  exit 1
fi

if [ -L "$PLUGIN_DIR" ]; then
  SYMLINK_TARGET=$(readlink "$PLUGIN_DIR")
  echo "✅ Plugin symlink found: $PLUGIN_DIR -> $SYMLINK_TARGET"
else
  echo "✅ Plugin directory found: $PLUGIN_DIR"
fi
echo ""

# Check plugin files
echo "📋 Checking plugin infrastructure..."
PLUGIN_FILES=(
  ".claude-plugin/plugin.json"
  "package.json"
  "README.md"
)

FOUND_PLUGIN=0
for file in "${PLUGIN_FILES[@]}"; do
  if [ -f "$PLUGIN_DIR/$file" ]; then
    echo "  ✅ $file"
    ((FOUND_PLUGIN++))
  else
    echo "  ❌ $file (missing)"
  fi
done

echo ""
echo "Plugin files: $FOUND_PLUGIN/${#PLUGIN_FILES[@]}"
echo ""

# Check ansible-collection-swarm
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Ansible Collection Swarm (Universal)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d "$PLUGIN_DIR/ansible-collection-swarm" ]; then
  echo "✅ Swarm directory found"
  echo ""

  # Check agents
  echo "  📋 Checking agents..."
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
    if [ -f "$PLUGIN_DIR/ansible-collection-swarm/core/agents/$agent.md" ]; then
      echo "    ✅ $agent"
      ((FOUND_AGENTS++))
    else
      echo "    ❌ $agent (missing)"
    fi
  done

  echo ""
  echo "  Agents: $FOUND_AGENTS/${#AGENTS[@]}"

  # Check patterns
  echo ""
  echo "  📋 Checking patterns..."
  PATTERNS=(
    "rest-api-pattern"
    "cli-based-pattern"
    "config-file-pattern"
    "database-pattern"
    "soap-api-pattern"
  )

  FOUND_PATTERNS=0
  for pattern in "${PATTERNS[@]}"; do
    if [ -f "$PLUGIN_DIR/ansible-collection-swarm/knowledge/patterns/$pattern.md" ]; then
      echo "    ✅ $pattern"
      ((FOUND_PATTERNS++))
    else
      echo "    ❌ $pattern (missing)"
    fi
  done

  echo ""
  echo "  Patterns: $FOUND_PATTERNS/${#PATTERNS[@]}"

  # Check skill
  echo ""
  echo "  📋 Checking skill..."
  if [ -f "$PLUGIN_DIR/ansible-collection-swarm/skills/ansible-collection-swarm.md" ]; then
    echo "    ✅ ansible-collection-swarm.md"
    SKILL_ANSIBLE=1
  else
    echo "    ❌ ansible-collection-swarm.md (missing)"
    SKILL_ANSIBLE=0
  fi

  ANSIBLE_TOTAL=$((FOUND_AGENTS + FOUND_PATTERNS + SKILL_ANSIBLE))
  ANSIBLE_EXPECTED=$((${#AGENTS[@]} + ${#PATTERNS[@]} + 1))

  echo ""
  echo "  Total: $ANSIBLE_TOTAL/$ANSIBLE_EXPECTED components"
else
  echo "❌ Ansible Collection Swarm not found"
  ANSIBLE_TOTAL=0
  ANSIBLE_EXPECTED=17
fi

echo ""

# Check windows-collection-swarm
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Windows Collection Swarm (Legacy)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -d "$PLUGIN_DIR/windows-collection-swarm" ]; then
  echo "✅ Swarm directory found"
  echo ""

  # Count agents
  WINDOWS_AGENTS=$(find "$PLUGIN_DIR/windows-collection-swarm/agents" -name "*.md" 2>/dev/null | wc -l)
  echo "  Agents: $WINDOWS_AGENTS found"

  # Check for README
  if [ -f "$PLUGIN_DIR/windows-collection-swarm/README.md" ]; then
    echo "  ✅ README.md"
    WINDOWS_README=1
  else
    echo "  ❌ README.md (missing)"
    WINDOWS_README=0
  fi

  WINDOWS_TOTAL=$((WINDOWS_AGENTS + WINDOWS_README))
else
  echo "⚠️  Windows Collection Swarm not found (optional)"
  WINDOWS_TOTAL=0
fi

echo ""

# Overall status
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Overall Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Plugin infrastructure: $FOUND_PLUGIN/3"
echo "Ansible Collection Swarm: $ANSIBLE_TOTAL/$ANSIBLE_EXPECTED"
echo "Windows Collection Swarm: $WINDOWS_TOTAL"
echo ""

GRAND_TOTAL=$((FOUND_PLUGIN + ANSIBLE_TOTAL + WINDOWS_TOTAL))
GRAND_EXPECTED=$((3 + ANSIBLE_EXPECTED + 2))  # 3 plugin files + 17 ansible + 2 windows minimum

if [ $ANSIBLE_TOTAL -eq $ANSIBLE_EXPECTED ] && [ $FOUND_PLUGIN -eq 3 ]; then
  echo "✅ Plugin ready to use!"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Usage Examples"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "1. Slash command (Universal Swarm):"
  echo ""
  echo "   /ansible-collection-swarm EPIC-XXX"
  echo ""
  echo "2. Agent tool (Universal Swarm):"
  echo ""
  echo "   Agent({"
  echo "     description: \"Build collection\","
  echo "     prompt: \"Build collection from EPIC-XXX\","
  echo "     subagent_type: \"agentic-workflows/ansible-collection-swarm:lead-architect\""
  echo "   })"
  echo ""
  echo "3. Agent tool (Windows Swarm - Legacy):"
  echo ""
  echo "   Agent({"
  echo "     description: \"Build Windows collection\","
  echo "     prompt: \"Build collection from EPIC-XXX\","
  echo "     subagent_type: \"agentic-workflows/windows-collection-swarm:lead-architect\""
  echo "   })"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Documentation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "  Plugin README:  cat $PLUGIN_DIR/README.md"
  echo "  Universal Swarm: cat $PLUGIN_DIR/ansible-collection-swarm/QUICKSTART.md"
  echo "  Windows Swarm:  cat $PLUGIN_DIR/windows-collection-swarm/README.md"
  echo ""
else
  echo "⚠️  Plugin incomplete"
  echo "   Missing components - please reinstall"
fi
