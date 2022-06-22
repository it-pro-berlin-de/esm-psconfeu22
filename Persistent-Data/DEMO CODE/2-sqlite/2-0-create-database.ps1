<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-0: Create SQLite database
#>

Add-Type -Path (Join-Path -Path $PSScriptRoot -ChildPath 'System.Data.SQLite.dll')

$sqliteDB = 'C:\Data\share\stat-20.sqlite'
$sqlStatements = @(
    "CREATE TABLE CurrentState (processID bigint, computerName varchar(32), processName varchar(256), processPath varchar(256), processMemory bigint, processCPU bigint, processHandles bigint)"
)

$dbConn = New-Object System.Data.SQLite.SQLiteConnection
# https://www.connectionstrings.com/sqlite-net-provider/
$dbConn.ConnectionString = ('Data Source={0};Version=3;Synchronous=Full;' -f $sqliteDB)

$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()
foreach ($sqlStatement in $sqlStatements) {
    $dbcmd.CommandText = $sqlStatement
    $dbcmd.ExecuteNonQuery()
}
$dbConn.Close()