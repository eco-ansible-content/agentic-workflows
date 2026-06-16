# Universal Ansible Collection Swarm - Intelligence-Based Architecture

## The Problem with My Previous Approach

❌ **What I did wrong**:
```
if platform == "windows": use PowerShell
elif platform == "azure": use Azure SDK
elif platform == "cisco": use network_cli
```

This is TEMPLATE-BASED, not INTELLIGENT.

✅ **What you want**:
```
Read Epic: "Manage XYZ platform"
Understand: What is XYZ? How does it work?
Research: How do people typically manage XYZ?
Learn: From examples, documentation, existing code
Adapt: Apply learned patterns intelligently
```

This works for **ANY** platform, including ones that don't exist yet.

---

## Core Principle: Characteristics Over Classifications

**Don't ask**: "Is this Windows, Azure, or Cisco?"  
**Instead ask**: "What are the characteristics of this platform?"

### Platform Characteristics (Generic)

Every platform has these characteristics that agents can discover:

#### 1. Module Implementation Language
**Question**: "What language is used to interact with this platform?"

**Discovery method**:
- Read Epic description: "Python modules", "PowerShell cmdlets", "Go SDK"
- Check existing modules in Jira: What language are they written in?
- Research: "How to automate X platform" → find SDK/library language
- Default: Python (most common for Ansible)

**Examples**:
- Windows → PowerShell (keyword: "PowerShell cmdlets", "WMI", "CIM")
- Most others → Python (keywords: "SDK", "API", "REST")
- Custom apps → Could be anything (ask user or research)

#### 2. Connection Method
**Question**: "How does Ansible connect to this platform?"

**Discovery method**:
- Read Epic: "via WinRM", "SSH access", "API endpoint", "network CLI"
- Research platform documentation: Look for "remote management" sections
- Check inventory examples: What connection vars are mentioned?
- Pattern recognition: Network devices → network_cli, Windows → winrm, Linux → ssh, Cloud → local (API)

**Characteristics to detect**:
- **Agent-based** (requires remote connection): WinRM, SSH, network_cli
- **API-based** (local execution): httpapi, REST API, SDK calls
- **Hybrid** (both): Some platforms support multiple methods

#### 3. State Management Approach
**Question**: "How do you check current state and apply changes?"

**Discovery method**:
- Read platform documentation: Look for idempotency patterns
- Analyze: "Is this declarative (desired state) or imperative (commands)?"
- Research SDK/API: Does it have GET/PUT methods? Or only execute commands?
- Learn from examples: How do existing modules for similar platforms work?

**Patterns to recognize**:
- **Declarative**: GET current state → Compare → PUT if different (cloud, APIs)
- **Imperative**: Run command → Parse output → Decide next command (CLI-based)
- **Transactional**: Begin transaction → Apply changes → Commit (databases, NETCONF)

#### 4. Testing Strategy
**Question**: "How do you test modules for this platform?"

**Discovery method**:
- Connection type determines test environment needs
- API-based → Can mock responses (unit tests sufficient)
- Agent-based → Needs real or simulated targets (integration tests required)
- Research: "How to test X automation" → find common practices

**Test characteristics**:
- **Mockable**: Cloud APIs, REST endpoints → can use mocks/stubs
- **Requires real target**: Network devices, Windows servers → needs test environment
- **Containers**: Linux → can use Docker/Podman for fast tests
- **Simulators**: Network gear → VIRL/CML, GNS3 available

#### 5. Prerequisites
**Question**: "What needs to be installed/configured before testing?"

**Discovery method**:
- Read Epic: "Requires X software", "Needs Y credentials"
- Research platform: "Getting started with X" → find installation steps
- Infer from platform type: Cloud → credentials, On-prem → software installation
- Ask user: "What's already available in your environment?"

**Categories to recognize**:
- **Software installation**: Install server/agent software (Windows platforms)
- **Credential setup**: Create service principals, API keys (Cloud platforms)
- **Test infrastructure**: Provision VMs, containers, simulators (Infrastructure platforms)
- **Network access**: Configure firewall, VPN, SSH keys (Remote platforms)

#### 6. Idempotency Verification Method
**Question**: "How do you verify a module is idempotent?"

**Discovery method**:
- Based on state management approach
- Declarative → Run twice, second run should report no changes
- Imperative → Check state before/after, should match expected
- Transactional → Verify transaction commits only when needed

---

## How Agents Become Intelligent

### Jira Ingestion Specialist (Intelligence)

**OLD approach** (template-based):
```markdown
if "SCVMM" in epic_title:
    platform = "windows"
    template = "windows_prerequisites.yml"
```

**NEW approach** (intelligence-based):
```markdown
## Platform Characteristic Discovery

Read the Epic description like a human engineer:

**Epic Title**: "Build modules for managing SolarWinds Orion network monitoring"

**Understanding process**:
1. What is SolarWinds Orion?
   - Search knowledge: Network monitoring platform
   - Research: Has REST API (SWIS)
   - Conclusion: API-based platform

2. How is it automated?
   - Research: "SolarWinds Orion automation"
   - Find: REST API with JSON responses
   - Find: Python SDK available (orionsdk)
   - Conclusion: Python modules using REST API or SDK

3. What's needed to test?
   - Research: Requires SolarWinds server
   - Find: Trial version available
   - Alternative: Mock API responses
   - Conclusion: Can mock for unit tests, needs server for integration

4. How to implement?
   - Pattern: Similar to other REST API platforms
   - GET current state → Compare → POST/PUT changes
   - Idempotency: Built into REST pattern (PUT is idempotent)

**Output to prerequisites.md**:
```markdown
# Prerequisites for SolarWinds Orion Collection

## Platform Characteristics
**Platform Type**: Network Monitoring (API-based)
**Automation Method**: REST API (SWIS)
**Module Language**: Python (orionsdk library available)
**Connection**: httpapi or local (API calls)
**Idempotency**: Declarative (GET-compare-PUT pattern)

## Required Software
- SolarWinds Orion Server (trial or full version)
  - Research: Download from solarwinds.com/orion/trial
  - Alternative: Mock API responses for unit tests
  
## Required Credentials
- Orion API credentials (username/password)
- API endpoint URL

## Test Environment Options
**Option A** (Recommended): Mock API responses
- Faster tests, no infrastructure
- Limitations: Doesn't test real integration

**Option B**: SolarWinds trial server
- Full integration testing
- Requires: Windows Server VM, 8GB RAM, SolarWinds installer

## Similar Platforms
- Modules for other REST API platforms (Jira, ServiceNow, etc.)
- Pattern reference: See REST API module examples in Ansible docs
```

**Key difference**: NO platform templates, just UNDERSTANDING the characteristics.
```

### Platform Prerequisite Specialist (Intelligence)

**OLD approach**:
```markdown
if platform == "windows":
    run windows_install_script.sh
elif platform == "azure":
    run azure_credentials_setup.sh
```

**NEW approach**:
```markdown
## Intelligent Prerequisite Installation

Read prerequisites.md and UNDERSTAND what's needed:

**Example: SolarWinds Orion (from above)**

Reading: "SolarWinds Orion Server (trial or full version)"

**Intelligent process**:
1. **Recognize pattern**: This is third-party software installation
2. **Search for installer**:
   - Check Epic attachments
   - Research: "SolarWinds Orion trial download"
   - Find URL: https://www.solarwinds.com/orion-trial
3. **Understand installation**:
   - Research: "SolarWinds Orion silent install"
   - Find: MSI installer with /quiet flag
   - Find: Requires SQL Server backend (dependency)
4. **Installation sequence**:
   a. Install SQL Server (prerequisite for SolarWinds)
   b. Download SolarWinds trial
   c. Run MSI with silent parameters
   d. Configure API access
   e. Verify: Test API endpoint responds

**If installation fails** (3-attempt recovery):
1. **Attempt 1**: Check SQL Server is running, retry
2. **Attempt 2**: Use Express edition of SolarWinds if available
3. **Attempt 3**: Offer degraded environment (use API mocks instead)

**No hardcoded scripts** - intelligence adapts to ANY platform.
```

### Module Worker (Intelligence)

**OLD approach**:
```markdown
if platform == "windows":
    use 5-pillars-guide.md
elif platform == "azure":
    use azure-sdk-guide.md
```

**NEW approach**:
```markdown
## Implementation Pattern Discovery

**Given task**: Implement `solarwinds_node` module

**Intelligent process**:

1. **Understand the task**:
   - Goal: Manage network nodes in SolarWinds Orion
   - Operations: Add, remove, update nodes

2. **Research the platform**:
   - Check prerequisites.md: "REST API (SWIS), Python orionsdk"
   - Research: "SolarWinds SWIS API documentation"
   - Find: SDK has `swisclient.query()` and `swisclient.invoke()` methods

3. **Find similar patterns**:
   - Question: "What other Ansible modules use REST APIs?"
   - Search: Existing Ansible modules for REST-based platforms
   - Find: Common pattern:
     ```python
     # 1. GET current state
     # 2. Compare with desired state
     # 3. POST/PUT/DELETE if different
     # 4. Return result
     ```

4. **Create implementation decision tree** (dynamically):
   
   **For SolarWinds Orion**:
   
   ⭐⭐⭐⭐⭐ **Option 1: orionsdk Python library**
   - Official SDK, handles authentication
   - Methods: query(), create(), update(), delete()
   - Idempotency: Check if exists, update only if changed
   
   ⭐⭐⭐⭐ **Option 2: Direct REST API (requests library)**
   - More control, no SDK dependency
   - More verbose, manual auth handling
   
   ⭐⭐⭐ **Option 3: Ansible uri module wrapper**
   - Quick prototyping
   - Not idempotent by default, fragile

   **Recommendation**: Use Option 1 (orionsdk)

5. **Implement following discovered pattern**:
   ```python
   from orionsdk import SwisClient
   
   def ensure_node_present(swis, node_params):
       # Get current nodes
       current = swis.query("SELECT NodeID FROM Orion.Nodes WHERE IPAddress=@ip",
                            ip=node_params['ip_address'])
       
       if current['results']:
           # Node exists, check if update needed
           node_id = current['results'][0]['NodeID']
           # Compare current vs desired...
           if needs_update:
               swis.update(f'Orion.Nodes[NodeID={node_id}]', **updates)
               return {'changed': True}
           return {'changed': False}
       else:
           # Create new node
           swis.create('Orion.Nodes', **node_params)
           return {'changed': True}
   ```

**Key**: Pattern learned from research, not from template.
```

### QA Coordinator (Intelligence)

**OLD approach**:
```markdown
if platform == "windows":
    run 4-stage-testing-guide.md
elif platform == "network":
    run network-testing-guide.md
```

**NEW approach**:
```markdown
## Testing Strategy Discovery

**Given**: solarwinds_node module to test

**Intelligent process**:

1. **Understand connection method** (from prerequisites.md):
   - Connection: API-based (local execution)
   - No remote agent needed

2. **Determine testability**:
   - Can be mocked? YES (REST API responses)
   - Needs real server? RECOMMENDED (but optional)
   - Containers available? NO (Windows-only server)

3. **Design test strategy** (dynamically):

   **Stage 1: Unit Tests with Mocks**
   ```yaml
   - name: Test node creation (mocked)
     solarwinds_node:
       ip_address: "192.168.1.100"
       hostname: "test-node"
       state: present
     check_mode: no
     # Mock the SWIS API responses
   ```

   **Stage 2: Idempotency Test**
   ```yaml
   - name: Create node
     solarwinds_node:
       ip_address: "192.168.1.100"
       state: present
     register: result1
   
   - name: Create same node again (should not change)
     solarwinds_node:
       ip_address: "192.168.1.100"
       state: present
     register: result2
   
   - assert:
       that:
         - result1.changed == true
         - result2.changed == false
   ```

   **Stage 3: Check Mode**
   ```yaml
   - name: Test check mode reports what would change
     solarwinds_node:
       ip_address: "192.168.1.101"
       state: present
     check_mode: yes
     register: result
   
   - assert:
       that:
         - result.changed == true
         - result.msg is search("Would create")
   ```

   **Stage 4: Error Handling**
   ```yaml
   - name: Test invalid IP address
     solarwinds_node:
       ip_address: "invalid"
       state: present
     ignore_errors: yes
     register: result
   
   - assert:
       that:
         - result.failed == true
         - "'Invalid IP' in result.msg"
   ```

4. **Adapt stages based on platform characteristics**:
   - API-based → Mocking possible, check mode easy
   - CLI-based → Harder to mock, check mode = parse without apply
   - Transactional → Add rollback testing
   - Real-time (network) → Add connection failure testing

**No fixed test template** - adapts to platform needs.
```

---

## Universal Pattern Recognition

### Teaching Agents to Learn Patterns

Instead of hardcoded knowledge, agents use **pattern recognition**:

#### Pattern: REST API Platforms

**Characteristics detected**:
- Keywords: "REST API", "HTTP endpoint", "JSON", "SDK"
- Connection: API calls (no remote agent)
- State management: GET current → Compare → PUT changes

**Implementation pattern learned**:
```python
# Generic REST API module pattern
def ensure_resource_state(api_client, resource_type, desired_state):
    current = api_client.get(resource_type, id=desired_state['id'])
    
    if not current:
        api_client.create(resource_type, desired_state)
        return {'changed': True}
    
    if current != desired_state:
        api_client.update(resource_type, desired_state)
        return {'changed': True}
    
    return {'changed': False}
```

**Applies to**: Azure, AWS, GCP, ServiceNow, Jira, SolarWinds, Splunk, VMware REST, etc.

#### Pattern: CLI-Based Platforms

**Characteristics detected**:
- Keywords: "CLI", "command line", "shell", "terminal"
- Connection: SSH, WinRM, network_cli
- State management: Run command → Parse output → Decide next command

**Implementation pattern learned**:
```python
# Generic CLI module pattern
def ensure_config_present(connection, config_command, check_command):
    # Check current state
    current = connection.run(check_command)
    
    # Parse output
    current_config = parse_output(current)
    
    # Compare
    if config_needed(current_config, desired_config):
        # Apply config
        connection.run(config_command)
        return {'changed': True}
    
    return {'changed': False}
```

**Applies to**: Cisco, Juniper, Arista, Linux (systemd), Windows (PowerShell), etc.

#### Pattern: Declarative Config Files

**Characteristics detected**:
- Keywords: "configuration file", "declarative", "YAML/JSON config"
- State management: Read file → Modify → Write if changed

**Implementation pattern learned**:
```python
# Generic config file pattern
def ensure_config_file(file_path, desired_config):
    current = read_file(file_path)
    
    if current != desired_config:
        write_file(file_path, desired_config)
        return {'changed': True}
    
    return {'changed': False}
```

**Applies to**: Kubernetes, Terraform, Docker Compose, etc.

---

## How Intelligence Scales Infinitely

### Example: New Platform (Never Seen Before)

**Scenario**: User wants to build collection for "WidgetCorp ProMonitor v3.2" (fictional, never existed)

**Jira Ingestion process**:

1. **Read Epic**:
   ```
   "Build Ansible modules for WidgetCorp ProMonitor v3.2.
   ProMonitor manages application performance via SOAP API.
   Requires ProMonitor server installed with admin credentials."
   ```

2. **Extract characteristics** (no template needed):
   - **Platform**: WidgetCorp ProMonitor v3.2 (unknown platform)
   - **Automation method**: SOAP API (keyword detected)
   - **Prerequisites**: ProMonitor server, admin credentials
   - **Connection type**: API-based (inferred from "SOAP API")

3. **Research** (agent investigates):
   - Search: "SOAP API automation Python"
   - Find: `zeep` library for SOAP in Python
   - Pattern: Similar to REST (but XML instead of JSON)
   
4. **Output prerequisites.md**:
   ```markdown
   # Prerequisites for WidgetCorp ProMonitor Collection
   
   ## Platform Characteristics
   **Platform**: WidgetCorp ProMonitor v3.2 (custom application monitoring)
   **Automation Method**: SOAP API
   **Module Language**: Python (zeep library for SOAP)
   **Connection**: local (API calls)
   **Pattern**: Similar to REST API platforms
   
   ## Required Software
   - WidgetCorp ProMonitor v3.2 Server
     - Check Epic for installer location
     - May require vendor license
   
   ## Required Credentials
   - Admin username/password
   - SOAP API endpoint URL (default: https://promonitor:8443/api)
   
   ## Implementation Pattern
   Similar to REST API modules:
   1. Connect via SOAP client (zeep)
   2. GET current resource state
   3. Compare with desired state
   4. POST/PUT changes if needed
   ```

5. **Module Worker implements** (learns SOAP pattern):
   ```python
   from zeep import Client
   
   # Pattern learned from SOAP API research
   def ensure_monitor_present(wsdl_url, credentials, monitor_params):
       client = Client(wsdl_url)
       
       # Get current monitors (SOAP call)
       current = client.service.GetMonitor(monitor_params['id'])
       
       if not current:
           # Create (SOAP call)
           client.service.CreateMonitor(**monitor_params)
           return {'changed': True}
       
       # Compare and update if needed
       if needs_update(current, monitor_params):
           client.service.UpdateMonitor(**monitor_params)
           return {'changed': True}
       
       return {'changed': False}
   ```

**ZERO platform-specific templates needed** - agent learned the pattern!

---

## Generic Learning Database

### Lessons Apply Across Platforms

**Lesson learned from Windows**:
```markdown
## Lesson #045: Installer Timeout Detection

**Root Cause**: Silent installers can hang without progress
**Solution**: Monitor log file growth to detect hung installers
**Pattern**: Check log file size every 30s, if no growth → timeout
```

**This lesson applies to**:
- ANY platform with software installation (SolarWinds, ProMonitor, Cisco IOS upgrades)
- Generic pattern, not platform-specific

**Lesson learned from Azure**:
```markdown
## Lesson #067: API Rate Limiting Handling

**Root Cause**: Cloud APIs throttle requests
**Solution**: Implement exponential backoff retry logic
**Pattern**: Catch 429 error → wait 2^attempt seconds → retry
```

**This lesson applies to**:
- ANY REST API platform (AWS, GCP, ServiceNow, Jira, etc.)
- Generic pattern, not platform-specific

### Cross-Platform Knowledge Transfer

**Learning database structure**:
```markdown
# Lessons Learned (Universal)

## Category: API Patterns
- #067: API Rate Limiting → Applies to: REST APIs, SOAP APIs
- #082: Idempotency via GET-compare-PUT → Applies to: Declarative platforms
- #103: Pagination for large result sets → Applies to: Any API returning lists

## Category: Installation Robustness
- #045: Installer timeout detection → Applies to: Any software installation
- #089: Disk space pre-flight checks → Applies to: Any installation
- #112: Dependency ordering → Applies to: Multi-component platforms

## Category: Testing Intelligence
- #034: Idempotency detection → Applies to: All modules
- #056: Mock API responses → Applies to: API-based platforms
- #091: Container-based testing → Applies to: Linux, containerized apps
```

**Pattern**: Lessons tagged by CHARACTERISTICS, not platform names.

---

## Agent Implementation Changes

### No Platform-Specific Logic

**REMOVE all code like this**:
```python
if platform == "windows":
    do_windows_thing()
elif platform == "azure":
    do_azure_thing()
```

**REPLACE with intelligence**:
```python
# Understand characteristics
characteristics = discover_platform_characteristics(epic_description)

# Find similar patterns
similar_patterns = search_learned_patterns(characteristics)

# Apply learned approach
implementation = adapt_pattern(similar_patterns, current_task)
```

### Lead Architect (Universal)

```markdown
## Platform Intelligence

At start of build:

1. **No platform detection** - just read Epic
2. **Extract characteristics**:
   - What's being managed?
   - How is it managed? (API, CLI, config files)
   - What language/SDK is used?
   - What connection method?
3. **Pass characteristics** to all agents (not "platform name")
4. **Agents adapt** based on characteristics

**No hardcoded platform list** - works for platforms that don't exist yet!
```

### Jira Ingestion (Universal)

```markdown
## Characteristic Extraction (Not Platform Detection)

Read Epic and understand:

**Instead of**: "Is this Windows, Azure, or Cisco?"
**Ask**: 
- What is being automated?
- How do people typically manage it?
- What APIs/interfaces exist?
- What language/tools are common?

**Output**: Natural language description of characteristics
**NOT**: Platform name or template selection
```

### Module Worker (Universal)

```markdown
## Pattern Research (Not Template Selection)

For each module:

1. **Understand the task**: What resource are we managing?
2. **Research the API/interface**: How is it managed?
3. **Find similar patterns**: What other modules do similar things?
4. **Learn implementation approach**: Adapt pattern to this task
5. **Implement**: Following learned pattern, not template

**No implementation guide files** - agent researches and learns
```

---

## File Structure (Simplified)

```
~/.claude/agents/ansible-collection-swarm/
├── core/
│   ├── agents/                    # 10 universal agents
│   │   └── *.md                   # NO platform-specific logic
│   └── templates/
│       └── collection_template/   # Generic structure
│
├── knowledge/                     # Pattern library (NOT platform packs)
│   ├── patterns/
│   │   ├── rest-api-pattern.md        # Generic REST pattern
│   │   ├── cli-based-pattern.md       # Generic CLI pattern
│   │   ├── config-file-pattern.md     # Generic config management
│   │   └── database-pattern.md        # Generic DB operations
│   └── examples/
│       ├── rest-api-example.py        # Generic REST module
│       ├── cli-based-example.py       # Generic CLI module
│       └── config-file-example.py     # Generic config module
│
└── docs/
    └── lessons_learned.md         # Tagged by characteristics, not platforms
```

**No `platforms/` directory** - no hardcoded platforms at all!

---

## Success Criteria

The swarm is truly universal when:

✅ Can build collection for platform that doesn't exist yet
✅ No "if platform == X" logic anywhere
✅ Agents learn from research, not templates
✅ Patterns apply across platforms
✅ Adding new platform = zero code changes
✅ Learning database benefits all future builds

**Test**: "Build collection for fictional FooBar monitoring system"
→ Should work by researching, learning, adapting. Not fail with "unknown platform".

---

## Next Steps

Should I:

1. **Refactor current Windows swarm** → Remove all Windows-specific logic, make it learn Windows patterns instead?

2. **Create generic pattern library** → REST API, CLI, Config File patterns (not platform-specific)?

3. **Update agents to research and learn** instead of loading platform guides?

4. **Remove platform detection** → Replace with characteristic extraction?

This would be **TRULY universal** - works for ANY platform by UNDERSTANDING it, not matching it to templates.
