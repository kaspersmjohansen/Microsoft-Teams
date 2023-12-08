# Path to Backgrounds Teams 2.1 Client
# %localappdata%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads
# Required Image Size: 1920x1080 keep aspect ratio
# Preview: 220x158 keep aspect ratio
# Requires ResizeImage PowerShell Module: https://github.com/RonildoSouza/ResizeImageModulePS
#
# Place the script in the same directory as the desired background images
#
#### 

function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}

$outputPath = "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads"
if (!(Get-InstalledModule -Name ResizeImageModule -ErrorAction SilentlyContinue )) {
    Write-Host "ResizeImageModule not installed, installing..." -ForegroundColor Yellow
    Install-Module -Name  ResizeImageModule -Scope CurrentUser
    Write-Host "Import Module ResizeImageModule"
    Import-Module  ResizeImageModule
}
else {
    if (!(Get-Module -Name ResizeImageModule)) {
        Write-Host "Import ResizeImageModule"
        Import-Module ResizeImageModule 
    }
    else {
        Write-Host "ResizeImageModule already imported"
    }
}

$images = Get-ChildItem *.jpg
foreach($image in $images){
    $guid = New-Guid
    Write-Host "Creating Background"
    Resize-Image -InputFile $image -Width 1920 -Height 1080 -ProportionalResize $true -OutputFile $outputPath\$guid.jpg
    Write-Host "Creating Background Thumbnail"
    $ThumbName = "$guid`_thumb.jpg"
    Resize-Image -InputFile $image -Width 220 -Height 158 -ProportionalResize $true -OutputFile $outputPath\$ThumbName
}