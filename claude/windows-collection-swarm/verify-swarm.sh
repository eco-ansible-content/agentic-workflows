#!/bin/bash
# Windows Collection Swarm - Integrity Verification Script
# Version: 1.0.0

set -e

SWARM="$HOME/.claude/agents/windows-collection-swarm"
ERRORS=0
WARNINGS=0

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Windows Collection Swarm - Integrity Verification         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
error() {
    echo -e "${RED}❌ FAIL:${NC} $1"
    ((ERRORS++))
}

warn() {
    echo -e "${YELLOW}⚠  WARN:${NC} $1"
    ((WARNINGS++))
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

check_file() {
    if [ -f "$SWARM/$1" ]; then
        success "$1"
    else
        error "Missing file: $1"
    fi
}

check_dir() {
    if [ -d "$SWARM/$1" ]; then
        success "$1/"
    else
        error "Missing directory: $1"
    fi
}

# Check base directory
echo "=== Base Directory ==="
if [ ! -d "$SWARM" ]; then
    error "Swarm directory not found at $SWARM"
    echo ""
    echo "Installation instructions:"
    echo "  1. Ensure swarm is extracted to ~/.claude/agents/"
    echo "  2. Run: ls ~/.claude/agents/windows-collection-swarm/"
    exit 1
else
    success "Swarm directory exists at $SWARM"
fi
echo ""

# Check root documentation
echo "=== Root Documentation ==="
check_file "README.md"
check_file "DEPLOYMENT.md"
check_file "MANIFEST.md"
echo ""

# Check agent definitions
echo "=== Agent Definitions ==="
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
    check_file "agents/$agent.md"
done

check_file "agents/invoke-swarm.md"
check_file "agents/QUICKSTART.md"
echo ""

# Check templates
echo "=== Collection Templates ==="
check_dir "templates/collection_template"
check_file "templates/collection_template/galaxy.yml"
check_file "templates/collection_template/README.md"
check_file "templates/collection_template/azure-pipelines.yml"
check_file "templates/collection_template/.gitignore"
check_file "templates/collection_template/.azure-pipelines/matrix.yml"
check_file "templates/collection_template/tests/inventory.winrm"

# Check template directories
check_dir "templates/collection_template/docs/plans"
check_dir "templates/collection_template/plugins/modules"
check_dir "templates/collection_template/plugins/module_utils"
check_dir "templates/collection_template/tests/integration/targets"
echo ""

# Check resources
echo "=== Resources (Guides) ==="
check_file "resources/5-pillars-guide.md"
check_file "resources/4-stage-testing-guide.md"
echo ""

# Check examples
echo "=== Example Files ==="
check_file "examples/module_example_cmdlet.ps1"
check_file "examples/module_example_cim.ps1"
check_file "examples/module_example_registry.ps1"
check_file "examples/test_example_4stage.yml"
echo ""

# Check for placeholders in templates
echo "=== Template Placeholders ==="
if grep -q "NAMESPACE_PLACEHOLDER" "$SWARM/templates/collection_template/galaxy.yml" 2>/dev/null; then
    success "galaxy.yml contains NAMESPACE_PLACEHOLDER"
else
    warn "galaxy.yml missing NAMESPACE_PLACEHOLDER (may have been customized)"
fi

if grep -q "NAME_PLACEHOLDER" "$SWARM/templates/collection_template/galaxy.yml" 2>/dev/null; then
    success "galaxy.yml contains NAME_PLACEHOLDER"
else
    warn "galaxy.yml missing NAME_PLACEHOLDER (may have been customized)"
fi
echo ""

# Check for external path references (should be none)
echo "=== Self-Containment Check ==="
EXTERNAL_REFS=$(grep -r "/Users/hyaish/.gemini/" "$SWARM/" 2>/dev/null | wc -l)
if [ "$EXTERNAL_REFS" -eq 0 ]; then
    success "No external path references found"
else
    error "Found $EXTERNAL_REFS external path references (should be 0)"
    echo "      Run: grep -r '/Users/hyaish/.gemini/' $SWARM/"
fi

INTERNAL_REFS=$(grep -r "~/.claude/agents/windows-collection-swarm/" "$SWARM/agents/" 2>/dev/null | wc -l)
if [ "$INTERNAL_REFS" -gt 0 ]; then
    success "Found $INTERNAL_REFS internal self-references"
else
    warn "No internal self-references found (agents may not be using resources)"
fi
echo ""

# Check file sizes
echo "=== File Sizes ==="
TOTAL_SIZE=$(du -sh "$SWARM" 2>/dev/null | cut -f1)
success "Total swarm size: $TOTAL_SIZE"

AGENT_SIZE=$(du -sh "$SWARM/agents" 2>/dev/null | cut -f1)
echo "  Agents: $AGENT_SIZE"

TEMPLATE_SIZE=$(du -sh "$SWARM/templates" 2>/dev/null | cut -f1)
echo "  Templates: $TEMPLATE_SIZE"

RESOURCE_SIZE=$(du -sh "$SWARM/resources" 2>/dev/null | cut -f1)
echo "  Resources: $RESOURCE_SIZE"

EXAMPLE_SIZE=$(du -sh "$SWARM/examples" 2>/dev/null | cut -f1)
echo "  Examples: $EXAMPLE_SIZE"
echo ""

# Count files
echo "=== File Counts ==="
AGENT_COUNT=$(ls -1 "$SWARM/agents/"*.md 2>/dev/null | wc -l)
echo "  Agent definitions: $AGENT_COUNT (expected: 9)"

EXAMPLE_COUNT=$(ls -1 "$SWARM/examples/"*.{ps1,yml} 2>/dev/null | wc -l)
echo "  Example files: $EXAMPLE_COUNT (expected: 4)"

RESOURCE_COUNT=$(ls -1 "$SWARM/resources/"*.md 2>/dev/null | wc -l)
echo "  Resource guides: $RESOURCE_COUNT (expected: 2)"
echo ""

# Summary
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    Verification Summary                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ PASSED${NC}: Swarm integrity verified successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Read: $SWARM/agents/QUICKSTART.md"
    echo "  2. Configure: $SWARM/templates/collection_template/tests/inventory.winrm"
    echo "  3. Invoke: cat $SWARM/agents/invoke-swarm.md"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠  PASSED WITH WARNINGS${NC}: $WARNINGS warnings found"
    echo ""
    echo "Warnings indicate optional files missing or customizations made."
    echo "Swarm should still function correctly."
    exit 0
else
    echo -e "${RED}❌ FAILED${NC}: $ERRORS errors, $WARNINGS warnings"
    echo ""
    echo "Critical files are missing. Swarm may not function correctly."
    echo "Please re-install or restore from backup."
    echo ""
    echo "See: $SWARM/DEPLOYMENT.md for installation instructions"
    exit 1
fi
