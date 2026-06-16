# Universal Ansible Collection Swarm - Manifest

**Version**: 2.0.0 (Intelligence-Based)  
**Created**: 2026-05-27  
**Architecture**: Characteristics over classifications  
**Platforms Supported**: Infinite (learns any platform)

## Complete File List

### Root Documentation (4 files)

- `README.md` - Main overview, architecture, examples
- `QUICKSTART.md` - One-command quick start guide
- `MANIFEST.md` - This file (complete file listing)
- `DEPLOYMENT.md` - Installation and setup guide (to be created)

### Core Agents (10 files)

**Location**: `core/agents/`

1. **lead-architect.md** (Opus)
   - Phase 0: Context gathering (test environment + delivery target)
   - Phases 1-9: Orchestrates lifecycle
   - COMPLETED ✅

2. **jira-ingestion-specialist.md** (Opus)
   - Extracts characteristics (not platform names)
   - Researches unfamiliar platforms
   - Natural language output
   - COMPLETED ✅

3. **foundation-specialist.md** (Sonnet)
   - Scaffolds collection structure
   - Generic for all platforms
   - TODO 📋

4. **platform-prerequisite-specialist.md** (Opus)
   - Reads characteristics
   - Researches installation methods
   - 3-attempt recovery
   - TODO 📋

5. **module-worker.md** (Sonnet)
   - Pattern-based implementation
   - Researches APIs/interfaces
   - Parallel execution (3-5 per batch)
   - TODO 📋

6. **qa-coordinator.md** (Sonnet)
   - Adaptive testing strategy
   - Blocked modules tracking
   - TODO 📋

7. **refactor-specialist.md** (Opus)
   - Extract utilities every 10 modules
   - TODO 📋

8. **release-specialist.md** (Sonnet)
   - Four-pillar audit
   - Context-aware delivery (local or git)
   - TODO 📋

9. **ci-validation-specialist.md** (Opus)
   - Pipeline monitor and fixer
   - TODO 📋

10. **learning-evolution-specialist.md** (Opus)
    - Continuous improvement
    - Cross-platform lessons
    - TODO 📋

### Knowledge Library (Pattern-Based)

**Location**: `knowledge/`

#### Patterns (Generic, Reusable)

- `patterns/rest-api-pattern.md` - GET-compare-PUT pattern (Azure, AWS, SolarWinds, etc.)
- `patterns/cli-based-pattern.md` - Command execution pattern (Cisco, Linux, Windows)
- `patterns/config-file-pattern.md` - Declarative config (Kubernetes, Docker, etc.)
- `patterns/database-pattern.md` - SQL/NoSQL operations
- `patterns/soap-api-pattern.md` - SOAP/WSDL pattern (legacy enterprise)
- `patterns/README.md` - Pattern library guide
- TODO 📋 (all patterns)

#### Examples (Generic Reference Implementations)

- `examples/rest_api_module.py` - Generic REST API module
- `examples/cli_based_module.py` - Generic CLI module
- `examples/config_file_module.py` - Generic config module
- `examples/test_adaptive.yml` - Adaptive test template
- TODO 📋 (all examples)

### Resources (Guides)

**Location**: `resources/`

- `project-context-examples.md` - Test environment and delivery examples
- `pattern-recognition-guide.md` - How to recognize and apply patterns
- `characteristic-extraction.md` - How to extract platform characteristics
- TODO 📋 (create guides)

### Templates (Generic Collection Structure)

**Location**: `core/templates/collection_template/`

```
collection_template/
├── galaxy.yml                          # Collection metadata
├── README.md                           # Collection docs
├── .gitignore                          # Git ignore rules
├── azure-pipelines.yml                 # CI/CD pipeline
├── .azure-pipelines/
│   └── matrix.yml                      # Test matrix
├── plugins/
│   ├── modules/                        # Modules (populated at runtime)
│   └── module_utils/                   # Utilities (populated at runtime)
├── tests/
│   ├── integration/
│   │   └── targets/                    # Test targets (populated at runtime)
│   └── inventory.template              # Template (adapted per connection type)
└── docs/
    └── plans/                          # Planning directory
```

TODO 📋 (create all template files)

### Documentation

**Location**: `docs/`

- `lessons_learned.md` - Cross-platform learning database
- `architecture.md` - Deep dive into intelligence design
- `examples.md` - Real-world usage examples
- TODO 📋 (create docs)

## Directory Structure

```
ansible-collection-swarm/
├── README.md                           ✅ CREATED
├── QUICKSTART.md                       ✅ CREATED
├── MANIFEST.md                         ✅ CREATED (this file)
├── DEPLOYMENT.md                       📋 TODO
│
├── core/                               # Universal framework
│   ├── agents/                         # 10 intelligent agents
│   │   ├── lead-architect.md                       ✅ CREATED
│   │   ├── jira-ingestion-specialist.md            ✅ CREATED
│   │   ├── foundation-specialist.md                📋 TODO
│   │   ├── platform-prerequisite-specialist.md     📋 TODO
│   │   ├── module-worker.md                        📋 TODO
│   │   ├── qa-coordinator.md                       📋 TODO
│   │   ├── refactor-specialist.md                  📋 TODO
│   │   ├── release-specialist.md                   📋 TODO
│   │   ├── ci-validation-specialist.md             📋 TODO
│   │   └── learning-evolution-specialist.md        📋 TODO
│   │
│   └── templates/                      # Generic collection template
│       └── collection_template/        📋 TODO (all files)
│
├── knowledge/                          # Pattern library
│   ├── patterns/                       # Reusable patterns
│   │   ├── rest-api-pattern.md         📋 TODO
│   │   ├── cli-based-pattern.md        📋 TODO
│   │   ├── config-file-pattern.md      📋 TODO
│   │   ├── database-pattern.md         📋 TODO
│   │   ├── soap-api-pattern.md         📋 TODO
│   │   └── README.md                   📋 TODO
│   │
│   └── examples/                       # Generic reference implementations
│       ├── rest_api_module.py          📋 TODO
│       ├── cli_based_module.py         📋 TODO
│       ├── config_file_module.py       📋 TODO
│       └── test_adaptive.yml           📋 TODO
│
├── resources/                          # Documentation and guides
│   ├── project-context-examples.md     📋 TODO
│   ├── pattern-recognition-guide.md    📋 TODO
│   └── characteristic-extraction.md    📋 TODO
│
└── docs/                               # Additional documentation
    ├── lessons_learned.md              📋 TODO
    ├── architecture.md                 📋 TODO
    └── examples.md                     📋 TODO
```

## File Count

- **Total files planned**: ~35
- **Created**: 4 (README, QUICKSTART, MANIFEST, 2 agents)
- **Remaining**: 31

## Progress

### Phase 1: Core Framework (In Progress)
- [x] Directory structure
- [x] README.md
- [x] QUICKSTART.md
- [x] MANIFEST.md
- [x] Lead Architect agent
- [x] Jira Ingestion agent
- [ ] Remaining 8 agents
- [ ] Collection template

### Phase 2: Knowledge Library (TODO)
- [ ] 5 pattern guides
- [ ] 4 example implementations
- [ ] Pattern README

### Phase 3: Resources (TODO)
- [ ] 3 resource guides

### Phase 4: Documentation (TODO)
- [ ] Lessons learned template
- [ ] Architecture deep dive
- [ ] Real-world examples

### Phase 5: Testing (TODO)
- [ ] Test with real Epic
- [ ] Verify all phases work
- [ ] Validate learning system

## Key Differences from Windows Swarm

| Aspect | Windows Swarm | Universal Swarm |
|--------|---------------|-----------------|
| **Architecture** | Template-based | Intelligence-based |
| **Platform support** | Windows only | ANY platform |
| **Platform detection** | Pattern matching | Characteristic extraction |
| **Prerequisites** | YAML templates | Natural language, research-based |
| **Implementation** | 5 Pillars (Windows-specific) | Pattern library (generic) |
| **Context** | Assumed WinRM | User provides (Phase 0) |
| **Delivery** | Fixed temp repo | User choice (local or git) |
| **Learning** | Platform-specific | Cross-platform |
| **File count** | 27 files | ~35 files |
| **Size** | ~800 KB | ~600 KB (estimated) |

## Dependencies

### External Tools Required
- `jira-rh` - Jira CLI tool
- `git` - Version control
- `ansible-test` - Testing framework
- `ansible-galaxy` - Collection management

### Claude Code Requirements
- Agent spawning capability
- AskUserQuestion tool (for context gathering)
- File I/O operations
- Bash command execution
- Background task support

## Self-Contained

✅ **No external file references**  
✅ **All resources within swarm directory**  
✅ **Portable archive-ready**  
✅ **No dependencies on other agent systems**

## Portable Archive Creation

```bash
cd ~/.claude/agents
tar -czf ansible-collection-swarm-v2.0.0.tar.gz \
  --exclude='.git' \
  --exclude='.DS_Store' \
  ansible-collection-swarm/

# Verify
tar -tzf ansible-collection-swarm-v2.0.0.tar.gz | head -20
```

## Version History

### v2.0.0 (2026-05-27) - Intelligence-Based Architecture
- **BREAKING**: Complete redesign from Windows-specific to universal
- **NEW**: Phase 0 context gathering (test environment + delivery target)
- **NEW**: Characteristic extraction (not platform classification)
- **NEW**: Pattern library (not platform templates)
- **NEW**: Research-based prerequisite installation
- **NEW**: Cross-platform learning system
- **NEW**: Works for platforms that don't exist yet
- **Status**: In development (core agents + docs created)

### v1.0.0 (2026-05-27) - Windows-Specific (Superseded)
- Initial Windows Collection Swarm
- Template-based (rigid)
- Windows-only support
- **Superseded by v2.0.0**

## Installation

```bash
# Extract archive
cd ~/.claude/agents
tar -xzf ansible-collection-swarm-v2.0.0.tar.gz

# Verify structure
ls -la ansible-collection-swarm/

# Ready to use
# Invoke via Claude Code Agent tool
```

## Usage Verification

```bash
# Check core agents exist
ls ~/.claude/agents/ansible-collection-swarm/core/agents/

# Expected: 10 .md files

# Check knowledge library
ls ~/.claude/agents/ansible-collection-swarm/knowledge/patterns/

# Expected: 5+ pattern files
```

## Troubleshooting

### Missing Files
- Check extraction completed fully
- Verify file permissions (644 for files, 755 for dirs)

### Agent Not Found
- Verify path: `~/.claude/agents/ansible-collection-swarm/core/agents/<agent-name>.md`
- Check file naming (lowercase, hyphens)

### Template Issues
- Verify: `core/templates/collection_template/galaxy.yml` exists
- Check placeholders present: `NAMESPACE_PLACEHOLDER`, `NAME_PLACEHOLDER`

## Contact & Support

For issues with the swarm:
1. Check QUICKSTART.md for common scenarios
2. Review agent logs in Claude Code
3. Verify all required files present (this manifest)
4. Check generated `docs/plans/project_context.yml`

---

**Manifest Version**: 2.0.0  
**Last Updated**: 2026-05-27  
**Completion**: ~15% (4/35 files created)  
**Status**: Active Development
