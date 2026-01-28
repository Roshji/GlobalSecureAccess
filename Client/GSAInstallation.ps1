<#
.SYNOPSIS
Installs and configures the Global Secure Access Client on x64 devices

.DESCRIPTION
This PowerShell script to install the Global Secure Access Client. 
It also configures necessary registry settings for both Microsoft Edge and Google Chrome to ensure proper DNS over HTTPS functionality and restricts non-privileged users.

.VERSION
1.1.0

.AUTHOR
Remco van Diermen - RvD IT Consulting

.NOTES
- Created on: 22-10-2025
- This script is compatible with Windows 10 and later versions.

#>

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\GlobalSecureAccessInstall.log" -Append

# Installing Global Secure Access Client

# Testing if the Global Secure Access Client is already installed, if so, perform a repair installation

if (Test-Path "C:\Program Files\Global Secure Access Client\GlobalSecureAccessTunnelingService.exe") {
    Write-Host "Global Secure Access Client is already installed. Repairing installation..."
    $process = Start-Process -FilePath "GlobalSecureAccessClient.exe" -ArgumentList "/repair /quiet /norestart" -Wait -PassThru
    if (($process.ExitCode -ne 0) -and ($process.ExitCode -ne 3010)) {
        Write-Host "Repairing of Global Secure Access Client failed with exit code: $($process.ExitCode)"
        Write-Error "Repairing of Global Secure Access Client failed with exit code $($process.ExitCode)"
        exit $process.ExitCode
    }
} else {

# Installing Global Secure Access Client for the first time

    Write-Host "Installing Global Secure Access Client..."
    $process = Start-Process -FilePath "GlobalSecureAccessClient.exe" -ArgumentList "/install /quiet /norestart" -Wait -PassThru
    if (($process.ExitCode -ne 0) -and ($process.ExitCode -ne 3010)) {
        Write-Host "Installation of Global Secure Access Client failed with exit code: $($process.ExitCode)"
        Write-Error "Installation of Global Secure Access Client failed with exit code $($process.ExitCode)"
        exit $process.ExitCode
    }
}

Write-Host "Global Secure Access Client installed successfully."

write-host "Checking registry keys..."

# Ensure the registry keys exist

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Force | Out-Null
}
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force | Out-Null
}
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Google")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google" -Force | Out-Null
}
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Google\Chrome")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force | Out-Null
}
if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Global Secure Access Client")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Global Secure Access Client" -Force | Out-Null
}

write-host "Setting registry keys..."

# Setting registry keys

$disableBuiltInDNS = 0x00
$restrictprivilegedusers = 0x1

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Global Secure Access Client" -Name "RestrictNonPrivilegedUsers" -Type DWord -Value $restrictprivilegedusers
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" -Name "FarKdcTimeout" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "DnsOverHttpsMode" -Value "off"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "BuiltInDnsClientEnabled" -Type DWord -Value $disableBuiltInDNS
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DnsOverHttpsMode" -Value "off"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BuiltInDnsClientEnabled" -Type DWord -Value $disableBuiltInDNS

Stop-Transcript
