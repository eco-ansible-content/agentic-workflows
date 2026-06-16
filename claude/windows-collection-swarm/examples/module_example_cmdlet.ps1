#!powershell

# Copyright: (c) 2024, Jarvis Framework
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

#AnsibleRequires -CSharpUtil Ansible.Basic

$spec = @{
    options = @{
        name = @{ type = "str"; required = $true }
        state = @{ type = "str"; default = "present"; choices = @("present", "absent") }
    }
    supports_check_mode = $true
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

$name = $module.Params.name
$state = $module.Params.state
$check_mode = $module.CheckMode

# EXAMPLE: Pillar 1 - PowerShell Cmdlets
# This example uses native PowerShell cmdlets (highest preference)

$module.Result.changed = $false

try {
    # Check current state using PowerShell cmdlet
    $currentService = Get-Service -Name $name -ErrorAction SilentlyContinue

    if ($state -eq "present") {
        if ($null -eq $currentService) {
            # Service doesn't exist, would create it
            if (-not $check_mode) {
                # In real implementation, create the service
                # New-Service -Name $name
                $module.Result.changed = $true
            } else {
                # Check mode: report what would change
                $module.Result.changed = $true
            }
        } else {
            # Service exists, no change needed
            $module.Result.changed = $false
        }
    } elseif ($state -eq "absent") {
        if ($null -ne $currentService) {
            # Service exists, would remove it
            if (-not $check_mode) {
                # In real implementation, remove the service
                # Remove-Service -Name $name
                $module.Result.changed = $true
            } else {
                # Check mode: report what would change
                $module.Result.changed = $true
            }
        }
    }

    $module.Result.service = @{
        name = $name
        exists = $null -ne $currentService
        state = if ($null -ne $currentService) { $currentService.Status.ToString() } else { "absent" }
    }

} catch {
    $module.FailJson("Failed to manage service: $($_.Exception.Message)", $_)
}

$module.ExitJson()
