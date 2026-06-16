# Project Context Examples

This document provides examples of how users should provide test environment and delivery target information to the Lead Architect.

---

## Testing Environment Examples

### Example 1: Single Windows Server (WinRM)

**User provides**:
```
192.168.1.100
WinRM HTTPS (port 5986)
Username: Administrator
Password: P@ssw0rd123
```

**Parsed as**:
```yaml
test_environment:
  connection: winrm
  host: 192.168.1.100
  port: 5986
  credentials:
    username: Administrator
    password: P@ssw0rd123
  transport: ssl
```

**Used by agents**:
- Platform Prerequisite Specialist: Installs SCVMM/IIS/etc. on this host
- QA Coordinator: Runs ansible-test against this inventory

---

### Example 2: Linux Server (SSH with Key)

**User provides**:
```
ssh://test-linux.lab.internal:22
SSH key: ~/.ssh/ansible_test_rsa
User: ansible
```

**Parsed as**:
```yaml
test_environment:
  connection: ssh
  host: test-linux.lab.internal
  port: 22
  credentials:
    username: ansible
    private_key: ~/.ssh/ansible_test_rsa
```

---

### Example 3: Cisco Switch (network_cli)

**User provides**:
```
network_cli://10.0.1.1
User: admin
Password: cisco123
Enable password: cisco456
```

**Parsed as**:
```yaml
test_environment:
  connection: network_cli
  host: 10.0.1.1
  port: 22  # default SSH for network_cli
  credentials:
    username: admin
    password: cisco123
    become_password: cisco456
  network_os: ios  # inferred or asked
```

---

### Example 4: Azure API (Local Execution)

**User provides**:
```
Connection: local (Azure API)
Subscription ID: abcd-1234-5678-efgh
Service Principal: Stored in ~/.azure/credentials
```

**Parsed as**:
```yaml
test_environment:
  connection: local
  api_endpoint: https://management.azure.com
  credentials:
    subscription_id: abcd-1234-5678-efgh
    auth_method: service_principal
    credential_file: ~/.azure/credentials
  notes: Azure modules run locally, connect to API
```

---

### Example 5: Multiple Hosts (Cluster/Load Balanced)

**User provides**:
```
3 Windows servers in Hyper-V cluster:
- 192.168.1.10 (Primary)
- 192.168.1.11 (Secondary)
- 192.168.1.12 (Secondary)
All use WinRM, same credentials: ansible/P@ssw0rd
```

**Parsed as**:
```yaml
test_environment:
  connection: winrm
  hosts:
    - 192.168.1.10
    - 192.168.1.11
    - 192.168.1.12
  port: 5986
  credentials:
    username: ansible
    password: P@ssw0rd
  notes: Hyper-V cluster, test against primary, verify on all
```

---

### Example 6: Container-Based Testing

**User provides**:
```
Docker container: ansible-test-ubuntu
Runs locally, SSH on port 2222
Key: ~/.ssh/container_rsa
```

**Parsed as**:
```yaml
test_environment:
  connection: ssh
  host: localhost
  port: 2222
  credentials:
    username: root
    private_key: ~/.ssh/container_rsa
  notes: Docker container, ephemeral test environment
```

---

### Example 7: VMware vCenter (httpapi)

**User provides**:
```
vCenter: vcenter.lab.local
HTTPS API (port 443)
User: administrator@vsphere.local
Password: VMware123!
```

**Parsed as**:
```yaml
test_environment:
  connection: httpapi
  host: vcenter.lab.local
  port: 443
  credentials:
    username: administrator@vsphere.local
    password: VMware123!
  api_type: vmware_rest
```

---

## Delivery Target Examples

### Example 1: Local Only

**User selects**: Option A

**Result**:
```yaml
delivery:
  target: local
  path: ~/agentic-workflow-collections/microsoft/scvmm/
  git_push: false
```

**Behavior**:
- Collection built in local directory
- No git operations beyond local commits
- User manually pushes if/when ready

---

### Example 2: GitHub Repository (HTTPS)

**User provides**:
```
https://github.com/eco-ansible-content/agentic-workflow-collections.git
Branch: main
```

**Result**:
```yaml
delivery:
  target: git
  git_url: https://github.com/eco-ansible-content/agentic-workflow-collections.git
  branch: main
  auth_method: https  # Will prompt for credentials or use git config
```

**Behavior**:
- Collection committed locally first
- Pushed to GitHub repository after validation
- CI/CD pipelines triggered automatically

---

### Example 3: GitLab (SSH)

**User provides**:
```
git@gitlab.company.com:ansible-collections/windows.git
Branch: development
```

**Result**:
```yaml
delivery:
  target: git
  git_url: git@gitlab.company.com:ansible-collections/windows.git
  branch: development
  auth_method: ssh  # Uses ~/.ssh keys
```

---

### Example 4: Internal Git Server

**User provides**:
```
https://git.internal.corp/ansible/collections.git
Branch: feature/scvmm-automation
Credentials: Use corporate SSO
```

**Result**:
```yaml
delivery:
  target: git
  git_url: https://git.internal.corp/ansible/collections.git
  branch: feature/scvmm-automation
  auth_method: sso
  notes: Corporate SSO authentication required
```

---

## Inventory File Generation

Based on test environment context, agents generate appropriate inventory files:

### Generated: WinRM Inventory

**From Example 1** (Windows WinRM):
```ini
# tests/inventory.winrm
[windows]
192.168.1.100

[windows:vars]
ansible_connection=winrm
ansible_port=5986
ansible_user=Administrator
ansible_password=P@ssw0rd123
ansible_winrm_transport=ssl
ansible_winrm_server_cert_validation=ignore
```

### Generated: SSH Inventory

**From Example 2** (Linux SSH):
```ini
# tests/inventory.ssh
[linux]
test-linux.lab.internal

[linux:vars]
ansible_connection=ssh
ansible_port=22
ansible_user=ansible
ansible_ssh_private_key_file=~/.ssh/ansible_test_rsa
ansible_python_interpreter=/usr/bin/python3
```

### Generated: Network CLI Inventory

**From Example 3** (Cisco):
```ini
# tests/inventory.network
[cisco]
10.0.1.1

[cisco:vars]
ansible_connection=network_cli
ansible_network_os=ios
ansible_user=admin
ansible_password=cisco123
ansible_become=yes
ansible_become_method=enable
ansible_become_password=cisco456
```

### Generated: Local Inventory (API-based)

**From Example 4** (Azure):
```ini
# tests/inventory.local
[localhost]
127.0.0.1

[localhost:vars]
ansible_connection=local
ansible_python_interpreter=/usr/bin/python3

# Azure credentials sourced from environment or ~/.azure/
```

---

## How Agents Use Project Context

### Platform Prerequisite Specialist

Reads `project_context.yml`:
```yaml
test_environment:
  connection: winrm
  host: 192.168.1.100
```

**Actions**:
- Connects to 192.168.1.100 via WinRM
- Installs SCVMM, SQL Server, Hyper-V on this host
- Verifies installation by running PowerShell commands remotely
- Creates degraded environment if installation fails

---

### QA Coordinator

Reads `project_context.yml`:
```yaml
test_environment:
  connection: ssh
  host: test-linux.lab.internal
```

**Actions**:
- Generates SSH inventory file
- Runs: `ansible-test integration --inventory tests/inventory.ssh`
- Tests connect via SSH to target host
- Validates module functionality on real target

---

### Release Specialist

Reads `project_context.yml`:
```yaml
delivery:
  target: git
  git_url: https://github.com/eco-ansible-content/agentic-workflow-collections.git
```

**Actions**:
- Commits collection to local git repository
- Pushes to specified remote repository
- Verifies push succeeded
- Triggers CI/CD pipelines (if configured)

**If delivery.target == "local"**:
- Commits locally only
- Reports: "Collection available at: ~/agentic-workflow-collections/..."
- Skips remote push

---

## Validation Examples

### Valid Test Environment Inputs

✅ `192.168.1.100, winrm, user: Administrator, pass: P@ss123`
✅ `ssh://server.local:22, key: ~/.ssh/test_key`
✅ `network_cli://10.0.1.1, user: admin, pass: cisco`
✅ `local, Azure API, subscription: abc-123`
✅ `vcenter.lab.local, httpapi, user: admin@vsphere.local`

### Invalid Test Environment Inputs

❌ "Use my test server" (no connection details)
❌ "Standard setup" (not specific)
❌ "Same as last time" (no persistence between runs)
❌ Just an IP with no connection method or credentials

### Valid Delivery Target Inputs

✅ Option A (local only)
✅ `https://github.com/user/repo.git`
✅ `git@gitlab.com:user/repo.git`
✅ `https://git.internal.corp/ansible/collections.git`

### Invalid Delivery Target Inputs

❌ "Push to GitHub" (no URL)
❌ "My repository" (not specific)
❌ Incomplete URL: `github.com/user/repo`

---

## Context Persistence

**project_context.yml** is created in the collection workspace and persists:

```
~/agentic-workflow-collections/microsoft/scvmm/
├── docs/
│   └── plans/
│       ├── module_backlog.md
│       ├── prerequisites.md
│       └── project_context.yml    ← Stores test env + delivery config
```

**Benefits**:
- All agents read from single source of truth
- User can review/modify context file manually
- Resume capability: If build interrupted, context preserved
- Documentation: Future users know how collection was tested

---

## Edge Cases

### No Test Environment Available

**User says**: "I don't have a test environment yet"

**Lead Architect response**:
```
Cannot proceed without test environment.

Options:
A) Provide test environment details (IP, credentials)
B) I can build modules CODE-ONLY (no integration tests)
C) Pause until test environment ready

Choice?
```

If user chooses B:
- Skip Platform Prerequisite phase
- Skip QA integration tests (code review only)
- Mark all modules as `[!] CODE COMPLETE, TESTS BLOCKED`
- Generate `blocked_modules.md` for resume capability

### Git Repository Not Accessible

**User provides**: `https://github.com/private/repo.git`

**Lead Architect validates**:
```bash
git ls-remote https://github.com/private/repo.git
# Returns: Authentication failed
```

**Response**:
```
Cannot access git repository (authentication failed).

Options:
A) Provide git credentials (token, SSH key)
B) Change to local-only delivery
C) Fix authentication and retry

Choice?
```

---

**This document ensures users provide context in formats agents can parse and use effectively!**
