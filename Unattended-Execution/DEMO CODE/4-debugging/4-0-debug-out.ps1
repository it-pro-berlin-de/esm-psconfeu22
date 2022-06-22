<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 4-0: Debug Output
#>
[CmdletBinding()]
Param()
if (Test-Path "$PSScriptRoot\debug.txt") {
    $VerbosePreference = 'Continue'
    function Write-Verbose {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$true)][string]$Message
            
        )
        ('{0}: {1}' -f (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'), $Message) | 
            Add-Content -Path (Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ScriptExecution.log' )
    }
} elseif ($null -ne $psISE) {
    $VerbosePreference = 'Continue'
} else {
    $VerbosePreference = 'SilentlyContinue'
    Get-Item Function:\Write-Verbose -EA SilentlyContinue | Remove-Item
} 
Write-Verbose "Doing some stuff..."
Write-Verbose "Now doing some other stuff..."
Write-Verbose "This stuff went awry but we can continue..."
