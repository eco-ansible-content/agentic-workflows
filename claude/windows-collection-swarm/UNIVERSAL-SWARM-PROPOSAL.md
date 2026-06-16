# Universal Ansible Collection Swarm - Architecture Proposal

## Vision

Transform the Windows Collection Swarm into a **platform-agnostic framework** that can build Ansible collections for ANY platform (Windows, Azure, Cisco, Linux, AWS, VMware, etc.) using a **plugin-based architecture**.

## Core Concept

**Separate orchestration from platform knowledge:**

```
Universal Framework (CORE)          Platform Knowledge (PLUGINS)
├── 9-phase lifecycle          +    ├── Implementation patterns
├── Agent orchestration        +    ├── Testing strategies  
├── QA coordination            +    ├── Prerequisites
├── Git delivery               +    ├── Module examples
├── CI/CD validation           +    └── Inventory templates
└── Learning system            =    WORKS FOR ANY PLATFORM
```

## Architecture

```
~/.claude/agents/ansible-collection-swarm/
├── core/                              # Generic framework (platform-agnostic)
│   ├── agents/                        # 10 universal agents
│   │   ├── lead-architect.md          # Platform-aware orchestrator
│   │   ├── jira-ingestion-specialist.md
│   │   ├── foundation-specialist.md
│   │   ├── platform-prerequisite-specialist.md
│   │   ├── module-worker.md           # Loads platform-specific guides
│   │   ├── qa-coordinator.md          # Loads platform-specific tests
│   │   ├── refactor-specialist.md
│   │   ├── release-specialist.md
│   │   ├── ci-validation-specialist.md
│   │   └── learning-evolution-specialist.md
│   ├── templates/
│   │   └── collection_template/      # Universal collection structure
│   └── docs/
│       └── lessons_learned.md         # Cross-platform learning database
│
├── platforms/                         # Platform-specific knowledge packs
│   ├── windows/
│   │   ├── implementation-guide.md    # 5 Pillars (Cmdlets/WMI/CIM/.NET/Registry)
│   │   ├── testing-guide.md           # WinRM, 4-stage loop
│   │   ├── prerequisites-guide.md     # Windows platforms (SCVMM, IIS, SQL, etc.)
│   │   ├── inventory.winrm.template   # WinRM inventory
│   │   ├── module-language: PowerShell
│   │   └── examples/
│   │       ├── module_cmdlet.ps1
│   │       ├── module_cim.ps1
│   │       └── test_4stage.yml
│   │
│   ├── azure/
│   │   ├── implementation-guide.md    # Azure SDK, REST API patterns
│   │   ├── testing-guide.md           # Mock responses, integration tests
│   │   ├── prerequisites-guide.md     # Azure subscription, service principal
│   │   ├── inventory.localhost.template  # Azure is API-based (localhost)
│   │   ├── module-language: Python
│   │   └── examples/
│   │       ├── azure_vm.py            # Azure VM module
│   │       ├── azure_storage.py       # Storage account module
│   │       └── test_azure.yml
│   │
│   ├── cisco/
│   │   ├── implementation-guide.md    # network_cli, NETCONF, NX-API patterns
│   │   ├── testing-guide.md           # Network device testing, VIRL/CML
│   │   ├── prerequisites-guide.md     # Test switches, simulators
│   │   ├── inventory.network.template # network_cli inventory
│   │   ├── module-language: Python
│   │   └── examples/
│   │       ├── cisco_vlan.py
│   │       ├── cisco_interface.py
│   │       └── test_network.yml
│   │
│   ├── linux/
│   │   ├── implementation-guide.md    # Shell commands, systemd, package managers
│   │   ├── testing-guide.md           # SSH, containers, idempotency
│   │   ├── prerequisites-guide.md     # Linux VMs/containers
│   │   ├── inventory.ssh.template     # SSH inventory
│   │   ├── module-language: Python (or Bash)
│   │   └── examples/
│   │       ├── systemd_service.py
│   │       ├── package_manager.py
│   │       └── test_linux.yml
│   │
│   ├── aws/
│   │   ├── implementation-guide.md    # boto3, AWS SDK patterns
│   │   ├── testing-guide.md           # Moto mocking, integration
│   │   ├── prerequisites-guide.md     # AWS credentials, IAM
│   │   ├── inventory.localhost.template
│   │   ├── module-language: Python
│   │   └── examples/
│   │
│   ├── vmware/
│   │   ├── implementation-guide.md    # pyVmomi, vSphere APIs
│   │   ├── testing-guide.md           # vCenter simulator
│   │   ├── prerequisites-guide.md     # vCenter, ESXi hosts
│   │   ├── inventory.localhost.template
│   │   ├── module-language: Python
│   │   └── examples/
│   │
│   └── gcp/
│       ├── implementation-guide.md    # Google Cloud SDK
│       ├── testing-guide.md
│       ├── prerequisites-guide.md
│       ├── inventory.localhost.template
│       ├── module-language: Python
│       └── examples/
│
└── README.md                          # Universal swarm documentation
```

## How Platform Detection Works

### Option 1: Automatic Detection (from Epic)

**Jira Ingestion Specialist** reads Epic and infers platform:

```markdown
Epic: "Build modules for managing Azure Virtual Machines and Storage Accounts"

Agent understands:
- Platform: Azure (keywords: "Azure", "Virtual Machines", "Storage Accounts")
- Sets: PLATFORM=azure
- Loads: platforms/azure/implementation-guide.md
```

**Detection keywords**:
- **Windows**: SCVMM, Hyper-V, IIS, SQL Server, Active Directory, PowerShell
- **Azure**: Azure VM, Storage Account, Resource Group, Subscription, ARM
- **Cisco**: VLAN, NX-OS, IOS-XE, Catalyst, Nexus, network_cli
- **Linux**: systemd, apt, yum, SELinux, firewalld
- **AWS**: EC2, S3, VPC, Lambda, CloudFormation, boto3
- **VMware**: vSphere, ESXi, vCenter, VM, Datastore

### Option 2: Explicit Platform (user-specified)

```bash
# User invokes with platform flag
Agent({
  description: "Build Cisco collection",
  prompt: "Build collection from EPIC-456 using platform: cisco"
})
```

### Option 3: Multi-Platform Detection

```markdown
Epic: "Build modules for managing Windows servers in Azure"

Agent understands:
- Primary platform: Windows (module target)
- Secondary platform: Azure (infrastructure)
- Creates hybrid collection with both knowledge packs
```

## Platform-Specific Implementation Guides

### Example: Azure Implementation Guide

```markdown
# Azure Module Implementation Guide

## Overview
Azure modules interact with Azure Resource Manager (ARM) APIs using the Azure SDK for Python.

## Decision Tree (Azure "Pillars")

### Pillar 1: Azure SDK (⭐⭐⭐⭐⭐) - PREFERRED
**When to use**: For all Azure resource management
**Why best**: Official SDK, idempotent by design, handles auth
**Example**: Managing VMs, Storage, Networking

```python
from azure.mgmt.compute import ComputeManagementClient
from azure.identity import DefaultAzureCredential

credential = DefaultAzureCredential()
compute_client = ComputeManagementClient(credential, subscription_id)

# Create VM
vm = compute_client.virtual_machines.begin_create_or_update(
    resource_group_name,
    vm_name,
    vm_parameters
).result()
```

### Pillar 2: Azure REST API (⭐⭐⭐⭐) - FALLBACK
**When to use**: SDK doesn't support the resource yet
**Why good**: Direct control, no SDK dependency
**Why not first**: More verbose, manual auth handling

### Pillar 3: Azure CLI Wrapper (⭐⭐⭐) - AVOID
**When to use**: Prototyping only
**Why avoid**: Parsing output is brittle, not idempotent

## Module Structure

All Azure modules follow this pattern:

1. **Import Azure SDK libraries**
2. **Authenticate** (DefaultAzureCredential or service principal)
3. **Check current state** (idempotency)
4. **Apply changes** if needed
5. **Return structured result**

## Idempotency Strategy

Azure SDK handles idempotency via:
- **GET** current resource state
- **Compare** with desired state
- **UPDATE** only if different
- Most SDK methods are `create_or_update()` - inherently idempotent

## Check Mode Implementation

```python
if module.check_mode:
    # Don't call SDK methods that modify resources
    # Return what WOULD happen
    return {"changed": True, "msg": "Would create VM", "vm": vm_params}
```

## Common Patterns

### Pattern 1: Resource Creation with Idempotency
```python
def ensure_vm_present(compute_client, resource_group, vm_name, vm_params):
    try:
        # Check if exists
        vm = compute_client.virtual_machines.get(resource_group, vm_name)
        # Compare current vs desired state
        if vm_matches_params(vm, vm_params):
            return {"changed": False, "vm": vm}
    except ResourceNotFoundError:
        pass  # Doesn't exist, create it
    
    # Create or update
    vm = compute_client.virtual_machines.begin_create_or_update(
        resource_group, vm_name, vm_params
    ).result()
    return {"changed": True, "vm": vm}
```

(continues with more Azure-specific patterns...)
```

### Example: Cisco Implementation Guide

```markdown
# Cisco Network Module Implementation Guide

## Overview
Cisco modules interact with network devices using Ansible connection plugins (network_cli, netconf, httpapi).

## Decision Tree (Network "Pillars")

### Pillar 1: NETCONF (⭐⭐⭐⭐⭐) - PREFERRED for modern devices
**When to use**: IOS-XE 16.3+, NX-OS 7.0+
**Why best**: Structured data (XML), transactional, idempotent
**Example**: Configuration management

### Pillar 2: network_cli (⭐⭐⭐⭐) - Most compatible
**When to use**: Any Cisco device with SSH
**Why good**: Works everywhere, familiar CLI
**Why not first**: Parsing output is manual

### Pillar 3: NX-API / RESTCONF (⭐⭐⭐) - Modern API
**When to use**: Nexus switches, modern IOS-XE
**Why good**: REST API, JSON responses
**Why not first**: Limited device support

## Module Structure

Network modules use connection plugins:

```python
from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.network.common.config import NetworkConfig

def main():
    module = AnsibleModule(
        argument_spec={
            'vlan_id': {'type': 'int', 'required': True},
            'name': {'type': 'str'},
            'state': {'choices': ['present', 'absent'], 'default': 'present'}
        },
        supports_check_mode=True
    )
    
    # Get current config
    current_config = module.run_commands(['show vlan'])[0]
    
    # Build desired config
    commands = build_vlan_commands(module.params, current_config)
    
    if commands:
        if module.check_mode:
            module.exit_json(changed=True, commands=commands)
        result = module.run_commands(commands)
        module.exit_json(changed=True, commands=commands, output=result)
    else:
        module.exit_json(changed=False)
```

(continues with Cisco-specific patterns...)
```

## Agent Changes for Universal Platform Support

### Lead Architect (Modified)

```markdown
## Platform Detection

At the start of Ingestion phase:

1. **Read Epic description** via Jira Ingestion Specialist
2. **Detect platform keywords**:
   - Windows: SCVMM, Hyper-V, IIS, PowerShell, Active Directory
   - Azure: Azure, ARM, Subscription, Resource Group
   - Cisco: VLAN, IOS, NX-OS, Catalyst, Nexus
   - AWS: EC2, S3, Lambda, boto3
   - (etc.)
3. **Set environment variable**: `PLATFORM=<detected_platform>`
4. **Verify platform pack exists**: `platforms/<platform>/`
5. **Load platform-specific paths**:
   - Implementation guide: `platforms/$PLATFORM/implementation-guide.md`
   - Testing guide: `platforms/$PLATFORM/testing-guide.md`
   - Prerequisites: `platforms/$PLATFORM/prerequisites-guide.md`
6. **Pass platform context** to all downstream agents

If platform cannot be detected:
- Ask user: "Which platform? windows | azure | cisco | linux | aws | vmware | other"
```

### Module Worker (Modified)

```markdown
## Platform-Aware Implementation

Before implementing a module:

1. **Load platform implementation guide**:
   ```bash
   IMPL_GUIDE="~/.claude/agents/ansible-collection-swarm/platforms/$PLATFORM/implementation-guide.md"
   ```
2. **Read guide** to understand platform-specific patterns
3. **Use platform examples**:
   ```bash
   EXAMPLES_DIR="~/.claude/agents/ansible-collection-swarm/platforms/$PLATFORM/examples/"
   ```
4. **Determine module language**:
   - Windows: PowerShell (.ps1)
   - Azure/Linux/Network/Cloud: Python (.py)
5. **Follow platform decision tree** instead of generic 5 Pillars

## Language Selection

```python
PLATFORM_LANGUAGES = {
    'windows': 'PowerShell',
    'azure': 'Python',
    'cisco': 'Python',
    'linux': 'Python',
    'aws': 'Python',
    'vmware': 'Python',
    'gcp': 'Python'
}
```
```

### QA Coordinator (Modified)

```markdown
## Platform-Aware Testing

Load testing strategy from platform pack:

```bash
TEST_GUIDE="~/.claude/agents/ansible-collection-swarm/platforms/$PLATFORM/testing-guide.md"
INVENTORY_TEMPLATE="~/.claude/agents/ansible-collection-swarm/platforms/$PLATFORM/inventory.*.template"
```

**Windows**: 4-stage loop (Initial, Idempotency, Check Mode, Error Handling) via WinRM
**Azure**: 3-stage loop (Initial, Idempotency, Error Handling) - no Check Mode for cloud
**Cisco**: Network-specific (Config, Idempotency, Rollback, Connection Error)
**Linux**: 4-stage loop via SSH
```

### Platform Prerequisite Specialist (Modified)

```markdown
## Platform-Aware Prerequisites

Load prerequisite knowledge:

```bash
PREREQ_GUIDE="~/.claude/agents/ansible-collection-swarm/platforms/$PLATFORM/prerequisites-guide.md"
```

**Windows**: Install software (SCVMM, SQL, IIS)
**Azure**: Configure credentials (service principal, subscription)
**Cisco**: Configure test switches (VIRL/CML, physical lab)
**AWS**: Configure credentials (IAM user, access keys)
**Linux**: Provision test VMs/containers
```

## Platform Pack Template

Each platform pack follows this structure:

```markdown
# Platform Pack: <PLATFORM_NAME>

## Metadata
- **Platform**: <name>
- **Module Language**: PowerShell | Python | Bash
- **Connection Method**: winrm | ssh | httpapi | network_cli | local
- **Primary Use Case**: <description>

## Implementation Guide
<Platform-specific decision tree and patterns>

## Testing Guide
<How to test modules for this platform>

## Prerequisites Guide
<What needs to be installed/configured>

## Inventory Template
<Connection settings for this platform>

## Examples
<Reference module implementations>
```

## Benefits of Universal Architecture

### For Users
✅ **One swarm, all platforms** - learn once, use everywhere
✅ **Consistent experience** - same 9 phases regardless of platform
✅ **Cross-platform learning** - lessons learned apply across platforms
✅ **Flexible** - mix platforms (Windows on Azure, Linux on AWS)

### For Maintainers
✅ **Write orchestration once** - 10 core agents never change
✅ **Add platforms easily** - create knowledge pack, plug it in
✅ **Isolate platform logic** - changes to Azure don't affect Cisco
✅ **Shared improvements** - CI/CD fixes benefit all platforms

### For the Swarm
✅ **Learning across platforms** - SQL lessons apply to PostgreSQL
✅ **Pattern recognition** - idempotency patterns similar across platforms
✅ **Metrics aggregation** - track success rate across all platforms
✅ **Knowledge transfer** - Azure auth lessons help AWS auth

## Migration Path

### Phase 1: Extract Core Framework
1. Move current agents to `core/agents/`
2. Move Windows knowledge to `platforms/windows/`
3. Update agent prompts to load platform-specific guides
4. Test with Windows (should work exactly as before)

### Phase 2: Add Azure Platform Pack
1. Create `platforms/azure/`
2. Write Azure implementation guide
3. Write Azure testing guide
4. Create Azure examples
5. Test with Azure collection

### Phase 3: Add Network Platform Packs
1. Create `platforms/cisco/`
2. Create `platforms/juniper/`
3. Create `platforms/arista/`

### Phase 4: Add Cloud Platform Packs
1. Create `platforms/aws/`
2. Create `platforms/gcp/`
3. Create `platforms/vmware/`

### Phase 5: Add Linux Platform Pack
1. Create `platforms/linux/`
2. Test with Linux system collections

## Example: Multi-Platform Epic

```markdown
Epic: "Build collection for managing Linux servers on AWS with Cisco network connectivity"

Jira Ingestion detects:
- Primary: Linux (managing Linux servers)
- Infrastructure: AWS (provisioning on AWS)
- Network: Cisco (network connectivity)

Module breakdown:
- linux_systemd_service (uses platforms/linux/)
- aws_ec2_instance (uses platforms/aws/)
- cisco_security_group (uses platforms/cisco/)

Each module uses appropriate platform knowledge pack!
```

## Questions to Resolve

1. **Should we refactor the current Windows swarm into this universal architecture?**
   - Pro: Future-proof, extensible
   - Con: More complex, refactoring effort

2. **Which platforms to prioritize first?**
   - Suggestion: Windows (done), Azure, Cisco, AWS, Linux (most common)

3. **How to handle multi-platform collections?**
   - Option A: Primary platform only
   - Option B: Hybrid (load multiple platform packs)

4. **Should learning database be shared or per-platform?**
   - Suggestion: Shared with platform tags (cross-pollination of knowledge)

5. **How to version platform packs independently?**
   - Each platform pack has version number
   - Core framework has version
   - Compatibility matrix maintained

## Next Steps

If you approve this architecture:

1. ✅ Refactor current Windows swarm → Universal core + Windows platform pack
2. ✅ Create Azure platform pack (proof of concept)
3. ✅ Create Cisco platform pack (network proof of concept)
4. ✅ Update Lead Architect for platform detection
5. ✅ Update Module Worker for platform-aware implementation
6. ✅ Update QA Coordinator for platform-aware testing
7. ✅ Update documentation with universal architecture

**Result**: One swarm that can build ANY Ansible collection!
