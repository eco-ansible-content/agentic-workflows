# The 5 Pillars of Introspection for Windows Module Development

This guide helps agents autonomously choose the best implementation approach for Windows Ansible modules.

## Decision Tree

```
Need to manage Windows resource?
├─ Native PowerShell cmdlet exists? → Use Pillar 1 (Cmdlets)
├─ Windows Server 2012+ and CIM available? → Use Pillar 3 (CIM)
├─ Older Windows or only WMI available? → Use Pillar 2 (WMI)
├─ Complex operations requiring .NET? → Use Pillar 4 (.NET)
└─ Configuration in Registry only? → Use Pillar 5 (Registry)
```

## Pillar 1: PowerShell Cmdlets

**Preference**: ⭐⭐⭐⭐⭐ (Highest - use whenever available)

**When to use**:
- Native cmdlets exist for the functionality
- Most reliable and maintainable approach
- Best performance and error handling

**Examples**:
- `Get-Service`, `Start-Service`, `Stop-Service`
- `Get-Process`, `Stop-Process`
- `New-Item`, `Remove-Item`, `Set-ItemProperty`
- `Get-WindowsFeature`, `Install-WindowsFeature`

**Implementation pattern**:
```powershell
try {
    $result = Get-Service -Name $name -ErrorAction Stop
    # Process result...
} catch {
    $module.FailJson("Failed: $($_.Exception.Message)", $_)
}
```

**Advantages**:
- Built-in error handling
- Consistent interface
- Microsoft-supported
- Idempotent by design

**Disadvantages**:
- Not all functionality has cmdlets
- May require specific PowerShell versions

## Pillar 2: WMI (Windows Management Instrumentation)

**Preference**: ⭐⭐⭐ (Medium - legacy fallback)

**When to use**:
- CIM not available (older Windows)
- System-level queries needed
- No cmdlet available

**Examples**:
- `Get-WmiObject Win32_Service`
- `Get-WmiObject Win32_Process`
- `Get-WmiObject Win32_OperatingSystem`

**Implementation pattern**:
```powershell
try {
    $wmiObject = Get-WmiObject -Class Win32_Service -Filter "Name='$name'"
    if ($null -eq $wmiObject) {
        # Handle not found...
    }
} catch {
    $module.FailJson("WMI query failed: $($_.Exception.Message)", $_)
}
```

**Advantages**:
- Available on all Windows versions
- Rich system information
- Remote management capable

**Disadvantages**:
- Legacy technology (deprecated)
- Performance overhead
- Complex error handling

## Pillar 3: CIM (Common Information Model)

**Preference**: ⭐⭐⭐⭐ (High - modern WMI replacement)

**When to use**:
- Windows Server 2012+ or Windows 8+
- Prefer over WMI for modern systems
- System information queries

**Examples**:
- `Get-CimInstance Win32_OperatingSystem`
- `Get-CimInstance Win32_Service`
- `Get-CimInstance Win32_NetworkAdapter`

**Implementation pattern**:
```powershell
try {
    $cimInstance = Get-CimInstance -ClassName Win32_Service -Filter "Name='$name'"
    # CIM uses modern error handling
} catch {
    $module.FailJson("CIM query failed: $($_.Exception.Message)", $_)
}
```

**Advantages**:
- Modern, standards-based
- Better performance than WMI
- Consistent error model
- Future-proof

**Disadvantages**:
- Requires Windows Server 2012+ / Windows 8+
- Not available on older systems

## Pillar 4: .NET Framework

**Preference**: ⭐⭐⭐ (Medium - for complex operations)

**When to use**:
- Complex file/directory operations
- Advanced string manipulation
- Cryptography operations
- No cmdlet or CIM equivalent

**Examples**:
- `[System.IO.Directory]::CreateDirectory($path)`
- `[System.IO.File]::ReadAllText($path)`
- `[System.Security.Cryptography.SHA256]::Create()`

**Implementation pattern**:
```powershell
try {
    $result = [System.IO.Directory]::Exists($path)
    if (-not $result) {
        [System.IO.Directory]::CreateDirectory($path) | Out-Null
    }
} catch [System.IO.IOException] {
    $module.FailJson("IO error: $($_.Exception.Message)", $_)
}
```

**Advantages**:
- Full access to .NET Framework
- Powerful for complex operations
- Type-safe operations

**Disadvantages**:
- More complex code
- Requires .NET knowledge
- May have version dependencies

## Pillar 5: Registry Manipulation

**Preference**: ⭐⭐ (Low - use only when necessary)

**When to use**:
- Configuration stored only in registry
- No cmdlet or API available
- Application-specific settings

**Examples**:
- `Get-ItemProperty HKLM:\Software\...`
- `Set-ItemProperty HKLM:\Software\...`
- `New-Item HKLM:\Software\...`

**Implementation pattern**:
```powershell
try {
    $value = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue
    if ($null -eq $value -or $value.$regName -ne $desiredValue) {
        Set-ItemProperty -Path $regPath -Name $regName -Value $desiredValue
        $changed = $true
    }
} catch {
    $module.FailJson("Registry operation failed: $($_.Exception.Message)", $_)
}
```

**Advantages**:
- Direct access to configuration
- Lightweight operations
- No external dependencies

**Disadvantages**:
- Fragile (typos cause issues)
- Security implications
- Hard to test
- Must ensure idempotency manually

## Decision Matrix

| Requirement | Recommended Pillar | Alternative |
|-------------|-------------------|-------------|
| Manage Windows services | Cmdlets (Get-Service) | CIM |
| Query system information | CIM | WMI (legacy) |
| File/directory operations | Cmdlets (New-Item) | .NET |
| Install Windows features | Cmdlets (Install-WindowsFeature) | - |
| Application settings | Cmdlets if available | Registry |
| Complex string operations | .NET | PowerShell string methods |
| Process management | Cmdlets (Get-Process) | CIM |
| Event log operations | Cmdlets (Get-EventLog) | .NET |

## Idempotency Considerations

### Always Idempotent
- **Cmdlets**: Usually idempotent by design
- **CIM**: Read operations always idempotent

### Requires Manual Handling
- **Registry**: Must check current value before setting
- **.NET**: Must implement state checking
- **WMI**: Must verify before making changes

### Idempotency Pattern
```powershell
# 1. Check current state
$currentState = Get-CurrentState

# 2. Compare with desired state
if ($currentState -ne $desiredState) {
    # 3. Make change only if needed
    Set-DesiredState
    $changed = $true
} else {
    $changed = $false
}
```

## Check Mode Implementation

All pillars must support check mode (`-WhatIf`):

```powershell
if ($state -ne $desiredState) {
    if (-not $check_mode) {
        # Actually make the change
        Set-DesiredState
    }
    # Report change in both check and real mode
    $module.Result.changed = $true
} else {
    $module.Result.changed = $false
}
```

## Error Handling Best Practices

### Specific Exception Types
```powershell
try {
    # Operation
} catch [System.UnauthorizedAccessException] {
    $module.FailJson("Permission denied: $($_.Exception.Message)", $_)
} catch [System.IO.FileNotFoundException] {
    $module.FailJson("File not found: $($_.Exception.Message)", $_)
} catch {
    $module.FailJson("Unexpected error: $($_.Exception.Message)", $_)
}
```

### Meaningful Error Messages
```powershell
# Bad
$module.FailJson("Error", $_)

# Good
$module.FailJson("Failed to start service '$name': $($_.Exception.Message). Verify the service exists and you have permissions.", $_)
```

## Performance Considerations

### Fast to Slow
1. **Cmdlets**: Optimized by Microsoft
2. **CIM**: Modern, efficient
3. **.NET**: Direct, but may require more code
4. **WMI**: Slower due to COM overhead
5. **Registry**: Fast but fragile

### Batch Operations
```powershell
# Slow - individual calls
foreach ($item in $items) {
    Get-Service -Name $item
}

# Fast - single call with pipeline
$items | ForEach-Object { Get-Service -Name $_ }

# Fastest - batch query
Get-Service -Name $items
```

## Testing Requirements

Every module using any pillar MUST pass:
1. **Initial Run**: Works on first execution
2. **Idempotency**: No changes on second run
3. **Check Mode**: Reports correctly without changes
4. **Error Handling**: Fails gracefully on invalid input

## Examples by Pillar

See the `examples/` directory:
- `module_example_cmdlet.ps1` - Pillar 1
- `module_example_cim.ps1` - Pillar 3
- `module_example_registry.ps1` - Pillar 5
