<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-0: Importing modules
#>
#region setting the stage

    $modulesToImport = @(
        'ActiveDirectory'
        'VMware.VimAutomation.Core' # this is important - do NOT import VMware.PowerCLI!
        'BullshitModule'
    )
    $initOK = $true

#endregion
#region if you're logging every step

    foreach ($module in $modulesToImport) {
        try {
            Import-Module -Name $module -Force -EA Stop
        } catch {
            $initOK = $false
        }
    }

#endregion
#region oherwise

    try {
        Import-Module -Name $modulesToImport -Force -EA Stop
    } catch {
        $initOK = $false
    }

#endregion
$initOK