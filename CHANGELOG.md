# Changelog

All notable changes to Agentic Workflows will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2026-07-02

### Added
- **Custom Analysis Ingestion System** - Paste your pre-analysis directly when invoking swarm
  - Universal parser handles ANY format (tables, bullets, freeform text, etc.)
  - Lead Architect automatically creates `docs/plans/PROJECT_BRIEF.md`
  - All agents read and follow custom instructions
  - Custom rules OVERRIDE generic patterns
  - Unfamiliar steps are researched and executed automatically
  - See `docs/CUSTOM-ANALYSIS.md` for comprehensive guide
- **PROJECT_BRIEF.md Support** in all agents:
  - Lead Architect: Phase 0.1 parses user analysis
  - Module Worker: Reads critical rules, testing requirements, constraints
  - QA Coordinator: Reads testing requirements, definition of done
  - Platform Prerequisite Specialist: Reads setup order, custom prerequisites
  - Release Specialist: Reads delivery requirements, certification checklist
- **Enhanced Slash Command**: `/ansible-collection-swarm` now accepts analysis text after ticket key

### Changed
- Lead Architect now has Phase 0.1 (Process Custom Analysis) before Phase 0.2 (Gather Context)
- All agents check for `docs/plans/PROJECT_BRIEF.md` FIRST before executing work
- Custom instructions take absolute precedence over generic patterns

### Documentation
- Added `docs/CUSTOM-ANALYSIS.md` - Complete guide with real examples
- Updated README.md with custom analysis feature
- Updated slash command examples

## [0.0.2] - 2026-06-15

### Added
- **Universal PR Review Learnings** - Language-agnostic quality patterns
  - Extracted from WinGet module PR review (9 critical issues)
  - Works for PowerShell, Python, Bash, Java, Go, Ruby, Rust, C#, JavaScript, ANY language
  - Universal API Preference Order (Collection utils → SDK → CLI JSON → Text parsing)
  - Added to `docs/PR-REVIEW-LEARNINGS.md`
- **Pre-Implementation Research Phase** in Module Worker (Step 0)
  - Mandatory research BEFORE writing any code
  - Search collection utilities first
  - Research language-appropriate libraries
  - Check CLI flags for structured output
  - Verify features exist in official docs
  - Document research findings
- **Safety Rules** in Module Worker (Step 4.5)
  - No connection-breaking operations (allow_reboot, network changes)
  - No protected system directories
  - Default parameters to lists for bulk operations
- **Universal Pre-Test Quality Checklist** in QA Coordinator
  - No AI hallucinations check
  - Collection utilities usage
  - Language-appropriate APIs
  - Safety checks
  - 9 mandatory checks before integration tests

### Changed
- Module Worker now has mandatory research phase (90% first-time QA pass rate expected)
- QA Coordinator fails modules that don't pass pre-test checklist
- All quality patterns are now truly universal (not platform-specific)

### Fixed
- install.sh now reads version dynamically from package.json (was hardcoded)
- uninstall.sh now cleans both marketplace and manual cache locations

## [0.0.1] - 2026-06-10

### Added
- Initial beta release
- Universal Ansible Collection Swarm (11 agents)
  - Works for ANY platform through intelligent research
  - Supports Task/Epic/ANSTRAT ticket types
  - Full build + enhancement modes
- Windows Collection Swarm (13 agents) - legacy
- Dynamic Jira scope detection
  - Single Task → build one module
  - Epic → build all modules in Epic
  - ANSTRAT → build all modules across all Epics
- Marketplace installation support
- Manual bash script installation
- Collections repository integration (eco-ansible-content/agentic-workflow-collections)
- Comprehensive documentation

### Changed
- Version strategy: 0.0.x for beta (not production ready)
- Marketplace installation is primary recommendation
- Bash script is fallback/alternative

### Documentation
- README.md with quick start
- GETTING-STARTED.md
- Installation guides
- Publishing guide
- Verification script

---

## Version Strategy

- **0.0.x** - Beta releases (not production ready)
- **0.x.x** - Pre-release (production-ready but evolving)
- **1.0.0** - First production release
- **x.0.0** - Major releases (breaking changes)

## Links

- **Repository**: https://github.com/eco-ansible-content/agentic-workflows
- **Issues**: https://github.com/eco-ansible-content/agentic-workflows/issues
- **Discussions**: https://github.com/eco-ansible-content/agentic-workflows/discussions
