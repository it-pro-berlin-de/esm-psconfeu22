<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 0-0: Script structure example
#>
[CmdletBinding()]
Param(
    [Parameter()]
    [object]$InputObject
)
#region function definitions
    # this is for this demo only, we will refine it going forward
    function Get-Result {
        [CmdletBinding()]
        Param(
            [Parameter()][bool]$InitOK,
            [Parameter()][bool]$InputOK,
            [Parameter()][bool]$ProcessOK,
            [Parameter()][object]$ProcessOutput
        )
        <#
            create $outputObject and set $exitCode
            depending on the parameter values
        #>
        [PSCustomObject]@{
            'OutputObject' = $outputObject
            'ExitCode' = $exitCode
        }
    }
#endregion
#region init
    $initOK = $true
    $inputOK = $false
    $processOK = $false
    # check prerequisites
    # check permissions
    # load required modules and assemblies
    # set $initOK = $false if something goes wrong
#endregion
#region check input
    if ($initOK) {
        # check input for existence and validity
        if ($InputExistsAndValid) {
            $inputOK = $true
        } else {
            $inputOK = $false
        }
    } else {
        $inputOK = $false
    }
#endregion
#region process input (PUT-PUT)
    if ($inputOK) {
        $processOK = $true
        # do what you came here to do
        # set $processOK = $false if something goes wrong
    }
#endregion
#region cleanup
    if ($inputOK -and (-not $processOK)) {
        # roll back changes made in PUT-PUT block
    }
#endregion
#region exit
    $result = Get-Result -InitOK $initOK -InputoK $inputOK -ProcessOK $processOK -ProcessOutput $processOutput
    $result.OutputObject
    exit $result.ExitCode
#endregion