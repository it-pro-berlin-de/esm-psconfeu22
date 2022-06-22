<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 0-1: CLIXML
#>

#region export
    
    $ownProcess = Get-Process -Id $PID
    $clixmlPath = [System.IO.Path]::GetTempFileName()
    $jsonPath = [System.IO.Path]::GetTempFileName()
    $ownProcess | Export-Clixml -Path $clixmlPath -Encoding UTF8
    Start-Process notepad.exe -ArgumentList $clixmlPath
    $ownProcess | ConvertTo-Json | Set-Content -Path $jsonPath -Encoding UTF8
    Start-Process notepad.exe -ArgumentList $jsonPath

#endregion
#region import
    
    $processSnapshotCLIXML = Import-Clixml -Path $clixmlPath
    $processSnapshotCLIXML | fl *
    $processSnapshotCLIXML | Get-Member

    $processSnapshotJSON = Get-Content -Path $jsonPath | ConvertFrom-Json
    $processSnapshotJSON | fl *
    $processSnapshotJSON | Get-Member 

#endregion