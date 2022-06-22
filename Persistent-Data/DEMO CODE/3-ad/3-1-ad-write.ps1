<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 3-1: Adding a list item to an object in AD
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [string]$ItemToAdd = "Five"
)
$searcher = New-Object System.DirectoryServices.DirectorySearcher
$searcher.Filter = "(distinguishedName=CN=Data001,OU=STORE,DC=lab,DC=metabpa,DC=org)"
$null = $searcher.PropertiesToLoad.Add('description')
$entry = $searcher.FindOne().GetDirectoryEntry()
if ($ItemToAdd -in $entry.description) {
    Write-Warning "$ItemToAdd already in the description attribute"
} else {
    $null = $entry.description.Add($ItemToAdd)
    $entry.CommitChanges()
}