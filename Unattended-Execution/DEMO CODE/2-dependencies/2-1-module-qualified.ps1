<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-1: Using module qualified cmdlet names
#>
#region let's address the right command

    Get-Command Export-VM
    Get-Command New-VM
    Get-Command Hyper-V\Export-VM
    Get-Command VMware.VimAutomation.Core\New-VM

#endregion

#region but what happens here?

    Get-Command VMware.VimAutomation.Core\Export-VM

#endregion