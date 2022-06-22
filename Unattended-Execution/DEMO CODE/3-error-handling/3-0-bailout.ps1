<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 3-0: Bailout function examples
#>

function BailOut-Simple {
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

function BailOut-CleanUp {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [switch]$Error
    )
    if ($script:dbconn.State -eq "Open") {
        $script:dbconn.Close()
    }
    $statePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "ScriptState.json"
    if (Test-Path -Path $statePath) {
        try {
            Remove-Item -Path $statePath -Force -EA Stop
        } catch {}
    }
    if ($Error) {
        $false
        exit 1
    } else {
        $true
        exit 0
    }
}

BailOut-Simple -Error