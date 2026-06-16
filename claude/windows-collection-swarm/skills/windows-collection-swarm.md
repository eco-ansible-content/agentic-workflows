---
name: windows-collection-swarm
description: Build Windows-specific Ansible collections from Jira Epics (Legacy - Template-based approach)
---

# Windows Collection Swarm (Legacy)

**Note**: This is the legacy Windows-specific swarm. For new projects, consider using the Universal Ansible Collection Swarm (`/ansible-collection-swarm`) which works for Windows AND all other platforms through intelligent research.

## Purpose

Build Windows-specific Ansible collections from Jira Epics using proven template-based patterns for Windows Server environments (SCVMM, Hyper-V, Exchange, Active Directory, etc.).

## When to Use

**Use this swarm when:**
- Working on existing Windows collections that use these templates
- Need battle-tested Windows patterns
- Prefer template-based approach over intelligence-based

**Use Universal Swarm instead when:**
- Starting a new Windows project
- Working with mixed platforms (Windows + Linux + Cloud)
- Want platform-agnostic patterns
- Need enhancement mode for existing collections

## Usage

### Slash Command (Recommended)

```
/windows-collection-swarm EPIC-XXX
```

### Agent Tool

```javascript
Agent({
  description: "Build Windows Ansible collection",
  prompt: "Build Windows collection from Jira Epic EPIC-2345",
  subagent_type: "agentic-workflows/windows-collection-swarm:lead-architect"
})
```

## Arguments

- **Epic ID** (required): Jira epic key (e.g., EPIC-2345, WINOPS-123)
- **Optional flags**: Currently none (uses defaults)

## What It Does

1. **Reads Jira Epic** - Extracts requirements and module specifications
2. **Scaffolds Collection** - Creates Windows collection structure with proven templates
3. **Implements Modules** - Using Windows-specific patterns:
   - PowerShell cmdlet pattern
   - CIM/WMI pattern
   - Registry pattern
4. **Runs Tests** - 4-stage testing (syntax → import → unit → integration)
5. **Delivers** - Local or git push

## Example

```bash
# In Claude Code CLI
/windows-collection-swarm WINOPS-2345

# You'll be asked:
# Q1: Test environment? → 192.168.50.10, winrm, user: Administrator, pass: P@ssw0rd
# Q2: Delivery? → https://github.com/myorg/ansible-collections.git

# Result (2 hours later):
# ✅ Collection: microsoft.exchange
# ✅ 12 modules implemented
# ✅ All tests passing
# ✅ Pushed to GitHub
```

## Architecture

**13 Specialized Agents**:
- `lead-architect` - Chief orchestrator
- `jira-ingestion-specialist` - Epic analyzer
- `foundation-specialist` - Scaffolding
- `platform-prerequisite-specialist` - Environment setup
- `module-worker` - Module implementation
- `qa-coordinator` - Testing
- `refactor-specialist` - Code optimization
- `release-specialist` - Delivery
- `ci-validation-specialist` - Pipeline monitoring
- `learning-evolution-specialist` - Knowledge capture
- (+ 3 more specialized agents)

## Windows-Specific Patterns

1. **PowerShell Cmdlet Pattern**
   - Get-* cmdlet for state check
   - New-*/Set-* for changes
   - Idempotency built-in

2. **CIM/WMI Pattern**
   - Query current state
   - Compare and modify
   - Handle Windows-specific types

3. **Registry Pattern**
   - Test-Path for existence
   - Get-ItemProperty for values
   - Set-ItemProperty for changes

## Migration Path

**From Windows Swarm to Universal Swarm**:

Your existing collections continue working. For new work:

1. Use `/ansible-collection-swarm` for new collections
2. Use `/ansible-collection-swarm` with enhancement mode for adding to existing collections
3. Gradually adopt universal patterns

No migration required - both swarms coexist!

## Documentation

- **Quick Reference**: `/windows-collection-swarm/QUICKREF.md`
- **Agent Details**: `/windows-collection-swarm/agents/README.md`
- **Patterns**: `/windows-collection-swarm/examples/`

## Limitations (Why Universal is Better)

- ❌ Windows-only (doesn't work for Linux, Cloud, Network)
- ❌ Template-based (doesn't learn new platforms)
- ❌ No enhancement mode (can't add to existing collections)
- ✅ But: Proven patterns, battle-tested for Windows

**Recommendation**: Use Universal Swarm unless you specifically need these legacy templates.

## Support

For issues or questions:
- GitHub Issues: https://github.com/eco-ansible-content/agentic-workflows/issues
- Documentation: See `/windows-collection-swarm/README.md`
