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
    $filePath = [System.IO.Path]::GetTempFileName()
    $ownProcess | Export-Clixml -Path $filePath -Encoding UTF8
    Start-Process notepad.exe -ArgumentList $filePath

#endregion
#region import
    
    $processSnapshot = Import-Clixml -Path $filePath
    $processSnapshot | fl *
    $processSnapshot | Get-Member

#endregion