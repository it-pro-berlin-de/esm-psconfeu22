<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 3-0: Bailout function examples
#>

$divisor = 1

function Return-Result {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [switch]$Error
    )
    if ($Error) {
        $false
        exit 1
    } else {
        $true
        exit 0
    }
}
$ErrorActionPreference = "Stop"
trap { Return-Result -Error }


Write-Host "Starting..."
try {
    $file = Get-Item -Path nowhere
} catch {
    Write-Warning $_.Exception.Message
}
Write-Host "Finished getting non-existent file..."
$a = 1 / $divisor
Write-Host "Finished dividing by $divisor ... got $a"
Return-Result