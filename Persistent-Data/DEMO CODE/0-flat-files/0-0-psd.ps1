<#
    Basic Toolmaking:
    Storing persistent data

    PSConfEU VIENNA 2022

    by Evgenij Smirnov
    @cj_berlin

    DEMO 0-0: PSD1 Import
#>

#region locale-dependent import

    Import-LocalizedData -BindingVariable InputData
    $InputData['Parameter01']

#endregion
#region fixed locale import

    Import-LocalizedData -BindingVariable InputData -UICulture 'de-DE'
    $InputData['Parameter01']

#endregion
#region fixed path import

    Import-LocalizedData -BindingVariable InputData -FileName "somedata.psd1"
    $InputData['Parameter01']

#endregion