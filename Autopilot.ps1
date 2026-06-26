# ============================================================
# Autopilot.ps1 — draait na eerste boot via SetupComplete.cmd
# ============================================================

# Omgevingsvariabelen instellen (verplicht in SetupComplete context)
$env:APPDATA      = "C:\Windows\System32\Config\SystemProfile\AppData\Roaming"
$env:LOCALAPPDATA = "C:\Windows\System32\Config\SystemProfile\AppData\Local"
$env:PSModulePath = $env:PSModulePath + ";C:\Program Files\WindowsPowerShell\Scripts"
$env:Path         = $env:Path + ";C:\Program Files\WindowsPowerShell\Scripts"

# Logging
Start-Transcript -Path "C:\Windows\Temp\Autopilot.log" -ErrorAction Ignore | Out-Null

Write-Host "Autopilot script gestart..." -ForegroundColor Cyan

# Credentials laden van USB
$ConfigPath = (Get-PSDrive -PSProvider FileSystem | 
    Where-Object { Test-Path "$($_.Root)OSDCloud\Config\config.json" } | 
    Select-Object -First 1).Root + "OSDCloud\Config\config.json"

$Config    = Get-Content $ConfigPath | ConvertFrom-Json
$TenantId  = $Config.TenantId
$AppId     = $Config.AppId
$AppSecret = $Config.AppSecret
$GroupTag  = $Config.GroupTag

Write-Host "Config geladen. GroupTag: $GroupTag" -ForegroundColor Cyan

# Modules installeren
Write-Host "Modules installeren..." -ForegroundColor Cyan
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers | Out-Null
Install-Script -Name Get-WindowsAutoPilotInfo -Force -Scope AllUsers | Out-Null

# Hardware hash uploaden + wachten op Assigned + reboot
Write-Host "Hardware hash uploaden en wachten op Assigned..." -ForegroundColor Cyan
Get-WindowsAutoPilotInfo `
    -Online `
    -TenantId  $TenantId `
    -AppId     $AppId `
    -AppSecret $AppSecret `
    -GroupTag  $GroupTag `
    -Assign `
    -Reboot

Stop-Transcript
