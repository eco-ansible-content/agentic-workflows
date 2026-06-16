#!powershell

# Copyright: (c) 2024, Jarvis Framework
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

#AnsibleRequires -CSharpUtil Ansible.Basic

$spec = @{
    options = @{
        path = @{ type = "str"; required = $true }
        name = @{ type = "str"; required = $true }
        value = @{ type = "str" }
        state = @{ type = "str"; default = "present"; choices = @("present", "absent") }
    }
    supports_check_mode = $true
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

$path = $module.Params.path
$name = $module.Params.name
$value = $module.Params.value
$state = $module.Params.state
$check_mode = $module.CheckMode

# EXAMPLE: Pillar 5 - Registry Manipulation
# Use for configuration, ensure idempotency

$module.Result.changed = $false

try {
    # Check if registry path exists
    $pathExists = Test-Path -Path $path

    if ($state -eq "present") {
        # Ensure registry key exists
        if (-not $pathExists) {
            if (-not $check_mode) {
                New-Item -Path $path -Force | Out-Null
            }
            $module.Result.changed = $true
        }

        # Get current value
        $currentValue = $null
        if ($pathExists) {
            $currentValue = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $name -ErrorAction SilentlyContinue
        }

        # Set value if different
        if ($currentValue -ne $value) {
            if (-not $check_mode) {
                Set-ItemProperty -Path $path -Name $name -Value $value -Force
            }
            $module.Result.changed = $true
        }

        $module.Result.registry = @{
            path = $path
            name = $name
            value = $value
            previous_value = $currentValue
        }

    } elseif ($state -eq "absent") {
        if ($pathExists) {
            $valueExists = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
            if ($null -ne $valueExists) {
                if (-not $check_mode) {
                    Remove-ItemProperty -Path $path -Name $name -Force
                }
                $module.Result.changed = $true
            }
        }
    }

} catch {
    $module.FailJson("Failed to manage registry: $($_.Exception.Message)", $_)
}

$module.ExitJson()
