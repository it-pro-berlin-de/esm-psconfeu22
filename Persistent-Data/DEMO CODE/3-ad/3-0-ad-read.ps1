<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 3-0: Reading a list of values from an object in AD
#>
$searcher = New-Object System.DirectoryServices.DirectorySearcher
$searcher.Filter = "(distinguishedName=CN=Data001,OU=STORE,DC=lab,DC=metabpa,DC=org)"
$null = $searcher.PropertiesToLoad.Add('description')
$entry = $searcher.FindOne().GetDirectoryEntry()
$entry.description