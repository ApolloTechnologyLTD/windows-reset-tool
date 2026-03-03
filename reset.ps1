<#
.SYNOPSIS
    Apollo Technology Factory Reset Initiator v1.1
.DESCRIPTION
    A stylized PowerShell wrapper to initiate the Windows Factory Reset process.
    - MATCHED: Style, auto-elevation, and headers from the hardware diagnostic tool.
    - SAFETY: Uses the native Windows System Reset tool to ensure safe data handling.
    - COMPLIANCE: Includes a strict customer authorization disclaimer.
#>

# --- 1. AUTO-ELEVATE TO ADMINISTRATOR ---
$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "Requesting Administrator privileges for system reset..." -ForegroundColor Yellow
    try { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; Exit }
    catch { Write-Error "Failed to elevate. Please run as Administrator manually."; Pause; Exit }
}

# --- 2. HELPER FUNCTIONS ---
function Show-Header {
    Clear-Host
    $Banner = @'
    ___    ____  ____  __    __    ____     ____________________  ___   ______  __    ____  ________  __
   /   |  / __ \/ __ \/ /   / /   / __ \   /_  __/ ____/ ____/ / / / | / / __ \/ /   / __ \/ ____/\ \/ /
  / /| | / /_/ / / / / /   / /   / / / /    / / / __/ / /   / /_/ /  |/ / / / / /   / / / / / __   \  / 
 / ___ |/ ____/ /_/ / /___/ /___/ /_/ /    / / / /___/ /___/ __  / /|  / /_/ / /___/ /_/ / /_/ /   / /  
/_/  |_/_/    \____/_____/_____/\____/    /_/ /_____/\____/_/ /_/_/ |_/\____/_____/\____/\____/   /_/   
'@
    Write-Host $Banner -ForegroundColor Cyan
    Write-Host "`n    FACTORY RESET INITIATOR v1.1" -ForegroundColor White
    Write-Host "=================================================================================" -ForegroundColor DarkGray
    Write-Host "        [CRITICAL] Running in Elevated Permissions" -ForegroundColor Red 
}

# --- 3. MAIN MENU & COMPLIANCE DISCLAIMER ---
Show-Header

Write-Host "`n=================================================================================" -ForegroundColor Red
Write-Host "                             [ CRITICAL WARNING ]" -ForegroundColor Red
Write-Host "=================================================================================" -ForegroundColor Red

Write-Host "`nDATA DESTRUCTION NOTICE:" -ForegroundColor Yellow
Write-Host "You are about to initiate a Windows Factory Reset. Depending on the options" -ForegroundColor White
Write-Host "selected in the following prompts, this process will result in the IRREVERSIBLE" -ForegroundColor White
Write-Host "LOSS of all files, applications, user profiles, and logical partition data." -ForegroundColor White

Write-Host "`nCUSTOMER AUTHORIZATION REQUIRED:" -ForegroundColor Yellow
Write-Host "Do you have explicit, documented permission from the customer to wipe this device?" -ForegroundColor White
Write-Host "Unauthorized data destruction can result in severe liability, data recovery costs," -ForegroundColor White
Write-Host "and immediate disciplinary action. By proceeding, you certify that the customer" -ForegroundColor White
Write-Host "has backed up their data and authorized a full system wipe." -ForegroundColor White

Write-Host "`n---------------------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "To acknowledge you have authorization and wish to proceed, type 'CONFIRM'." -ForegroundColor Cyan
$Confirmation = Read-Host "   > "

if ($Confirmation -cne "CONFIRM") {
    Write-Host "`n[ CANCELLED ] Operation aborted. No changes have been made to the system." -ForegroundColor Green
    Pause
    Exit
}

# --- 4. EXECUTION ---
Write-Host "`n[ EXECUTING SYSTEM RESET ]" -ForegroundColor Yellow
Write-Host "   > Launching native Windows Reset tool..." -ForegroundColor Green

# Launching the built-in Windows System Reset tool.
try {
    Start-Process -FilePath "systemreset.exe" -ArgumentList "-factoryreset"
    Write-Host "`n[ COMPLETE ] The Windows Reset UI has been launched." -ForegroundColor Green
    Write-Host "Please follow the on-screen prompts to finalize the wipe." -ForegroundColor DarkGray
} catch {
    Write-Error "Failed to launch systemreset.exe. Ensure you are running Windows 10 or 11."
}

Pause