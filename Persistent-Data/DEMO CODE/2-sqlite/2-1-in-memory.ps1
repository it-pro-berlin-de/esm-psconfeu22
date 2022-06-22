<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-1: Create In-Memory SQLite database
#>

Add-Type -Path (Join-Path -Path $PSScriptRoot -ChildPath 'System.Data.SQLite.dll')
# this is only for generating random strings
# unfortunately, this assembly will not load in pwsh
Add-Type -AssemblyName System.Web
$sqliteDB = 'C:\Data\share\stat-21.sqlite'
$sqlStatements = @(
    "CREATE TABLE TestData (someString varchar(256))"
)

$dbConn = New-Object System.Data.SQLite.SQLiteConnection
# https://www.connectionstrings.com/sqlite-net-provider/
$dbConn.ConnectionString = 'Data Source=:memory:;Version=3;'

$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()
foreach ($sqlStatement in $sqlStatements) {
    $dbcmd.CommandText = $sqlStatement
    $dbcmd.ExecuteNonQuery()
}
(1..1000) | ForEach-Object {
    $dbCmd.CommandText = "INSERT INTO TestData (someString) VALUES ('$([System.Web.Security.Membership]::GeneratePassword(100,0))')"
    $dbCmd.ExecuteNonQuery()
}
$dbCmd.CommandText = "SELECT COUNT(*) FROM TestData"
$dbCmd.ExecuteScalar()
$dbCmd.CommandText = "VACUUM INTO '$($sqliteDB)'"
$dbcmd.ExecuteNonQuery()
$dbConn.Close()


$dbConn.Open()
    $dbCmd = $dbConn.CreateCommand()
    $dbCmd.CommandText = "SELECT COUNT(*) FROM TestData"
    $dbCmd.ExecuteScalar()
$dbConn.Close()