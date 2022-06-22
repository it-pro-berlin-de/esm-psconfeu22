<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 1-0: Check prerequisites
#>
#region setting the stage
    $modulesToImport = @(
        'ActiveDirectory'
        'VMware.VimAutomation.Core' # this is important - do NOT import VMware.PowerCLI!
        'BullshitModule'
    )
    $needsToRunElevated = $true
    $runsOnWindows = $true
    $runsOnLinux = $false
    $runsOnMacOS = $false
    $allowedHosts = @('ConsoleHost')
    $initOK = $true
#endregion
#region check platform

    if ($null -ne $PSVersionTable.Platform) {
        if ($IsWindows) {
            # PowerShell on Windows 
            $initOK = $runsOnWindows
        } elseif ($IsLinux) {
            # PowerShell on Linux
            $initOK = $runsOnLinux
        } else {
            # PowerShell on Mac or BSD
            $initOK = $runsOnMacOS
        }
    } else {
        # Windows PowerShell or ISE or custom host
        $IsWindows = $true
        $initOK = $runsOnWindows
    }

#endregion
#region check host

    if ($allowedHosts.Count -gt 0) {
        $initOK = $initOK -and ($Host.Name -in $allowedHosts) 
    }

#endregion
#region check for elevation

    # windows only
    if ($initOK -and $IsWindows -and $needsToRunElevated) {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $initOK = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

#endregion
#region check modules

    try {
        $existingModules = Get-Module $modulesToImport -ListAvailable -EA Stop
    } catch {
        $existingModules = @()
    }
    if ($existingModules.Count -lt $modulesToImport.Count) {
        # modules are missing
        $initOK = $false
    } else {
        # try actually importing modules if all required ones are present
    }

#endregion