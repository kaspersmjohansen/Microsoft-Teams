#Requires -Version 3.0
<#
*********************************************************************************************************************
Name:               Configure-TeamsSettings
Author:             Kasper Johansen
Website:            https://virtualwarlock.net
Last modified Date: 17-11-2020

.SYNOPSIS
    This script can change certain settings in Teams and serves as a simply way of doing central management

.DESCRIPTION
    With this script you are able to either enable or disable the following settings:
    
    Open application in background
    On close, keep the application running
    Disable GPO hardware acceleration
    Register Teams as the chat app for Office

    Microsoft does not provide any central management of Teams, at least not via the traditional ways of group policy.
    However they may be certain scenarioes where central management is needed ie. to disable GPU hardware acceleration
    when running Teams in a remote session with no GPU present.

.PARAMETER DisableGPU
Disable GPU hardware acceleration in Teams

.PARAMETER OpenAsHidden
Opens Teams in the background

.PARAMETER OpenAtLogin
Auto-starts Teams at logon. The feature is only available in the Teams per-user install!

.PARAMETER RegisterAsIMProvider
Registers Teams as the default chat app in Office. Which means that if you hover a user/mail address in Outlook and click the messaging button, Teams will start instead of Skype 4B.

.PARAMETER RunningOnClose
Keeps Teams running on the background when closing the app.


#>
param(
     # must be either $true or $false
     [boolean]$DisableGPU=$True,
     [boolean]$OpenAsHidden=$True,
     [boolean]$OpenAtLogin=$False,
     [boolean]$RegisterAsIMProvider=$True,
     [boolean]$RunningOnClose=$True
      )

function Configure-TeamsSettings
    {
        # Get the contents of AppData\Microsoft\Teams\desktop-config.json
        $ConfigFolder = "$env:APPDATA\Microsoft\Teams"
        $ConfigFile = "desktop-config.json"
        $TeamsDesktopConfig = Get-Content -Path "$ConfigFolder\$ConfigFile"
        $DesktopConfig = ConvertFrom-Json -InputObject $TeamsDesktopConfig

        $DesktopConfig.appPreferenceSettings.disableGPU=$DisableGPU
        $DesktopConfig.appPreferenceSettings.openAsHidden=$OpenAsHidden
        $DesktopConfig.appPreferenceSettings.openAtLogin=$OpenAtLogin
        $DesktopConfig.appPreferenceSettings.runningOnClose=$RunningOnClose
        $DesktopConfig.appPreferenceSettings.registerAsIMProvider=$RegisterAsIMProvider

        <#
            # Configure disable GPU hardware acceleration ($DisableGPU)
            If ($DisableGPU)
            { 
                $DesktopConfig.appPreferenceSettings.disablegpu=$DisableGPU
            }

            # Configure open application in background ($OpenAsHidden)
            If ($OpenAsHidden)
            { 
                $DesktopConfig.appPreferenceSettings.openAsHidden=$OpenAsHidden
            }

            # Configure auto-start application ($OpenAtLogin)
            If ($OpenAtLogin)
            { 
                $DesktopConfig.appPreferenceSettings.openAtLogin=$OpenAtLogin
            }

            # Configure register Teams as the chat app for Office ($RegisterAsIMProvider)
            If ($RegisterAsIMProvider)
            { 
                $DesktopConfig.appPreferenceSettings.registerAsIMProvider=$RegisterAsIMProvider
            }

            # Configure on close, keep the application running ($RunningOnClose)
            If ($RunningOnClose)
            { 
                $DesktopConfig.appPreferenceSettings.runningOnClose=$RunningOnClose
            }
        #>

# Make sure Teams is not running
Get-Process Teams -ErrorAction SilentlyContinue | Stop-Process -Force

# Convert Object back to JSON format
$NewDesktopConfig = $DesktopConfig | ConvertTo-Json

# Write changes to the config file
$NewDesktopConfig | Set-Content "$ConfigFolder\$ConfigFile"

    }

Configure-TeamsSettings $DisableGPU $OpenAsHidden $OpenAtLogin $RegisterAsIMProvider $RunningOnClose