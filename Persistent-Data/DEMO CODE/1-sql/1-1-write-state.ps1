<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 1-1: Write state to database
#>
$sqlServer = 'SRV01'
$dbConn = New-Object System.Data.SqlClient.sqlConnection
$dbConn.ConnectionString = ('Server={0};Database=ScriptState;Trusted_Connection=True;' -f $sqlServer)
$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()

do {
    $allProcesses = Get-Process | ForEach-Object {
        [PSCustomObject]@{
            'ComputerName'=[System.Environment]::MachineName
            'ProcessID' = $_.Id
            'ProcessName' = $_.Name 
            'ProcessPath' = $_.Path
            'ProcessMemory' = $_.WorkingSet
            'ProcessCPU' = if ($null -eq $_.TotalProcessorTime) { -1 } else {$_.TotalProcessorTime.TotalSeconds}
            'ProcessHandles' = if ($null -eq $_.HandleCount) { -1 } else {$_.HandleCount}
        }
    }
    foreach ($proc in $allProcesses) {
        $q = "IF EXISTS (SELECT * FROM CurrentState WHERE ComputerName='$([System.Environment]::MachineName)' AND ProcessID=$($proc.ProcessID)) UPDATE CurrentState SET processMemory=$($proc.ProcessMemory), processCPU=$($proc.ProcessCPU), processHandles=$($proc.ProcessHandles) WHERE ComputerName='$([System.Environment]::MachineName)' AND ProcessID=$($proc.ProcessID) ELSE INSERT INTO CurrentState (ComputerName, ProcessId, ProcessName) VALUES ('$([System.Environment]::MachineName)',$($proc.ProcessId),'$($proc.ProcessName)')"
        $dbCmd.CommandText = $q
        $null = $dbCmd.ExecuteNonQuery()
    }
} until ($false)

$dbConn.Close()