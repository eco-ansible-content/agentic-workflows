# Project Context Examples

## Test Environment Examples

**Windows (WinRM)**:
```
192.168.1.100, winrm, user: Administrator, pass: P@ssw0rd
```

**Linux (SSH)**:
```
ssh://test-server.lab.local:22, key: ~/.ssh/ansible_rsa
```

**Cisco (network_cli)**:
```
network_cli://10.0.1.1, user: admin, pass: cisco123
```

**Azure (API)**:
```
local (Azure API), subscription: abc-1234
```

## Delivery Target Examples

**Local only**:
```
Select: Option A
```

**GitHub**:
```
https://github.com/myorg/ansible-collections.git
```

**GitLab**:
```
git@gitlab.company.com:ansible/collections.git
```
