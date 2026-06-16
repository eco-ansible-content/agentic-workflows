# Platform Installation Guide for Windows Test Environments

Complete installation procedures for common Windows platforms required for Ansible module testing.

## Table of Contents

1. [SCVMM (System Center Virtual Machine Manager)](#scvmm)
2. [Hyper-V](#hyper-v)
3. [SQL Server](#sql-server)
4. [IIS (Internet Information Services)](#iis)
5. [Active Directory Domain Services](#active-directory)
6. [DNS Server](#dns-server)
7. [DHCP Server](#dhcp-server)
8. [Failover Clustering](#failover-clustering)
9. [WSUS (Windows Server Update Services)](#wsus)

---

## SCVMM (System Center Virtual Machine Manager)

### Prerequisites
- Windows Server 2019 or 2022
- SQL Server 2019 or later
- Hyper-V role installed
- ADK (Assessment and Deployment Kit)
- Minimum 16 GB RAM, 4 CPU cores
- 100 GB free disk space

### Installation Steps

#### 1. Install SQL Server
```powershell
# Download SQL Server 2019
$sqlUrl = "https://download.microsoft.com/download/..."
Invoke-WebRequest -Uri $sqlUrl -OutFile "C:\Installers\SQLServer2019.exe"

# Silent installation
C:\Installers\SQLServer2019.exe /Q /ACTION=Install `
    /FEATURES=SQLENGINE,FULLTEXT `
    /INSTANCENAME=MSSQLSERVER `
    /SQLSYSADMINACCOUNTS="BUILTIN\Administrators" `
    /SECURITYMODE=SQL `
    /SAPWD="YourStrongPassword123!" `
    /TCPEN ABLED=1 `
    /IACCEPTSQLSERVERLICENSETERMS
```

#### 2. Install Prerequisites
```powershell
# Install required Windows features
Install-WindowsFeature -Name Hyper-V `
    -IncludeManagementTools `
    -Restart

# After restart, install RSAT tools
Install-WindowsFeature -Name RSAT-Clustering `
    -IncludeAllSubFeature

# Download and install Windows ADK
$adkUrl = "https://download.microsoft.com/download/..."
Invoke-WebRequest -Uri $adkUrl -OutFile "C:\Installers\ADK.exe"
C:\Installers\ADK.exe /quiet /features OptionId.DeploymentTools
```

#### 3. Install SCVMM
```powershell
# Mount SCVMM ISO
$isoPath = "C:\Installers\SCVMM2022.iso"
$mountResult = Mount-DiskImage -ImagePath $isoPath -PassThru
$driveLetter = ($mountResult | Get-Volume).DriveLetter

# Create unattended installation file
$setupINI = @"
[OPTIONS]
CompanyName = Test Environment
ProductKey =
ProgramFiles = C:\Program Files\Microsoft System Center\Virtual Machine Manager
CreateNewSqlDatabase = 1
SqlInstanceName = localhost\MSSQLSERVER
SqlDatabaseName = VirtualManagerDB
RemoteDatabaseImpersonation = 0
SqlMachineName = localhost
IndigoTcpPort = 8100
IndigoHTTPSPort = 8101
IndigoNETTCPPort = 8102
IndigoHTTPPort = 8103
WSManTcpPort = 5985
BitsTcpPort = 443
CreateNewLibraryShare = 1
LibrarySharePath = C:\ProgramData\Virtual Machine Manager Library Files
LibraryShareName = MSSCVMMLibrary
SQMOptIn = 0
MUOptIn = 0
"@

$setupINI | Out-File -FilePath "C:\Installers\VMM_Setup.ini" -Encoding ASCII

# Run SCVMM setup
& "${driveLetter}:\setup.exe" /server /i /f "C:\Installers\VMM_Setup.ini"

# Wait for installation
Start-Sleep -Seconds 1800  # 30 minutes

# Verify installation
$service = Get-Service -Name "SCVMMService" -ErrorAction SilentlyContinue
if ($service.Status -eq "Running") {
    Write-Output "SCVMM installed successfully"
} else {
    throw "SCVMM installation failed"
}
```

#### 4. Post-Installation Configuration
```powershell
# Import SCVMM module
Import-Module VirtualMachineManager

# Connect to VMM server
$vmmServer = Get-SCVMMServer -ComputerName localhost

# Add local Hyper-V host
Add-SCVMHost -ComputerName $env:COMPUTERNAME `
    -VMMServer $vmmServer `
    -Credential (Get-Credential)

# Create default VM network
New-SCVMNetwork -Name "Test Network" `
    -LogicalNetwork "Test Logical Network"

# Verify library shares
Get-SCLibraryShare
```

### Verification
```powershell
# Test all critical components
$tests = @(
    { Get-SCVMMServer -ComputerName localhost },
    { Get-SCVMHost },
    { Get-SCLibraryShare },
    { Get-Service SCVMMService }
)

foreach ($test in $tests) {
    try {
        $result = & $test
        Write-Output "✓ Test passed: $($test.ToString())"
    } catch {
        Write-Error "✗ Test failed: $($test.ToString())"
    }
}
```

---

## Hyper-V

### Prerequisites
- Windows Server 2019 or 2022
- Virtualization enabled in BIOS/UEFI
- Minimum 8 GB RAM
- 50 GB free disk space

### Installation Steps

```powershell
# Install Hyper-V role
Install-WindowsFeature -Name Hyper-V `
    -IncludeManagementTools `
    -Restart

# After restart, configure Hyper-V
# Create virtual switch
New-VMSwitch -Name "External Switch" `
    -NetAdapterName (Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object -First 1).Name `
    -AllowManagementOS $true

# Set default VM paths
Set-VMHost -VirtualHardDiskPath "C:\HyperV\Virtual Hard Disks" `
    -VirtualMachinePath "C:\HyperV\Virtual Machines"

# Create directories
New-Item -Path "C:\HyperV\Virtual Hard Disks" -ItemType Directory -Force
New-Item -Path "C:\HyperV\Virtual Machines" -ItemType Directory -Force
```

### Verification
```powershell
# Verify Hyper-V is running
$hypervService = Get-Service -Name vmms
if ($hypervService.Status -ne "Running") {
    throw "Hyper-V service not running"
}

# Verify virtual switch
$vSwitch = Get-VMSwitch
if ($vSwitch.Count -eq 0) {
    throw "No virtual switches configured"
}

# Test VM creation (will delete immediately)
$testVM = New-VM -Name "TestVM" -MemoryStartupBytes 512MB -Generation 2
Remove-VM -Name "TestVM" -Force

Write-Output "Hyper-V verified successfully"
```

---

## SQL Server

### Prerequisites
- Windows Server 2019 or 2022
- .NET Framework 4.8 or later
- Minimum 4 GB RAM
- 20 GB free disk space

### Installation Steps

```powershell
# Install .NET Framework if needed
Install-WindowsFeature -Name NET-Framework-45-Features

# Download SQL Server
$sqlUrl = "https://download.microsoft.com/download/..."
Invoke-WebRequest -Uri $sqlUrl -OutFile "C:\Installers\SQLServer2019.exe"

# Create configuration file
$configINI = @"
[OPTIONS]
ACTION="Install"
QUIET="True"
FEATURES=SQLENGINE,FULLTEXT,CONN
INSTANCENAME="MSSQLSERVER"
INSTANCEDIR="C:\Program Files\Microsoft SQL Server"
SQLSVCACCOUNT="NT AUTHORITY\SYSTEM"
SQLSYSADMINACCOUNTS="BUILTIN\Administrators"
SECURITYMODE="SQL"
SAPWD="YourStrongPassword123!"
TCPENA BLED="1"
NPENABLED="1"
IACCEPTSQLSERVERLICENSETERMS="True"
"@

$configINI | Out-File -FilePath "C:\Installers\SQL_Config.ini" -Encoding ASCII

# Run installation
C:\Installers\SQLServer2019.exe /ConfigurationFile="C:\Installers\SQL_Config.ini"

# Wait for installation
Start-Sleep -Seconds 600  # 10 minutes

# Enable TCP/IP
Import-Module SQLPS -DisableNameChecking
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = New-Object ($smo + 'Wmi.ManagedComputer')
$tcp = $wmi.ServerInstances['MSSQLSERVER'].ServerProtocols['Tcp']
$tcp.IsEnabled = $true
$tcp.Alter()

# Restart SQL Server
Restart-Service -Name MSSQLSERVER -Force
```

### Verification
```powershell
# Test SQL connection
$connectionString = "Server=localhost;Database=master;Integrated Security=True;"
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    $connection.Close()
    Write-Output "✓ SQL Server connection successful"
} catch {
    throw "SQL Server connection failed: $_"
}

# Verify service
$service = Get-Service -Name MSSQLSERVER
if ($service.Status -ne "Running") {
    throw "SQL Server service not running"
}
```

---

## IIS (Internet Information Services)

### Installation Steps

```powershell
# Install IIS with common features
Install-WindowsFeature -Name Web-Server `
    -IncludeManagementTools `
    -IncludeAllSubFeature

# Install additional features
$features = @(
    "Web-Asp-Net45",
    "Web-Net-Ext45",
    "Web-ISAPI-Ext",
    "Web-ISAPI-Filter",
    "Web-Mgmt-Console",
    "Web-Scripting-Tools"
)

foreach ($feature in $features) {
    Install-WindowsFeature -Name $feature
}

# Start IIS
Start-Service -Name W3SVC

# Create default website if needed
Import-Module WebAdministration
if (-not (Get-Website -Name "Default Web Site")) {
    New-Website -Name "Default Web Site" `
        -Port 80 `
        -PhysicalPath "C:\inetpub\wwwroot"
}
```

### Verification
```powershell
# Test IIS is responding
$response = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
if ($response.StatusCode -ne 200) {
    throw "IIS not responding correctly"
}

# Verify service
$service = Get-Service -Name W3SVC
if ($service.Status -ne "Running") {
    throw "IIS service not running"
}

Write-Output "IIS verified successfully"
```

---

## Active Directory Domain Services

### Installation Steps

```powershell
# Install AD DS role
Install-WindowsFeature -Name AD-Domain-Services `
    -IncludeManagementTools

# Promote to Domain Controller
Import-Module ADDSDeployment

# Create new forest (test environment)
$domainName = "test.local"
$netbiosName = "TEST"
$safeModePassword = ConvertTo-SecureString "SafeMode123!" -AsPlainText -Force

Install-ADDSForest `
    -DomainName $domainName `
    -DomainNetbiosName $netbiosName `
    -SafeModeAdministratorPassword $safeModePassword `
    -InstallDns `
    -Force

# Server will restart automatically
```

### Verification
```powershell
# After restart, verify AD
Import-Module ActiveDirectory

# Test AD cmdlets
$domain = Get-ADDomain
if ($domain.Name -ne "test") {
    throw "AD domain not configured correctly"
}

# Verify NTDS service
$service = Get-Service -Name NTDS
if ($service.Status -ne "Running") {
    throw "AD DS service not running"
}

Write-Output "Active Directory verified successfully"
```

---

## Common Installation Patterns

### Silent Installation Template
```powershell
function Install-SilentMSI {
    param(
        [string]$MsiPath,
        [string]$LogPath = "C:\Installers\install.log",
        [hashtable]$Properties = @{}
    )
    
    $propertyString = ($Properties.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$($_.Value)"
    }) -join " "
    
    $arguments = "/i `"$MsiPath`" /qn /norestart /L*v `"$LogPath`" $propertyString"
    
    $process = Start-Process -FilePath "msiexec.exe" `
        -ArgumentList $arguments `
        -Wait `
        -PassThru `
        -NoNewWindow
    
    if ($process.ExitCode -ne 0) {
        throw "Installation failed with exit code $($process.ExitCode). See $LogPath"
    }
}
```

### Service Verification Template
```powershell
function Test-ServiceHealth {
    param(
        [string]$ServiceName,
        [int]$TimeoutSeconds = 60
    )
    
    $elapsed = 0
    while ($elapsed -lt $TimeoutSeconds) {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        
        if ($service -and $service.Status -eq "Running") {
            return $true
        }
        
        Start-Sleep -Seconds 5
        $elapsed += 5
    }
    
    return $false
}
```

### Download with Retry Template
```powershell
function Download-FileWithRetry {
    param(
        [string]$Url,
        [string]$Destination,
        [int]$MaxRetries = 3
    )
    
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing
            return $true
        } catch {
            if ($i -eq $MaxRetries) {
                throw "Failed to download after $MaxRetries attempts: $_"
            }
            Write-Warning "Download attempt $i failed, retrying..."
            Start-Sleep -Seconds (5 * $i)
        }
    }
}
```

---

## Installation Time Estimates

| Platform | Minimum Time | Typical Time | Maximum Time |
|----------|-------------|--------------|--------------|
| Hyper-V | 5 min | 10 min | 15 min |
| SQL Server | 10 min | 20 min | 30 min |
| IIS | 2 min | 5 min | 10 min |
| Active Directory | 15 min | 25 min | 40 min |
| SCVMM | 30 min | 60 min | 90 min |
| DNS Server | 2 min | 5 min | 10 min |
| DHCP Server | 2 min | 5 min | 10 min |
| Failover Clustering | 10 min | 20 min | 30 min |
| WSUS | 20 min | 40 min | 60 min |

**Note**: Times include download, installation, and basic configuration. Does not include complex post-installation setup.

---

## Troubleshooting

### Common Issues

#### Installation Fails with "Access Denied"
```powershell
# Ensure running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Must run as Administrator"
}
```

#### Service Won't Start
```powershell
# Check dependencies
$service = Get-Service -Name $serviceName
$dependencies = $service.DependentServices

foreach ($dep in $dependencies) {
    if ($dep.Status -ne "Running") {
        Start-Service -Name $dep.Name
    }
}

# Check event logs
Get-EventLog -LogName System -Source $serviceName -Newest 10
```

#### Installation Hangs
- Check available disk space
- Verify internet connectivity for downloads
- Check antivirus isn't blocking installer
- Review installation logs

---

Use this guide as a reference for the Platform Prerequisite Specialist agent.
