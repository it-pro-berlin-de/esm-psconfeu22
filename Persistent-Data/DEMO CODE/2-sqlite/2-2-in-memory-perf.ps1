<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 2-2: In-Memory SQLite Performance
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [int]$NumberOfRecords = 100
)
#region setup

    Add-Type -Path (Join-Path -Path $PSScriptRoot -ChildPath 'System.Data.SQLite.dll')
    # this is only for generating random strings
    # unfortunately, this assembly will not load in pwsh
    Add-Type -AssemblyName System.Web
    $sqliteDBmem = 'C:\Data\share\stat-22mem.sqlite'
    Get-Item -Path $sqliteDBmem -EA SilentlyContinue | Remove-Item -Force
    $sqliteDBorg = 'C:\Data\share\stat-22org.sqlite'
    Get-Item -Path $sqliteDBorg -EA SilentlyContinue | Remove-Item -Force
    $sqlStatements = @(
        "CREATE TABLE TestData (someString varchar(256))"
    )

#endregion
#region create data

    $data = New-Object System.Collections.Generic.List[string]
    (1..$NumberOfRecords) | ForEach-Object {
        $pwd = [System.Web.Security.Membership]::GeneratePassword(100,0)
        $data.Add($pwd)
    }

#endregion
#region gauge in memory performance

$start = [datetime]::Now
$dbConn = New-Object System.Data.SQLite.SQLiteConnection
# https://www.connectionstrings.com/sqlite-net-provider/
$dbConn.ConnectionString = 'Data Source=:memory:;Version=3;'
$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()
foreach ($sqlStatement in $sqlStatements) {
    $dbcmd.CommandText = $sqlStatement
    $null = $dbcmd.ExecuteNonQuery()
}
foreach ($d in $data) {
    $dbCmd.CommandText = "INSERT INTO TestData (someString) VALUES ('$d')"
    $null = $dbCmd.ExecuteNonQuery()
}
Write-Host "Populating in memory DB: $((New-TimeSpan -Start $start).TotalSeconds)"
$start = [datetime]::Now
$dbCmd.CommandText = "VACUUM INTO '$($sqliteDBmem)'"
$null = $dbcmd.ExecuteNonQuery()
$dbConn.Close()
[gc]::Collect()
Write-Host "Flushing to disk: $((New-TimeSpan -Start $start).TotalSeconds)"

#endregion
#region gauge on disk performance

$start = [datetime]::Now
$dbConn = New-Object System.Data.SQLite.SQLiteConnection
# https://www.connectionstrings.com/sqlite-net-provider/
$dbConn.ConnectionString = ('Data Source={0};Version=3;' -f $sqliteDBorg)
$dbConn.Open()
$dbCmd = $dbConn.CreateCommand()
foreach ($sqlStatement in $sqlStatements) {
    $dbcmd.CommandText = $sqlStatement
    $null = $dbcmd.ExecuteNonQuery()
}
foreach ($d in $data) {
    $dbCmd.CommandText = "INSERT INTO TestData (someString) VALUES ('$d')"
    $null = $dbCmd.ExecuteNonQuery()
}
$dbConn.Close()
[gc]::Collect()
Write-Host "Writing stuff directly to disk: $((New-TimeSpan -Start $start).TotalSeconds)"

#endregion