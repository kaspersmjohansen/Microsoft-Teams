
param(
     # can be either $true or $false
     [boolean]$DisableGPU,
     [boolean]$OpenAsHidden,
     [boolean]$OpenAtLogin,
     [boolean]$RegisterAsIMProvider,
     [boolean]$RunningOnClose

      )
function Configure-TeamsSettings
    {
        # Get the contents of AppData\Microsoft\Teams\desktop-config.json
        $ConfigFolder = "$env:APPDATA\Microsoft\Teams"
        $ConfigFile = "desktop-config.json"
        $DesktopConfig = Get-Content "$ConfigFolder\$ConfigFile" -raw | ConvertFrom-Json

            # Configure disable GPU hardware acceleration ($DisableGPU)
            If ($DisableGPU)
            { 
                $DesktopConfig.appPreferenceSettings.disablegpu=$DisableGPU
            }

            # Configure open application in background ($OpenAsHidden)
            # Configure auto-start application ($OpenAtLogin)
            # Configure register Teams as the chat app for Office ($RegisterAsIMProvider)
            # Configure on close, keep the application running ($RunningOnClose)

# Write changes to the config file
$DesktopConfig | ConvertTo-Json | Set-Content "$TeamsConfigFolder\$TeamsConfigFile"

    }