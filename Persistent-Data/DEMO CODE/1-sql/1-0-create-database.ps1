<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 1-0: Create database
#>
$sqlServer = 'SRV01'
$sqlStatements = @(
    "CREATE DATABASE ScriptState"
    "USE [ScriptState]"
    "CREATE TABLE CurrentState (processID bigint, computerName varchar(32), processName varchar(256), processPath varchar(max), processMemory bigint, processCPU bigint, processHandles bigint)"
)

$dbConn = New-Object System.Data.SqlClient.sqlConnection
# https://www.connectionstrings.com/microsoft-data-sqlclient/
$dbConn.ConnectionString = ('Server={0};Trusted_Connection=True;' -f $sqlServer)
$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()
foreach ($sqlStatement in $sqlStatements) {
    $dbcmd.CommandText = $sqlStatement
    $dbcmd.ExecuteNonQuery()
}
$dbConn.Close()