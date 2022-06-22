<#
    Basic Toolmaking:
    Robust scripting for unattended execution

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 5-0: Breadcrumb

    Since we do not know what execution context we will be running in,
    we need a place where eveybody can write to.

    On Linux, /tmp/ is usually writable by everyone so can just leave a textfile there
    On Windows, our best bet is the Event Log.

#>
#region breadcrumb
    $bcMessage = ('{3}: Script {0} started by {1} on computer {2}' -f ($MyInvocation.MyCommand.Name), [System.Environment]::UserName, [System.Environment]::MachineName, (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'))
    if ($IsLinux -or $IsMacOS) {
        # here /tmp/ is writable by everyone
        $Path = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ScriptExecution.log'
        try {
            $bcMessage | Add-Content -Path -Force -EA Stop
        } catch {
            # if this happens, there won't be a breadcrumb
        }
    } else {
        try {
            $res = Write-EventLog -LogName Application -Source "Application" -EntryType Information -Message $bcMessage -EventId 1000 -Category 0 -EA Stop
        } catch {
            # same
        }
    }
#endregion