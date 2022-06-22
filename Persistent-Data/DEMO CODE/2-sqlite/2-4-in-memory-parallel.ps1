<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-4: Transcending runspaces using In-Memory SQLite and Foreach-Object -Parallel
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
    try {
        Add-Type -Path "C:\DATA\DEMO-DS\2-sqlite\System.Data.SQLite.dll"
        $dbConn = New-Object System.Data.SQLite.SQLiteConnection
        # https://www.connectionstrings.com/sqlite-net-provider/
        $dbConn.ConnectionString = 'FullURI=file::memory:?cache=shared;'
        $dbConn.Open()
        $dbCmd = $dbConn.CreateCommand()
        $dbcmd.CommandText = "SELECT someString FROM TestData"
        $res = $dbcmd.ExecuteScalar()
        "READ IN RUNSPACE $_ - $($res)"
        $dbcmd.CommandText = "INSERT INTO Runspaces (runspaceID) VALUES ('INSERTED IN RUNSPACE $_')"
        $null = $dbCmd.ExecuteNonQuery()
        $dbconn.Close()
        [gc]::Collect()
    } catch {$_.Exception.Message}
}
#endregion
#region create and run runspace pool
(1..10) | ForEach-Object -Parallel $sb 
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