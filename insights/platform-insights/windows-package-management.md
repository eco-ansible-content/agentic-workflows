# Insight: Windows Package Management Patterns

**Date**: 2026-06-02
**Category**: Platform
**Subcategory**: Windows-Package-Management
**Applies To**: Windows collections managing packages (winget, PackageManagement/OneGet, MSI, MSIX)
**Applied To Agents**: module-worker, enhancement-specialist
**Severity**: High
**Source Epic**: ACA-6275
**Source Collection**: ansible.windows (PR #905)

## The Problem

Windows has multiple package management subsystems that operate differently:
- **winget** (Windows Package Manager CLI) - modern, app-store-like
- **PackageManagement/OneGet** (PowerShell framework) - NuGet, PowerShellGet providers
- **MSI/MSIX** (traditional installers) - file-based
- **Registry-based** (exe installers) - file-based with registry detection

Each subsystem has different prerequisites, detection mechanisms, and installation patterns. A single module (win_package) already supported MSI/MSIX/Registry; adding PackageManagement as a new provider required careful isolation to avoid breaking the auto-detection loop.

## What We Learned

### 1. Winget Under SYSTEM Context (WinRM)

When Ansible runs modules via WinRM, the process executes as SYSTEM. The `winget.exe` binary is NOT in the SYSTEM PATH. The module must resolve the path manually:

```powershell
Function Find-WingetPath {
    # Try standard PATH first
    $cmd = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    
    # SYSTEM context: resolve from WindowsApps directory
    $paths = Get-ChildItem "$env:ProgramFiles\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe" `
        -ErrorAction SilentlyContinue
    if ($paths) { return $paths | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName }
    
    # Fallback: query package family
    $pkg = Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction SilentlyContinue
    if ($pkg) {
        $wingetPath = Join-Path $pkg.InstallLocation "winget.exe"
        if (Test-Path $wingetPath) { return $wingetPath }
    }
    
    return $null  # Not found
}
```

**Key takeaway**: Any CLI-based module running under WinRM/SYSTEM must handle path resolution for executables that are installed per-user or via AppX packages.

### 2. Provider Auto-Detection Must Exclude Non-Standard Providers

When win_package has `provider=auto` (default), it iterates all registered providers to detect what type of package is installed. A new provider (like `package_management`) that requires additional mandatory parameters will CRASH the auto-detection loop because those parameters are not set during detection.

**Solution**: Exclude providers that require explicit opt-in from the auto-detection list:

```powershell
$providerList = [String[]]$providerInfo.Keys | Where-Object {
    ($_ -ne 'msix' -or $msixAvailable) -and $_ -ne 'package_management'
}
```

**Pattern**: Any provider that needs extra mandatory parameters beyond the base module spec must be excluded from auto-detection.

### 3. PackageManagement (OneGet) Provider Patterns

The PowerShell PackageManagement framework supports multiple sub-providers:

| Sub-Provider | Purpose | Detection Method | Install Method |
|-------------|---------|-----------------|----------------|
| **NuGet** | .NET packages | `Get-Package -ProviderName NuGet` + filesystem check | `Install-Package -ProviderName NuGet -Destination` |
| **PowerShellGet** | PS modules | `Get-Package -ProviderName PowerShellGet` | `Install-Package -ProviderName PowerShellGet` |

**NuGet-specific**: Requires `destination_path` for filesystem-based installs. Detection needs both `Get-Package` AND filesystem check because `Get-Package` alone may not find packages installed to custom paths.

**PowerShellGet-specific**: Uses `package_source` (e.g., PSGallery) for repository-based installs. The PSGallery must be trusted before installs work non-interactively.

### 4. Documentation Format Detection

The ansible.windows collection uses TWO documentation formats:
- **Older modules**: `.py` file with `DOCUMENTATION`, `EXAMPLES`, `RETURN` as Python string constants
- **Newer modules**: `.yml` file with YAML-formatted documentation (e.g., `win_winget.yml`)

When enhancing a collection, detect which format is used for recent additions:
```bash
# Check for .yml doc files (newer pattern)
ls plugins/modules/*.yml 2>/dev/null

# If .yml files exist alongside .ps1 files, use .yml for new modules
# If only .py files exist, use .py for documentation
```

### 5. Test Structure for Package Management Modules

Package management tests need careful prerequisite setup:

```yaml
# Setup: Ensure package providers are registered
- name: ensure NuGet package provider is registered
  win_shell: |
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null

# Setup: Trust repositories for non-interactive installs
- name: ensure PSGallery is trusted
  win_shell: |
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
```

**Always use block/always pattern** for cleanup in package tests to avoid test pollution.

## Impact

**Before**:
- No guidance for Windows package management module patterns
- Auto-detection collision risk unknown
- WinRM/SYSTEM path resolution not documented

**After**:
- Clear patterns for winget and PackageManagement providers
- Auto-detection exclusion pattern documented and reusable
- SYSTEM context path resolution pattern available for any CLI module
- Two CI failures caught and fixed autonomously during build

## Applies To

This pattern applies to:
- **Any Windows CLI-based module** running under WinRM (SYSTEM context path resolution)
- **Any module with provider auto-detection** (exclusion pattern for new providers)
- **PackageManagement/OneGet modules** (NuGet, PowerShellGet, Chocolatey, etc.)
- **winget modules** (Windows Package Manager CLI)

---

*Generated by learning-evolution-specialist from ACA-6275 build on 2026-06-02*
