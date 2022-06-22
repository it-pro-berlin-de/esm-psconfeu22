<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 1-2: What is NULL?
#>

[DBNull]::Value -eq 0
[DBNull]::Value -eq $null
[DBNull]::Value -eq ""
[DBNull]::Value -eq @()



[DBNull]::Value | Get-Member
([DBNull]::Value).ToString() -eq ""
[string]::IsNullOrEmpty([DBNull]::Value)