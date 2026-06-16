#!powershell

# Copyright: (c) 2024, Jarvis Framework
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

#AnsibleRequires -CSharpUtil Ansible.Basic

$spec = @{
    options = @{
        computer_name = @{ type = "str"; default = "localhost" }
        property = @{ type = "str"; required = $true }
    }
    supports_check_mode = $true
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

$computer_name = $module.Params.computer_name
$property = $module.Params.property

# EXAMPLE: Pillar 3 - CIM (Common Information Model)
# Modern replacement for WMI, preferred for Windows Server 2012+

$module.Result.changed = $false

try {
    # Query system information using CIM
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computer_name

    # Extract requested property
    if ($osInfo.PSObject.Properties.Name -contains $property) {
        $value = $osInfo.$property
        $module.Result.value = $value
        $module.Result.found = $true
    } else {
        $module.Result.found = $false
        $module.Result.available_properties = $osInfo.PSObject.Properties.Name
    }

    $module.Result.system_info = @{
        caption = $osInfo.Caption
        version = $osInfo.Version
        build_number = $osInfo.BuildNumber
        architecture = $osInfo.OSArchitecture
    }

} catch {
    $module.FailJson("Failed to query CIM: $($_.Exception.Message)", $_)
}

$module.ExitJson()
