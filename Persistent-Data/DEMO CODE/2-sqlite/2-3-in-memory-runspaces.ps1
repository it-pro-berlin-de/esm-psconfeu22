<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-3: Transcending runspaces using In-Memory SQLite
#>
#region set up
Add-Type -Path (Join-Path -Path $PSScriptRoot -ChildPath 'System.Data.SQLite.dll')
$sqlStatements = @(
    "CREATE TABLE TestData (someString varchar(256))"
    "INSERT INTO TestData (someString) VALUES ('INSERTED IN OUTER SCRIPT')"
    "CREATE TABLE Runspaces (runspaceID varchar(256))"
)
$dbConn = New-Object System.Data.SQLite.SQLiteConnection
# https://www.connectionstrings.com/sqlite-net-provider/
$dbConn.ConnectionString = 'FullURI=file::memory:?cache=shared;'
$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()
foreach ($sqlStatement in $sqlStatements) {
    $dbcmd.CommandText = $sqlStatement
    $null = $dbcmd.ExecuteNonQuery()
}
#endregion
#region define script block to run in different runspaces
$sb = {
    Param($rid, $path)
    try {
        Add-Type -Path (Join-Path -Path $path -ChildPath "System.Data.SQLite.dll")
        $dbConn = New-Object System.Data.SQLite.SQLiteConnection
        # https://www.connectionstrings.com/sqlite-net-provider/
        $dbConn.ConnectionString = 'FullURI=file::memory:?cache=shared;'
        $dbConn.Open()
        $dbCmd = $dbConn.CreateCommand()
        $dbcmd.CommandText = "SELECT someString FROM TestData"
        $res = $dbcmd.ExecuteScalar()
        "READ IN RUNSPACE $($rid) - $($res)"
        $dbcmd.CommandText = "INSERT INTO Runspaces (runspaceID) VALUES ('INSERTED IN RUNSPACE $rid')"
        $null = $dbCmd.ExecuteNonQuery()
        $dbconn.Close()
        [gc]::Collect()
    } catch {$_.Exception.Message}
}
#endregion
#region create and run runspace pool
$SessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$RunspacePool = [runspacefactory]::CreateRunspacePool(1,5)
$null = $RunspacePool.Open()
$jobs = New-Object System.Collections.ArrayList
(1..10) | ForEach-Object {
    $PowerShell = [powershell]::Create()
    $PowerShell.RunspacePool = $RunspacePool
    $null = $PowerShell.AddScript($sb)
    $null = $PowerShell.AddArgument($_)
    $null = $PowerShell.AddArgument($PSScriptRoot)
    $Handle = $PowerShell.BeginInvoke()

    $temp = [PSCustomObject]@{
        'PowerShell' = $PowerShell
        'Handle' = $Handle
    }
    $null = $jobs.Add($temp)
}
#endregion
#region wait for runspaces to finish
while ($jobs.Where({ $_.Handle.iscompleted -ne 'Completed' }).Count -gt 0) {
    Start-Sleep -Milliseconds 500
}


#endregion
#region get results from runspaces
$return = $jobs | ForEach {
    $_.powershell.EndInvoke($_.handle)
    $_.PowerShell.Dispose()
}
$jobs.clear()
$return
#endregion
#region read the other table and bail out
$dbCmd.CommandText = "SELECT * FROM Runspaces"
$dbrdr = $dbCmd.ExecuteReader()
while ($dbrdr.Read()) {
    Write-Host "READ IN OUTER SCRIPT - $($dbrdr[0])"
}
$dbrdr.Close()
$dbrdr.Dispose()
$dbConn.Close()
[gc]::Collect()
#endregion