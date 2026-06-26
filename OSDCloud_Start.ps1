# ============================================================
# OSDCloud_Start.ps1 — draait in WinPE
# ============================================================

# Windows installatie
Write-Host "Windows 11 installatie starten..." -ForegroundColor Cyan
$Params = @{
    OSVersion  = "Windows 11"
    OSEdition  = "Pro"
    OSLanguage = "nl-nl"
    ZTI        = $true
}
Start-OSDCloud @Params

# Scripts klaarzetten voor na de installatie
Write-Host "Post-install scripts klaarzetten..." -ForegroundColor Cyan
$Dest = "C:\Windows\Setup\Scripts"
New-Item -ItemType Directory -Path $Dest -Force | Out-Null

$BaseUrl = "https://raw.githubusercontent.com/ITEnergyVision/EnergyVision-OSDCloud/main"
Invoke-WebRequest "$BaseUrl/Autopilot.ps1" -OutFile "$Dest\Autopilot.ps1" -UseBasicParsing

Set-Content "$Dest\SetupComplete.cmd" 'PowerShell -NoProfile -ExecutionPolicy Bypass -NoExit -File "C:\Windows\Setup\Scripts\Autopilot.ps1"' -Encoding ASCII

Write-Host "Klaar. Laptop reboot nu automatisch." -ForegroundColor Green
