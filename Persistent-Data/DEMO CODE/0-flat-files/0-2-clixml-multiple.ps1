<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 0-2: Multiple instances writing state to one file
#>

$statePath = "\\SRV01.lab.metabpa.org\SHARE\state-00.clixml"
do {
    $allProcesses = Get-Process | ForEach-Object {
        [PSCustomObject]@{
            'ComputerName'=[System.Environment]::MachineName
            'ProcessID' = $_.Id
            'ProcessName' = $_.Name 
            'ProcessPath' = $_.Path
            'ProcessMemory' = $_.WorkingSet
            'ProcessCPU' = $_.TotalProcessorTime
            'ProcessHandles' = $_.HandleCount 
        }
    }
    if (Test-Path -Path $statePath) {
        $state = Import-Clixml -Path $statePath
    } else {
        $state = @{}
    }
    foreach ($proc in $allProcesses) {
        $key = "$([System.Environment]::MachineName)_$($proc.ProcessID)"
        if ($state.ContainsKey($key)) {
            $state[$key] = $proc
        } else {
            $state.Add($key, $proc)
        }
    }
    $state | Export-Clixml -Path $statePath
} until ($false)